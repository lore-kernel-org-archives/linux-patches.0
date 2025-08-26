Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A992345758;
	Tue, 26 Aug 2025 13:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215173; cv=none; b=DsiMY75HNGUKWZsESQxinAm8dEB4I/eFfyx0qUNguTrX3Q4u3Dkrydx/THyZh6hC1Xmwg2prqz0faZyo1zPob/H7sJKjBNUq5+q1k0Sv0liFSGM55tjtT+bGjCZogJIUwx3LpAMAhFuVzj/1P9w1efNeujb/Pm4WPSmCg+S8V2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215173; c=relaxed/simple;
	bh=ry4E59uLPPzOjTS33TFBw0L6S7l3pnPyPIfKPt/ChA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gT/Pgp/T2M7MDBVEEObrL2rSzgw2U3E2FutiNHzq2cjEKyd3rG3nlJatP/bbwUJRaanKEOwp2N8Jt6mvzoDnO7WwaWnuHNxgy3J5opCmVTKu1HdpVrpZS34UBv2C42uNZ7yv+IPqC1Oh2pI+61APiw8TXqexiHXCRqhNxzT4Eyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebpNoNg2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebpNoNg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92261C4CEF1;
	Tue, 26 Aug 2025 13:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215172;
	bh=ry4E59uLPPzOjTS33TFBw0L6S7l3pnPyPIfKPt/ChA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebpNoNg2XbIvOziw+vgyterBvYYSqrcr4IFr5DkR0HJmaFK4NvoEC9q3WKyIpPwnZ
	 /k8NBTSF6mNGxNeT6IMHCblbQSjdIrHGnHUwf0+zlpRrZY2p/QpWiBKGNr1P5QCAj8
	 FVWy+dwMoez98zQqb3l+1La6r8pqT3D25D9EPFUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Li <limiao@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 413/482] usb: quirks: Add DELAY_INIT quick for another SanDisk 3.2Gen1 Flash Drive
Date: Tue, 26 Aug 2025 13:11:06 +0200
Message-ID: <20250826110941.029790415@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

From: Miao Li <limiao@kylinos.cn>

commit e664036cf36480414936cd91f4cfa2179a3d8367 upstream.

Another SanDisk 3.2Gen1 Flash Drive also need DELAY_INIT quick,
or it will randomly work incorrectly on Huawei hisi platforms
when doing reboot test.

Signed-off-by: Miao Li <limiao@kylinos.cn>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20250801082728.469406-1-limiao870622@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -371,6 +371,7 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0781, 0x5591), .driver_info = USB_QUIRK_NO_LPM },
 
 	/* SanDisk Corp. SanDisk 3.2Gen1 */
+	{ USB_DEVICE(0x0781, 0x5596), .driver_info = USB_QUIRK_DELAY_INIT },
 	{ USB_DEVICE(0x0781, 0x55a3), .driver_info = USB_QUIRK_DELAY_INIT },
 
 	/* SanDisk Extreme 55AE */


