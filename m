Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E58517A2E8;
	Mon, 10 Mar 2025 18:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629655; cv=none; b=RINXUaashdiiaxZj7hd9tH/adwHSvlpPLAO1ZnqFdT6+ARB/YH27VFoK5jzU80JvBcVB/KIuRmYZwwBcI30Tc0pmfCMQYjQ7dlkhebglZ3VNgU/s0sGlINWH0O1em7nBXpdtun78fwEiZkHH+ieTAqnOrfYNXOcBfxPXbSKonIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629655; c=relaxed/simple;
	bh=CfUOEVcXhbFfl5uhIEkP5pqN1D6M1/1tQ9PyZg6gSXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pwkgxljt5U5BXrYFpF8JlXSRbRtaD6PjM+krbeTjutYC1w+/UB66QHrwPA9mre/sz+X6bzDM4Qyb1Os7ZbtC7cRkKEITVQZUj6zv0LLeZht8UfGPqEhie4tpj4JWEH2nNb5XLZ4FV5N0pikHDKoPnJhNACn2CqugNoll2enFmmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rt0/FLlN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rt0/FLlN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB7EC4CEE5;
	Mon, 10 Mar 2025 18:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629655;
	bh=CfUOEVcXhbFfl5uhIEkP5pqN1D6M1/1tQ9PyZg6gSXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rt0/FLlNWnqKfmear30I7Zi6lrWo6k2dplD36Lk/SHOP6IJe6dACuVawRL1Tf0605
	 fROfNyzrNw9azrML+mWbMGdplnMYAwB9lNoOzCAscV2EeaKawpSvK0RYS9icQylfXI
	 yUqIX+41erAHKJyEc1uyBDKNB/muNXFboz+sE0Zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5.15 369/620] USB: cdc-acm: Fill in Renesas R-Car D3 USB Download mode quirk
Date: Mon, 10 Mar 2025 18:03:35 +0100
Message-ID: <20250310170600.168901770@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1707,13 +1707,16 @@ static const struct usb_device_id acm_id
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


