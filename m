Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0F91E52C;
	Wed,  2 Oct 2024 14:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878844; cv=none; b=oggooqchtdaLc1YvwXC5fTdWzrpsdZnLJYq4vQhq0qdjDRY/RxhrPb6eBM1QcIzmRSUVjnbx9rfIij/TlQI6DxfO6PH9pzwGQvP0S+zxwMvJIdrvRi56eUA2KQztIh9CNPu/T2PhAtlrVDJPpQ+sN7O9nMJsubza4su75xMiMZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878844; c=relaxed/simple;
	bh=hm5S042Yw4gF5OFHlvQPlleV3sR2K+IyC+H1jzKXJNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DiFzBDU8Cajrxi4csI5BauHQXU1UBizr5oj5rWmgMf3Hy+HxcpPZ5+/YEKkkDHHN5w6h40TsXkJL8y3dBoofJyU8h/DJ0gCd/ePo6LERx0e0DX9GuBXHAUoLF9WNUePhsXNf4mTBeWopFpmmSdcyJGgvkUvvbsG39nmFFR7TDB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HIQ9YOoQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HIQ9YOoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C9AC4CEC5;
	Wed,  2 Oct 2024 14:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878843;
	bh=hm5S042Yw4gF5OFHlvQPlleV3sR2K+IyC+H1jzKXJNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HIQ9YOoQhW22tSircaUsAYRNIDKQpA3sjwOjbHhE8yWeEg1D8MNtDCKAJgPJ7sDnI
	 d8JQGNt33Mva3ZQE6HtCPBpG1RFBlnLAxX703cpujEVXM4wZY+3r4vQW8fQ7B9J97J
	 crEn4A6sQXp9zCPxrR7DRjDfPv04OUsqoL0fFVWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Morrow <morrownr@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.10 552/634] wifi: rtw88: 8821cu: Remove VID/PID 0bda:c82c
Date: Wed,  2 Oct 2024 15:00:52 +0200
Message-ID: <20241002125832.898455918@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


