Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208747;
	b=c86Dv9HY0fHXBifi8UzmL4yw/np+kQCHmrU8YwAbU4Fbb7YoUO1SY9H0RwARaR1BhrV9
	 RkGz+4xZ+e7/glawl6Xt45pUXVA4+WTtAcEgJVLUrc3LBSTBk3+SbxN8Ob2xA/ojmrWU6
	 ZkFXVpwx6HC3qvXp1AaUXtXqEuybbsGPP5ORaHVbU5I1CCkYtazk2Pn1eoDEgOZQcNxfg
	 ViXxmkdCdBOMQYS4IpcFB44GsDnRxXl+CMLcnDA00giFqC/hzwcyrXJd5AQBM9lJn3adT
	 0amgHKEn9ZUrpwYQe2GTqtCLB+qv6IRdDcerAuh8TwyZujAk6HSVpXbRJ2z8qa8XIpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208747;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IEjvQ3zxMmzihCc3R+E9Ss1ZXXWXIyXSciI/L5UHNLI=;
	b=439GEJyd1xC9n7KE0Skd5S6EPkjn3fzGVOPTN4QzVjfSoZ5OUw30D2sfVWxrRgUhAd2S
	 L/K8kV2UyiBdhQ0h8lmOAlSdMg21ZEp5kHsJF9jRx3cfY06d4twwDM1JcsAC/wQ3GmVgd
	 NJo+B0j+uh8FQyvfIoAlaRgDnnyXsh5WWby2012QQWLBSyCX9KtB/SU1SlXw50JxRnOAc
	 1FhHg7ITh97VrS5f+JmAx7fyj4XXyaGUtTGkfQWGGutNl1OGmhP0bUgmseEiIzY2vJdHo
	 ev2HO0bkf1UJE0kLCUEZQLBwDSFEZ/hTcb6O1sy9QdUN9lq8unWv4Fg0dSAiSrG6krA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lcDfwnC+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A051D606A31A;
	Wed, 28 Oct 2026 17:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lcDfwnC+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A771F01825;
	Wed, 28 Oct 2026 17:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208747;
	bh=IEjvQ3zxMmzihCc3R+E9Ss1ZXXWXIyXSciI/L5UHNLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lcDfwnC+cj8bzWHb8+MoaIDVgogD9QaldEL6XYEuTiqAc2VxDIbnJ481TtQ+GVttt
	 fNI947j9sbH1W3GWD065aV24t4zPUOQJkdvcYbu6u4XHbVf1HswC+ubi1XbYEiu1oi
	 eA3W1CKoWvEjNTp4zJ5qAbh20H1EmNxlKXHspJAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.10 191/516] usb: ohci-da8xx: disable controller wakeup on cleanup
Date: Wed, 28 Oct 2026 17:55:43 +0100
Message-ID: <20261028170008.027510265@linuxfoundation.org>
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


