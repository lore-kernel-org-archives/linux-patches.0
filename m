Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902781419A1;
	Tue, 27 Feb 2024 14:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042812; cv=none; b=MXT+PBbyymvHC2sJlY2u+DMTceA9Z3BqWTWfs3d+1A3iO64uAEC2HkZZbpEWPqkcQc9jxSM34NHduJLMRjczaY+VFOWbYBdhrGn6BpVUGIbBnG9y5oiMJu6YgB63NmekRL/joZH7XDGh6TbwCWqpk6GBm3o3QJAqalTI7uSNdJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042812; c=relaxed/simple;
	bh=smSzktnpvWvRDzmh+cIm7PWdvFILjrKEUS4+UgguX4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uJl6VJgW2v/4HJN5R9kGmjx7llFxf19ycZhLi0/kTA0KrB0vMWpJf1ujgGFAV1rvxhX4AYNJjhMMhF8oJyNegpFtPoR3fWQCIIm0J5hMIuW4zyFl+ALGCukZB7tbTRPjEphGKRpo6KcwEMrpDNNDOE3gHlJHo5xKd7/HFNweqhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0f6+Oi8i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0f6+Oi8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB51C433C7;
	Tue, 27 Feb 2024 14:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042812;
	bh=smSzktnpvWvRDzmh+cIm7PWdvFILjrKEUS4+UgguX4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0f6+Oi8iJSaibMgcgIXZ0oafxnuyxC936iStueZ68BwcEG5KS7J8pY++LP4H4CDRh
	 20S5BAudafqdKEWQItkRWwJ0RL40y/MYucMQjTpWdD6EnQ3pzsM9Knq1RbUduUkNtH
	 iupNTX5BGP0WWvOhLBpK2iZZDAjUGOEam3PDkpxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/245] ARM: dts: BCM53573: Drop nonexistent #usb-cells
Date: Tue, 27 Feb 2024 14:25:18 +0100
Message-ID: <20240227131619.441857299@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 05d2c3d552b8c92fc397377d9d1112fc58e2cd59 ]

Such property simply doesn't exist (is not documented or used anywhere).

This fixes:
arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-1440.dtb: usb@d000: Unevaluated properties are not allowed ('#usb-cells' was unexpected)
        From schema: Documentation/devicetree/bindings/usb/generic-ohci.yaml

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Link: https://lore.kernel.org/r/20230707114004.2740-2-zajec5@gmail.com
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm53573.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/bcm53573.dtsi b/arch/arm/boot/dts/bcm53573.dtsi
index 933b6a380c367..85a23dc52423c 100644
--- a/arch/arm/boot/dts/bcm53573.dtsi
+++ b/arch/arm/boot/dts/bcm53573.dtsi
@@ -159,8 +159,6 @@ ehci_port2: port@2 {
 			};
 
 			ohci: usb@d000 {
-				#usb-cells = <0>;
-
 				compatible = "generic-ohci";
 				reg = <0xd000 0x1000>;
 				interrupt-parent = <&gic>;
-- 
2.43.0



