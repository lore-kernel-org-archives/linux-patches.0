Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F258248BA0;
	Wed, 15 Jan 2025 10:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937804; cv=none; b=B5XhdQz89J5qhDcOLY5iRUrADL2s1glrcBkCTf0g7IRiLF6YUnV2pV1ouGSSQcAz14kqa6FXawzknyLQ4c7tonMBYiYZRCsLg90JeGI1ozMGkl5rxWZo8kUagCxlSM+fPiRXpOVU+Ld75oFMNpFz3vYjCatFFAiocRXO0e56Ypo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937804; c=relaxed/simple;
	bh=emvujC7Z3PU2JMP4vS9mTu+t4Y9jCxj/QD6ybBNWgps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VrhMqPBH+b9wXZbUx9okIe0QCuCzlEWk8RsyyfmsU2Hsf+zEK8/JuDWXsXAQ482SO4H3uhMhVfkDuQSX0rsUomYwCVnl5NMn1kz9o06uASRzFB83pGija+BADFqxinkMPyrOHsFjxxSmcqK3lVX3ap8ZxWXJTiUguXLCuC5P2/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RYnV6iwP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RYnV6iwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B722EC4CEE4;
	Wed, 15 Jan 2025 10:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937804;
	bh=emvujC7Z3PU2JMP4vS9mTu+t4Y9jCxj/QD6ybBNWgps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RYnV6iwP8fIfbF2eWUt+86ZWAgpFKw61USqgMsI8RX2QPFxksZ14szKO/qgFeKMkp
	 HsNSx978fT1ZjdhnV9iOFpL48ZJntne9NqyHT6JaUH+xLMjgjXbSOR6akdc45Y3RlE
	 HihouPnKFTZk4cZHo9Mq2RBsieGElRx58SBCknBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 86/92] of: address: Remove duplicated functions
Date: Wed, 15 Jan 2025 11:37:44 +0100
Message-ID: <20250115103551.004969380@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit 3eb030c60835668997d5763b1a0c7938faf169f6 ]

The recently added of_bus_default_flags_translate() performs the exact
same operation as of_bus_pci_translate() and of_bus_isa_translate().

Avoid duplicated code replacing both of_bus_pci_translate() and
of_bus_isa_translate() with of_bus_default_flags_translate().

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Link: https://lore.kernel.org/r/20231017110221.189299-3-herve.codina@bootlin.com
Signed-off-by: Rob Herring <robh@kernel.org>
Stable-dep-of: 7f05e20b989a ("of: address: Preserve the flags portion on 1:1 dma-ranges mapping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/address.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index 4f7f4f519e80..39abcad30ddb 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -221,10 +221,6 @@ static u64 of_bus_pci_map(__be32 *addr, const __be32 *range, int na, int ns,
 	return da - cp;
 }
 
-static int of_bus_pci_translate(__be32 *addr, u64 offset, int na)
-{
-	return of_bus_default_translate(addr + 1, offset, na - 1);
-}
 #endif /* CONFIG_PCI */
 
 int of_pci_address_to_resource(struct device_node *dev, int bar,
@@ -334,11 +330,6 @@ static u64 of_bus_isa_map(__be32 *addr, const __be32 *range, int na, int ns,
 	return da - cp;
 }
 
-static int of_bus_isa_translate(__be32 *addr, u64 offset, int na)
-{
-	return of_bus_default_translate(addr + 1, offset, na - 1);
-}
-
 static unsigned int of_bus_isa_get_flags(const __be32 *addr)
 {
 	unsigned int flags = 0;
@@ -369,7 +360,7 @@ static struct of_bus of_busses[] = {
 		.match = of_bus_pci_match,
 		.count_cells = of_bus_pci_count_cells,
 		.map = of_bus_pci_map,
-		.translate = of_bus_pci_translate,
+		.translate = of_bus_default_flags_translate,
 		.has_flags = true,
 		.get_flags = of_bus_pci_get_flags,
 	},
@@ -381,7 +372,7 @@ static struct of_bus of_busses[] = {
 		.match = of_bus_isa_match,
 		.count_cells = of_bus_isa_count_cells,
 		.map = of_bus_isa_map,
-		.translate = of_bus_isa_translate,
+		.translate = of_bus_default_flags_translate,
 		.has_flags = true,
 		.get_flags = of_bus_isa_get_flags,
 	},
-- 
2.39.5



