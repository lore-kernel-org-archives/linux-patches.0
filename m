Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032527;
	b=BiIE/0PTFAedBNjGoBvJgse+6Myn7IgOxStvPuEiN6jSCx8DQ60d4pbRcoe2irnh7Oyh
	 mZ3gAQ1ByptKifWXx5OFAXgDL19+6VYdPFD7eJXoZlwRVL7Wzw8iwf2xQT8pDdxLNy+/M
	 xnFnFEnvV/6iMhaqsffJDAjzqsEKVpm4F+9ErxBalgIuRXj3crG0r2y7Ob9r5ZAjUfpBP
	 lnx5wvRf9MpuZ9Si10z5729Sj4Zp7vCOAYe0tQunFPweo0UpudmiFFThJTfAVGW3W+1B5
	 CHO1L95hgNPW0LrNVlop288IkEgtMwvq856l5Hz/RofUpOFSP9y3HeZg5Fgbz5mmzeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZlIWhnTmGgiM3hrkEcWu9g7kPx/sKWBgX/1IKk2kKmM=;
	b=SesXlPzAawBOreoOm43W1CjIHe1RMWFemDnJ7M4ZyAZsx9JBKnAXchK1I/bRFSolSUqV
	 NcUpWkoM/+oRxZYYz1+WxPREkPMw3mrwwtu4b4joqwVpUC3gy+JX7UKYJmqfVzt03julo
	 P+Ju5mKyOdoMd69KOuep35JzJwsEi77RDJ0itZKGDFOdzOe4+FnJi8cuUeWTQj5gVV/R/
	 YDXs5dMSLqrPSGvjBhM1EF0JGZEjp3FbyN3t0Qr+aTDIrdqU66tnhuwx+/qDjqrc8iEBI
	 fH0vMnnzpIpSfex+JnW5ecPFKiEy1wpxn+pjFPpw5Skdmk9Aeu9AGwYKIqP22gPsOdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rilyXpAb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4759C606A335;
	Wed, 18 Nov 2026 20:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rilyXpAb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358311F000C5;
	Wed, 18 Nov 2026 20:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032526;
	bh=ZlIWhnTmGgiM3hrkEcWu9g7kPx/sKWBgX/1IKk2kKmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rilyXpAb1AMa9wV6cq1jpy2UarHuBei8SpK49fviZIhwavLKUCkOXMvjdU80N0lCV
	 /TPCqyLg7vtKbdtWi+XcD+cppWeaN+mCFAj/jwvG0f9chgYBDZoSmMBhys+yFtefSX
	 1OMO3Mq/ZcP1cb/XVzEnVpm+gWpR2koWUb1/ejRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1443/1756] net: phy: realtek: use string choices helpers
Date: Wed, 18 Nov 2026 15:59:30 +0100
Message-ID: <20261118150106.580010390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 0bea93fdbaf8675b7e8124bdcaf51497dcc8bcfa ]

Use string choices helpers to simplify the code.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501190707.qQS8PGHW-lkp@intel.com/
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 20c0c6773624 ("net: phy: realtek: restore RTL8211F RGMII delays on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek/realtek_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/realtek/realtek_main.c b/drivers/net/phy/realtek/realtek_main.c
index 8ce5705af69c5..36406c0b4056d 100644
--- a/drivers/net/phy/realtek/realtek_main.c
+++ b/drivers/net/phy/realtek/realtek_main.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/clk.h>
+#include <linux/string_choices.h>
 
 #define RTL821x_PHYSR				0x11
 #define RTL821x_PHYSR_DUPLEX			BIT(13)
@@ -417,11 +418,11 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 	} else if (ret) {
 		dev_dbg(dev,
 			"%s 2ns TX delay (and changing the value from pin-strapping RXD1 or the bootloader)\n",
-			val_txdly ? "Enabling" : "Disabling");
+			str_enable_disable(val_txdly));
 	} else {
 		dev_dbg(dev,
 			"2ns TX delay was already %s (by pin-strapping RXD1 or bootloader configuration)\n",
-			val_txdly ? "enabled" : "disabled");
+			str_enabled_disabled(val_txdly));
 	}
 
 	ret = phy_modify_paged_changed(phydev, 0xd08, 0x15, RTL8211F_RX_DELAY,
@@ -432,11 +433,11 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 	} else if (ret) {
 		dev_dbg(dev,
 			"%s 2ns RX delay (and changing the value from pin-strapping RXD0 or the bootloader)\n",
-			val_rxdly ? "Enabling" : "Disabling");
+			str_enable_disable(val_rxdly));
 	} else {
 		dev_dbg(dev,
 			"2ns RX delay was already %s (by pin-strapping RXD0 or bootloader configuration)\n",
-			val_rxdly ? "enabled" : "disabled");
+			str_enabled_disabled(val_rxdly));
 	}
 
 	if (priv->has_phycr2) {
-- 
2.53.0



