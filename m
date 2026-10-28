Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212775;
	b=OVYUuG1zkm8+0TSiD6K/FKtz8WvsNePcgjlsD3JOV8uutJI1M6kTj0LNFQRfRyMf58ed
	 z6KQ6QRXih+fvAweA+7idClVYxdjC9toUp2iliBhoaq0tw6wB61kCKCUVaxYvKylnCgPB
	 tL2sEobgpKenoxmnzf7KeOr709yzcvKP7F4wEBwtP9NbRSW5w9KPlwDjnoZFKCRKbNQ7t
	 GCQhYsN9nvR5zXsB1TSY4NIk3JeC7QrQY8yq1BJzrqtOAG68uVv4/IqxnmSn9vz69xq/R
	 gTXM555Q3jW+ChNuNRJoskYvHfT2lMtLPDl7x/UPw3ScPcfHy6gj6g+P/fxAuNSi9eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lkoYD0e2Yuh1Y+a/xoNCCG531C6mODKZrh2GJziS/Z4=;
	b=DaOenv8YrdeByr2hYKwNpgMnJZfiLcspNKp8djMyC0oNAhEjlxT9bpBk1hOjhSu2K4/e
	 xu1+uZvuBA017Med5mkwSTp5XeEc6TkWtpcu46MGSDwZ3Hl6SD9qvJJMGYH6VLprZny6W
	 uxnrCdA0VbIylCcFeT4ctLTaJML16JT+nd1nX29u5xQ3DMPpCorETBt9iYNqNRIA7Fxqr
	 J8U/TSkjmTzvRZZyWnc3BjTUlsp7jSd9r4ZOeLNQiwW9VfC+YJgqYQmq09E68gRtWU54s
	 dDQouHGn801/M/LrP6mPn+I1rErwf7DeJmdZQYcG6Q9kDkiK7Nd0q8N3fKPEp2+nwtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mI5FJJz3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EB3606A31C;
	Wed, 28 Oct 2026 18:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mI5FJJz3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4485E1F01828;
	Wed, 28 Oct 2026 18:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212774;
	bh=lkoYD0e2Yuh1Y+a/xoNCCG531C6mODKZrh2GJziS/Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mI5FJJz3JjPUvz6M+gtxOZFU1R2vwElPG8gm+cpmT7wP32kDPK6VIICbf9+ge519T
	 J1GftYir1WpJTlhx4iE5rfkxx+1QvdcZf4gunVyMpLVatZ+APnxbDourC6k6uhETHD
	 pSjZhsxMGRliED+h2kg4gkXG7STF2hXV4uIHu7Dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.1 0272/1887] usb: ohci-da8xx: disable controller wakeup on cleanup
Date: Wed, 28 Oct 2026 17:39:28 +0100
Message-ID: <20261028170505.418404541@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 901197dd4c7dcffbf97426487d4c047555c98554 upstream.

The OHCI core marks controllers with RemoteWakeupConnected as
wakeup-capable. Probe enables wakeup, but neither removal nor a later
notifier registration failure disables it, leaving the wakeup source
attached.

Disable controller wakeup after removing the HCD on both paths.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: a6eeeb9f45b5 ("USB: Update USB default wakeup settings")
Cc: stable <stable@kernel.org>
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260915012011.61874-2-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-da8xx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/host/ohci-da8xx.c
+++ b/drivers/usb/host/ohci-da8xx.c
@@ -464,6 +464,7 @@ static int ohci_da8xx_probe(struct platf
 
 err_remove_hcd:
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 err:
 	usb_put_hcd(hcd);
 	return error;
@@ -474,6 +475,7 @@ static int ohci_da8xx_remove(struct plat
 	struct usb_hcd	*hcd = platform_get_drvdata(pdev);
 
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 	usb_put_hcd(hcd);
 
 	return 0;


