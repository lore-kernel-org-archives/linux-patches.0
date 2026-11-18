Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026144;
	b=JE5a/S1AaN+b2fjX0tRGJaA5+vHkiVohEPfpexVjg/ofa6RSTmgxcWLwv3YdoiRG3wz+
	 eJNqoREyiEi9sZ0QrGjgRgOAwvNiOgbzFf2+HYd1q5FQFQB7/r/m1JjDZyzaZKPCE3T4b
	 QVUC0L0xEgOVpYifyl8d7ZzJBh3SgLTuqEW8HfpzupNwcvbKy/f+9jIF/Gwlu7pqDTvCS
	 luSYNw5xBx1DXtgIWm18TM6sGX767dJtKMmRB9+4E9/Bxt2F0aKtk7XyTscrk4zKkn1Ej
	 JDxRO9n9PC93aE8B06v5DmGBkSU01/O/OWwCqFWlr05QqqRvCMKuu6EDGvT0n+2+dxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CJARhk7c0Frdqa2SZfMbZJLaCxuVwXF39B0n5KFfsE8=;
	b=aS6wZyUXYjRe8MGjqqumP6xfKTXxZVIDZYaFY3zQLbU1og/8SWaBspt/WaN/MC26Fzxk
	 CHnH0QivGnvG2QkOv1fClmz/Y9H4NCA06F9jqramQ+/o/euQgIF4tQx1G8+IhNqdFDt4Y
	 F06i59dQmdp7/Motme1vzZQEHgL9wNuMD4NMDA/y3MMT3nSUxMS+qNVAR3+VGBdc0HtYm
	 NkrQOREnFb575SyS2r0vPPdv54IjwLpOGlSp8k98qxGiZ1M1M0TkiivNckB+90SBiVUlL
	 bRL4Hwyrz48nyKn5H6LM3wDn2hjokAKtSiPnLMpsDqxaJYE8k36nSNHtDvXOznvCmpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dIAzkP+n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB8E606A32A;
	Wed, 18 Nov 2026 18:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dIAzkP+n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708E21F000C6;
	Wed, 18 Nov 2026 18:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026144;
	bh=CJARhk7c0Frdqa2SZfMbZJLaCxuVwXF39B0n5KFfsE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dIAzkP+nyUmWVIMBvsEGPsk61aUSe0B8hza8MADkVSexWzw5RRrxuZP0dvxGRcFRN
	 8nuLsLTsw06uhV34ndTYTaue2dfcqOigqugwFmmBq57md90VLg8/XiSKGJkcWutc6I
	 JrbpKKYJkJoYMyk/bD5/XzlbjbylmahCrz/nVh7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1328/2151] mailbox: qcom-ipcc: remove stray disable_irq_wake() call
Date: Wed, 18 Nov 2026 15:51:03 +0100
Message-ID: <20261118150210.453706276@linuxfoundation.org>
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



