import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/models/cast_member.dart';
import '../../../core/theme/app_theme.dart';

class CastSection extends StatelessWidget {
  final List<CastMember> cast;

  const CastSection({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 14),
            child: Text(
              'Elenco',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20),
              itemCount: cast.length,
              itemBuilder: (context, index) {
                final member = cast[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: _CastCard(member: member),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CastCard extends StatelessWidget {
  final CastMember member;

  const _CastCard({required this.member});

  @override
  Widget build(BuildContext context) {
    final profileUrl = ApiConstants.profileUrl(member.profilePath);

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: profileUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: profileUrl,
                  width: 62,
                  height: 62,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => _placeholder(),
                )
              : _placeholder(),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: 62,
          child: Text(
            member.name,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _placeholder() {
    return Container(
      width: 62,
      height: 62,
      color: AppColors.card,
      child: const Icon(Icons.person_outline, color: AppColors.textSecondary, size: 28),
    );
  }
}
