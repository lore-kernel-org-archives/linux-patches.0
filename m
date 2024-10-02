Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B702A29CE7;
	Wed,  2 Oct 2024 13:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876963; cv=none; b=B8CpcZxURCLjZbLssnxdaNfPxVh2fTac/XO6dM7P//WSjfEwpTMU69C5E35viXt7pAzIlXwo0/+W4BfnKna7lAV8h3gAeXNoobR+1teil+0VFrIYZTj9MW2EEUhJnTheVcHalhGoumLfGgjA/SAfJ2ZFve8n9KplYzZxbpl9Q8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876963; c=relaxed/simple;
	bh=rsB72sXJgXGzufp/pIrUggGc1g26NCPftYQ0ZSmep1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSd58LNrh8CFqtFt05iKN5vIikDpBwOXlM5pCXnKsGxqWSCUUaNsRYSND+z3nSchtUFbT9ldsvzreUXtxVz8p0+4fu59LrcqtHHKwp45zXOclGMcEteXNA4/gvcjNpb/2EJY6V7P6Zz8GQjUqoOQf+2IzdNmeqHBf3PpQSu6e8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXkwN3pL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXkwN3pL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF2DC4CEC2;
	Wed,  2 Oct 2024 13:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876963;
	bh=rsB72sXJgXGzufp/pIrUggGc1g26NCPftYQ0ZSmep1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bXkwN3pLJb4F+unWDjVZXDkzc9rWYeZKrRoiM6kTy8w+tCA4WCAaObC8mzmGuanX2
	 2QDk+PQtdjEjiOwSxE8OD0DAxmf1sOLFQxad3/ZT4+F8oA/cXJg1Bg304hrSd9qkNx
	 KmOakD73be07K9YusIpak5cswJFFdMm9QGs1mMcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Morrow <morrownr@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.11 619/695] wifi: rtw88: 8821cu: Remove VID/PID 0bda:c82c
Date: Wed,  2 Oct 2024 15:00:17 +0200
Message-ID: <20241002125847.222034279@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Morrow <morrownr@gmail.com>

commit 0af8cd2822f31ed8363223329e5cff2a7ed01961 upstream.

Remove VID/PID 0bda:c82c as it was inadvertently added to the device
list in driver rtw8821cu. This VID/PID is for the rtw8822cu device
and it is already in the appropriate place for that device.

Cc: stable@vger.kernel.org
Signed-off-by: Nick Morrow <morrownr@gmail.com>
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/335d7fa1-0ba5-4b86-bba5-f98834ace1f8@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/rtw8821cu.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/wireless/realtek/rtw88/rtw8821cu.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821cu.c
@@ -31,8 +31,6 @@ static const struct usb_device_id rtw_88
 	  .driver_info = (kernel_ulong_t)&(rtw8821c_hw_spec) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(RTW_USB_VENDOR_ID_REALTEK, 0xc82b, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&(rtw8821c_hw_spec) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(RTW_USB_VENDOR_ID_REALTEK, 0xc82c, 0xff, 0xff, 0xff),
-	  .driver_info = (kernel_ulong_t)&(rtw8821c_hw_spec) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x331d, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&(rtw8821c_hw_spec) }, /* D-Link */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x7392, 0xc811, 0xff, 0xff, 0xff),


