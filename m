Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210942;
	b=JugP/jb/j1Cyi3GRabe/NWtTfRYuE3R2F1+tjHwc7Rnv7/kxYREecBFauW03zEoTUbz+
	 dWseyUZ2G4HEW0r6Pt9vmnrK1BpJqKuychusRYtIffw2ajRXygyWB9rvZTknyq+bP4Mju
	 DQVLSFIwa2n92BEunxI0lEGbQ526CkGqQ8IbToNs4i+F+VIAKU/o0IrNb/cl1w96wpzGV
	 anmLt9kWU1h21tVShsItjaz4PZ38pc1XjZ4QR2gwLzqHgsBM7+IDzxLNEIJbgEO6hDgFM
	 sHazK5HbZiiFH6pG6rEI5mRucgf1CHmT4q9xQL7gbr7lyijAKhyfx+i+Z/ZJyfU+6ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210942;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=18+6EgcszOT0ceL610dwxRRG2rua1ht+zT8fdQz8k20=;
	b=wHQ4JyrwCdpyqWwnPaKZejCHiIimXx2iUckWpVfVjvWxkbrTi700yZPINxKCvu35qQkt
	 fNT334aykQ5UTEVyHmQupW040XZbkj70YIYjaj8b3vlDUPSEhPgwv7f4UTMLNR8abSE56
	 6CqKxTr9kWDA2U9D0IFV9590Vdtjs23BeCb6cJE9VopmivohYOTz0iGSvFboZtybBqZ0h
	 if4ZpQ/khYX3cNSCI6IPdH/HyRTnXx/KlHac2ySoPH6SyMLb+x0wuCr7G/XFziTEJjZ+U
	 zYywWcg0vpzpmn0BZiMIwp+edW08C1Vcaf+HC6ypUS5h0XrYVkD0TUCNwPzn0pa3G/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xHEksX3q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD842606A31D;
	Wed, 28 Oct 2026 18:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xHEksX3q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3842A1F01825;
	Wed, 28 Oct 2026 18:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210941;
	bh=18+6EgcszOT0ceL610dwxRRG2rua1ht+zT8fdQz8k20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xHEksX3q9nPQh6hxm2ntJTscwsTN1eX6C4SYfsMHVPVdquprRO/e3CBqr8e/5Em40
	 tBXlq2nbMqFiNyKsYUTLDtxdw1pMKCEzH7kFxZrLX6yzdc9YPtsZ/YerTIhIcyvHVg
	 Km8yo7ubFU++sUHZY6WYdP4YVa4B25zazMhygXZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 203/571] usb: ohci-s3c2410: disable controller wakeup on removal
Date: Wed, 28 Oct 2026 17:55:50 +0100
Message-ID: <20261028170012.823650959@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 8dd8451c527e2a723bca20da5a6d724b8592551f upstream.

Probe enables controller wakeup after the OHCI core marks controllers with
RemoteWakeupConnected as wakeup-capable. Removal does not undo this, so the
wakeup source can remain attached after driver unbind.

Disable controller wakeup after removing the HCD.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: a6eeeb9f45b5 ("USB: Update USB default wakeup settings")
Cc: stable <stable@kernel.org>
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260915012011.61874-3-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-s3c2410.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/ohci-s3c2410.c
+++ b/drivers/usb/host/ohci-s3c2410.c
@@ -337,6 +337,7 @@ ohci_hcd_s3c2410_remove(struct platform_
 	struct usb_hcd *hcd = platform_get_drvdata(dev);
 
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 	s3c2410_stop_hc(dev);
 	usb_put_hcd(hcd);
 	return 0;


