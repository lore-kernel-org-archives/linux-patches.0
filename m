Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC47522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30BFC433C8;
	Sun,  9 Jul 2023 11:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901923;
	bh=X+kT1oQ8n6bKvVaOHHWJx/EBykQV1Xs7jNl7HikPjmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CG3/mJQrnhnlYR0RPyqSFO7YAOyuRRQRbJJXbKm0seMGmYusQZ2n+dgTWKbSQrP8D
	 7h8t8rvbcoE6F2vfOvM7PvrpSc2LF4/EAqCOz3c8RPtVVCYnJnKha+Z9Nz6A3J1tXN
	 63F8+PglVQkfL5ByVlabr7E0W4Ws4pC+aAGdBwDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Arthur Grillo <arthurgrillo@riseup.net>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mairacanal@riseup.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 193/431] drm: Add fixed-point helper to get rounded integer values
Date: Sun,  9 Jul 2023 13:12:21 +0200
Message-ID: <20230709111455.699903028@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 8b25320887d7feac98875546ea0f521628b745bb ]

Create a new fixed-point helper to allow us to return the rounded value
of our fixed point value.

[v2]:
    * Create the function drm_fixp2int_round() (Melissa Wen).
[v3]:
    * Use drm_fixp2int() instead of shifting manually (Arthur Grillo).

Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Arthur Grillo <arthurgrillo@riseup.net>
Signed-off-by: Maíra Canal <mairacanal@riseup.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20230512104044.65034-1-mcanal@igalia.com
Stable-dep-of: ab87f558dcfb ("drm/vkms: Fix RGB565 pixel conversion")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_fixed.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/drm/drm_fixed.h b/include/drm/drm_fixed.h
index 255645c1f9a89..6ea339d5de088 100644
--- a/include/drm/drm_fixed.h
+++ b/include/drm/drm_fixed.h
@@ -71,6 +71,7 @@ static inline u32 dfixed_div(fixed20_12 A, fixed20_12 B)
 }
 
 #define DRM_FIXED_POINT		32
+#define DRM_FIXED_POINT_HALF	16
 #define DRM_FIXED_ONE		(1ULL << DRM_FIXED_POINT)
 #define DRM_FIXED_DECIMAL_MASK	(DRM_FIXED_ONE - 1)
 #define DRM_FIXED_DIGITS_MASK	(~DRM_FIXED_DECIMAL_MASK)
@@ -87,6 +88,11 @@ static inline int drm_fixp2int(s64 a)
 	return ((s64)a) >> DRM_FIXED_POINT;
 }
 
+static inline int drm_fixp2int_round(s64 a)
+{
+	return drm_fixp2int(a + (1 << (DRM_FIXED_POINT_HALF - 1)));
+}
+
 static inline int drm_fixp2int_ceil(s64 a)
 {
 	if (a > 0)
-- 
2.39.2



