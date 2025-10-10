Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1492F60D8;
	Fri, 10 Oct 2025 13:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102374; cv=none; b=uietKzitLGeXJGAdh6tTcjyRf5jAuQhKJZlQ8cZrpajnC2e21/iCMogiCCDL/vMjNsdL6cgu2hsj5eYvpN2jodgnsKgn/ZEo/wM4jERoNOOaWjAKtSTfKQvCrExxvWIhcXKl0tJJnpowIzlmKwix8e9hPgHaf2tHtP2OplPBhIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102374; c=relaxed/simple;
	bh=wVBobpJxKdmIxzp/cH2sj0QeUZfyX7viAbwCPzVaZBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjlywQ33tJI2Jm3pw2oIedAZ8eVGDQwQdx1J2O7Ykvqk1GeFVPZNwJHRLFgHWhTHbb17ggpXQDFx1f2hhD//JXyPSlM9ULFvSIRxq3jyl9p4hrXduV+VGBbCR9vVbQaAktzFNp8xfnJXtYnpTNiwpa0lrWtC4mt1YXwW2pVCEn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRdpz24w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRdpz24w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B75C4CEF9;
	Fri, 10 Oct 2025 13:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102373;
	bh=wVBobpJxKdmIxzp/cH2sj0QeUZfyX7viAbwCPzVaZBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sRdpz24wOhUNcUgzW7AAmLSctfFpeAM4afV8yS+wWGwT3DgCUXsHC34bqabv9Ogyv
	 B0OdnLoxqgyhTrQbcGjK/i4veBP003xnyfw80eQUgw0GHXSNZA1Fn2PnYQXE2X9zE+
	 4VTceqrbV1eMhTyIv54/JOVSSQ0Lro18Ks3ghMoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.16 08/41] wifi: rtl8xxxu: Dont claim USB ID 07b8:8188
Date: Fri, 10 Oct 2025 15:15:56 +0200
Message-ID: <20251010131333.726674052@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


