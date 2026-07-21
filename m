Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8D246EC8B;
	Tue, 21 Jul 2026 19:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661798; cv=none; b=aMoRb1LxavSCh3v1bfVHA1fM+XwiJ0iXTnU2kDwmgKRJxLED5rPHoM73MYIRc0B/nbudc1t5HcGVSNJIeYppyVXSV1vJNS9sdgNFJQDz7N/2Zw9DfqHEdME3NkHDbdc3aVvOWpilNqS0o+L1xkWLleczYkf8jv/EQBU6UKGJflM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661798; c=relaxed/simple;
	bh=xhEcS7TYXJI8xuwTZbY0rZYRfJMvFA7dkiAVqJS8G3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jB02R7ZxafjFwlOC42akyq09meEaJyPHQbYe0IZ+Jh9jCq2XawWwqj6yH9lA+FMAFZb707K3tdPK23DppgGtfiFq3kq0/oYauVGNqlnjNEiD0qABVWesq+DrGpkhfjQWXXiH7RNyElNC1RPm9SYztJcTfCp+YPwXV12LX8JjiiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hHxM2NK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hHxM2NK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32B81F000E9;
	Tue, 21 Jul 2026 19:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661797;
	bh=BWNx3x5blAhBPaB+Zr8sBfniUtKucjLjzZ4DinjJhOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0hHxM2NKLgJn2gsAfEQ7raHRKOtnhUiXFJEnb0BrQl2+6W9p+vxUd4T86PlwZO8iq
	 atdTMxo6FRgaGN2w6t1t7OVEdBFvmE14ORJmFTmQmMSH6GNSyQ2bLgs0bAcMASgHyn
	 mvLCileK2DB9nK8+t0XxiiTILrkHRoMg9KfG9H34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Renjiang Han <renjiang.han@oss.qualcomm.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0202/1276] media: qcom: venus: relax encoder frame/blur step size on v6
Date: Tue, 21 Jul 2026 17:10:45 +0200
Message-ID: <20260721152450.606357445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Renjiang Han <renjiang.han@oss.qualcomm.com>

[ Upstream commit c53e0550288b2e08b984b24035c471941b7820c7 ]

Encoder HFI capabilities on v6 enforce a 16-pixel step for frame and blur
dimensions, which does not reflect actual hardware requirements and can
reject valid userspace configurations.

Relax the step size to 1 while leaving min/max limits unchanged.

Fixes: 869d77e706290 ("media: venus: hfi_plat_v6: Populate capabilities for v6")
Signed-off-by: Renjiang Han <renjiang.han@oss.qualcomm.com>
Reviewed-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/qcom/venus/hfi_platform_v6.c  | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_platform_v6.c b/drivers/media/platform/qcom/venus/hfi_platform_v6.c
index 4e8af645f8b95b..b5b769d735c1e7 100644
--- a/drivers/media/platform/qcom/venus/hfi_platform_v6.c
+++ b/drivers/media/platform/qcom/venus/hfi_platform_v6.c
@@ -172,8 +172,8 @@ static const struct hfi_plat_caps caps[] = {
 	.codec = HFI_VIDEO_CODEC_HEVC,
 	.domain = VIDC_SESSION_TYPE_ENC,
 	.cap_bufs_mode_dynamic = true,
-	.caps[0] = {HFI_CAPABILITY_FRAME_WIDTH, 128, 8192, 16},
-	.caps[1] = {HFI_CAPABILITY_FRAME_HEIGHT, 128, 8192, 16},
+	.caps[0] = {HFI_CAPABILITY_FRAME_WIDTH, 128, 8192, 1},
+	.caps[1] = {HFI_CAPABILITY_FRAME_HEIGHT, 128, 8192, 1},
 	.caps[2] = {HFI_CAPABILITY_MBS_PER_FRAME, 64, 138240, 1},
 	.caps[3] = {HFI_CAPABILITY_BITRATE, 1, 160000000, 1},
 	.caps[4] = {HFI_CAPABILITY_SCALE_X, 8192, 65536, 1},
@@ -194,8 +194,8 @@ static const struct hfi_plat_caps caps[] = {
 	.caps[19] = {HFI_CAPABILITY_RATE_CONTROL_MODES, 0x1000001, 0x1000005, 1},
 	.caps[20] = {HFI_CAPABILITY_COLOR_SPACE_CONVERSION, 0, 2, 1},
 	.caps[21] = {HFI_CAPABILITY_ROTATION, 1, 4, 90},
-	.caps[22] = {HFI_CAPABILITY_BLUR_WIDTH, 96, 4096, 16},
-	.caps[23] = {HFI_CAPABILITY_BLUR_HEIGHT, 96, 4096, 16},
+	.caps[22] = {HFI_CAPABILITY_BLUR_WIDTH, 96, 4096, 1},
+	.caps[23] = {HFI_CAPABILITY_BLUR_HEIGHT, 96, 4096, 1},
 	.num_caps = 24,
 	.pl[0] = {HFI_HEVC_PROFILE_MAIN, HFI_HEVC_LEVEL_6 | HFI_HEVC_TIER_HIGH0},
 	.pl[1] = {HFI_HEVC_PROFILE_MAIN10, HFI_HEVC_LEVEL_6 | HFI_HEVC_TIER_HIGH0},
@@ -209,8 +209,8 @@ static const struct hfi_plat_caps caps[] = {
 	.codec = HFI_VIDEO_CODEC_VP8,
 	.domain = VIDC_SESSION_TYPE_ENC,
 	.cap_bufs_mode_dynamic = true,
-	.caps[0] = {HFI_CAPABILITY_FRAME_WIDTH, 128, 4096, 16},
-	.caps[1] = {HFI_CAPABILITY_FRAME_HEIGHT, 128, 4096, 16},
+	.caps[0] = {HFI_CAPABILITY_FRAME_WIDTH, 128, 4096, 1},
+	.caps[1] = {HFI_CAPABILITY_FRAME_HEIGHT, 128, 4096, 1},
 	.caps[2] = {HFI_CAPABILITY_MBS_PER_FRAME, 64, 36864, 1},
 	.caps[3] = {HFI_CAPABILITY_BITRATE, 1, 74000000, 1},
 	.caps[4] = {HFI_CAPABILITY_SCALE_X, 8192, 65536, 1},
@@ -228,8 +228,8 @@ static const struct hfi_plat_caps caps[] = {
 	.caps[16] = {HFI_CAPABILITY_P_FRAME_QP, 0, 127, 1},
 	.caps[17] = {HFI_CAPABILITY_MAX_WORKMODES, 1, 2, 1},
 	.caps[18] = {HFI_CAPABILITY_RATE_CONTROL_MODES, 0x1000001, 0x1000005, 1},
-	.caps[19] = {HFI_CAPABILITY_BLUR_WIDTH, 96, 4096, 16},
-	.caps[20] = {HFI_CAPABILITY_BLUR_HEIGHT, 96, 4096, 16},
+	.caps[19] = {HFI_CAPABILITY_BLUR_WIDTH, 96, 4096, 1},
+	.caps[20] = {HFI_CAPABILITY_BLUR_HEIGHT, 96, 4096, 1},
 	.caps[21] = {HFI_CAPABILITY_COLOR_SPACE_CONVERSION, 0, 2, 1},
 	.caps[22] = {HFI_CAPABILITY_ROTATION, 1, 4, 90},
 	.num_caps = 23,
-- 
2.53.0



