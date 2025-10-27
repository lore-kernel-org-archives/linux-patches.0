Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8576198A11;
	Mon, 27 Oct 2025 18:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591021; cv=none; b=lyxWHNsH12+ljn6/n+kHJIp1p9GfWaqtdTC+svT8pgdklpWI7k/rhUWNxVZp5MMh3e09QJh+jfgF2tSXDXNvJEmuPIW0xjHoqmYkhUhGo57XCjcQup7+rC3QsrF8CYZD5LbywWicqNDKvWRKeHdFaGVjpBqPp4coLt5waAqSG/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591021; c=relaxed/simple;
	bh=gS+6UOy+BVylz29hCJsjjPpk+ghhePKnWeYoqOVRD7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAyHhI8JHvpzW00kXnC09kchQ8NzTT1OiEDku2t8BX3y9qcTgfYF9QWnnI49NvUf55gbxOqctyk43zJYvrv5cLZXcUCugABJdiEk1ELJx3aXjhoLy0D7hA7aMcpP4LG3ZWyKSlVFfg0ezgnfpcrqG+ScG0h8MF0PFOcdawkqgvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TgwmTH+d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TgwmTH+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67ED7C4CEF1;
	Mon, 27 Oct 2025 18:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591021;
	bh=gS+6UOy+BVylz29hCJsjjPpk+ghhePKnWeYoqOVRD7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TgwmTH+dZ+IvqBbqxk+33dY1N1MY1D9VFv/Dj9Gk3uig+tvqODpQbCPg9HHrmPS/D
	 Vss7fvWGkQpsJiGw6ucciMTi9GJ5YS01zKsb6UVgxy24vZ3uFAMOymUcLzbASavDVl
	 8xAvn9OqAx4b2M6xcYs5b23D4u2vlLriPOWWO/6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 5.10 009/332] wifi: rtlwifi: rtl8192cu: Dont claim USB ID 07b8:8188
Date: Mon, 27 Oct 2025 19:31:02 +0100
Message-ID: <20251027183524.869156875@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


