Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B883F9D2;
	Fri, 21 Nov 2025 13:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731849; cv=none; b=QbHVh36BbsXwyxZyMv3HStPIxk8DKSedBu91BKAr6Fbp7V+y0CQTpJONoc2m3lpUI6DjkU6+4Fy2omFSWRc8IegzMsEYjCIogdMg1fKPpeTtc3XuLCBxmghSyobaya2rcrdO4pZAqNfcjrBkQUZ8xcg3quLsmUWrpOMfxliOZk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731849; c=relaxed/simple;
	bh=HAlyxdha6aJKVxzK5vRA4lyjtJGoCOorGKj2gnoH1xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jfqc/o0mnNFy+J20xSlJqYYWFVMvcFCu//AlobE3XLoeyD1g5XYqIsnXg5/6g/JUsRX0GWPbH6fdNIriDAQJy/ZMctliNuWdUaFvQFaTQACDF+NCzUcVyEsZc9q7BVVtxKZMjW9ibpNOqBYz64rfVQ3MkULjT6tWF8t37tFxQuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LuPpVNef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LuPpVNef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21823C116C6;
	Fri, 21 Nov 2025 13:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731849;
	bh=HAlyxdha6aJKVxzK5vRA4lyjtJGoCOorGKj2gnoH1xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LuPpVNefSM17NpsUWh0b4C3Q0HyinZ242XPxqzoAU/vHcjnUQH68ysmTAg101SL7m
	 y6dDL0Y3uN/8EwtRG9oDXzUEtYTcxyQneatAGz8m83DZrcKwzn554Q2sMlycyiO4jo
	 YfEcm7ewxIbWvGkScKN9ax1Pxa40D1ztF5wMJCCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/185] ARM: dts: BCM53573: Fix address of Luxul XAP-1440s Ethernet PHY
Date: Fri, 21 Nov 2025 14:12:10 +0100
Message-ID: <20251121130147.590711155@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 3d1c795bdef43363ed1ff71e3f476d86c22e059b ]

Luxul XAP-1440 has BCM54210E PHY at address 25.

Fixes: 44ad82078069 ("ARM: dts: BCM53573: Fix Ethernet info for Luxul devices")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Link: https://lore.kernel.org/r/20251002194852.13929-1-zajec5@gmail.com
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-1440.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-1440.dts b/arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-1440.dts
index ac44c745bdf8e..a39a021a39107 100644
--- a/arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-1440.dts
+++ b/arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-1440.dts
@@ -55,8 +55,8 @@
 	mdio {
 		/delete-node/ switch@1e;
 
-		bcm54210e: ethernet-phy@0 {
-			reg = <0>;
+		bcm54210e: ethernet-phy@25 {
+			reg = <25>;
 		};
 	};
 };
-- 
2.51.0



