Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D513B0AFC;
	Wed,  8 Apr 2026 18:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673626; cv=none; b=iaPtdjHAd/cJjKsskvvWPJEph49BPVOM7WsukcKTjV7zNS37XQbNfaRwjDImDW/4F5ImQxdexXnv0bcmx5fUthG1JNSs5WRkzX5bOoWumfXquz6gFjXwfSnChJODsb1asRsKO4vXTnNrlpDXT8YLjWiFpfsa8x3gnzwqOxfmItw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673626; c=relaxed/simple;
	bh=tsCkIEt0fQUOT3GLkBf2L8N9uUC8i/bAStE781xl/xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwiOCrHlTZyo/rfJmf/pI5Lbzx+7NOJnHikt6QbZsuW/YAr2mq/pqBK2Lri4Qx43VGzeZsODqtCD4lT8TSkm1kt6EocWN6OZAHrhUO2ngvxwus/5logU+onTVAnqNkWDzhymyNO9JqXkzgClafAxrrk8OVGwN0IvhcLbYUTDRoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sFA4UoFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sFA4UoFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606A7C19421;
	Wed,  8 Apr 2026 18:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673626;
	bh=tsCkIEt0fQUOT3GLkBf2L8N9uUC8i/bAStE781xl/xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFA4UoFVluosNxp2mwrnwTt1oTEqTXkWk25oNLA2fUodUS4C07llw6pTB4Y93cVa8
	 5Oo/lzKHAIkdYF2QCRe767+M7yuLpD65VIXnes3eHCkqfgY/Thz3MyUK/fbm2JEud0
	 13MJjdU5/zA22kjrOB2f8mYdQOq8e/TRYhLFaiDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Freund <adrian@freund.io>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/242] HID: logitech-hidpp: Enable MX Master 4 over bluetooth
Date: Wed,  8 Apr 2026 20:01:07 +0200
Message-ID: <20260408175928.086072166@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Adrian Freund <adrian@freund.io>

[ Upstream commit 70031e70ca15ede6a39db4d978e53a6cc720d454 ]

The Logitech MX Master 4 can be connected over bluetooth or through a
Logitech Bolt receiver. This change adds support for non-standard HID
features, such as high resolution scrolling when the mouse is connected
over bluetooth.
Because no Logitech Bolt receiver driver exists yet those features
won't be available when the mouse is connected through the receiver.

Signed-off-by: Adrian Freund <adrian@freund.io>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 492a02ca80594..c9df222e894a1 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4695,6 +4695,8 @@ static const struct hid_device_id hidpp_devices[] = {
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb038) },
 	{ /* Slim Solar+ K980 Keyboard over Bluetooth */
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb391) },
+	{ /* MX Master 4 mouse over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb042) },
 	{}
 };
 
-- 
2.53.0



