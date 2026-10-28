Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210939;
	b=3QNtBMbcYJjS98qqD7uyIdxR4AD626GvuS86gpfQQapHtXw8BtxVUtfpAHIMUNlEhSj9
	 qUsOVCs3TTQ+4qolOJFJY26ErUTwdSnaGL12l7bHvg6kPTF+eivoNLNAD5r2hqcmuPfQP
	 9Gz0KDVGbSbwDtvELbZQDPwVUA6z17Tf8gzop/wk+651L6qYhbhXryEpkXgVTTASVdWQl
	 8QMgB6a9hlFNQwIQa04/jjt/ZjzEHjS8O9MdmAzECWOlY5TUPEh3FmVAGwbcxI7tWCr3+
	 R7ghG2M5sqHnP0DUMEgImP9rk8FkbjizpFQ8uisXSnvDpeyEwzA8cKttg3snil4d4aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210939;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KQcGQATbwZfhQgqXn6aUTlQZGrBeZjCY9pjpaenSrMU=;
	b=Kf/5/DGcumkf0NITaeAbt7n2ZSqVCqK3lSYoq+1gmXp4YdfHZWHsiWl+hoaz3EpxgBmg
	 BkAlbowLKZsWN8QKxwlj80NfdLyy5KYg+4MJHcVnlOtwYEsWEIIqwLmrtKCVFbXMTqTvJ
	 mcDNt0d5K0I7bJpdLus/0ijbssHQlydzUNSqk9MIA/6z4yyEr11jRLv2lm/7Qx5HNVcmW
	 C7gZrxJuia4H4cw7yyTWLMxpwAAW5r/MHrxXr6/VshX0/pMUN1qsBkUiqNKV8hQ2//CpL
	 2lbJQslN0gFZLe0wxXYngSQ8kVNs0xzX1CQ14lWb923BJ7u1GZf41Q+piVsaWeuhE2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QGj60w3S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD43606A31D;
	Wed, 28 Oct 2026 18:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QGj60w3S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7441F01825;
	Wed, 28 Oct 2026 18:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210938;
	bh=KQcGQATbwZfhQgqXn6aUTlQZGrBeZjCY9pjpaenSrMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QGj60w3SFdyFQ9wdbMNyfSboajV3780JKXqVxhQ5laR1gP+bvVGT109LfalnfR9Uv
	 O8sMex2EBDEUTXQK9njeQRzKSGmDDDxMlhelLr1uIQIEfJVInrRluAad+lQtF0F1Rz
	 kZ/itou06iDY2u/sHHh6KSB5x7FT/uZiyGapTY14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 202/571] usb: ohci-da8xx: disable controller wakeup on cleanup
Date: Wed, 28 Oct 2026 17:55:49 +0100
Message-ID: <20261028170012.799821865@linuxfoundation.org>
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


