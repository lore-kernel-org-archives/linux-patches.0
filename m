Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7652EAE5;
	Thu, 12 Dec 2024 15:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015989; cv=none; b=CJGQbQ8aQuM7ucBetGvTAdk09z4VLfqG6bsl1TCDlpiJ/Ch6eoWU2hUx3DWCfrZwF1cAwfg82Qy8qTpIMhIsHGJnFcv6Nmha5Rsu9pQbj15DILFu67PFewSSwowKRLdyTBeFEI1hevW+fuV58TX/9CGqEzcpspogbeQg7MDOJ6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015989; c=relaxed/simple;
	bh=5aTEZC0G98TI5ce2GfaZZJAEanR0jzP8Xth/0cekz18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZLmEgqv0n/RnbCnLCljIpDkKSH5ffpc9i3qIw/YvgW7H/SUrc3VlxDmnvmLqrASvn04LHgUXlbbTD8XKCBuqZqD/kuxZPufiENoFXaTEWtVD80zvdx91NhFSXPKB/ZqeaKD8mVRHCRyI3g9UFDmEaFQNCfWkiyu+FgxfxnMWhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vMoElA52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vMoElA52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE581C4CECE;
	Thu, 12 Dec 2024 15:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015989;
	bh=5aTEZC0G98TI5ce2GfaZZJAEanR0jzP8Xth/0cekz18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vMoElA52yEeyyx01wLmH6OD3cqtLDzxGZC82hfoXNUbjZmzalK+XAfwakaA0YadfR
	 PtunUbao2fY3fjMVilXwXr/R4gJzshVg94IGKbbkFSHqnW2FNyJnSFAzOyRihf07Jc
	 +LS/qj2UaEQajXaZVVieu5Aw/8970Wmg4nbmQ6Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/466] irqchip/stm32mp-exti: CONFIG_STM32MP_EXTI should not default to y when compile-testing
Date: Thu, 12 Dec 2024 15:54:30 +0100
Message-ID: <20241212144310.804308534@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 9151299ee5101e03eeed544c1280b0e14b89a8a4 ]

Merely enabling compile-testing should not enable additional functionality.

Fixes: 0be58e0553812fcb ("irqchip/stm32mp-exti: Allow building as module")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/ef5ec063b23522058f92087e072419ea233acfe9.1733243115.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index d82bcab233a1b..66ce15027f28d 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -407,7 +407,7 @@ config PARTITION_PERCPU
 config STM32MP_EXTI
 	tristate "STM32MP extended interrupts and event controller"
 	depends on (ARCH_STM32 && !ARM_SINGLE_ARMV7M) || COMPILE_TEST
-	default y
+	default ARCH_STM32 && !ARM_SINGLE_ARMV7M
 	select IRQ_DOMAIN_HIERARCHY
 	select GENERIC_IRQ_CHIP
 	help
-- 
2.43.0



