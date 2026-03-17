Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FF13F210B;
	Tue, 17 Mar 2026 16:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765980; cv=none; b=Kntwo4YmKc0ybi05VX4ZEF3p7B5d+szkjjrIBcd5np74hcfAsnPjyoPZYh9oXfTirAD5R/UOYbssX+PU3yZDer1HSiA8bZL6qsCsoIPrEj5Y506LAKggPhAr+UtdL6TveHWowGxF+qTiMEipjHMme9QRd0ktDrupjLHLSAS/J5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765980; c=relaxed/simple;
	bh=oDPAgEIb0eR2kKiShX++j1qtDrG68BZE6+/fvx9QZlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cywnMh/16zzficcBB+YIMPcrckg1xL0O2NCDmLkTOTB4LXAokVV7GdkHIxfazYtQI7pvpJVrrT8XWCpwAIxUJyRWdsQP1icfKCNwD+lOYM+MW89omnNb0vYSFZVWbOHZiziSG53XwEcDigzpCygMaG03cNRBWADJseA+K2GrCSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQE5fHq8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQE5fHq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435A3C2BC86;
	Tue, 17 Mar 2026 16:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765979;
	bh=oDPAgEIb0eR2kKiShX++j1qtDrG68BZE6+/fvx9QZlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JQE5fHq8P4OxdtzIq/Sqe0sPtnyhcWwc7lKxW1uKo6lDDCYUqXKQEnFeQYRZSwzw8
	 XKr9KFmgkCqa+eyO+TX16v01nEd6tjHOa14ASI+hjtqTRA2b3N/1lZ/IAeTDBA/RML
	 A4HH5AqG1smjlzBZso8U++AXtlQn95FYNaJ5rZM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>
Subject: [PATCH 6.19 143/378] usb/core/quirks: Add Huawei ME906S-device to wakeup quirk
Date: Tue, 17 Mar 2026 17:31:40 +0100
Message-ID: <20260317163012.278041934@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Sandberg <cs@tuxedo.de>

commit 0326ff28d56b4fa202de36ffc8462a354f383a64 upstream.

Similar to other Huawei LTE modules using this quirk, this version with
another vid/pid suffers from spurious wakeups.

Setting the quirk fixes the issue for this device as well.

Cc: stable <stable@kernel.org>
Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260306172817.2098898-1-wse@tuxedocomputers.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -208,6 +208,10 @@ static const struct usb_device_id usb_qu
 	/* HP v222w 16GB Mini USB Drive */
 	{ USB_DEVICE(0x03f0, 0x3f40), .driver_info = USB_QUIRK_DELAY_INIT },
 
+	/* Huawei 4G LTE module ME906S  */
+	{ USB_DEVICE(0x03f0, 0xa31d), .driver_info =
+			USB_QUIRK_DISCONNECT_SUSPEND },
+
 	/* Creative SB Audigy 2 NX */
 	{ USB_DEVICE(0x041e, 0x3020), .driver_info = USB_QUIRK_RESET_RESUME },
 


