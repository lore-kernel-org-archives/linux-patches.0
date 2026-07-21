Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E313859EE;
	Tue, 21 Jul 2026 18:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656890; cv=none; b=YgpZWuncXXLWi/ZgZMIewqi0Wp6L2SZrD3T6+1f9s3t5PsrbfVtQIwa2ZrIM7S2c2AMR4mxqdfUKNcPgZeiVy7yunWPTbCqD6EW8jFPxCb9PteSrKiFDOLBtK2ZTU3HUZPurAUonz7HL/+8MJvHq0LwENUHG8n391JPR4PnmbnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656890; c=relaxed/simple;
	bh=2qLIs7nCT1/iyArNoXrF0lZYwqVy2qGADh8MaOKCXWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pN3PxfKmr2UI5N6HNApg7r6ApvQmNsoynu8Q8JfjlUdw6Yuq3gvUfVVswVM2nWd3U5XAL6zLg9lIfSHoVLMI52C83cMAKRQR4YQ/rkFZFDePa7cZD5z0LHpCUO4o/Vt4IiCDP+U3SlOleok0nG6UzbGQm0zMHnp06q3ADIZenvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JldwlNrD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JldwlNrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8C61F000E9;
	Tue, 21 Jul 2026 18:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656888;
	bh=Hmyl4Zr9szqvgjD6u0cIVrh9SmHLupcgam58b/tZUv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JldwlNrDnlJyEy6/pb2dbhTCNlfxuxHTrVj4G6Yn+Tqntyz9jjl2IkM8CWJt5yT/n
	 AjWrIqvd518n9NUpAaF/UdGv2+1vKqiUJUnPnj5snJVfKDurkgWqHjVS9p79TyLZoE
	 w4XHTt56nhNr8Ce2TEMOluXIJyDM/TUzrOYRNiIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0555/1611] dt-bindings: net: updated interrupt type to be active low, level triggered
Date: Tue, 21 Jul 2026 17:11:11 +0200
Message-ID: <20260721152527.862437555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



