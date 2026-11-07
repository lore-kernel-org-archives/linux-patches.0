Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063749;
	b=NC6WpsjA7NoHqXWmsfRoytcIfFb9X0OFj9cpclaTTDPM/Loil787t2fpz4T7pHco3X48
	 P9f5dmdQEzx/rVg8swo4st1kGhH09UpSQNIzfoGoJ8LEg/RfqvoG1MG9e2bf/RPak2Lls
	 +xc5NzSKJckHhEMmmc2ws63WBEXSaVx1jtW6uKCX+UdAos1U5UGxXF/Y/tfQtnOGKik3T
	 feOEFk7S0DvNQvTMjfb5+h3ja6kycPMDADHXQMW/rqsi8YCT9qvxZ34pTdKzCfitLxy9S
	 4kj+NVRM4CwbE9Ov+wubL2UJiH6uEgIEI6bYuR6uzmmppotLcI+EEWR746SANKI3sZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Oq+UCzdBBNtSGqlRY3RAjZlY05lrOVaWgX6UUkWvIcE=;
	b=y5swF8e351McFqdIutojrxqFaMz2Iig9Z2N6EE7DVKXyK9ND5RxQ8qzmaoc83ppI6J8z
	 xwn9F+QtSYIy1TbcNvAtomEXDo1QlUjs5NYb/EYc/iUaEDJA/ezxIojuC10hLx1+r8xk5
	 owDle8+NxpfDaUyg1NHeOKskL7uFUKX2mVwHWnnAkTdL6dVbBjYbEiUBjyOENRHD9utHr
	 ykUmaT32fRzZ5h2b4QFDb8mydEWtStHGSvBoBWCrBcC/EC3tw+x8PBaPxXzZMgFpuI0RQ
	 LFQgtGEPPZD0rTktqQ6+s3/qJDtMm+jY3pgOL1UH0+t/l5I+Y6gLJM/cvp00RSFjPpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NNSnl27H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD72606D809;
	Sat,  7 Nov 2026 15:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NNSnl27H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862131F0089F;
	Sat,  7 Nov 2026 15:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063748;
	bh=Oq+UCzdBBNtSGqlRY3RAjZlY05lrOVaWgX6UUkWvIcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NNSnl27Hh4xHV6KLY98S1yFhCmtGUdWwO5cRdV0kVu7tw+DllaTNmKx0/oBLRq7T7
	 v1eGxu/9bnr87Ef5KbtrmpkJWfSk6XH5RvXdhCIfUZBOk9AstbVrEYAmQfszo88jFj
	 wG1bfmVd1a4Frt3msGCk12mkTQMaG+fTVetIhqgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 842/869] irqchip/riscv-imsic: Report successful hardware retrigger
Date: Sat,  7 Nov 2026 08:58:44 -0500
Message-ID: <20261107134921.401553880@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit a2f482407d33ebe7f12e30d6cf383ffb1c7d709d ]

imsic_irq_retrigger() writes to the IMSIC MSI register to retrigger
an interrupt, but returns 0. The IRQ core treats zero as failure and
may schedule a software resend despite the hardware retrigger.

Return 1 after the MSI write to report successful hardware
retriggering and prevent the unnecessary software resend.

Fixes: 027e125acdba ("irqchip/riscv-imsic: Add device MSI domain support for platform devices")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Reviewed-by: Anup Patel <anup@brainfault.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261026122641.3292904-2-thnkslprpt@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-riscv-imsic-platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-riscv-imsic-platform.c b/drivers/irqchip/irq-riscv-imsic-platform.c
index 643c8e4596117..52673ff9edf4a 100644
--- a/drivers/irqchip/irq-riscv-imsic-platform.c
+++ b/drivers/irqchip/irq-riscv-imsic-platform.c
@@ -61,7 +61,7 @@ static int imsic_irq_retrigger(struct irq_data *d)
 
 	local = per_cpu_ptr(imsic->global.local, vec->cpu);
 	writel_relaxed(vec->local_id, local->msi_va);
-	return 0;
+	return 1;
 }
 
 static void imsic_irq_ack(struct irq_data *d)
-- 
2.53.0



