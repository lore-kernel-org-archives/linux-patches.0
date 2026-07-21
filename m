Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DA0472F7F;
	Tue, 21 Jul 2026 17:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656153; cv=none; b=GMAKPOALSvjwG+E4mIGh2AAp9C+E5rRs0DXXBA2ZLBlS+u1wqW8Y4oNGxG6hNY+64aJjV7eadN9446WBvRl6GqMOrWbGzaEf3dlDV/OKnZyPu7Y0b9oDzFrOSrlNlAvcF4ucT2ixhin6HYiHlVM/g7EpLn2COk/zzQ6tCt3v2OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656153; c=relaxed/simple;
	bh=q5unhgAKuk6xUR4+DxmP0CmONNDIBdsQZvNTNMzkqV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6JSjvddc6pvmb4xuazliytgAmIkoCXalf6eycC7REZWxQ70kVcAQpRyAqhESW1yluhG5Of0iq4/Y49JofPpnfNZgRk+J1SJgfFVLjW1A9NuqcE9k2JbYwKbfcOpkzhxJJ7q6GuIubQlcMSluwurTj9EaRa+Xx/ar5HHUwjrZ+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lm5GOJKA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lm5GOJKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AD21F000E9;
	Tue, 21 Jul 2026 17:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656151;
	bh=jINV50DyaF9hR5R8DaefSuYP5M0lFVvSjMsKFVokgL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lm5GOJKAHJ5Uka9uvDj/9FIP8dq8Dl2CMt4cQi0Gi1CYrmOfNdQeWrzckSMKReVWI
	 48dOcAMx2sUR9/kOYoyfTPZwHlS6RBYD5o503nFT48dNcSoVJYYiDYUAPdZNEluMZR
	 k5SkACxi7cgipsthyMRVMwNjEI6rqo0WPqqOcauA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Renjiang Han <renjiang.han@oss.qualcomm.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0277/1611] media: qcom: venus: relax encoder frame/blur dimension steps on v4
Date: Tue, 21 Jul 2026 17:06:33 +0200
Message-ID: <20260721152521.285166877@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Renjiang Han <renjiang.han@oss.qualcomm.com>

[ Upstream commit 35428ae3a6a40912f1f7b47bb6c65f1a63d0b8f8 ]

Encoder HFI capabilities on v4 advertise a 16-pixel step for frame and
blur dimensions. This is overly restrictive and can cause userspace caps
negotiation to fail even for valid resolutions.

Relax the advertised step size to 1 and keep alignment enforcement in
buffer layout and size calculations.

Fixes: 8b88cabef404e ("media: venus: hfi_plat_v4: Populate codecs and capabilities for v4")
Signed-off-by: Renjiang Han <renjiang.han@oss.qualcomm.com>
Reviewed-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/qcom/venus/hfi_platform_v4.c     | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_platform_v4.c b/drivers/media/platform/qcom/venus/hfi_platform_v4.c
index cda888b56b5d48..e0b3652bb44093 100644
--- a/drivers/media/platform/qcom/venus/hfi_platform_v4.c
+++ b/drivers/media/platform/qcom/venus/hfi_platform_v4.c
@@ -136,8 +136,8 @@ static const struct hfi_plat_caps caps[] = {
 	.codec = HFI_VIDEO_CODEC_H264,
 	.domain = VIDC_SESSION_TYPE_ENC,
 	.cap_bufs_mode_dynamic = true,
-	.caps[0] = {HFI_CAPABILITY_FRAME_WIDTH, 96, 4096, 16},
-	.caps[1] = {HFI_CAPABILITY_FRAME_HEIGHT, 96, 4096, 16},
+	.caps[0] = {HFI_CAPABILITY_FRAME_WIDTH, 96, 4096, 1},
+	.caps[1] = {HFI_CAPABILITY_FRAME_HEIGHT, 96, 4096, 1},
 	.caps[2] = {HFI_CAPABILITY_MBS_PER_FRAME, 1, 36864, 1},
 	.caps[3] = {HFI_CAPABILITY_BITRATE, 1, 120000000, 1},
 	.caps[4] = {HFI_CAPABILITY_SCALE_X, 8192, 65536, 1},
@@ -173,8 +173,8 @@ static const struct hfi_plat_caps caps[] = {
 	.codec = HFI_VIDEO_CODEC_HEVC,
 	.domain = VIDC_SESSION_TYPE_ENC,
 	.cap_bufs_mode_dynamic = true,
-	.caps[0] = {HFI_CAPABILITY_FRAME_WIDTH, 96, 4096, 16},
-	.caps[1] = {HFI_CAPABILITY_FRAME_HEIGHT, 96, 4096, 16},
+	.caps[0] = {HFI_CAPABILITY_FRAME_WIDTH, 96, 4096, 1},
+	.caps[1] = {HFI_CAPABILITY_FRAME_HEIGHT, 96, 4096, 1},
 	.caps[2] = {HFI_CAPABILITY_MBS_PER_FRAME, 1, 36864, 1},
 	.caps[3] = {HFI_CAPABILITY_BITRATE, 1, 120000000, 1},
 	.caps[4] = {HFI_CAPABILITY_SCALE_X, 8192, 65536, 1},
@@ -195,8 +195,8 @@ static const struct hfi_plat_caps caps[] = {
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
@@ -210,8 +210,8 @@ static const struct hfi_plat_caps caps[] = {
 	.codec = HFI_VIDEO_CODEC_VP8,
 	.domain = VIDC_SESSION_TYPE_ENC,
 	.cap_bufs_mode_dynamic = true,
-	.caps[0] = {HFI_CAPABILITY_FRAME_WIDTH, 96, 4096, 16},
-	.caps[1] = {HFI_CAPABILITY_FRAME_HEIGHT, 96, 4096, 16},
+	.caps[0] = {HFI_CAPABILITY_FRAME_WIDTH, 96, 4096, 1},
+	.caps[1] = {HFI_CAPABILITY_FRAME_HEIGHT, 96, 4096, 1},
 	.caps[2] = {HFI_CAPABILITY_MBS_PER_FRAME, 1, 36864, 1},
 	.caps[3] = {HFI_CAPABILITY_BITRATE, 1, 120000000, 1},
 	.caps[4] = {HFI_CAPABILITY_SCALE_X, 8192, 65536, 1},
@@ -229,8 +229,8 @@ static const struct hfi_plat_caps caps[] = {
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



