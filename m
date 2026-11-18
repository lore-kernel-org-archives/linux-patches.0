Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049483;
	b=ZR21/ScgJZQncVvVUvQNAw3M1IqwGSTaB3Paao0q6MRU+8f+GDG4i4NaX40bGU0NNKjO
	 9cIf/qZOLgG/sdjyIb3omKnkY72qk35tLvVr8JAwlHCuaOeqKQEr2MnRBnaFqiCXR00Bi
	 vgWvBDHjL1Mqz3HkF3wtB31coTPrwhkvoBTiwFGp17C+v2jJFmv/18IAnIBQ6uZgCr6yk
	 JSeaPvYGIdVX3YbZ3SythaHw4vTZEp2Co6Nu/5aDh5rBmpXNW+unXwdAzlE4GQRabsCnL
	 JHQntZzABwBuIpyqfYZs8Lttk/33DJ7+bIfw5a8VMo7Je4rUYo4q1FgDkU6GOHdzhQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Uht2sKQfz4e2XACapBy4QYDHnaxGBcyO04fGFUeB9QA=;
	b=XMB3nUGpBirwYBj9n6M+PC074zkTm4pTFHxrYrMu0htnJYngx/a7nkWE2EisgXBMDOpl
	 JgegUsByPukgYLJQDGs3GyaCyhlcOmDorwmxCoV6d9PDThF8mzpUUUdHT5iL4XeCHRppB
	 wYM62ep1Jpzx4CY8s1+Q+wXXSfkVGqJiSGhHns8JJZRuJwdzO7/BZagf/OxfISoTWnrQc
	 Qzn1mgoOShH8lHgCl2zqhZJmkwVmVEW8An4lHSOVSmBR7joKnxxAjKr6Tlzxp6yMN2UW/
	 kw4xghWHl2lgz9mEf7RB5MFalUL3Ja8XmzKGsOkW3aMHKS/RWFhvPmxRj3NeslAjydA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F9+4InSL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35602606A320;
	Thu, 19 Nov 2026 00:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F9+4InSL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B17F1F000C4;
	Thu, 19 Nov 2026 00:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049483;
	bh=Uht2sKQfz4e2XACapBy4QYDHnaxGBcyO04fGFUeB9QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F9+4InSLskTB6jIqQ65YMkR/Iw06UCcO5Bsje5bCYJbipxEZJaHUxcr5+ZGNwEa7w
	 SBJoXSAVjnETqTcg3VPrrFW2R0dR0xiQU8ZKkvrO/N7Tb+TLVKWpn87ZV1gfy00ilc
	 kDrt49cSjr2hEkKSw3CDA3WLl2BiTEsXH02tLLWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2360/2857] mailbox: qcom-ipcc: remove stray disable_irq_wake() call
Date: Wed, 18 Nov 2026 15:56:34 +0100
Message-ID: <20261118150326.495997051@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>

[ Upstream commit 134ef0278d4e48bcc325a7699250dfe861c11953 ]

Commit afaf2ba5b430 ("mailbox: qcom-ipcc: Support interrupt wake up
from suspend") replaced enable_irq_wake() with IRQF_NO_SUSPEND on the
IRQ request, but left the paired disable_irq_wake() in remove()
behind.

disable_irq_wake() decrements the IRQ's wake_depth. With no matching
enable_irq_wake() left to increment it, wake_depth stays at 0 and
irq_set_irq_wake() reports:

  WARN(1, "Unbalanced IRQ %d wake disable\n", irq)

on every unbind. Since there is no enable_irq_wake() to pair it with,
remove the stray disable_irq_wake() call; IRQF_NO_SUSPEND already
provides the intended wake behaviour.

Fixes: afaf2ba5b430 ("mailbox: qcom-ipcc: Support interrupt wake up from suspend")
Signed-off-by: Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/qcom-ipcc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mailbox/qcom-ipcc.c b/drivers/mailbox/qcom-ipcc.c
index c1e0d7ef0053c..7426fc5e02e4b 100644
--- a/drivers/mailbox/qcom-ipcc.c
+++ b/drivers/mailbox/qcom-ipcc.c
@@ -341,7 +341,6 @@ static int qcom_ipcc_remove(struct platform_device *pdev)
 {
 	struct qcom_ipcc *ipcc = platform_get_drvdata(pdev);
 
-	disable_irq_wake(ipcc->irq);
 	irq_domain_remove(ipcc->irq_domain);
 
 	return 0;
-- 
2.53.0



