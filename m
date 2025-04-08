Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B20D266EFC;
	Tue,  8 Apr 2025 11:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111116; cv=none; b=T7FWLtDimET8P2IJXPSluGDxljyT0B46r1SE3OqNS6I0Q7ThhWp0u6dFBcY1CoY8RHqaCSLdbO/3S0sWBTiS1woGifhORFYRcl7FNvRn8+XLbacShEIUgqJeMYIwlRXg4z5wsMS1iKXRH8N7+icaI84fkCBl4sXIcjDfUZ7j5b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111116; c=relaxed/simple;
	bh=9wcHyyK2Y/eAUBM8WbXlOE3qzCprzqsNZ/w11xBlLcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsrDMtYxNpZwZst7uLFPb4SumlxzAb7+CNIZQrGCG60UfWpfPQvMlbFvrjkz5QVv98u0pq0rvDweLhYdQbs0R9i5pZP6I6pMfVBa2mxLbzPyMgDUDI0f8BphZI6RvLFenprlCd2VvHlE5aagfW8aeJT7KWuB7hea1NLS8EYdhEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nPrZAwbJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPrZAwbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C547C4CEE5;
	Tue,  8 Apr 2025 11:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111116;
	bh=9wcHyyK2Y/eAUBM8WbXlOE3qzCprzqsNZ/w11xBlLcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nPrZAwbJHjJPZpWc995CCcLTJZ63o6oFyFy0nWJeVymLUYAzz7UmCxvIGVgIG3IxJ
	 sXmkaZkTyjgB/cdvSW+GXhJsXa0Pl8K5TqftRdV6qceb/EPYNTcy62PgvBPJFsMsAs
	 N/4eu0RUfGzuGPjRhQ6O6BlLaRHaQjkwFBIncmPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 314/731] drm/msm/dpu: simplify dpu_encoder_get_topology() interface
Date: Tue,  8 Apr 2025 12:43:31 +0200
Message-ID: <20250408104921.581777231@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 41921f231abf9a3a95550b2b565df8e4329319cb ]

As a preparation for calling dpu_encoder_get_topology() from different
code paths, simplify its calling interface, obtaining some data pointers
internally instead passing them via arguments.

Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/633396/
Link: https://lore.kernel.org/r/20250123-drm-dirty-modeset-v2-3-bbfd3a6cd1a4@linaro.org
Stable-dep-of: 2dde2aadaed1 ("drm/msm/dpu: don't set crtc_state->mode_changed from atomic_check()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 66dc2b1dee7f8..9928e72dfabda 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -649,14 +649,14 @@ struct drm_dsc_config *dpu_encoder_get_dsc_config(struct drm_encoder *drm_enc)
 
 static struct msm_display_topology dpu_encoder_get_topology(
 			struct dpu_encoder_virt *dpu_enc,
-			struct dpu_kms *dpu_kms,
 			struct drm_display_mode *mode,
 			struct drm_crtc_state *crtc_state,
-			struct drm_connector_state *conn_state,
-			struct drm_dsc_config *dsc)
+			struct drm_connector_state *conn_state)
 {
 	struct msm_drm_private *priv = dpu_enc->base.dev->dev_private;
 	struct msm_display_info *disp_info = &dpu_enc->disp_info;
+	struct dpu_kms *dpu_kms = to_dpu_kms(priv->kms);
+	struct drm_dsc_config *dsc = dpu_encoder_get_dsc_config(&dpu_enc->base);
 	struct msm_display_topology topology = {0};
 	int i, intf_count = 0;
 
@@ -771,7 +771,6 @@ static int dpu_encoder_virt_atomic_check(
 	struct drm_display_mode *adj_mode;
 	struct msm_display_topology topology;
 	struct dpu_global_state *global_state;
-	struct drm_dsc_config *dsc;
 	int ret = 0;
 
 	if (!drm_enc || !crtc_state || !conn_state) {
@@ -792,10 +791,7 @@ static int dpu_encoder_virt_atomic_check(
 
 	trace_dpu_enc_atomic_check(DRMID(drm_enc));
 
-	dsc = dpu_encoder_get_dsc_config(drm_enc);
-
-	topology = dpu_encoder_get_topology(dpu_enc, dpu_kms, adj_mode, crtc_state, conn_state,
-					    dsc);
+	topology = dpu_encoder_get_topology(dpu_enc, adj_mode, crtc_state, conn_state);
 
 	if (topology.needs_cdm && !dpu_enc->cur_master->hw_cdm)
 		crtc_state->mode_changed = true;
-- 
2.39.5



