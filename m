Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E3D31E823;
	Sat, 12 Sep 2026 19:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241668; cv=none; b=PzxQcAE0afCi2/KK1w12jWlWibL0GLhz/d92Wt4HNCsrQo5vpvqvDqb5hlvS5FwgpqPZNFkgz4zJu3NcmXnLa51a/lwap8AGcp6o9X8XwwaqNSQgX9FzaPzRH5xNCfVm22ctp7v81omDGa+caTBDDVi0mRRsFJMOZQH3g9/C994=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241668; c=relaxed/simple;
	bh=zGHj3uU1OD/ymFdKTs0St65cyWseqBRomujLWayd1y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxUbX4muHEc7UHbginqVMkSsuLtfujAtm/yokhnqZBA5YoPuFWXVSrWE4rsKDZ0oLnhk6T7WfH8dtRP8MIEn5xgQBNyT5COz2Q3rcTBfeWEvrIzpge1R42ozg7IAfOG803nnbF2uJOVJnWPuH9Vq+RojEDEU41QozbI3PM/VzgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iwIVkwHd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iwIVkwHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7BF1F000FF;
	Sat, 12 Sep 2026 19:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241667;
	bh=nJ8w3JX/0YpBPnk4rDd5JHZGMShFTvBCm1gcdD4xdkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iwIVkwHdppCFnSHYGSd6EMJtmgWhKT+bJAQBBd7yoH30TxSxRorD3XKWezG8JAN/v
	 cjSwDeEs6NYXrba7gSPm9D8D+G9HhrfelbyBT2SivtOaIiCKig8hXJtI4bBMm4CzX8
	 O+RQRsW6SIpctih+gPZLkQSLLORvTuU0Uad6kE8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Ping-Ke Shih <pkshih@realtek.com>,
	stable@kernel.org
Subject: [PATCH 5.10 182/798] wifi: rtl818x: initialize eeprom_93cx6 struct to zero
Date: Sat, 12 Sep 2026 08:56:50 +0200
Message-ID: <20260912065521.208095901@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1646,7 +1646,7 @@ static void rtl8180_eeprom_register_writ
 
 static void rtl8180_eeprom_read(struct rtl8180_priv *priv)
 {
-	struct eeprom_93cx6 eeprom;
+	struct eeprom_93cx6 eeprom = {};
 	int eeprom_cck_table_adr;
 	u16 eeprom_val;
 	int i;
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
@@ -1439,7 +1439,7 @@ static int rtl8187_probe(struct usb_inte
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct ieee80211_hw *dev;
 	struct rtl8187_priv *priv;
-	struct eeprom_93cx6 eeprom;
+	struct eeprom_93cx6 eeprom = {};
 	struct ieee80211_channel *channel;
 	const char *chip_name;
 	u16 txpwr, reg;


