Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030884;
	b=KdVxu8OJh8zH/s9rRBOeIOFHo5JZTW8lzC8kG8zDkpNoYQQqCYNmjA4ze2Lz+YA0cXoo
	 +1x4S4tUwLcGguj12cjE6CcFC4SZqcAjY9FXnFeDztDHnIxT13oRxSSUZfcksnWou4q9l
	 hoY+0s1Vwc3cTDGNJEl94PqCtDL8lfX3tjcov3jsjnjwmHPuiZVQfJ9zJitU9bRYzw7kK
	 82y5TOVW7lALOgotegTcRkOu0sseTzc9r/A/8bNmdB6M845ztUv6C5HbaMbRWjcTvaeMV
	 gGYf+LBgioLdaTkzTUqFJVoFogqZwR2ZII1ShpNAnSWNRnKJ2xNVVBrte9+e2kEHyzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WgFpBqsE9pyAQ5Q2f069d9x5m+ZzKxcwexXIS83jDM8=;
	b=PY/IpePxMm+gAtDeFDF52mFHuI204thiVP0pyE+ohIMfMRouXAnOXgO0TlM01hxJSaf/
	 aMxno1oz7i3BL8L89wI9B/4XPpbtmTsdhobPhexDM250iF45rO/dmGYDQtWKgOdi+SRLj
	 WmI+IzNzuU78IdSEBKugKlWzKDKMrt899yNDbEIkDgIIX3fuShhEHXcLts0DqTG81/DBT
	 8h1vYolQ7384zYYs2SDqamk3/6/lX08zXzhfwP4efYHqgFuAkvOZsUfHLozqG4gXzuuSJ
	 DEMoa7D/mck+tk5QS+p46Z7JladV03R2Sn4OlFQ3iib0Ccj39hl4na5V3tf/jz/rmpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wXA0hRRl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14ACE606D356;
	Wed, 18 Nov 2026 19:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wXA0hRRl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378AE1F000C4;
	Wed, 18 Nov 2026 19:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030883;
	bh=WgFpBqsE9pyAQ5Q2f069d9x5m+ZzKxcwexXIS83jDM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wXA0hRRlAI+wuYfvzGPDSCXJpYS0xrBnO/VOrPaMYKy7j6ecYpJlNx9ZEzz+wvTyI
	 1Fb5XS/hyJoQkKXDtboRuWwETu/TLREt9+MFGOPEmi069d9EyYbpprQQQzJTZ/Ccvm
	 /CZiRBs3VBr+bCqI+6W5eZTxvwSDoX+5wQvZz/yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0861/1756] soc: qcom: pmic_glink: Avoid losing early rpmsg probe
Date: Wed, 18 Nov 2026 15:49:48 +0100
Message-ID: <20261118150043.619910213@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index be64a4ce8e0ca..7e954db8e7ae0 100644
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



