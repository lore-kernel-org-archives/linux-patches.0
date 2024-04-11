Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707DA14535A;
	Thu, 11 Apr 2024 10:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829732; cv=none; b=ECXPKRr0ZLCSPB2XzE9IDJfZk82aieB+tvNCeih/944FOoPCTXLJY/CMgVPlJ2Mcy3yBuvb3N/y8uV7gTJRgPXPmev3VtAvxy4ThVyAYmDagy0mFVtd3Mp6/QbO/X/dkd7RE5nr9zogYnd9GNANbGzCdd1ucNOmIUVY7wXXhpWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829732; c=relaxed/simple;
	bh=6MH7m7V25HpM9Zl0fXPqKViZmhO9wyQwWpF1sc1+m/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WjWnSZ5k0io+gjkUeHIfqK9x9WgAceHnSgBqHu9WJpp6EPm4IMaiaf8X6tQCo8r/LGLTE+zydul5ifgIiAG5+8nqXJNqGpX9yrs8LejLHYuepGgGpmuL9d7oltItq5mr3ynJFXM0gy0bUg/SX+b/KryD88XEB3nHqX6J5NJPRwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B58o+K6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B58o+K6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9051BC433F1;
	Thu, 11 Apr 2024 10:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829732;
	bh=6MH7m7V25HpM9Zl0fXPqKViZmhO9wyQwWpF1sc1+m/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B58o+K6CgUR6Bfza6+ys16yAPw/XPW48EE07w7W6DF4lD8zSoCr+0PhjXcLl2EuWZ
	 55H3vl2VWS4N6YFK2tPwQ06dsAOG7y7BQcD6l/9n4HKMB7qlvwc+o4ZEFa3Fa1YCIN
	 IA6UrzsHEIoZgJtTM3CzJdr2WWkFcTcLumF9+jNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20H=C3=A4ggstr=C3=B6m?= <christian.haggstrom@orexplore.com>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 037/175] USB: serial: cp210x: add ID for MGP Instruments PDS100
Date: Thu, 11 Apr 2024 11:54:20 +0200
Message-ID: <20240411095420.675405435@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Häggström <christian.haggstrom@orexplore.com>

[ Upstream commit a0d9d868491a362d421521499d98308c8e3a0398 ]

The radiation meter has the text MGP Instruments PDS-100G or PDS-100GN
produced by Mirion Technologies. Tested by forcing the driver
association with

  echo 10c4 863c > /sys/bus/usb-serial/drivers/cp210x/new_id

and then setting the serial port in 115200 8N1 mode. The device
announces ID_USB_VENDOR_ENC=Silicon\x20Labs and ID_USB_MODEL_ENC=PDS100

Signed-off-by: Christian Häggström <christian.haggstrom@orexplore.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/cp210x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 9901fd79b8a21..4bebe0f3c201a 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -145,6 +145,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0x85EA) }, /* AC-Services IBUS-IF */
 	{ USB_DEVICE(0x10C4, 0x85EB) }, /* AC-Services CIS-IBUS */
 	{ USB_DEVICE(0x10C4, 0x85F8) }, /* Virtenio Preon32 */
+	{ USB_DEVICE(0x10C4, 0x863C) }, /* MGP Instruments PDS100 */
 	{ USB_DEVICE(0x10C4, 0x8664) }, /* AC-Services CAN-IF */
 	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
 	{ USB_DEVICE(0x10C4, 0x87ED) }, /* IMST USB-Stick for Smart Meter */
-- 
2.43.0



