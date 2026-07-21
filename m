Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E5031716E;
	Tue, 21 Jul 2026 19:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661533; cv=none; b=kRtVHc9tEuCY7oVR6WSFOB5yBid1OpHxmt5uNVuejlzZxLwjiln9Rl42Q+IVl3MLD3AYKp8lrePsA7vls2o1RH41ZTrV+bvfehpz6S93grMukEmCXi2xI9AIphG3GA19l52b/HLxYadpj57jOEiohaiFZQWdzfHCbT+2DtqkyQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661533; c=relaxed/simple;
	bh=5n+x4d8KdzhwPsLJSKs1IavKgNW1cqXG0BK8OfKVn94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NdHcn5Vtmo6niD04QoaWnCPbStLZ8Lu4uVfsHykOwEM+4HVyPzxndXoiNTNGj77tEbPujYuTH6S1s8hoTKnQNK75Hlh8n1ZuX4uzWu8rx/W4MD5M4gEZV0DVnPxOsRETiVM2i0pCjLUXnD5eRrvh5DXEz7+Uu9/kPMzNVLdEx9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ceoubJur; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ceoubJur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C8E1F000E9;
	Tue, 21 Jul 2026 19:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661531;
	bh=vhLr8Npg/EdJ9hkLL7h3QOWGFxcAgK7mef40P5KJ+MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ceoubJurtvIkyU4QvCTytx4/hXJ08VWeDepPmrusH9jTnCgI4CozzVqiAqOv7FA05
	 s5V8O+E5/anmEBuR4Mmi0sVLgQCIMVfNygeh7uUilk9f5+kuWAgEieGNyTIanJc8yo
	 hNsNIJw+HSfzGbbHpaRUY86P12Y4fKR2UaWY7ZXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0103/1276] media: qcom: camss: vfe: fix PIX subdev naming on VFE lite
Date: Tue, 21 Jul 2026 17:09:06 +0200
Message-ID: <20260721152448.400074748@linuxfoundation.org>
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
index 8f6b0eccefb48f..76839898ace976 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -1740,7 +1740,7 @@ int msm_vfe_register_entities(struct vfe_device *vfe,
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



