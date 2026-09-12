Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2BC25A640;
	Sat, 12 Sep 2026 15:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227852; cv=none; b=sSemFVlnXKPIA88u/fo8pdbDr6JFmWdjZakd0Np58DKc4OSpvLNWy2Lm7PkHbdurp5teIvgBz6flz5rln9RxpGzzetE1Ok8xdewH+CbZfEk2cDH8FgA5lOR+kra98jEW/DWGmQiTaj//UITDCP5m9aJc5bbMq+Tl8/F/Dn1SFvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227852; c=relaxed/simple;
	bh=Xbs4jCFAvFuFSH4UR3ECp3KECMEmgAuz+VHr7dnCpeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnmIAvxOIsVzjNeMHs3XBQ2Z9ieJsdKoZq7VKEZSOBkbmOITH7EXAxsXDxtVROjmNJA9LZkOgy/rJScasExSbCfsP9ZByOBGH6d+nPhKEQbg8fatm7j7DGmN2xiYAwYBTPH/z3zvMfoKmyYz4+GRHuGxcrAzgF6YTISZKmxQuJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDKSgwxK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDKSgwxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A711F00893;
	Sat, 12 Sep 2026 15:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227851;
	bh=1JgjsQS7PE+9LENW1QHS7PGURivhbAyMRk+UwE6ySws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GDKSgwxK2rdNaK/SyRyjteTp5qeVoxJW1ei1BXJBCwwMFUVDEAQrMzgRh28rKJvIl
	 YyD8oq3NI9IsM+S7gx7R0LeIWa7nwIpMqgLZ+tqHcbiCY71bVJovmHCSrLv5ixCxDn
	 ClKF9zuwn75p2siFykGL6WxF6KaXTISngfczdXC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Ping-Ke Shih <pkshih@realtek.com>,
	stable@kernel.org
Subject: [PATCH 6.1 0239/1191] wifi: rtl818x: initialize eeprom_93cx6 struct to zero
Date: Sat, 12 Sep 2026 08:49:27 +0200
Message-ID: <20260912065553.580019328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1647,7 +1647,7 @@ static void rtl8180_eeprom_register_writ
 
 static void rtl8180_eeprom_read(struct rtl8180_priv *priv)
 {
-	struct eeprom_93cx6 eeprom;
+	struct eeprom_93cx6 eeprom = {};
 	int eeprom_cck_table_adr;
 	u16 eeprom_val;
 	int i;
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
@@ -1440,7 +1440,7 @@ static int rtl8187_probe(struct usb_inte
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct ieee80211_hw *dev;
 	struct rtl8187_priv *priv;
-	struct eeprom_93cx6 eeprom;
+	struct eeprom_93cx6 eeprom = {};
 	struct ieee80211_channel *channel;
 	const char *chip_name;
 	u16 txpwr, reg;


