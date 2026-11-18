Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025474;
	b=tODoK8+m65MFrj4LhSxRRWZ7UOTI4gJzD1XFkzcHzMk72llhZFG7F5WkR7S/fmuWXE7U
	 8amoSRLA7KWXMIKfJKuEzwDffp5G+nn81fWW8/UuRncdwkB3r+J0tKubhtahkCOV/d1De
	 JSE2CgInWNX/oKZosGdZVN0sUMWJkEZhSj7bwquJeUDFws+LJncA2Me8h7fMOcD6NSoKA
	 xMabLGKvsApQnPaAYxJQk/hRHdycsK14y1pnw/PAFFnWevekjm0sPVzQySWTIXyTuMjqe
	 +2fq3HcVa8R7gmiWEydjuHk5hfa/45NaVXypeOBCaR22ocNyt8HbzWPR624OscUWB4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025474;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lqtmuj6X9h4q2oKpc1++pGFNxzGIZvX5VWFBsY2i6pk=;
	b=Q+NCytFNQrUjGIyA/nSrgP41QPrtCzVU4kAgNFcrwsnRxvmsO48Iqqw6lOmy4jMXq/Rg
	 OqXMryf6k/WV6iPowBo7lIJnGxx/ydPsCDAE0Tm+IjkwWvgXfNk9IRMttnCiRNdQvtD97
	 QcnpJOpbmoecHtG7WfLM1Jawde9jDpmpX0quFlsCpdwXpyz7WqnjzQhpsqCwvIixmMetM
	 UI+bE2CesXPmiibHyoBAO+9nXPlVO8NBzXGBJ7xKjsWoXrnKUMHCRxiBv1b8EldLgipFh
	 nXWYCaFd2CZ+INLCcn2N4Oapeqa3dLruQVMa4UhrI/BvwalldmO3NkaoZoxaczRrgBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JuL2Rs97;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4F560A260B;
	Wed, 18 Nov 2026 18:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JuL2Rs97
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A63F1F000C4;
	Wed, 18 Nov 2026 18:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025474;
	bh=lqtmuj6X9h4q2oKpc1++pGFNxzGIZvX5VWFBsY2i6pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JuL2Rs97HhdokSMbXyK/HZigMo7pPhm72Sr81L+oAdIikaOrC7voIoEWNpo6Uxmzq
	 j33eiXEgXuIZT3+V8kIcaFumdsUXz/3/FY4r2I8qqiZDmvw9BndfRn0Tjs2QW4D/nc
	 r5T7DOa4ZphuKkbdKTTIAYIZKnH1xD9OxCU0stzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1091/2151] soc: qcom: pmic_glink: Avoid losing early rpmsg probe
Date: Wed, 18 Nov 2026 15:47:06 +0100
Message-ID: <20261118150202.022757317@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c0a4be5df9267..83088e3d15c94 100644
--- a/drivers/soc/qcom/pmic_glink.c
+++ b/drivers/soc/qcom/pmic_glink.c
@@ -243,7 +243,8 @@ static int pmic_glink_rpmsg_probe(struct rpmsg_device *rpdev)
 	guard(mutex)(&__pmic_glink_lock);
 	pg = __pmic_glink;
 	if (!pg)
-		return dev_err_probe(&rpdev->dev, -ENODEV, "no pmic_glink device to attach to\n");
+		return dev_err_probe(&rpdev->dev, -EPROBE_DEFER,
+				     "no pmic_glink device to attach to\n");
 
 	dev_set_drvdata(&rpdev->dev, pg);
 
-- 
2.53.0



