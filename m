Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D97D4409;
	Mon, 23 Jun 2025 22:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716078; cv=none; b=kPXPmBs5mMyTN2UMLtb57NLCDSylJR8Slh3gAdR9BkBB3wJlQjx+wsCaHupuX4XQWONp0T1+Nzz+BtO/cM+7INvuYYQfbeSnUkKz8PemSsPoRofqP1Z0b1XjmBhrl/FoFpmwHOdNsCJ+LGZfys5ZFNC3/ZzHq/piIRQwWNKauX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716078; c=relaxed/simple;
	bh=FfDRAXG3LVtJCBWRgSl+WhBu6iWCXvOuSJ0uIsQR6lM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCh6YPOIFZi+LR/yyjdxcKKucPmYrP0GhJkTBI1P/fQRdGR1nl/FueDDceupd6xNtvO6zjZ+pkc0mQ+vPrITr3Gm/aXdMqNoUN4aq/RaytWSInfzWse4Ztypnis/1MDbV+MsWAMGoJuxs4+oy71bIFAs5PQR2qe0g5lLSzVQelQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ug4o0lWk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ug4o0lWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D42AC4CEEA;
	Mon, 23 Jun 2025 22:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716075;
	bh=FfDRAXG3LVtJCBWRgSl+WhBu6iWCXvOuSJ0uIsQR6lM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ug4o0lWktwkpUC8ed2w7m9/jbadUDZJv+UvcXJnaSlrsNrYHZjt3Igsxru1BNPofX
	 Pz3L3Vx1il/eFW2Zbri46/3x9rJm/rIcppXg7bcMt3W7Auy1HQpUBvheK37BkpmMsk
	 srSA7dKlJklJoHRrpczfwC06q0sJCGJCqSnsmGaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Foster <colin.foster@in-advantage.com>,
	Kevin Hilman <khilman@baylibre.com>,
	"Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 5.10 319/355] ARM: dts: am335x-bone-common: Increase MDIO reset deassert time
Date: Mon, 23 Jun 2025 15:08:40 +0200
Message-ID: <20250623130636.357762234@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Foster <colin.foster@in-advantage.com>

commit b9bf5612610aa7e38d58fee16f489814db251c01 upstream.

Prior to commit df16c1c51d81 ("net: phy: mdio_device: Reset device only
when necessary") MDIO reset deasserts were performed twice during boot.
Now that the second deassert is no longer performed, device probe
failures happen due to the change in timing with the following error
message:

SMSC LAN8710/LAN8720: probe of 4a101000.mdio:00 failed with error -5

Restore the original effective timing, which resolves the probe
failures.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Link: https://lore.kernel.org/r/20240531183817.2698445-1-colin.foster@in-advantage.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/am335x-bone-common.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/am335x-bone-common.dtsi
+++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
@@ -381,7 +381,7 @@
 		/* Support GPIO reset on revision C3 boards */
 		reset-gpios = <&gpio1 8 GPIO_ACTIVE_LOW>;
 		reset-assert-us = <300>;
-		reset-deassert-us = <6500>;
+		reset-deassert-us = <13000>;
 	};
 };
 


