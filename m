Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051927;
	b=3bRXTw+/OyuBQbEFyYeQgyjQylR61czIGPwP0ujRxmh0iEUIMrtKODNVqpOt2CGQzfxU
	 K3woEjrq/W5NuluHN3SuX9SUiwcnCfXKevnjWJZyH7UTonW5NeIR5iXdD9b4Sfy7kPU/c
	 Zx6AQxIstvSlu9fu1IQfrk4Bti4Kw4ICR6IHkjgPEvO6y2D9H8Gl3x2Wcbr9jV8XHW5iU
	 fM7EysXbEzenMx4iNZZx6JHP60gre+0ApowhIx/jxijxG62zVkQ6lueSk6aF6A+AcEQHv
	 7ZMBW5B+XBCbvhXwZYPb/woTSh7GwLd5KDrivDFMet/RbdBZOFpHidIKEZVRQLCni5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C2dKhO/F8vtnhiOTomzK1/V0EhanD3FWzMCZvZ59iCk=;
	b=x0iPmTobj+SSNsefOvOzZ4kwtA/5hLZRZaefypUtPbzRgtViJF6YNNu69NdCnVe71+PI
	 ZuhYiFA3FUSZMkgoOWP94fBXKv3ZfBCEOp7lzsgq813yUed0xbD98C3r30IivVR9cs1Rs
	 UTQLhpzx/OflWO1ra1sLJ4UVCspeVw6ncH2VDls4Xr1VwDGDYwlu9i4ccpgyFG+RX8iBy
	 ytk+umKx0L/LeGKMAKTUJGJCS542gYq8VfAlCiszueBqKsx0e4EhlQrms4Y+b5c1GiI+S
	 ukZ1pfFG4ojfXrj7wTINz4LuYkHy7mUQcoG+P3HOVzUvnAey3JlS2wVZbYtFl97grng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pxlLzhKS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C450606A32A;
	Thu, 19 Nov 2026 01:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pxlLzhKS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAEA1F000C4;
	Thu, 19 Nov 2026 01:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051927;
	bh=C2dKhO/F8vtnhiOTomzK1/V0EhanD3FWzMCZvZ59iCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pxlLzhKSmjNygvwhZ70iDyUbOgXW9jHZnMtaymzmjGtbXD/AEvxETEYl2FqithWiP
	 qwCerghQjLbmpyqwFlcxx+cTn9H8N5f/7J9AOoZ5qsInCmJ7jxEsj9uzHdX2Ltg8NH
	 HXK0ho71Rg7iCneTI69Pa8HlHmPvlO/4YyhiqtUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.15 0382/2214] HID: roccat: konepure: reject short button reports
Date: Wed, 18 Nov 2026 15:34:18 +0100
Message-ID: <20261118150025.975876734@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

commit 1590b7c9bea0abe7a5d25dbfe06287c48c238a6f upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It reads the report number without checking the received length
and passes matching data to roccat_report_event(), which copies a complete
struct konepure_mouse_report_button.  A truncated report can therefore
cause an out-of-bounds read and expose adjacent data through the Roccat
character device.

Require a complete button report before inspecting or forwarding it.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: 8936aa31cd5f ("HID: roccat: add support for Roccat Kone Pure gaming mouse")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-konepure.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-konepure.c
+++ b/drivers/hid/hid-roccat-konepure.c
@@ -178,6 +178,9 @@ static int konepure_raw_event(struct hid
 			!= USB_INTERFACE_PROTOCOL_MOUSE)
 		return 0;
 
+	if (size < sizeof(struct konepure_mouse_report_button))
+		return 0;
+
 	if (data[0] != KONEPURE_MOUSE_REPORT_NUMBER_BUTTON)
 		return 0;
 


