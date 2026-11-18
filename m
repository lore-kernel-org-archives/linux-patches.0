Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018762;
	b=CPgeMjHl21RMRdomnLZJ/z0tYZRZyrmd45uuHug8dCeBNcHGJILOS6e3lPBSVLyqJBCy
	 cZ1cISuifUki2CRgdiiP2CN4bjFcCiYMFL5BelfPZ/1F+WU+JEMHm88/8woHNPInH9EyT
	 2KmCRrzvzVBfS8TBnrn4cRL2McNZtKsvobMsIFexzZPLy9rpjpOHiwFteQmIMcXlD68bW
	 zRI7Hm1HYhPPTSEDFvD1EMXFxdTjCCVsg+6IUINLuoH7i0rOQIQ5DXb2dRed9Vcz7eFz3
	 eg3bpA7oyWiWqqzDNDSlT6IKPNrMGrL8C36EYOJ5z1do1OZPbfqsKsmdmCOgj69Akdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/rovwHcjH49Xb2ExPbQN0wPYPDde1AlwUxyigbG05Sk=;
	b=PdROYdsUR4ADDW8BbXwT7nyOBc06Etyk8D0xesH3Mfv1LeXvaqJtutbMtTrrYfmUTKie
	 vPqKCTN8xwHo7MSQUF845Vw7Ri/L7mXNY/A+klWjc7SGUFFRpbyngpOv1Vs4tqiObKuyt
	 4hTg6i0V/SMp0+y5/MoAu6E9o1OiIt5ZmnmK/xlJb2HpFA4nMHvfT3p8Qgnq7WHOd8Ion
	 uY4RXhQ/L9EmG68wU58vbbq/t3VrfUoBkCWxyQkgeZlXDQMEhPD/m54hd+8A+OyN2WboZ
	 9EcH/CbWxVB4jot0TRlW8l7RazTaeUESNSQbJsdaLGtK0Snm0oAW/LKPV697XsBNlRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PBlzGAOk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E062606A31C;
	Wed, 18 Nov 2026 16:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PBlzGAOk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995861F000C4;
	Wed, 18 Nov 2026 16:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018762;
	bh=/rovwHcjH49Xb2ExPbQN0wPYPDde1AlwUxyigbG05Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PBlzGAOkcMRJ9m3JpUJJ8tInMPPVTCQltJuM9WFakVb4Ihi7SMdNWikRoylC2rndw
	 LjY/R0PEu71m6VrrGBc0hzJiT240tgx2XVBZEs620sECLiuuAkRYY20tNNUQ94IEOa
	 3/00GOvvADTBTDUT9uarrUYHwa6PpPvC4ZRRMD0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1304/2651] soc: qcom: pmic_glink: Avoid losing early rpmsg probe
Date: Wed, 18 Nov 2026 15:42:24 +0100
Message-ID: <20261118150334.913984621@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 0c79a829af36a94143c747a0ab8f0a8563b17cfa ]

The PMIC GLINK rpmsg device can appear before the platform device has
finished probing. In that case pmic_glink_rpmsg_probe() sees
__pmic_glink as NULL and returns -ENODEV, which is treated as a fatal
probe failure for the rpmsg endpoint.

If this race is hit, pg->ept is never installed and PMIC GLINK clients
never receive the service-up notification. This may leave the system
with no Type-C functionality and without battery/power supply
management.

Return -EPROBE_DEFER when the rpmsg endpoint arrives before the platform
device is ready.

Fixes: 58ef4ece1e41 ("soc: qcom: pmic_glink: Introduce base PMIC GLINK driver")
Assisted-by: Codex:GPT-5.5
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20260720-topic-pmic_glink_defer-v1-1-94c0f233f2f7@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/pmic_glink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/pmic_glink.c b/drivers/soc/qcom/pmic_glink.c
index 3042261578aad..84fd0c82c0c4d 100644
--- a/drivers/soc/qcom/pmic_glink.c
+++ b/drivers/soc/qcom/pmic_glink.c
@@ -250,7 +250,8 @@ static int pmic_glink_rpmsg_probe(struct rpmsg_device *rpdev)
 	guard(mutex)(&__pmic_glink_lock);
 	pg = __pmic_glink;
 	if (!pg)
-		return dev_err_probe(&rpdev->dev, -ENODEV, "no pmic_glink device to attach to\n");
+		return dev_err_probe(&rpdev->dev, -EPROBE_DEFER,
+				     "no pmic_glink device to attach to\n");
 
 	dev_set_drvdata(&rpdev->dev, pg);
 	pg->pdr_available = rpdev->id.driver_data;
-- 
2.53.0



