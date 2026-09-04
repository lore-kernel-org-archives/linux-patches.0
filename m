Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8C941C2FF;
	Fri,  4 Sep 2026 06:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502952; cv=none; b=FsTCcl2bzSvy3yF77CLi0Ia733/CgPCPRI6oDchvCcV+IZxXSdQGFrL+M+yQpuZooGdFor1NnjKGK1IjE+pGJo65e+SMHlxzsL0cC7CwAqwT2W3uWGcPB4NejNy/8XDJTLF7n9ohz03Jhe+xcajAxJOgdLbaqsVWymkRieMjdIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502952; c=relaxed/simple;
	bh=uw8IRKKOogiG02GYgoX8Gyp1BBl11LYTkkAiafkRXSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BXZCtUBgXyV8aQ9LW2gJJhhX6p4cEF7rLEvJL1DEql/Klflaj/qh2m4oLeCUk3qwtsI9g2cicsi2USZw1CXMobLEVWv2XzuoGgaibPjpOdZuG9ZThfPQ6zD/JRQ7A8tSAUbymQWBAmf6MlKjYakkG1L9XbQv1RdJv3k9WPLL4GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yysalC/0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yysalC/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2901F00A3D;
	Fri,  4 Sep 2026 06:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502950;
	bh=4ImbqEx69NQdA01ldCMHURWqxo1tDeMfRlOUKSymJo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yysalC/0aVABwA47yDWjx2VQVevMtmP/sowhHIANIsE6i7NgIF9Bm23KulFJ2XpvJ
	 aC/A8jXsodUlFg7xd+X5IRYUZJ4ueaXL8jvFV1UCH1fuNQIP1OR1B4nh0VrwX/r7Ts
	 K4IP36F7ZaZQPOn7orSofZBRLnMQJukndiIHQjjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Ping-Ke Shih <pkshih@realtek.com>,
	stable@kernel.org
Subject: [PATCH 6.12 387/403] wifi: rtl818x: initialize eeprom_93cx6 struct to zero
Date: Fri,  4 Sep 2026 07:03:10 +0200
Message-ID: <20260904045743.590042432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Stanislaw Gruszka <stf_xl@wp.pl>

commit 799b5f45cb8194ebd06c9c89e0afdad5bedd2cc5 upstream.

Commit 7738a7ab9d12 ("misc: eeprom: eeprom_93cx6: Add quirk for extra
read clock cycle") added extra 'quirk' field to struct eeprom_93cx6.

Many existing users of eeprom_93cx6, including rtl818x drivers, allocate
the structure on the stack without initializing all fields. As a result,
the added quirk field has an undefined value and can randomly cause
reading wrong data from the EEPROM.

Fix by initializing the structures with {}.

Fixes: 7738a7ab9d12 ("misc: eeprom: eeprom_93cx6: Add quirk for extra read clock cycle")
Cc: stable@kernel.org # v6.13+
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260723110640.8588-1-stf_xl@wp.pl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |    2 +-
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
@@ -1652,7 +1652,7 @@ static void rtl8180_eeprom_register_writ
 
 static void rtl8180_eeprom_read(struct rtl8180_priv *priv)
 {
-	struct eeprom_93cx6 eeprom;
+	struct eeprom_93cx6 eeprom = {};
 	int eeprom_cck_table_adr;
 	u16 eeprom_val;
 	int i;
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
@@ -1445,7 +1445,7 @@ static int rtl8187_probe(struct usb_inte
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct ieee80211_hw *dev;
 	struct rtl8187_priv *priv;
-	struct eeprom_93cx6 eeprom;
+	struct eeprom_93cx6 eeprom = {};
 	struct ieee80211_channel *channel;
 	const char *chip_name;
 	u16 txpwr, reg;


