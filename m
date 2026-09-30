Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835205158B4;
	Wed, 30 Sep 2026 16:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784517; cv=none; b=HDdA9CIZCDue02xqn2nkUwTJ+WFU0QpakApriRmdnnGoJlnQkx6qTyCuYOsHXX/gk6ZkjRCaHR/LbcuJOEJz9kPuQ499zAl5Zw8vyo/LkO5DcD7juJnhdDgdfgqRUR27eU4gyWUo6rxY6aXQCEXPR/041RcuRwEKPkZ1Asjqz8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784517; c=relaxed/simple;
	bh=KdjNMNSNJWOT4oF3EYNeYbhKNWq4QoZMzSaDdSL9xTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUdJ+BYaNACljKfY9wTzZ3ItSvn8/Aacl1cgmXLCESf7wC5RrBz3NDU5AVTC76xkJvp/tWxlnq081YaPHo+0gwoFQGQza9qICPgOLRxntB+QSHRAaCmVxQRvhfHvqp3JN5zMkob1z5z335DjXKDgbkl4AXFXajaFekwoNpvm5Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZCyy3fL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZCyy3fL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86061F00899;
	Wed, 30 Sep 2026 16:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784510;
	bh=rRrQgBemBR17NanR1KyJpASR0bTcV54kBltqtzPW094=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZCyy3fLMgptL1Oqlj5W995nL74LgN8S9FEIhBzkjVcz8phyAOuIIxaLCQqMztMVR
	 BZa2KQOPBF7xjUBFtZVLpAgHlKdquHNaWzQZFCBSP/bJ6wzGRd8Q6xPQmI7FEaY+cn
	 GwgoGxFRbA70j9oqS1+HgFVxb6jaFRDwMUSPq4FM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hrvoje Nuic <hrvoje.nuic@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 182/982] Bluetooth: btusb: Add Mercusys MA530 for Realtek RTL8761BUV
Date: Wed, 30 Sep 2026 17:15:18 +0200
Message-ID: <20260930152420.724465292@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Hrvoje Nuic <hrvoje.nuic@gmail.com>

[ Upstream commit ce21a5cf3d1fd92b84ea9ad2b7c7240aff2162d2 ]

Add the USB ID for the Mercusys MA530 Bluetooth adapter. The device uses
a Realtek RTL8761BUV controller and works with the existing Realtek setup
path.

The device reports vendor ID 0x2c4e and product ID 0x0115, and loads the
rtl_bt/rtl8761bu_fw.bin firmware successfully with this quirk.

Signed-off-by: Hrvoje Nuic <hrvoje.nuic@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index acf58aaa551ef..0e38bf99d572b 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -659,6 +659,8 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x2ff8, 0xb011), .driver_info = BTUSB_REALTEK },
 
 	/* Additional Realtek 8761BUV Bluetooth devices */
+	{ USB_DEVICE(0x2c4e, 0x0115), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x2357, 0x0604), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0b05, 0x190e), .driver_info = BTUSB_REALTEK |
-- 
2.53.0



