Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD04921579F;
	Fri, 10 Oct 2025 13:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102467; cv=none; b=bIsiY8UMf2aGSHb90oJO1Tt5BDh+GVRtwnUz8SI40oogB8oavfSQYItUxazhcZCTyeR94Kl4Q8yWE8uuwDc3ePoQUJDPcWCHRqRGWL1M2/uhQ+iNaC9SaXQX/KXG546rIZa3swNXymLdk1LGqAI55G0HVPfzdGEwRWMk9Dj/QyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102467; c=relaxed/simple;
	bh=H6F7A3Xe9CVE5xVPFOSmf46w2eNWuK2D3M7DSgP0uLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgwbMRIbAQRJfg2f7iqF286TeI5QQJJ17xMS2FhmRL65wl7WDaSqJHlDsom7Cx6un7WQ/EEBwlZXLv0WoD3T+6u/7wShx/kv+9ZJHgtfklrhB6cRy2lvE/RZLd2L2AfHuf9T88s0lezp/xgE3NFhN2rM8pmXs7J08dckgVKsGjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BzCXr7fc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BzCXr7fc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F53C4CEF1;
	Fri, 10 Oct 2025 13:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102467;
	bh=H6F7A3Xe9CVE5xVPFOSmf46w2eNWuK2D3M7DSgP0uLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BzCXr7fc3kLQCtt0XBccpvnVhX/uRHX6/O4SS7juqqB3tSoie4tuKyqST8FgQiu2c
	 rUGN9gTk/Q/FAgvwnou/mDQSR8uDhCksbQkoFll49IwEhUZujIlZXmPT+Bh9ZDWLhe
	 zAvTWNLLinRauXQFr4D0Ck1RM76jB/6jwynwvvKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.12 06/35] wifi: rtl8xxxu: Dont claim USB ID 07b8:8188
Date: Fri, 10 Oct 2025 15:16:08 +0200
Message-ID: <20251010131332.024320140@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
References: <20251010131331.785281312@linuxfoundation.org>
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

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

commit ec0b44736b1d22b763ee94f1aee856f9e793f3fe upstream.

This ID appears to be RTL8188SU, not RTL8188CU. This is the wrong driver
for RTL8188SU. The r8712u driver from staging used to handle this ID.

Closes: https://lore.kernel.org/linux-wireless/ee0acfef-a753-4f90-87df-15f8eaa9c3a8@gmx.de/
Cc: stable@vger.kernel.org
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/f147b2ab-4505-435a-aa32-62964e4f1f1e@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/core.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -8170,8 +8170,6 @@ static const struct usb_device_id dev_ta
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x06f8, 0xe033, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
-{USB_DEVICE_AND_INTERFACE_INFO(0x07b8, 0x8188, 0xff, 0xff, 0xff),
-	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x07b8, 0x8189, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x0846, 0x9041, 0xff, 0xff, 0xff),


