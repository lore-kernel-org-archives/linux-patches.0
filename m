Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA10635DA40;
	Tue, 21 Jul 2026 19:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662319; cv=none; b=DEwaRPLRuddQnjqhtv6R3oXCF8N76IXlUlMrVCRVFCUxRV0wGfH0mnHtEOBHCLUe124l5IRoqXG104TRnjGC6MqNuvltHjpcz0t2zJhNFcneTl02rFLfICIgn5PKlX48arBId9LO6MUpZk04PZR3AL6mPDyagUlDvvV5clAm2LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662319; c=relaxed/simple;
	bh=aMJpJIxfKoDFYit7LKlPPylsmDh/vVlGfzv/GR5Ca1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cqr3+q3ikpk8G5SMzF6nKDAAZap92PqbeQ3FWpljlkipsLzaIiZJc1Wr0KC/pZvrQ5OKX7dQSwKQQWyAx1XAF9AyJ4ce4gUuEDsYDc2617+//YsbysDZClRM3xosBR+ctPsXg5BlXND0UOl4SpGaEtJPTQlVvv+Hbhi4cKOfLws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lyEz1SEL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lyEz1SEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9231F000E9;
	Tue, 21 Jul 2026 19:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662317;
	bh=jnzygcGhiaA4Qqj7BQ8xIQBGJvHJXkPqA33unRTHe18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lyEz1SELt/aLOhLYNwL2oAJ5aRATNQEIAYUs6DHq6MGBjLIBU8/ZsFBOZcVdTXGcj
	 cGFVMElA+yauEKUeQCIFmYUyJmyfV4JgYRIl/Mgfj8+tN4igAmRuuPYuTLZG3nn3jZ
	 dlgqtSk9WMMjzo7T+DkJIIgqje9aavN4ldnRYUVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0398/1276] dt-bindings: net: updated interrupt type to be active low, level triggered
Date: Tue, 21 Jul 2026 17:14:01 +0200
Message-ID: <20260721152455.009203372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>

[ Upstream commit 31e56112e6544afba0a50d60251175585ee62943 ]

According to OPEN Alliance 10BASE-T1x MACPHY Serial Interface (TC6)
specification, interrupt type is active low, level triggered interrupt.

Specification calls for when interrupt level will be asserted and what
condition it is de-asserted. By using edge triggered interrupt, there is a
potential chance to miss it, particularly if it is asserted when interrupt
is disabled.

Level triggered interrupt can't be missed as it gets de-asserted only on
interrupt handler taking actions on interrupting conditions.

Fixes: ac49b950bea9 ("dt-bindings: net: add Microchip's LAN865X 10BASE-T1S MACPHY")
Signed-off-by: Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260611-level-trigger-v5-4-4533a9e85ce2@onsemi.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/net/microchip,lan8650.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/microchip,lan8650.yaml b/Documentation/devicetree/bindings/net/microchip,lan8650.yaml
index 61e11d4a07c407..766ff58147ae36 100644
--- a/Documentation/devicetree/bindings/net/microchip,lan8650.yaml
+++ b/Documentation/devicetree/bindings/net/microchip,lan8650.yaml
@@ -67,7 +67,7 @@ examples:
         pinctrl-names = "default";
         pinctrl-0 = <&eth0_pins>;
         interrupt-parent = <&gpio>;
-        interrupts = <6 IRQ_TYPE_EDGE_FALLING>;
+        interrupts = <6 IRQ_TYPE_LEVEL_LOW>;
         local-mac-address = [04 05 06 01 02 03];
         spi-max-frequency = <15000000>;
       };
-- 
2.53.0



