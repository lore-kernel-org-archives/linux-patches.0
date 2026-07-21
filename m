Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1408E386571;
	Tue, 21 Jul 2026 17:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655756; cv=none; b=jC0c/uUj47oKCUTNDwss4ojwBRnZD+dN4LuwB9OI50Uks5HmCT0KSMtsDnN719i6QloCYr3G79pRCAi1U23YrEAqjPI8wvb0FrDTejkaJJLAqBOF23t1R9BXIVvpx9/0xp2cwZdEzLbxOmxJIxHp/N8Dhq/6HfnaAOeFD/bNO6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655756; c=relaxed/simple;
	bh=W3L5+59EcKuT1gbKJ06cuU+/33Kupx9X9Z2dqymcxw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svnE4jmC9mZmXJ4MM0GjsQquAybnzgpZLA1Hg81ucADvHgBSmwtsMB4AoV7mSWHjP5RXc6JDO2Ouo2sRcMcQxjnOLQ7OkeHqYMp5S6qg+ms4i10uMj2KrQrjRHXO6+RZd78Q3ws9Agb8tZ6locY5td7pkQXTohrxhBz3eUuTXog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fC40l2GE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fC40l2GE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7900D1F00A3D;
	Tue, 21 Jul 2026 17:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655755;
	bh=+r3w8dE33xmIeTG0qRFZEZ7IDo8DlRvjpJ0gX6gCe3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fC40l2GEXXbOdCDA2lB+wFLPO9x/5muey3JALorP5c0jJ++spB18XywPj/30GJzjY
	 d6l4Cbqe5KhE5S2eMdJOBPzPDvnuCmtwf5tOcABdcUP3d6H+w6j/lxj2e4Ip6ASata
	 dBeHcrAToUDexrY6lkSOE45xmuKcINxigrHUPtpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0128/1611] media: qcom: camss: vfe: fix PIX subdev naming on VFE lite
Date: Tue, 21 Jul 2026 17:04:04 +0200
Message-ID: <20260721152517.750763652@linuxfoundation.org>
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
index dff8d0a1e8c228..20e0d6604fa936 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -2038,7 +2038,7 @@ int msm_vfe_register_entities(struct vfe_device *vfe,
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



