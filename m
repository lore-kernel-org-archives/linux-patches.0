Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336166FB0;
	Wed,  2 Oct 2024 14:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880428; cv=none; b=KJFdpAXqcCiJLQwk2FzykuqDNPp+tB1QcT70KedEjl2IGVGJc0mm0FYbXU0hiJb0DluMR24pj7ljsXXXI+mKRD2Xq06C2iYMq4cj0hrPbMsdv94s8Kt91BVRYl2vEliQtM3ZbNhWKIWGI0IfVYOoTuMMGt5Hx3hsa52Nrfzqs80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880428; c=relaxed/simple;
	bh=4MHmxLcSSzf1I6z12Pqv15sFNHGRhj7RdEup0VkYHfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDpamhvk5BuJAAxSnzrMA7DqwDajGTItzzRqOS4mN0d0CVLfINsvkV/wGY+9pa7Nye2T/WNs5ujV1LazEuJdCxcYamz6ISjUyrx7aBHKmSwyeItiqQEJQ0hmty2GrEk7YL2QyeMt2UnfP06K2al4O2RqZ/Z4wFq5YQOXBwtgZAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LMKxTliF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LMKxTliF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8B2C4CEC2;
	Wed,  2 Oct 2024 14:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880428;
	bh=4MHmxLcSSzf1I6z12Pqv15sFNHGRhj7RdEup0VkYHfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LMKxTliFYvRRL/tg5SUhC4MLk6elvPxv9ROlzEymZxRWV467I12Bh+SE6/FqTDHvO
	 HiYot8/qUGnzy29k9VqnosPU0FW/F2KDVhj5vytTTzj5nFNPoCvf0i9wWG1f+ls9F3
	 xAcSqShJ6VxJBxdVTjwyx4Z+uEq1JqckXa8zczJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Morrow <morrownr@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.6 455/538] wifi: rtw88: 8821cu: Remove VID/PID 0bda:c82c
Date: Wed,  2 Oct 2024 15:01:34 +0200
Message-ID: <20241002125810.402818542@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


