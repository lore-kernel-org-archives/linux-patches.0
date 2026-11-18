Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035544;
	b=m9i/6iS+OI8f9/ZY5KvMOcktAhJ76L22e3ZsQLdr902oC/HV6S3toyMR+0gaMeqpnnl4
	 ytSwV0XcmixP6fZAOx/we/jJdhJ2OAp4oRKSwtH5LkgSUh8bJEx3Qi+aYr1B5BqK6uQ7s
	 rhAiM/4tHHWUK5kZ9Vm44fx/rUmciAERiM41XxZXG3jdqGU2Iwm+5+PX1JfUTDDDnjWcX
	 fFWe2jofRE3ve76A1IYgpdvsd4uWyHV39/M5fdSfbwIRh8PhZhTUlIubOBicHJXUHq+If
	 Ye1oopHeKoUWcqTbNvzNXzOBlzHbf6U8w87QkV/7QVFesA7qL+Z8WGWH2I6715AoBKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0WMHidajLMqeLeUdgmogFHXWsLXeJy624btcWDNHkh0=;
	b=tJlLdkqoXlPUehr/fZAAHjJqg66OQaSAGdZAD+qh3+yUY4lViiFAnoQsAUYtH3cbCEyo
	 8yAwrZXoxl7gg8fbloUVnjpyWsoE2OwIva3vMiTOb5bYj0ENhE6Hb8P/YOk3fPoxGaRh5
	 fMVF/Vwzdj+lPYhGRksD06LXFlT6t1lFXZHh0TzwVCC34z6HnGkE/sfB+7J+zFC+6mWJC
	 R6XhPv367FJ3Ys9SY8aKYTneFh+fA2CoLSHR9vUmRwzpx2dtQzCPkwloZT1jt/IvAsxNG
	 MfO3IrEoQaG3IAFXhkM095Mbrw4j9BB1sSB3HeiyOG/hCXF8zXB6VYQpmUue2jIWm4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L6BVXOF1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4E1606A320;
	Wed, 18 Nov 2026 20:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L6BVXOF1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737631F000C4;
	Wed, 18 Nov 2026 20:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035544;
	bh=0WMHidajLMqeLeUdgmogFHXWsLXeJy624btcWDNHkh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L6BVXOF1u+UFyn4tUGwdyCyCp7UU4/e3VZUdw81RcyMiVhnTZu843LEoVJ5PsYKaW
	 TwOoJISTJiNoMDp8OR5W6K3TlY07BOrhoGC+rHIvsrkVRM4gHbC7rvmt5mD5+KCV5U
	 JTk8xMrivsAI2iei9+3g25h0YnzaU+c5BzAT+RSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.6 0740/3318] HID: roccat: ryos: reject short special reports
Date: Wed, 18 Nov 2026 15:22:42 +0100
Message-ID: <20261118150340.789486320@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit 02f3607d0beb82e76481568bf631235e6a319b47 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It reads the report number without checking the received length
and passes matching data to roccat_report_event(), which copies a complete
struct ryos_report_special.  A truncated report can therefore cause an
out-of-bounds read and expose adjacent data through the Roccat character
device.

Require a complete special report before inspecting or forwarding it.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: 6f3a19360545 ("HID: roccat: add support for Ryos MK keyboards")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-ryos.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-ryos.c
+++ b/drivers/hid/hid-roccat-ryos.c
@@ -189,6 +189,9 @@ static int ryos_raw_event(struct hid_dev
 			!= RYOS_USB_INTERFACE_PROTOCOL)
 		return 0;
 
+	if (size < sizeof(struct ryos_report_special))
+		return 0;
+
 	if (data[0] != RYOS_REPORT_NUMBER_SPECIAL)
 		return 0;
 


