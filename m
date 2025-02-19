Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097391DE4C6;
	Wed, 19 Feb 2025 09:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957402; cv=none; b=BPsKvo/Itb4vMA7Ve2Jyz5hlW2kcTbpMG3pD/8NZ7Nmn20ywvFtcOHG8cWbL6nS9AKwtkyWWPnl0oR8ri9FxT/aHkmCVs2f+VtpkwnTUoLSQ1aek5IrVkU0fv4SzOOQKjL2f4JASh4Kr64Ofj7ntQKooTreHmfKHPPsoCz7llfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957402; c=relaxed/simple;
	bh=WqQhFOBkmUL/RYUXFySoNVL5s6StdFQwtmsPbaAnVhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZcHzwSaE7z4ZyrqDpmVhOnofZsP9yK/v1MVFgmW+I21pH19F1iUg9KYC2Az0eVSCAnRdjPDJGI9My+PIe/W1nVetQlEdSpf0mV0bFHdJScj8JmyKp0vijIMvrQ6iCzc9OJI4iBJm8/sd2N0RmqVY0EARvYuz2beoPbs+pfK9i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yy/iOWc0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yy/iOWc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B74C4CED1;
	Wed, 19 Feb 2025 09:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957401;
	bh=WqQhFOBkmUL/RYUXFySoNVL5s6StdFQwtmsPbaAnVhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yy/iOWc0EuO4u72lwiqPig3GJcDriirbrRs7bGyQBiXBI3C3ZUvpKBHQecQxCc6sf
	 dDJ2hxZRSurwTxeN8iFgwGyUWzck22B7T5+qycUgV/WqpGG5i0xLvtFL6fKO02G586
	 s33lsQG7+fvmNJbGoCGIYTZABsi973uHf5KnbK5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 6.1 513/578] USB: cdc-acm: Fill in Renesas R-Car D3 USB Download mode quirk
Date: Wed, 19 Feb 2025 09:28:37 +0100
Message-ID: <20250219082713.163666352@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1703,13 +1703,16 @@ static const struct usb_device_id acm_id
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


