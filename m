Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B042369999;
	Wed, 20 May 2026 17:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297450; cv=none; b=LHovmBMuwWc7qVNcZoiGCNihaUcRHRAAjmkO33TvYOVGwy967mCd5HKzMUY1vJJ8xq5SiWjXWkAioSJ6RPgJex1XpfFt1XtOGbd8gyiHyKT4V3KjM/d2kKtGeRF8I61UgtKcgYS04cB1pnW/uCM65OflhaRmL0xYW+wB9lTeqfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297450; c=relaxed/simple;
	bh=YY9iVMS2l7FrNN23sBcBg9M/a7EbITQHdYxAhyhgpxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dEQXewEWsNIbQPIr49d6Ghjtq2ETH3y6UHOaecTj8m+g/HRIeo8jK0mzD3g2m1poqYAxuMc+Pp/o97+RAUqi4dTQ5FYfzMzVmCBI2HOaHhPdPjGNRoD31mNZj85Ot1xwUfcY/ic0/iqJfnmJTP0tSK9IlmFTD8bC7Fi8VUPgLZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fjWj5s+s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fjWj5s+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24741F000E9;
	Wed, 20 May 2026 17:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297449;
	bh=jqObCKHpD2Jw3Fs7PkOvXJiShVISmvNoXFhNR8qTwYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fjWj5s+sr58wsfG4tZAPx52blxSb1LC+P+jSxeDhuhAqJJcsHblrTuNJLEkVm2TCR
	 Tz4WvQSYBMqRFpMe3Cl3WLvT66UAzmH/uAremIBk/t9htkQ73sDrm8WYEt4twUYqUe
	 enXsQrd2Fng6Hm9cg6kNYI/We/gx6TNzS1IeQFfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 035/957] irqchip/irq-pic32-evic: Address warning related to wrong printf() formatter
Date: Wed, 20 May 2026 18:08:38 +0200
Message-ID: <20260520162135.320689812@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5dfda8e8df10d..0bb664e3d7c51 100644
--- a/drivers/irqchip/irq-pic32-evic.c
+++ b/drivers/irqchip/irq-pic32-evic.c
@@ -196,7 +196,7 @@ static void __init pic32_ext_irq_of_init(struct irq_domain *domain)
 
 	of_property_for_each_u32(node, pname, hwirq) {
 		if (i >= ARRAY_SIZE(priv->ext_irqs)) {
-			pr_warn("More than %d external irq, skip rest\n",
+			pr_warn("More than %zu external irq, skip rest\n",
 				ARRAY_SIZE(priv->ext_irqs));
 			break;
 		}
-- 
2.53.0



