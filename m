Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031417;
	b=V3mpEktfynUzDPieeVjTuquQZF81/WJnEZzU9GQ22Ykghfvuqd9DyJCcN6fHwHaXQf7Y
	 PuvBz1KVXuI3ug6NQy8Gc+7Vtu+FmTTumZyn7a0m6H5sU9RVvPTzI13Ke4uZ8ZDiwuCW9
	 Dw8SShtvv2K2f2KSCZXYeukH4rwYqtEo/YR3S+DNa9ltnVllDpnnyY28dWihwkq2vOXkt
	 exXu5TWoEfM6PUW/NNsd65ksyZ03Yix1jSBDlzc9JrQAi6SxpBp439N020gqnyN0gJKNW
	 mqBU+KpAumqB9PO1Nr6zSPwuLgOWnfdGwi5SEjxB+ikX4Z6F0eVAfQ8rynHhiyyrnVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dzATMRrzuk2KjPOc6mMe3mEk5mSGqjlPnJt2eXNnu50=;
	b=rzm9gglTXJD6VdRUnINpFjN09Yrpg2kIojKM/o+bYo0sYheiNj5o5f1NkvPTBlFLiV4n
	 6szX7VszOoXBD432jioEtBj9akIvLlWYgA+bFC//Rwp3HvCn1x4ZnwXX23weFVr7CUzrh
	 42SE4PzLvp0PjD/bPQx+EnDukZeSSkzePbB+JafUqyX/ixFwNaY19BSf400u1h4/QbVAO
	 ZqOQHFgur3OlFHeczxBqHLLTS6y+EYlUo6ZJKiYtibWR/+Jxggas2l3ROiIBYAIFF0+vX
	 fE+p5b01yWfk7NvAyzfO7ErwAasgvDKmXnAh+mXKPDkCnpSAPrcDq7V3I0zKqArQFqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0xHAU98J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CD5606A320;
	Wed, 18 Nov 2026 19:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0xHAU98J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E611F000C4;
	Wed, 18 Nov 2026 19:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031416;
	bh=dzATMRrzuk2KjPOc6mMe3mEk5mSGqjlPnJt2eXNnu50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0xHAU98JhxCThyiiNef6KHM9fePakQ0nM/vbAH6O9HvlPK85m5W/xTbjeOwY4Cebs
	 BN9O+xiYirkl22cbFngTrPTJriMuMQKQ4plaO6+q9NeTkgGmKTXYyKVzD8/sJNpl7x
	 c8Swjp8X0MnuCTZKvRAjTTqsrrSIC+7CveMkcrt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1050/1756] mailbox: qcom-ipcc: remove stray disable_irq_wake() call
Date: Wed, 18 Nov 2026 15:52:57 +0100
Message-ID: <20261118150052.009208362@linuxfoundation.org>
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
index 9e7c82c7af0a4..c619dfb24cd0e 100644
--- a/drivers/mailbox/qcom-ipcc.c
+++ b/drivers/mailbox/qcom-ipcc.c
@@ -341,7 +341,6 @@ static void qcom_ipcc_remove(struct platform_device *pdev)
 {
 	struct qcom_ipcc *ipcc = platform_get_drvdata(pdev);
 
-	disable_irq_wake(ipcc->irq);
 	irq_domain_remove(ipcc->irq_domain);
 }
 
-- 
2.53.0



