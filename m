Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB4D1C68C;
	Sun,  1 Sep 2024 16:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208428; cv=none; b=p54qSfHw8M0M8fEniyk4ExncnVUyK0h8OPmBdONDvUQDl5kOJaZOVkuDzq7pDODSxwASY79IxqagY1Iy9SFWnEor3HiA+LI9PlLzB8ADXyyciLoD6HssAGE0zHJ1An8U3NzE1JdDkYpPQCBCU/URjduzyJVOibogl+k3R62Tm4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208428; c=relaxed/simple;
	bh=SZSoMA7JfukeC8Z7hm5Ev76sh+0p2FpwMgM1pKSp+Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJGZXH2W5wMJ9B2Ur8LZmjzAfxxkTZ8BDtFuXfAtcrPRTTp1Wj0P8JieJb59VRNS7pkK6cAgX4c6BbMUJbQli+mglx4tB/BEfX0Mj1TMWj6b+wAcrGbemGrm4mxZVFE/2FwWPBf99GqLM94u2cvjOAzU/Q6m7faS6ygYLwMD+u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6lwKk2z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6lwKk2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1233AC4CEC3;
	Sun,  1 Sep 2024 16:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208428;
	bh=SZSoMA7JfukeC8Z7hm5Ev76sh+0p2FpwMgM1pKSp+Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6lwKk2z87rOviAare48l/r1/dkzjHGum2tyOWdawAAlQN5EAICmd6wbzlkfBC1EV
	 xBiUyTtgB26ASLG6aH1bg8xKF/RdOm+CNDtWsel9uGc6R2YJje49XGCK9zAgSMHNjR
	 Ap8ZPC7iHn1fzb9trvZAZ4EEAUklSuD88lKSeCkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.10 079/149] phy: fsl-imx8mq-usb: fix tuning parameter name
Date: Sun,  1 Sep 2024 18:16:30 +0200
Message-ID: <20240901160820.439273486@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit ce52c2532299c7ccfd34a52db8d071e890a78c59 upstream.

According to fsl,imx8mq-usb-phy.yaml, this tuning parameter should be
fsl,phy-pcs-tx-deemph-3p5db-attenuation-db.

Fixes: 63c85ad0cd81 ("phy: fsl-imx8mp-usb: add support for phy tuning")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20240801124642.1152838-1-xu.yang_2@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/freescale/phy-fsl-imx8mq-usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/freescale/phy-fsl-imx8mq-usb.c
+++ b/drivers/phy/freescale/phy-fsl-imx8mq-usb.c
@@ -176,7 +176,7 @@ static void imx8m_get_phy_tuning_data(st
 		imx_phy->comp_dis_tune =
 			phy_comp_dis_tune_from_property(imx_phy->comp_dis_tune);
 
-	if (device_property_read_u32(dev, "fsl,pcs-tx-deemph-3p5db-attenuation-db",
+	if (device_property_read_u32(dev, "fsl,phy-pcs-tx-deemph-3p5db-attenuation-db",
 				     &imx_phy->pcs_tx_deemph_3p5db))
 		imx_phy->pcs_tx_deemph_3p5db = PHY_TUNE_DEFAULT;
 	else


