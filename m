Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208770;
	b=rbgxiGt1UmGpBWPaoucROLgQkTlP22S519JZf5p9AZJnwXirAxHeJC9U/u2D/o+nKOPU
	 UwDk9Mwyw4aEq9ddFsjhZwyyQICQQD7hgtvWVJxX5tsPiSriq4sFp5oCAxswMv9fasV65
	 m4ERmyEtbByz2ywkYPxyXHX+K0qojXM1AOy51sEoOnyvwYffv378k0FjVZfmlIl4pJc3Q
	 hyM6YBB1gcyf45H4pLgGd0eiI9qMvwv0AeELwVBCPwmhdBl11PR/PXPLpGasd5eorl3kd
	 qaRxU4/2NXUGwWP1WOT5NQj7/GuH5UmAWj96jN9C79nidxJ0OvKZdfBtOOS1+64GVSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208770;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KrD3UPzei600pq9JIpT8gHoyAxjaR0EXjFGVgvKDdmM=;
	b=TeUllvq71GzqUhnHDCVvj3AYVOSBM8aZk8eyQdundzG2qbDY3/6J4hMUyqV8MGt++DE5
	 4XRqDmN4inKlFc2pqYQLTsMG/YWX3xpuV9JdRVncx/MPdZ26/xAQYZvsGfBMax4eBOsyk
	 kobYQKUDZR3hiDaz6JRi/ZXu0aNAp5cT6ARp26IkCDxO+Dd2XDgDVbUG+nlu/Wdav71W5
	 aGIRACZvDW4VjcK+T4gDEq5KB4H0wOw10QpJj+oZK6EiGti34Yaz07wYyNMnjDe5CJOaN
	 ZurfoHJw+9LFKD5NqH08TRtLlmke5+j+/HF4eMTIwPzEmvk+YBY2txMIbzhJErC6z+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xCCbTvM1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC68606A31A;
	Wed, 28 Oct 2026 17:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xCCbTvM1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EECD1F01825;
	Wed, 28 Oct 2026 17:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208770;
	bh=KrD3UPzei600pq9JIpT8gHoyAxjaR0EXjFGVgvKDdmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xCCbTvM1VfiSRjAElAG1Ts3wTvffqKXdwUBCs7wAYa8ij4aTW6Hzg5qPO95xuFhwg
	 cC47z8A8mBk/fC0Yzft11Fo1UYB+KnRZpIB1n6qN4btzXJaWp2sNgJzTE9Z4kebiwc
	 xFDj4dmhOeuOOxUhYA7HOabpXuR3uOPPhn84rais=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.10 192/516] usb: ohci-s3c2410: disable controller wakeup on removal
Date: Wed, 28 Oct 2026 17:55:44 +0100
Message-ID: <20261028170008.050681753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -338,6 +338,7 @@ ohci_hcd_s3c2410_remove(struct platform_
 	struct usb_hcd *hcd = platform_get_drvdata(dev);
 
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 	s3c2410_stop_hc(dev);
 	usb_put_hcd(hcd);
 	return 0;


