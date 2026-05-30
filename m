Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53354320CAD;
	Sat, 30 May 2026 17:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163948; cv=none; b=jXxS1Bfcq6bD1M+haWSqLZU6TUtDQAOEo7bAZruobGvw6WkdSXP7X/MWZWF4XfEcJuT0EfCxhBJTvF4X8PpplMohs1QNQTLVq6NpVN7oISWKf+nnKZaApDVCnY8JKNm+6lu6EwnVJajWeaVJ+0D56irmNMsUepW/vDDWUBqTZv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163948; c=relaxed/simple;
	bh=CsrpRdWi5u4/0dvUeF7aubNjPjQdC6pCAK4Fah6vCpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sNE4osgI8l2Sz4taKn7XfUqLXHCiLvBU1oBvy9XvaWVhsqKVP3F0uieaGjKiQ++JEtjiFc+tt8cqDRC8/VtfdpMdkd6AxA2/Bb56Hue9Y/R/QPEUk87OBw18gxM6R+IbuKDdaAdzU0G+yNAuGxFJ8C3M3ofKym1j4QNbRsC/ekw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PBMtPCgv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PBMtPCgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992E71F00893;
	Sat, 30 May 2026 17:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163947;
	bh=cleHq9yNTBCTcBzN+3Cgmx6d7hIPcQZgh5tPz+vbmhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PBMtPCgvndIc0BtBdfyNRiT5shPE8LQciHYmZ/VHRVui4PB3qMfe0TeUBurWX3VPl
	 r9QRrbCGzB9oxLrydHPA+udEAy0riF6reIVA42EYCLnOCTgKwvAu4FnGOPiLPi9Bjz
	 A/HUMAZiX0XOu5XcA0nYGkUq4GtiUgeFtREvpLvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 392/776] irqchip/irq-pic32-evic: Address warning related to wrong printf() formatter
Date: Sat, 30 May 2026 18:01:46 +0200
Message-ID: <20260530160250.623163521@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 86be659415b0ddefebc3120e309091aa215a9064 ]

This driver is currently only build on 32 bit MIPS systems. When building
it on x86_64, the following warning occurs:

    drivers/irqchip/irq-pic32-evic.c: In function ‘pic32_ext_irq_of_init’:
    ./include/linux/kern_levels.h:5:25: error: format ‘%d’ expects argument of type
     ‘int’, but argument 2 has type ‘long unsigned int’ [-Werror=format=]

Update the printf() formatter in preparation for allowing this driver to
be compiled on all architectures.

Fixes: aaa8666ada780 ("IRQCHIP: irq-pic32-evic: Add support for PIC32 interrupt controller")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260222-irqchip-pic32-v1-1-37f50d1f14af@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-pic32-evic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-pic32-evic.c b/drivers/irqchip/irq-pic32-evic.c
index 1d9bb28d13e5d..1a72047f3aa2e 100644
--- a/drivers/irqchip/irq-pic32-evic.c
+++ b/drivers/irqchip/irq-pic32-evic.c
@@ -198,7 +198,7 @@ static void __init pic32_ext_irq_of_init(struct irq_domain *domain)
 
 	of_property_for_each_u32(node, pname, prop, p, hwirq) {
 		if (i >= ARRAY_SIZE(priv->ext_irqs)) {
-			pr_warn("More than %d external irq, skip rest\n",
+			pr_warn("More than %zu external irq, skip rest\n",
 				ARRAY_SIZE(priv->ext_irqs));
 			break;
 		}
-- 
2.53.0



