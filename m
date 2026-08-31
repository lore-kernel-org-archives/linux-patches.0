Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3068154B1A6;
	Mon, 31 Aug 2026 13:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183998; cv=none; b=PepfzLpL3f9pSMwfNB1xgV2n0ldtXgIBO2X9vfrwM0aHvWiChyu3hrDgXkm1MMgptzqpgWI+/O2dboanLysQL0ID23Ymi8o1YhcCIaKWgM5OISgls3OX7mE8riHGonjAM+wRuVapdDUKpE8Duw8dLmSytfT7CRg+yF8/4JCONyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183998; c=relaxed/simple;
	bh=Yk7XiU+KGgZRvbChi7ZBLTnWfiHt0rvpRCH898QG/RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AzPj2Oy0ZXa2CePJl+gtkk98lwNOvJTo9Yxxyvuxt5XGT8A5Vhxb4HS2EviexNcb+dqI7pT8kLVj2lZWXYypVZ0LtM4gkSXmHYMZZKq4b6xeJX/b0bH5aYpd+QIcoxLpGJZnLcq6enAiTJrQEhK5j5X4Pou9ZMtLijev3W/PLWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZzXqc7n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZzXqc7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87081F000E9;
	Mon, 31 Aug 2026 13:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183993;
	bh=Zhk8KnI1J0sNIOxLv4X3lZs3ypeeZ8nU9TDdLaZxNpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PZzXqc7ncOlc0+AZ6rdzYfih6NbtG8y7F0pIrqIGEl9+eWB1vWd+GFRFthNau63KR
	 PZ6TKv6G+dy65kabccApZ5OTPh0hIq+a9wzrEG3ccClFToCpdKTB3Qgh/4MBVAv4w9
	 3MPKBmewZy6x0DLp5m0zDKqpeKFywrzCy5w8Lra9PCF+su4/5X6oLq0PgFJYw997T/
	 K+vxozhSvRM+3oK18yH0BpjiZcdFMayt6nInocFw2+GLuXyzJWvkCs3EGSjVGs2X60
	 c2tKE/XRN01pW9L69rYoFeTgZYeuBo2RL6dUNJHDgBRUgy/wyPqI9YqurjXtN1J0lS
	 hTBqb+IlxZjPw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cris <cxs1494089474@gmail.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] Bluetooth: btusb: Add support for TP-Link TL-UB250
Date: Mon, 31 Aug 2026 09:27:34 -0400
Message-ID: <20260831133314.4125787-426-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cris <cxs1494089474@gmail.com>

[ Upstream commit ea77debfe443f505a4edbb7f21340a583a8a143f ]

Add USB ID 2357:0607 for TP-Link TL-UB250.

This is a Realtek RTL8761BUV based Bluetooth adapter.

Without this entry the device is picked up by the generic Bluetooth USB
class match and exposes hci0, but the Realtek setup path is not used and
rtl8761bu firmware/config are not loaded.

The controller reports Realtek Semiconductor Corporation as the
manufacturer and LMP subversion 0x8761. With this entry added, btusb
loads rtl_bt/rtl8761bu_fw.bin and rtl_bt/rtl8761bu_config.bin
successfully.

Relevant part of /sys/kernel/debug/usb/devices:

T:  Bus=01 Lev=02 Prnt=06 Port=00 Cnt=01 Dev#=  9 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=2357 ProdID=0607 Rev= 2.00
S:  Product=TP-Link TL-UB250 Adapter
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb

Use the same flags as the existing TP-Link 2357:0604 entry.

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Cris <cxs1494089474@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background history searches finished. They confirm the TL-UB250
commit (`4ca941ac55df8`) is not in the current `linux-6.18.y` checkout —
`2357:0607` is still missing from `btusb.c`. The `--grep="0607"` hits
were false positives (matching commit hashes, not the USB ID).

That matches the earlier analysis: this is a standard 2-line device ID
backport for stable, and the verdict remains **YES**.

 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 91208da2be48d..fad09a01ae125 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -799,6 +799,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x2357, 0x0604), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x2357, 0x0607), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0b05, 0x190e), .driver_info = BTUSB_REALTEK |
 	  					     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x2550, 0x8761), .driver_info = BTUSB_REALTEK |
-- 
2.53.0

