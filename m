Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062373;
	b=VhRWW0zUa7bq/1zItTSIiAKq3Do9G9teI5wBAsPdGqU8ubdzLjKNIZatGSX9ipcJ8tP2
	 lN6d4sC4UoTExq9HQY1M5/kRGLQp9MSlRWeFFPNgjB3FwWagyngd5IbHqiK8rAM3O00yz
	 PqYyx/wF2+o+Ox+WJHWUJ3UK+Yr2v7smT/Mjis4sXfV+r+wuny6rfnmnEjowm6GtsmgB8
	 PN6n8akRDFCPKDHnkG23dIU1jsTO2XZZ4ofRTj9XapOvwxK5pZTkBiS+vc5rRCQ7onSfB
	 cZtdVr6fB95F8z3HzeppbAWNoIfZdTLSJOFuG/4Vt3lOcRexcPLkmObTcKKcWWhBKlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=af+i+EcHj1d3TRiQJcz/3qGalMKHF74ntRefhcI+Atc=;
	b=HlJ4DGetTktmOmwlndsTfTSIyvCuYvk8nntRqZOO1xq1PHZ3BtQoPUJjPw7MbWxpHtVj
	 WHvsColn40lLK7iXf7mDs3SqwO2Tz3XDalYW9HeC5cD2GKsNQWz02xhOP6bdOBfFOlU3S
	 Qdd7GKwA5zeRRG+95H47gjugG/EbsDUihPS+V7ii2s15MmEKi/hEV6edxKI6vFSMpSD8z
	 BdOrozoEac1Tfs2rwHI16+K6gD0H4hfey5ZZe/uoIBN9aZyK18N1Bd7uIPRoSOzhIq6Pq
	 5wh4Z8ckb9KEIADQokn3KXKyyCdzdx7oP8aJQQD45u2LmOwZonLcgcZgQu0KB3EajWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AA/pnHRD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C5A606D838;
	Sat,  7 Nov 2026 14:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AA/pnHRD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764DD1F0089F;
	Sat,  7 Nov 2026 14:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062372;
	bh=af+i+EcHj1d3TRiQJcz/3qGalMKHF74ntRefhcI+Atc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AA/pnHRDNtGiPdhxvw+2YniieIU+3Ce8Ug1zbYuZEoTDggGq1xHK/ezZ1kIz1UNes
	 fFDVmpJI8Magw5VFYeVEEa6UrXpaTzxfciwpZTYrpH4Mmr98wXOdh1dxVDv6gMdfzD
	 IIMsP8qvPLINKSz157wv7vYY5pkp52JJ6xb5EPbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nikolaj=20Klitlund=20B=C3=B8rty?= <nbn@sj.dk>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1296/1536] Bluetooth: btusb: Add device ID for Realtek RTL8761BUE (StarTech AV53C1)
Date: Sat,  7 Nov 2026 08:55:12 -0500
Message-ID: <20261107135034.191675021@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolaj Klitlund Børty <nbn@sj.dk>

[ Upstream commit 1430308fc9d47a801a305700cd444b1a0051d14a ]

Add the USB ID 0x14b0:0x047a for the StarTech AV53C1-USB-BLUETOOTH
adapter, a Realtek RTL8761BUE based Bluetooth 5.3 dongle.

Without this entry btusb treats the device as a generic Bluetooth
adapter and never loads the Realtek firmware, leaving the controller on
its ROM firmware. In that state it advertises and scans actively, but
never reports advertisements during passive scanning. LE connections
initiated by the kernel wait for a passive-scan report before issuing
LE Create Connection, so connecting and pairing from BlueZ time out
without any error from the controller.

The same product is also sold with the ID 0x2c0a:0x8761, which is
already supported.

lsusb -v output for the device:

Bus 001 Device 010: ID 14b0:047a StarTech.com Ltd. Bluetooth Radio
Device Descriptor:
  bcdUSB               1.10
  bDeviceClass          224 Wireless
  bDeviceSubClass         1 Radio Frequency
  bDeviceProtocol         1 Bluetooth
  idVendor           0x14b0 StarTech.com Ltd.
  idProduct          0x047a
  bcdDevice            2.00
  iManufacturer           1 Realtek
  iProduct                2 Bluetooth Radio
  iSerial                 3 00E04C239987
  bNumInterfaces          2
    Interface Descriptor:
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth

Cc: stable@vger.kernel.org
Signed-off-by: Nikolaj Klitlund Børty <nbn@sj.dk>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 32465e6736d2a..84b1ee064f64f 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -816,6 +816,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x37ad, 0x0600), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x14b0, 0x047a), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Additional Realtek 8821AE Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
-- 
2.53.0



