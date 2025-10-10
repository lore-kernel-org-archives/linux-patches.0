Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4FB285CB6;
	Fri, 10 Oct 2025 13:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102465; cv=none; b=dJvkHFR9Azenr9z5SkT7E7Xx9B+N+As4q2hm3H7zyAOaTgY0K0i77O87zsSNRbC9nlJ3DGYJooZvibFQPdjLB7B4A5VEIFlS1oPnuQrm0miE0910nE4lKO/52bh338fG/SBCDv5wWxHmxvuCsUscJH+Fj3HTELebj8kUjslIsRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102465; c=relaxed/simple;
	bh=VKadKl1gcy9GbvCbfjMzO6+LNRkl78qWdC1oCQvo6RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uo5kKU0/2mV3b9GL/+yt66w+QgisDa26G4Tu4+6sL/aurt6iTearUFVN+FkzBdH18L23IeeiEXwrtBRQNfPAeMTa3joHn5wCuTPGLB/lkF8B48sh4UqXRyYmZ/AzdHjWTBwhPZyx23Y8SXSOe49ObrAF9hA0KrirYFoJwBp6r/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kRnqVU5q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kRnqVU5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451DFC4CEF1;
	Fri, 10 Oct 2025 13:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102464;
	bh=VKadKl1gcy9GbvCbfjMzO6+LNRkl78qWdC1oCQvo6RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kRnqVU5qUSJ3YyAg4HQYieVud/tdLLnFAQY3D7/Krp5zbMBY5C3Fphr5arDgZkLEh
	 zrLOSjXR2BwhCNHmHnRCLTDvnan/6ME+mjkByfAMrOSXS6vZfRfJ+j62sMSB48kXVH
	 p6COoG0YE33U2hAHWPg24xMMrIQ/fpuefPNtspko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.12 05/35] wifi: rtlwifi: rtl8192cu: Dont claim USB ID 07b8:8188
Date: Fri, 10 Oct 2025 15:16:07 +0200
Message-ID: <20251010131331.988064741@linuxfoundation.org>
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
@@ -291,7 +291,6 @@ static const struct usb_device_id rtl819
 	{RTL_USB_DEVICE(0x050d, 0x1102, rtl92cu_hal_cfg)}, /*Belkin - Edimax*/
 	{RTL_USB_DEVICE(0x050d, 0x11f2, rtl92cu_hal_cfg)}, /*Belkin - ISY*/
 	{RTL_USB_DEVICE(0x06f8, 0xe033, rtl92cu_hal_cfg)}, /*Hercules - Edimax*/
-	{RTL_USB_DEVICE(0x07b8, 0x8188, rtl92cu_hal_cfg)}, /*Abocom - Abocom*/
 	{RTL_USB_DEVICE(0x07b8, 0x8189, rtl92cu_hal_cfg)}, /*Funai - Abocom*/
 	{RTL_USB_DEVICE(0x0846, 0x9041, rtl92cu_hal_cfg)}, /*NetGear WNA1000M*/
 	{RTL_USB_DEVICE(0x0846, 0x9043, rtl92cu_hal_cfg)}, /*NG WNA1000Mv2*/


