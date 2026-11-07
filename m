Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065545;
	b=W0LYmOr+fNTID9wGQKKQxdGL9pyDm8QWt3PUm/bHoRLYHBxU9wZgHnjkzb2xySc5pQsn
	 CGHRELGdCdEkBYoGztqdgH5jPgdH4caWnsB/0Wc8+eVYXE1Wt9ixLUauPeLaVMMODZbJx
	 UbyeLc8HKp2O20Ep6UR9fhRku3IRbf7WcYc1idIMedkqejcRXw+qn6v//W+Rh21vSp+5s
	 gqYTq8eYB6zNjmqu/s3keUBRZlV+lhbPYt0RYdTbstbdSXHn2y/J3Y05OmInMX3qm9mfb
	 2lOo15veieUrJnTsajZfvt9cQxQga1q/QVDVHei6jV8hkjpPxut+MBmNNb/kbhVZkJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kajOY2uESK8mKVpWcJ0wWJrOJlUUnqJhWHYgax9+Yks=;
	b=0HPm+JBHYiX4Abiw/Xar+vODMQGatBq0+WSYtO32ho50wKNSL9ETPjc4NZDnq+DQTKwh
	 jEavacm388cIRug7q3fq7Gx5hq1pS4KcHD+ddOhV9gyBR23ibWpggG2HuUnMEZDNQOd5+
	 2w/XyxuRaHTwe2Wj+DmaYny650JMhrpMDk8xriPn2lA+F+Nze8TqXUYLmqpL2oup2D/PL
	 wnsas5OdlmEeG2vcZK7u44h6qUeAU8i6Gn3LvoGmO5HVCjZiDp87zLrXS+CKX/Nt3eEti
	 E2fSQhs1sYtWHs+Gysoj8odt7iymqdKtB7BKUeT/1zsSFYx3jdzofJ2+ayjjc3zl88g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dnA4GJH0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EAB606D80E;
	Sat,  7 Nov 2026 15:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dnA4GJH0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2271F008A1;
	Sat,  7 Nov 2026 15:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065545;
	bh=kajOY2uESK8mKVpWcJ0wWJrOJlUUnqJhWHYgax9+Yks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dnA4GJH0R2rpvW4IeKQ+CdkycrxQQzcJDnDvXGnllUTtvueTNpN4xt7rycpb/y3O/
	 6OEORIqTEf9xrPdDHxtk8iNymnkvg+Q4+Llcm7xa7RWeW/5UQ1RFWBABLxkLnuZhvM
	 BXRvcHrbnLp6FZaN+le7aPvm9E+njpC7SmC63VVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1220/1257] irqchip/riscv-imsic: Report successful hardware retrigger
Date: Sat,  7 Nov 2026 08:58:36 -0500
Message-ID: <20261107135013.052591192@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



