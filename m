Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BDA30CDAF;
	Mon, 13 Oct 2025 14:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366922; cv=none; b=pSHkSVLPm0+sapM0QOVN8Xxg+H6L8WbWaLdBmYdu77BvGp7XFoL50cAE7AfOQZK1R3+P9qTKbqvUyayhhXvXLATrW0VDmMVCL1xLhXA87I+OvVFBZEYMNUR0icaa/Dmq6MG0vEXkMlbKL3AewLF9KsyW5uGsp3NroU+BDHf+YVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366922; c=relaxed/simple;
	bh=rzHvq2YPDfR4OftOqn97AAdPXkbXf0wHd7k41brn4H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eflvSBwm+4Hz0PBxQDGpZnVMAjwCXUtyBm4QZzNV1in6o1ZMewXCKtvv9BIbeEn6ap+Q7JIh7qoU3DnihF2ydpvoypw9qtXmmhU2tHaE7FEpwxodlB1ERxp0rW1ri1hJrPcmEJf1f2QYWflfx/juqASCxrnm6I9F/1z0u2tXYxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7eUMHCI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7eUMHCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90399C116D0;
	Mon, 13 Oct 2025 14:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760366921;
	bh=rzHvq2YPDfR4OftOqn97AAdPXkbXf0wHd7k41brn4H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J7eUMHCIU/FJhMHogSGGiHXnLQuUIWNar2qPVvcaVboQ2mKXQ116hB2NTgOWEGgxb
	 8b2p6AnWLuA2YVlj3INDme3jPOJvHWjJR8WwHLIhtpZA+PtxtFfLLBdt5PjOZN8XnH
	 boL+39hLtp/V119FHftmCrWQj3MCpcJb6FrGjGhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.1 031/196] wifi: rtlwifi: rtl8192cu: Dont claim USB ID 07b8:8188
Date: Mon, 13 Oct 2025 16:43:24 +0200
Message-ID: <20251013144315.715698188@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

commit e798f2ac6040f46a04795d7de977341fa9aeabae upstream.

This ID appears to be RTL8188SU, not RTL8188CU. This is the wrong driver
for RTL8188SU. The r8712u driver from staging used to handle this ID.

Closes: https://lore.kernel.org/linux-wireless/ee0acfef-a753-4f90-87df-15f8eaa9c3a8@gmx.de/
Cc: stable@vger.kernel.org
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/2e5e2348-bdb3-44b2-92b2-0231dbf464b0@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
@@ -296,7 +296,6 @@ static const struct usb_device_id rtl819
 	{RTL_USB_DEVICE(0x050d, 0x1102, rtl92cu_hal_cfg)}, /*Belkin - Edimax*/
 	{RTL_USB_DEVICE(0x050d, 0x11f2, rtl92cu_hal_cfg)}, /*Belkin - ISY*/
 	{RTL_USB_DEVICE(0x06f8, 0xe033, rtl92cu_hal_cfg)}, /*Hercules - Edimax*/
-	{RTL_USB_DEVICE(0x07b8, 0x8188, rtl92cu_hal_cfg)}, /*Abocom - Abocom*/
 	{RTL_USB_DEVICE(0x07b8, 0x8189, rtl92cu_hal_cfg)}, /*Funai - Abocom*/
 	{RTL_USB_DEVICE(0x0846, 0x9041, rtl92cu_hal_cfg)}, /*NetGear WNA1000M*/
 	{RTL_USB_DEVICE(0x0846, 0x9043, rtl92cu_hal_cfg)}, /*NG WNA1000Mv2*/


