Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355033E3C40;
	Tue, 31 Mar 2026 16:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975363; cv=none; b=df4lJs6GN+UBLG8Uzz4631X1lKbvpuXrB47bpt1wBSGLVsxY0TULNz/g4ikVCc+kjZR7F4nwdcrFwmk3AiIViCpqLTgSvjnTX/A97QPrwAlgYAGFw9NLuq4/kEME4YUR9OJJ9geemCpVBLXvsDxmu75tzFcWIbgiurnf3jGoZIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975363; c=relaxed/simple;
	bh=fvxf8NAMrO78ZlMAodVlmD1Yl4EuNCXPM2uhoZWWY+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ds9MJHnqENHzwh/3N/Yh3hCmHKWYInK1d8liw2qfA/7+vKzs71CZiayjClsm8vjN1CRBWoPvwLStXOff3yaqf2hzjctw9p7I1GB8DRlEVA+lCvRvD2yQOTY38uUeEyypKbrKOqCDhjLuxQU3d9gUe5koGpQt/RTVi72hGoYlric=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smaZKFkx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smaZKFkx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E182C19423;
	Tue, 31 Mar 2026 16:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975362;
	bh=fvxf8NAMrO78ZlMAodVlmD1Yl4EuNCXPM2uhoZWWY+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smaZKFkxeQSs0P42510CyMWPuop3dNe3yhi4IBaUJ6nlNuM624iR6Kmw0uqy7QGMW
	 LlcHQF7Gjw15u9DQND+tvmhtNUXA99rodPpW28M7h6NqLmYlYJ4yDLCGCR4rn4Gm6b
	 BH4XtZBsfIyJK3X1FEIQfNzYUS9DxbkSPbfP4Eqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.19 264/342] drm/amd/display: Fix DCE LVDS handling
Date: Tue, 31 Mar 2026 18:21:37 +0200
Message-ID: <20260331161808.665837267@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 90d239cc53723c1a3f89ce08eac17bf3a9e9f2d4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dce100/dce100_resource.c |    6 +---
 drivers/gpu/drm/amd/display/dc/resource/dce110/dce110_resource.c |    5 ++-
 drivers/gpu/drm/amd/display/dc/resource/dce112/dce112_resource.c |    5 ++-
 drivers/gpu/drm/amd/display/dc/resource/dce120/dce120_resource.c |    5 ++-
 drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c   |   14 ++++------
 drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c   |    6 +---
 6 files changed, 19 insertions(+), 22 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/resource/dce100/dce100_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce100/dce100_resource.c
@@ -651,9 +651,6 @@ static struct link_encoder *dce100_link_
 		return &enc110->base;
 	}
 
-	if (enc_init_data->hpd_source >= ARRAY_SIZE(link_enc_hpd_regs))
-		return NULL;
-
 	link_regs_id =
 		map_transmitter_id_to_phy_instance(enc_init_data->transmitter);
 
@@ -662,7 +659,8 @@ static struct link_encoder *dce100_link_
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
@@ -672,7 +672,7 @@ static struct link_encoder *dce110_link_
 		kzalloc(sizeof(struct dce110_link_encoder), GFP_KERNEL);
 	int link_regs_id;
 
-	if (!enc110 || enc_init_data->hpd_source >= ARRAY_SIZE(link_enc_hpd_regs))
+	if (!enc110)
 		return NULL;
 
 	link_regs_id =
@@ -683,7 +683,8 @@ static struct link_encoder *dce110_link_
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
@@ -633,7 +633,7 @@ static struct link_encoder *dce112_link_
 		kzalloc(sizeof(struct dce110_link_encoder), GFP_KERNEL);
 	int link_regs_id;
 
-	if (!enc110 || enc_init_data->hpd_source >= ARRAY_SIZE(link_enc_hpd_regs))
+	if (!enc110)
 		return NULL;
 
 	link_regs_id =
@@ -644,7 +644,8 @@ static struct link_encoder *dce112_link_
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
@@ -717,7 +717,7 @@ static struct link_encoder *dce120_link_
 		kzalloc(sizeof(struct dce110_link_encoder), GFP_KERNEL);
 	int link_regs_id;
 
-	if (!enc110 || enc_init_data->hpd_source >= ARRAY_SIZE(link_enc_hpd_regs))
+	if (!enc110)
 		return NULL;
 
 	link_regs_id =
@@ -728,7 +728,8 @@ static struct link_encoder *dce120_link_
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
@@ -747,18 +747,16 @@ static struct link_encoder *dce60_link_e
 		return &enc110->base;
 	}
 
-	if (enc_init_data->hpd_source >= ARRAY_SIZE(link_enc_hpd_regs))
-		return NULL;
-
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
@@ -753,9 +753,6 @@ static struct link_encoder *dce80_link_e
 		return &enc110->base;
 	}
 
-	if (enc_init_data->hpd_source >= ARRAY_SIZE(link_enc_hpd_regs))
-		return NULL;
-
 	link_regs_id =
 		map_transmitter_id_to_phy_instance(enc_init_data->transmitter);
 
@@ -764,7 +761,8 @@ static struct link_encoder *dce80_link_e
 				      &link_enc_feature,
 				      &link_enc_regs[link_regs_id],
 				      &link_enc_aux_regs[enc_init_data->channel - 1],
-				      &link_enc_hpd_regs[enc_init_data->hpd_source]);
+				      enc_init_data->hpd_source >= ARRAY_SIZE(link_enc_hpd_regs) ?
+				      NULL : &link_enc_hpd_regs[enc_init_data->hpd_source]);
 	return &enc110->base;
 }
 


