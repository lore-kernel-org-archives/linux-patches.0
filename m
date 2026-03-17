Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941F03D6698;
	Tue, 17 Mar 2026 16:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765557; cv=none; b=N05FD/21CskBvdBCAeaYMeSkHJVcdEJ4mNeA0LXV4SccvMOdz0xkvPPeOF22czBHHT5JuPBzkxaAN2NQfew1HREGXA2tUWTPpCR6KBdopN2g9CPCwX4wcEiiU3eHxUgDWwoVteunbB2akvf5Ig1bdZ7naDCB8+hcUSIDlCNna8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765557; c=relaxed/simple;
	bh=bi74JSJVt8qA2ky0uWLrI2qDjvnJShCsMzzQr/1IFu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UIeyy5yAM34sPg+G84jOIuN7D9DJr0RgS1w0IWGg8jzZ7c8XMbEPOegQycRtjm4VRQfP5rad5NZ1QG+hWOLEp2BB9LeTQFhOlBw/Q468Q+twMWIiJaMt0FN2XHJESOu7qPNhJtuHJ4CrWiXBkqP5Ty5gh4qAaB3mfdEhfeDTBIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SW29+9h3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SW29+9h3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED374C4CEF7;
	Tue, 17 Mar 2026 16:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765557;
	bh=bi74JSJVt8qA2ky0uWLrI2qDjvnJShCsMzzQr/1IFu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SW29+9h3Sx8ABxa/xiudl9PmVhFJQgtHmFeWxVsPSPOIjwHAha3ZVfhj6cOQr1645
	 z3qTQfjgQhCywQ72tvaB46lBwyDvcfCjbqxZ9OJC4Z3DmUAwCCRcFUqjcaByoZVotU
	 o1ay39pcGpvFe8Gp9H2hK8cvL+chSfMQe/ZG8qlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 038/378] drm/amd/pm: add missing od setting PP_OD_FEATURE_ZERO_FAN_BIT for smu v13
Date: Tue, 17 Mar 2026 17:29:55 +0100
Message-ID: <20260317163008.385706674@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit cb47c882c31334aadc13ace80781728ed22a05ee ]

add missing od setting PP_OD_FEATURE_ZERO_FAN_BIT for smu v13.0.0/13.0.7

Fixes: cfffd980bf21 ("drm/amd/pm: add zero RPM OD setting support for SMU13")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/5018
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 576a10797b607ee9e4068218daf367b481564120)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c | 3 ++-
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index eaeff6a9bc50f..e8f8c3bae0ab0 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -2290,7 +2290,8 @@ static int smu_v13_0_0_restore_user_od_settings(struct smu_context *smu)
 	user_od_table->OverDriveTable.FeatureCtrlMask = BIT(PP_OD_FEATURE_GFXCLK_BIT) |
 							BIT(PP_OD_FEATURE_UCLK_BIT) |
 							BIT(PP_OD_FEATURE_GFX_VF_CURVE_BIT) |
-							BIT(PP_OD_FEATURE_FAN_CURVE_BIT);
+							BIT(PP_OD_FEATURE_FAN_CURVE_BIT) |
+							BIT(PP_OD_FEATURE_ZERO_FAN_BIT);
 	res = smu_v13_0_0_upload_overdrive_table(smu, user_od_table);
 	user_od_table->OverDriveTable.FeatureCtrlMask = 0;
 	if (res == 0)
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index a3fc35b9011e4..3c3393297c630 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -2276,7 +2276,8 @@ static int smu_v13_0_7_restore_user_od_settings(struct smu_context *smu)
 	user_od_table->OverDriveTable.FeatureCtrlMask = BIT(PP_OD_FEATURE_GFXCLK_BIT) |
 							BIT(PP_OD_FEATURE_UCLK_BIT) |
 							BIT(PP_OD_FEATURE_GFX_VF_CURVE_BIT) |
-							BIT(PP_OD_FEATURE_FAN_CURVE_BIT);
+							BIT(PP_OD_FEATURE_FAN_CURVE_BIT) |
+							BIT(PP_OD_FEATURE_ZERO_FAN_BIT);
 	res = smu_v13_0_7_upload_overdrive_table(smu, user_od_table);
 	user_od_table->OverDriveTable.FeatureCtrlMask = 0;
 	if (res == 0)
-- 
2.51.0



