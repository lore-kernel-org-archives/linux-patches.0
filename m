Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019486;
	b=lT+yYmsaYgIEQxZ9Lb6cYcyuWJtffqP0kNKPzNIk9L60YwiWkbxprSDMJjq30JYm073G
	 xrmFex5Hr46jjgcafN2eEXzz4N+ZY4yUvePTPjCNDxpUPxUSrdQkSw8ZVB7wFqN5IYDO5
	 tE+iTieRD1rb3lq8oPN+IcN0H6GL5/11h8K6w5JVejP6KVg3dBFGMjJPmDGJNB4GU0SlZ
	 tSoDJIxBRAr/EfEgDBEqW60SZWDEq2VO9UdS0eMm0H6nl2lum3z90iKjhQmtSOpKJUdh4
	 I3XVqX7dVMQaxdQtsjOj3y9H0WlZdJaPCR6Bh69mkYl8dCjTEQfPGxoRb1gcOv5uclw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wCfrUH4prdO4JoAYVGOw82F/9Ksr4M5u7ED1YfjrzO4=;
	b=L1LIxvofzXuP+nelEIaWC71G4Qm5Muj55cAGFQMHBYZ5gULi7NFVEKRbUmqi4La8dUHg
	 MFwZtepTel1fez3VMTZ8OPd7uf6srfFwG5IjTYcTvhDK9jdgCpQu+M9Gp1V4YDerEHgMm
	 KQR7r6IgBrfnS+sat1AXGuJxNc2+F+YyT7BPqXDQ5ihU7nGB0NIxzKopd2GrCtHb3lgWl
	 c4DKhmTUzAassTI2xLY2bxu0DCEAJethaQS7r+QuJJpc7+lHrekx+b5oXjl2GDyHEQ5km
	 d+KwZWwbBqJR1YJe3MEb3TjHSUxNiV+6nZid7Fg8r2+So3ljK3BJLGKcA9oMthXE0ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JeJGtI0N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B7B606A7CC;
	Wed, 18 Nov 2026 16:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JeJGtI0N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57E41F000C4;
	Wed, 18 Nov 2026 16:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019486;
	bh=wCfrUH4prdO4JoAYVGOw82F/9Ksr4M5u7ED1YfjrzO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JeJGtI0N/Q4FXiPRQgO64DQl7Mmpto1zssu3yDq3BjZKc0X9g0Eavc4HKakeE3NjO
	 lSrQcj+ZOcmqCerb1taua3+kp1wHABNBzpL8GdQmmJTFY5pSzUwwOZxlcx5rpJ0O5b
	 RVf9WhpGrXVgdnvCN/fLo/dQ1dTYZtj65rAVedas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1611/2651] mailbox: qcom-ipcc: remove stray disable_irq_wake() call
Date: Wed, 18 Nov 2026 15:47:31 +0100
Message-ID: <20261118150345.834838657@linuxfoundation.org>
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
index 43985fe6816c2..c1dec33290a79 100644
--- a/drivers/mailbox/qcom-ipcc.c
+++ b/drivers/mailbox/qcom-ipcc.c
@@ -351,7 +351,6 @@ static void qcom_ipcc_remove(struct platform_device *pdev)
 {
 	struct qcom_ipcc *ipcc = platform_get_drvdata(pdev);
 
-	disable_irq_wake(ipcc->irq);
 	irq_domain_remove(ipcc->irq_domain);
 }
 
-- 
2.53.0



