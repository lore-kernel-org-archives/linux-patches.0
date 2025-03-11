Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C22B25EFB5;
	Tue, 11 Mar 2025 15:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707046; cv=none; b=KhgTL4JYXexSwL+Lb11tb/ZVZXCKRx7eCWSmPEwlUipkQogF1+SoLTxCMBdp5KPvVcmx2bs5entVx5lAJKr2G0M31T/U2mw/jSjY2S9fZJJxbn/h6izfjoWwktIURPq8VjKccacvb0+an5NOUrgohUMgtZJAzI09wHHIFrDawh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707046; c=relaxed/simple;
	bh=Pt0Rmc18eJO+GC+6ww1ocoiHDJD0qhRsS2ukvJejigs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuW9qIShee/BGb3I5W62LpLbwySViOqyt4vGO2ThRpQKTHV3xml5X4MxivyHNyf8HGOKeW/k79YfwVjM6zk0uiahtuYRy/2t1GAEX2tR1efnPFYSFRpKygTgrjqM2BVWEWmqSfIPjdI4ozGvlzQ5lLHP4r9Po08kApRZvwtT4VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZyFrkchj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZyFrkchj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A9CC4CEE9;
	Tue, 11 Mar 2025 15:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707046;
	bh=Pt0Rmc18eJO+GC+6ww1ocoiHDJD0qhRsS2ukvJejigs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZyFrkchjE+5dfkmXSqipv0PIe3Cx5du2HBEFVXPuytsCCmwwT31mX1NcAY7Kwqia8
	 nGw7yQAIs9JyYmNtBp4OImw07NO0GS9plbyNs39LW2gVsDUHI1X6ORiiEbDgJ64k6x
	 fk9C5pJPYceyR3XjymGctp1XGmCMWjkJuFOd9wiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5.10 256/462] USB: cdc-acm: Fill in Renesas R-Car D3 USB Download mode quirk
Date: Tue, 11 Mar 2025 15:58:42 +0100
Message-ID: <20250311145808.476061227@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1723,13 +1723,16 @@ static const struct usb_device_id acm_id
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


