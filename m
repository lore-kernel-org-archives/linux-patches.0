Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062655;
	b=S5c1ehAQRL0QyBbgK7t7k9jwYBOioSYbcteKmDkGT5pyzcLqLXUcxweofq8YA4MAQN8S
	 DyCB83aWA0L67EK4nstwOOLFfgFyK1B869XL1YmdY7Q0XPNh2dXDgObZ9ij7VAleFMVzx
	 fsofdmxqOJAdxZAoBeWgXQaoe1puoSeCyZfa08A5i6nAg8Emc0vCKIU2ZM0dnUCf/07UN
	 6mlXSghUkcniPGs3BHbBs+NwDPBC4paJTlYPRb/W35hmVN4hTI0txnBaJJ6Av70e9JsWs
	 2292XvCl+VilQR4KUaiExhVo6WKs+tTDA2BqPmIxeosR7pcu+RGwBDqFgfzAluf9g+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4Ksd4gW8DYU7Q/rZrsiQNcdP2kxSUu4Hpvw+V5SMAWI=;
	b=W3qh4EfyQPnOXUCouv4ePycq5BPrRKLx0lQ1cKCEZgkUEAAw2ATAUawvuwOyfqjcXWIf
	 lEL3G52akXIRLZ2DyH2LrSXy07fcZGLNr+Hf97HuFMrYcVc8qcDULoyZk6uif17p0xY1y
	 UFeP3OepDDHrHvI1InDrDz000sLT2O6uDIaPKDViLf1UpR+MXwd1dVRKCAS+kgRe5Wchn
	 uVyzO8AsP+rObCpbA3O7jhFuznAFIAphIFqr2eSNB36H08Havg2eST/r5Bejo+ubW+RT8
	 RgLLjfvqpjs4R53VtdSLBgo5ryeWVOP17pwBSzP9VBxlXYQsftQBygKFJ/nxWiicpxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o56QyWxl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5976C606A330;
	Sat,  7 Nov 2026 14:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o56QyWxl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090851F0089F;
	Sat,  7 Nov 2026 14:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062655;
	bh=4Ksd4gW8DYU7Q/rZrsiQNcdP2kxSUu4Hpvw+V5SMAWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o56QyWxl2J+fbzlSKDF4F8CP2V5MwzbkSXcn9QM81MQt4RpgSUhYlIKIt506AmlnX
	 gONOQzXKgcmQ2z4e9b1Y2L+Nk3etc8CMYR7Dq8ALW9DPs/i6UNNwytoSSHBbGCmLl5
	 OIGASFYbBwEbJZDIf9VdwIEBZgftusXIQr7iy/hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1519/1536] irqchip/riscv-imsic: Report successful hardware retrigger
Date: Sat,  7 Nov 2026 08:58:55 -0500
Message-ID: <20261107135040.535922550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5d7c30ad8855b..d0c303882ed1b 100644
--- a/drivers/irqchip/irq-riscv-imsic-platform.c
+++ b/drivers/irqchip/irq-riscv-imsic-platform.c
@@ -60,7 +60,7 @@ static int imsic_irq_retrigger(struct irq_data *d)
 
 	local = per_cpu_ptr(imsic->global.local, vec->cpu);
 	writel_relaxed(vec->local_id, local->msi_va);
-	return 0;
+	return 1;
 }
 
 static void imsic_irq_compose_vector_msg(struct imsic_vector *vec, struct msi_msg *msg)
-- 
2.53.0



