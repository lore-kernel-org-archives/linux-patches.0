Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9976C14BFA2;
	Sun,  7 Sep 2025 20:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276468; cv=none; b=KA9qaasbDZsTnbmN4L3cwebWb9VSo4MrA3PUikWS7hv/SQTo+MjzROV8jF4ELdG9Uag4vNHSEH5Ji/fwqggoU7iX87RN4gRiQuJNvfK0CxtPLhfo805GMEWSQmUezUqnZpzxHdZ8RxSFpQKHut0VR5bc0BfN+1FkCZ1gpZi6+II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276468; c=relaxed/simple;
	bh=GpXORY65/uFftunlTNh2psIigAlMRF31jdHGkQ4rrTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i9FRdu07wdY0JSA5lACqWKATdJxkW3IkXQeFfkfSBP+q/j4PomrgN1/NU3bAXeFOxhceSnyVqlKW0QYWcHKvnzU97T9z6DraIhZvhs+Ce6pGnPTWKqV2bSWwHfWRZvsgSofLBAHmAjR2SvghKUNaQdk9EtTLWjWDL5e3N/iZ770=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcdvCkIU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcdvCkIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E49C4CEF0;
	Sun,  7 Sep 2025 20:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276468;
	bh=GpXORY65/uFftunlTNh2psIigAlMRF31jdHGkQ4rrTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcdvCkIUa/2UmOmGanL0X8fPxrZywCzp8kVZjnK8VgpB2qq1yb/1++jGg5VowU9TW
	 /MxsCEyYQvS3JOA2KtcYHPIfBAPjIm4bORCclhP55EDvrMtjiA4azqZqgiKAzE4N6s
	 YfeEqLkYpMWXFOJsCrriEOoXl28ZqIWg05uvYBjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Hung <alex.hung@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/121] drm/amd/display: Dont warn when missing DCE encoder caps
Date: Sun,  7 Sep 2025 21:57:26 +0200
Message-ID: <20250907195610.078286836@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 8246147f1fbaed522b8bcc02ca34e4260747dcfb ]

On some GPUs the VBIOS just doesn't have encoder caps,
or maybe not for every encoder.

This isn't really a problem and it's handled well,
so let's not litter the logs with it.

Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 33e0227ee96e62d034781e91f215e32fd0b1d512)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
index 136bd93c3b655..0a33f8f117e92 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
@@ -896,13 +896,13 @@ void dce110_link_encoder_construct(
 						enc110->base.id, &bp_cap_info);
 
 	/* Override features with DCE-specific values */
-	if (BP_RESULT_OK == result) {
+	if (result == BP_RESULT_OK) {
 		enc110->base.features.flags.bits.IS_HBR2_CAPABLE =
 				bp_cap_info.DP_HBR2_EN;
 		enc110->base.features.flags.bits.IS_HBR3_CAPABLE =
 				bp_cap_info.DP_HBR3_EN;
 		enc110->base.features.flags.bits.HDMI_6GB_EN = bp_cap_info.HDMI_6GB_EN;
-	} else {
+	} else if (result != BP_RESULT_NORECORD) {
 		DC_LOG_WARNING("%s: Failed to get encoder_cap_info from VBIOS with error code %d!\n",
 				__func__,
 				result);
@@ -1795,13 +1795,13 @@ void dce60_link_encoder_construct(
 						enc110->base.id, &bp_cap_info);
 
 	/* Override features with DCE-specific values */
-	if (BP_RESULT_OK == result) {
+	if (result == BP_RESULT_OK) {
 		enc110->base.features.flags.bits.IS_HBR2_CAPABLE =
 				bp_cap_info.DP_HBR2_EN;
 		enc110->base.features.flags.bits.IS_HBR3_CAPABLE =
 				bp_cap_info.DP_HBR3_EN;
 		enc110->base.features.flags.bits.HDMI_6GB_EN = bp_cap_info.HDMI_6GB_EN;
-	} else {
+	} else if (result != BP_RESULT_NORECORD) {
 		DC_LOG_WARNING("%s: Failed to get encoder_cap_info from VBIOS with error code %d!\n",
 				__func__,
 				result);
-- 
2.50.1



