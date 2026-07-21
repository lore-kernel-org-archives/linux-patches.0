Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2478446AA92;
	Tue, 21 Jul 2026 15:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648377; cv=none; b=ZOcl/MVb8HjESkekjWp69QKlkqrzme+6FV4Foghf3GcvNAOjBnWfJz3+jg248g/wDl9dpyHxN9AvbrTUiNfUs9exeKCsRef1YM/wbal63SaHoUiyGNYueMV94FDDyi9Pv0q4mFkUk7EBWoFaV2dU6WaSPKW5+nQ+oVrBuR7f+w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648377; c=relaxed/simple;
	bh=Yq7PIXKFH1w8hW9NkeEiUiCvHLCO2OhBSuTX8IIRi0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npbFDihMsUJ6l1cd6dgvqlWEcNEmQPT/WmnVXNoBtu4pfnijl/wm71zBfr3Uq1cJJ4wSqcn2al4aMmjlh2EzWOnz8LOYuDBY1TziNO42cnIHlVgdTWUyb066i9rYElw8O70zmz8K11H2B7y3lp5KueAFujFf1hGxk01D9l5JHdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GGyEBFgC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GGyEBFgC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2EB1F000E9;
	Tue, 21 Jul 2026 15:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648375;
	bh=QPk8SUNt00gkvPDtKpC8rvcQdFKrVoY6ZtwN6h0BNVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GGyEBFgCvovo2BqfbHEq/emkSS4Pg/Y6Xybqe3TjrRmP2YAoWio9kp/xSO7c7/W8k
	 1S+dOiIXvXYQibAg82Y81tNVY+65DNDrdfbDouGVFBrh11Me5klxXVPPm5DNWdIaV1
	 EcIq93xmaqo5b4wybEkQzCsmM/1Ywh4OdBYLUijg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0174/2077] media: qcom: camss: vfe: fix PIX subdev naming on VFE lite
Date: Tue, 21 Jul 2026 16:57:27 +0200
Message-ID: <20260721152556.789845338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>

[ Upstream commit c97e797a64cdfe4acecff831b4285418d2815893 ]

VFE lite hardware does not provide a functional PIX path, but after
the per sub-device type resource changes the PIX subdev name is still
assigned unconditionally.

Only assign the PIX subdev name on non-lite VFE variants to avoid
exposing a misleading device name.

Fixes: ae44829a4a97 ("media: qcom: camss: Add per sub-device type resources")
Signed-off-by: Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-vfe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index 5baf0e3d4bc461..2ee4f9ae0ab50e 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -2053,7 +2053,7 @@ int msm_vfe_register_entities(struct vfe_device *vfe,
 		v4l2_subdev_init(sd, &vfe_v4l2_ops);
 		sd->internal_ops = &vfe_v4l2_internal_ops;
 		sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-		if (i == VFE_LINE_PIX)
+		if (i == VFE_LINE_PIX && vfe->res->is_lite == false)
 			snprintf(sd->name, ARRAY_SIZE(sd->name), "%s%d_%s",
 				 MSM_VFE_NAME, vfe->id, "pix");
 		else
-- 
2.53.0



