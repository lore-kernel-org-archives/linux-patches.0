Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F43D1FDA8C;
	Wed, 19 Feb 2025 08:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954337; cv=none; b=MgJJ2GWj0j+BOl6k5+UWBW/u3/oHp/u7d/QC19MkzQRg3s2daqrtx2y6sEUD8u42UdJgl2X8odyP9dYsefUVroEisdHNzUiXP+UcoRScPb/4R7cR6lVXp4QQPHNSWKSOcUT5GF64/ND5r/Zlpd43GjRVJOR74zBMebXkgern2TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954337; c=relaxed/simple;
	bh=0+P/PS1lDlXPRCFGiYAzOirprH5CcddWjz1fUde0tmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGfYyKd3r/TLPGcAzxl67iDGB2xNYDPAK+hC7wdcMLTEuOcpTwICgGL440JMPeauDgCG54zO34BZwYkQ69mOH6irazpsi7Ki7ywx4qYKTHz+hjeH5bvDkcfWHNYc1akkSFWadrlud7PF+NOg0S4VlfXqwv45VhXixXL89csE8Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eZD8ibQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZD8ibQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7B7C4CED1;
	Wed, 19 Feb 2025 08:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954337;
	bh=0+P/PS1lDlXPRCFGiYAzOirprH5CcddWjz1fUde0tmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZD8ibQRd3aFcbaisF6eL3ae+P0ztMzrfusa8NSCWbUdMZ5QkOWGSX3PK+46a+PpH
	 D5xHy1x4QTluE66yDXfiUjpFfcCHYLAUQIDgscizjdC505CDuq85PiWyIoY7QdDRey
	 HXp/j5czQRCsQJmR64N6EbYYfhcSDcWCSil4qgOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 6.13 141/274] USB: cdc-acm: Fill in Renesas R-Car D3 USB Download mode quirk
Date: Wed, 19 Feb 2025 09:26:35 +0100
Message-ID: <20250219082615.120346172@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

commit 7284922f3e4fa285dff1b8bb593aa9a0b8458f30 upstream.

Add Renesas R-Car D3 USB Download mode quirk and update comments
on all the other Renesas R-Car USB Download mode quirks to discern
them from each other. This follows R-Car Series, 3rd Generation
reference manual Rev.2.00 chapter 19.2.8 USB download mode .

Fixes: 6d853c9e4104 ("usb: cdc-acm: Add DISABLE_ECHO for Renesas USB Download mode")
Cc: stable <stable@kernel.org>
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20250209145708.106914-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1727,13 +1727,16 @@ static const struct usb_device_id acm_id
 	{ USB_DEVICE(0x0870, 0x0001), /* Metricom GS Modem */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},
-	{ USB_DEVICE(0x045b, 0x023c),	/* Renesas USB Download mode */
+	{ USB_DEVICE(0x045b, 0x023c),	/* Renesas R-Car H3 USB Download mode */
 	.driver_info = DISABLE_ECHO,	/* Don't echo banner */
 	},
-	{ USB_DEVICE(0x045b, 0x0248),	/* Renesas USB Download mode */
+	{ USB_DEVICE(0x045b, 0x0247),	/* Renesas R-Car D3 USB Download mode */
 	.driver_info = DISABLE_ECHO,	/* Don't echo banner */
 	},
-	{ USB_DEVICE(0x045b, 0x024D),	/* Renesas USB Download mode */
+	{ USB_DEVICE(0x045b, 0x0248),	/* Renesas R-Car M3-N USB Download mode */
+	.driver_info = DISABLE_ECHO,	/* Don't echo banner */
+	},
+	{ USB_DEVICE(0x045b, 0x024D),	/* Renesas R-Car E3 USB Download mode */
 	.driver_info = DISABLE_ECHO,	/* Don't echo banner */
 	},
 	{ USB_DEVICE(0x0e8d, 0x0003), /* FIREFLY, MediaTek Inc; andrey.arapov@gmail.com */


