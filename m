Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5410A3BC691;
	Mon, 23 Mar 2026 16:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282569; cv=none; b=OSUMA4LBWZ4EmHq1BgFg37mLTQLORovdNa8kiIDryUbiYNnUokq/POPcG9fvcgk+1ONEGnJOrb+pK3bcLZBCJFFCRbrtmPd/0fM/PMVyKnAgvz5tuDpXxVBCudn40NvhxsiSrpffDu7i0HcSYBHFQtdKHGjPTadbnAH+gVchwto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282569; c=relaxed/simple;
	bh=82YrtEaciNngApzlJiWujGa/WMgsiKpD1wtPP8P0xvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVYSiXL0D/MrbyYa21xcokD2AtrPX39V5wYGcDrs6ZyglxEAz6gGJmFtkIfr81fZOOnsy874JsYq5rseoCSkLMkoTXcvecvsfqxSEJuXVbXFjhcOVA+7k2i7HLASdXiRwOS7s0gooePLSx6RGPcZGPmDmKU5A8UtYe/10VfV5Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVjjxK53; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVjjxK53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8161C2BC9E;
	Mon, 23 Mar 2026 16:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282569;
	bh=82YrtEaciNngApzlJiWujGa/WMgsiKpD1wtPP8P0xvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVjjxK53YE0q7I5ZRO4tgmIn+tWuGwg0viG50BbX0EGywZI/MVVFLMqfL27gpV4gC
	 KI5sK//BPoT1AUj6ftCT1wWYO9S9OGtIy6m4HN/00MTp184wx61shpeo9WHAV1hhIq
	 LoK3pfD1CopjAuucnuwOkoiNLWeVs0rO2D3LIz/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>
Subject: [PATCH 6.1 205/481] usb/core/quirks: Add Huawei ME906S-device to wakeup quirk
Date: Mon, 23 Mar 2026 14:43:07 +0100
Message-ID: <20260323134530.169545396@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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
 


