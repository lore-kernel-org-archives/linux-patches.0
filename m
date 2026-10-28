Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208773;
	b=G38hSCSIRuLFl49UeZuvg0/+ID2lL3wLVtmsA0sLZz0rvNyQsKTlyvzh0VgPIrDEsOCy
	 6qWscqpcsLlA+AsUyMjllYWJ8QaM/bzLnbKewrxv3/8rg21AkswOqZiowuVdn1B0bf1IU
	 S4sYa0h+BUSSXbSquyfUo41f0nfcw112xvrrMAbSnFLuwrwowNhpeSvZNxjgo/VLT0cpR
	 a1sJwsu5V5cP+6+Gtpyi1XXEp3zKwlpA1Y7p6avMRYE+WQE+UreVbFKiYi3/SncqKbPSo
	 fEbW3GaUKmZS1K/vp0DqN+8JX5wO0vxBtvaQbVjlE65uQbEh7D/NfzgKIuqDbBjjFhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208773;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sPHF/fieQGvcGfuTUZLclwLoNUEA28nAWP1aTxGqnik=;
	b=EdmXEV4KMRr3WaXmRDwXoneccHLKIjVtTfE9mP870Yw2Ci8LsHWb5moV3cXqamKfMYkP
	 9nPPnZJtmczopj8/l+vt7UkLGeqvfy3LhVymz8bO6ArNxQMtdezFRMXAKEsnLeCFzKftT
	 yCiVaIL9jBdYO0g899FJ/mhkorMlWVd3H/0Od7P+L13IDd7rai3czbfMa8nzfwXXX+Aow
	 Oe6ILO6C1G4pKE1JBVg7MtE8d9pZGc9UPc2TX6eKmRUWK8zPW94Gr9DZqAmWuiWM02o+h
	 /NIbDkC68LaRnAqYcKJ28SstmxEU0xR5CefMERO3WPo+sqiZPSiU3cWc9BRxMVzXgmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qv9zua9J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB9D606A31C;
	Wed, 28 Oct 2026 17:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qv9zua9J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF461F01825;
	Wed, 28 Oct 2026 17:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208773;
	bh=sPHF/fieQGvcGfuTUZLclwLoNUEA28nAWP1aTxGqnik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qv9zua9JMFBHVkjAuenG0R/dmc4BOWF7bwl5nQKGTO4AtnLPU+yZwjTc6ddfupD3t
	 kFU+Lj2bMtK3p2FQ26al1NICJrSk6fV8hAyb7RnHlgO6DMEbe59y0aW1tvyMdtw3lG
	 cRF4N8N7f4/P+B75gfMwcldflZcpNp04BJ7wfXmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.10 193/516] usb: ohci-st: disable controller wakeup on removal
Date: Wed, 28 Oct 2026 17:55:45 +0100
Message-ID: <20261028170008.074070136@linuxfoundation.org>
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

commit 08b2ccd7eb7e41f77a04a09112ca3edcc588e3f0 upstream.

Probe enables controller wakeup after the OHCI core marks controllers with
RemoteWakeupConnected as wakeup-capable. Removal does not undo this, so the
wakeup source can remain attached after driver unbind.

Disable controller wakeup after removing the HCD.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: d115837259ad ("usb: host: ohci-st: Add OHCI driver support for ST STB devices")
Cc: stable <stable@kernel.org>
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Patrice Chotard <patrice.chotard@foss.st.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260915012011.61874-5-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-st.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/ohci-st.c
+++ b/drivers/usb/host/ohci-st.c
@@ -243,6 +243,7 @@ static int st_ohci_platform_remove(struc
 	int clk;
 
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 
 	if (pdata->power_off)
 		pdata->power_off(dev);


