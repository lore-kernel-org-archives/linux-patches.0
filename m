Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FA83624B0;
	Wed,  8 Apr 2026 18:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673534; cv=none; b=Qw2H+FQ4ixpkETw0d8z/6CJaUGwVqc5kPUnXkCiQqlqDqnSJRR3fYicTf91vz2ByKFdR7J3pLKPSQXMMUIUFHroBeRiVRBCwtjJYVEbqrNgsHEq+iE1O2FK6308wei1EMT/X7+eklCtDQ5GIlP2jSs035Op+q/+ZKUFTN107ELI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673534; c=relaxed/simple;
	bh=0m1wuG3+Jpc6RTmEmdDybU/kfTVBkXsnbbVLbdL5xLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iox1VaYS/NR6LszUhRXo9N7aLU67j4yr132IHsmHKsf4fvLdF0o84Are6Os1Emm2eenRPLfwkJDwZ+19G1+cicdrH/zUte+ay/lB6Qcj9miSdGLrKFngB2S8BUlIhUmTM61+EpB8j/QDBImrb9knJUs9TPbWAmNSXedunLHnvI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GoZNWZcT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GoZNWZcT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5C4C19421;
	Wed,  8 Apr 2026 18:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673534;
	bh=0m1wuG3+Jpc6RTmEmdDybU/kfTVBkXsnbbVLbdL5xLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GoZNWZcTwE1c79I8gQXvWZSWqyt0PN8DH1l4rA59i9wiNYx91NTk5e4iPu8oz1z9H
	 3n9IExYkiQzph4OUFgDu5guTlyY83fJvLrgs9nxu3dg/LGcFOEoltD2mE/ro8Y0xyV
	 pY6ljlGeOitMpASPHrtYZboTNiIlgxTJvmLaDVlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 269/277] drm/amd/display: Fix DCE LVDS handling
Date: Wed,  8 Apr 2026 20:04:14 +0200
Message-ID: <20260408175943.908425449@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 90d239cc53723c1a3f89ce08eac17bf3a9e9f2d4 ]

LVDS does not use an HPD pin so it may be invalid.  Handle
this case correctly in link encoder creation.

Fixes: 7c8fb3b8e9ba ("drm/amd/display: Add hpd_source index check for DCE60/80/100/110/112/120 link encoders")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/5012
Cc: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Cc: Roman Li <roman.li@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Reviewed-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3b5620f7ee688177fcf65cf61588c5435bce1872)
Cc: stable@vger.kernel.org
[ removed unrelated VGA connector block absent from stable and split combined null/bounds check into separate guard and ternary ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dce100/dce100_resource.c |    5 ++-
 drivers/gpu/drm/amd/display/dc/resource/dce110/dce110_resource.c |    5 ++-
 drivers/gpu/drm/amd/display/dc/resource/dce112/dce112_resource.c |    5 ++-
 drivers/gpu/drm/amd/display/dc/resource/dce120/dce120_resource.c |    5 ++-
 drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c   |   13 +++++-----
 drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c   |    5 ++-
 6 files changed, 22 insertions(+), 16 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/resource/dce100/dce100_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce100/dce100_resource.c
@@ -624,7 +624,7 @@ static struct link_encoder *dce100_link_
 		kzalloc(sizeof(struct dce110_link_encoder), GFP_KERNEL);
 	int link_regs_id;
 
-	if (!enc110 || enc_init_data->hpd_source >= ARRAY_SIZE(link_enc_hpd_regs))
+	if (!enc110)
 		return NULL;
 
 	link_regs_id =
@@ -635,7 +635,8 @@ static struct link_encoder *dce100_link_
 				      &link_enc_feature,
 				      &link_enc_regs[link_regs_id],
 				      &link_enc_aux_regs[enc_init_data->channel - 1],
-				      &link_enc_hpd_regs[enc_init_data->hpd_source]);
+				      enc_init_data->hpd_source >= ARRAY_SIZE(link_enc_hpd_regs) ?
+				      NULL : &link_enc_hpd_regs[enc_init_data->hpd_source]);
 	return &enc110->base;
 }
 
--- a/drivers/gpu/drm/amd/display/dc/resource/dce110/dce110_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce110/dce110_resource.c
@@ -668,7 +668,7 @@ static struct link_encoder *dce110_link_
 		kzalloc(sizeof(struct dce110_link_encoder), GFP_KERNEL);
 	int link_regs_id;
 
-	if (!enc110 || enc_init_data->hpd_source >= ARRAY_SIZE(link_enc_hpd_regs))
+	if (!enc110)
 		return NULL;
 
 	link_regs_id =
@@ -679,7 +679,8 @@ static struct link_encoder *dce110_link_
 				      &link_enc_feature,
 				      &link_enc_regs[link_regs_id],
 				      &link_enc_aux_regs[enc_init_data->channel - 1],
