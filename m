Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041219;
	b=QsQcppWqwxLJDas1DnwjDy+I01ZpWihY7VHEiL+b2unPs+YwC81mcX7b/fus7erRJe2v
	 yQs0SVnRsXO0/DS822o5QJZa4Ncm88ok5UodNec3DeNfgqp7pXfl1X4AxPgj22Wuj+LmQ
	 x1mb35vjJauoGzxEtI9O1wbUHB1aY9czVeOjZiLAk0ErJwIJiQU8fqn7agjETDT2AATHj
	 kYqKaXI2tdwrpFrlhxaymu8BJn0nK377x55LWhz8YVkHvc6UAiCZL5WplC9YHUn/aq1u5
	 RnG5EHvdGuiuyXQ9rXR1wH4sgSTcHztibHKxk8JzybCMxPuIAemysqCO75DupWBeyjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zzdvg9rO5QMOi0/Wj8bLDxRlDgAtF/RRFfUgA0j3jpM=;
	b=CkzzvZnoPfcpwncV8AFTSYbOuBaSR7YKa5K/av43xH/obZZAZGK+4bsccszpKRxkSvCY
	 5aPzYIkQrcjaABrO8Gkd6LZjb30Ax90MoNqOcIA5x3DA30VTfvMVR+by+QLAIQGBIU9Qn
	 0Bw4NL7gIu/OFZ3Nytp5iz5Mm6+ngD/dZT6TELa4GzrtMrlcnGe6vtEbz/W1m4afCKDeB
	 uNMt/1Wrp6lG6CQ8KJVr+L+Bq2aInQIYyrWPXzJf1wZfoNu/OktI2KWvlhI6JZF9JuLmR
	 RgYSelYAtj4feGw4QlAW2qioRGOMAQcbrqU+N5QAp8jv8Fm1lhdjBQlYact0E4PBuJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nVpSY/Io";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EB5606A32A;
	Wed, 18 Nov 2026 22:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nVpSY/Io
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D721F000C4;
	Wed, 18 Nov 2026 22:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041219;
	bh=Zzdvg9rO5QMOi0/Wj8bLDxRlDgAtF/RRFfUgA0j3jpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nVpSY/IoFpIOJC4VSmMuApkTA4EqRXHVCbAxLMqeiG73P9Z+K5PMT0wdDJu+GusKG
	 Gm37nw2aW0idpWBCXvRKEmyBuaa6xhyX2NlKzglfXONEbwXCthAIBUZbJcT/XHkggZ
	 mvmW/CvblXhlR3u/h3UMC9BJ+dy/ndEfX3E+s56Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2735/3318] mailbox: qcom-ipcc: remove stray disable_irq_wake() call
Date: Wed, 18 Nov 2026 15:55:57 +0100
Message-ID: <20261118150442.856250177@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