-				      &link_enc_hpd_regs[enc_init_data->hpd_source]);
+				      enc_init_data->hpd_source >= ARRAY_SIZE(link_enc_hpd_regs) ?
+				      NULL : &link_enc_hpd_regs[enc_init_data->hpd_source]);
 	return &enc110->base;
 }
 
--- a/drivers/gpu/drm/amd/display/dc/resource/dce112/dce112_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce112/dce112_resource.c
@@ -629,7 +629,7 @@ static struct link_encoder *dce112_link_
 		kzalloc(sizeof(struct dce110_link_encoder), GFP_KERNEL);
 	int link_regs_id;
 
-	if (!enc110 || enc_init_data->hpd_source >= ARRAY_SIZE(link_enc_hpd_regs))
+	if (!enc110)
 		return NULL;
 
 	link_regs_id =
@@ -640,7 +640,8 @@ static struct link_encoder *dce112_link_
 				      &link_enc_feature,
 				      &link_enc_regs[link_regs_id],
 				      &link_enc_aux_regs[enc_init_data->channel - 1],
-				      &link_enc_hpd_regs[enc_init_data->hpd_source]);
+				      enc_init_data->hpd_source >= ARRAY_SIZE(link_enc_hpd_regs) ?
+				      NULL : &link_enc_hpd_regs[enc_init_data->hpd_source]);
 	return &enc110->base;
 }
 
--- a/drivers/gpu/drm/amd/display/dc/resource/dce120/dce120_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce120/dce120_resource.c
@@ -713,7 +713,7 @@ static struct link_encoder *dce120_link_
 		kzalloc(sizeof(struct dce110_link_encoder), GFP_KERNEL);
 	int link_regs_id;
 
-	if (!enc110 || enc_init_data->hpd_source >= ARRAY_SIZE(link_enc_hpd_regs))
+	if (!enc110)
 		return NULL;
 
 	link_regs_id =
@@ -724,7 +724,8 @@ static struct link_encoder *dce120_link_
 				      &link_enc_feature,
 				      &link_enc_regs[link_regs_id],
 				      &link_enc_aux_regs[enc_init_data->channel - 1],
-				      &link_enc_hpd_regs[enc_init_data->hpd_source]);
+				      enc_init_data->hpd_source >= ARRAY_SIZE(link_enc_hpd_regs) ?
+				      NULL : &link_enc_hpd_regs[enc_init_data->hpd_source]);
 
 	return &enc110->base;
 }
--- a/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
@@ -718,18 +718,19 @@ static struct link_encoder *dce60_link_e
 		kzalloc(sizeof(struct dce110_link_encoder), GFP_KERNEL);
 	int link_regs_id;
 
-	if (!enc110 || enc_init_data->hpd_source >= ARRAY_SIZE(link_enc_hpd_regs))
+	if (!enc110)
 		return NULL;
 
 	link_regs_id =
 		map_transmitter_id_to_phy_instance(enc_init_data->transmitter);
 
 	dce60_link_encoder_construct(enc110,
-				      enc_init_data,
-				      &link_enc_feature,
-				      &link_enc_regs[link_regs_id],
-				      &link_enc_aux_regs[enc_init_data->channel - 1],
-				      &link_enc_hpd_regs[enc_init_data->hpd_source]);
+				     enc_init_data,
+				     &link_enc_feature,
+				     &link_enc_regs[link_regs_id],
+				     &link_enc_aux_regs[enc_init_data->channel - 1],
+				     enc_init_data->hpd_source >= ARRAY_SIZE(link_enc_hpd_regs) ?
+				     NULL : &link_enc_hpd_regs[enc_init_data->hpd_source]);
 	return &enc110->base;
 }
 
--- a/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
@@ -724,7 +724,7 @@ static struct link_encoder *dce80_link_e
 		kzalloc(sizeof(struct dce110_link_encoder), GFP_KERNEL);
 	int link_regs_id;
 
-	if (!enc110 || enc_init_data->hpd_source >= ARRAY_SIZE(link_enc_hpd_regs))
+	if (!enc110)
 		return NULL;
 
 	link_regs_id =
@@ -735,7 +735,8 @@ static struct link_encoder *dce80_link_e
 				      &link_enc_feature,
 				      &link_enc_regs[link_regs_id],
 				      &link_enc_aux_regs[enc_init_data->channel - 1],
-				      &link_enc_hpd_regs[enc_init_data->hpd_source]);
+				      enc_init_data->hpd_source >= ARRAY_SIZE(link_enc_hpd_regs) ?
+				      NULL : &link_enc_hpd_regs[enc_init_data->hpd_source]);
 	return &enc110->base;
 }
 


