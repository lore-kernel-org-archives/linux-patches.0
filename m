Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051935;
	b=mJGMk0VpyxHj4n+HdoSvV/FoabWU4HkEtl/26H4O4tCr07hyF8qRm6TVivHULc+NnR3t
	 daawdtOy08X2Wk3iwY1QE9hddpmzwqAksMh5EH2aGJEPz9gxLG/BGbBmuNyZgW9NQ2/RQ
	 MPwJ7Tq2YtQAOv6xd05jfZmgCzZ+xVNbL2NQA21hRhN+3a2jLSX/brZN/FrJOlFvddM0P
	 defiNvzlsjfNVgYwFEhWpho82Gz+Eo0R1x4djvHCdk/PBh09a18TT6qw2WCFQgY8R4kCa
	 3+S+2D0Scu4sak/rPL7UNEK/Un8TFNYQ1xmyBjWVbDk4NPrmh+Hgz9CDi8FjdkrlAAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t1X+zNxwgS14a4gPgbAGf/mRfnI3qtiBH75sPoXw1jM=;
	b=NB9v8vBjnIUwHSGn9J3Q7tlcNL0Ohi3i+zlLqqK+UkQQZPYYSxSFBwlVYPq/kOLcCatp
	 vXC4a12HL4Us5yBsn5xBJbP/jR0qcxPGken7DxImaucacTRf8uFJGBG26lDGBnnPa+gSC
	 8f/DOA1IuggIu2aUCo/kbihHt7Q2Z1UXXHiIQt4iOpoUDgHSNmfOSXe/WtpasHK4r5tyw
	 v2oUiyUWhzzPvvZByOqLf+KgQVqhmcfBUuTRxhaq7bXUXcRejjS8X/rz1Zu88PfXX5v8e
	 AKgFUdzleJZ23Tw+d4bklFP46D/ElnRHb7uwuU9eFdoJOWS9xW0aVEVIWIeJuZ9BESg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JpIt9zqp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A608606A338;
	Thu, 19 Nov 2026 01:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JpIt9zqp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7E11F000C4;
	Thu, 19 Nov 2026 01:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051935;
	bh=t1X+zNxwgS14a4gPgbAGf/mRfnI3qtiBH75sPoXw1jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JpIt9zqpSNN2kYAqXIXMqh1LKg40HIPEbup2awrJEBjj6bxH77KFjSyZrQOzNSNDj
	 h/AoGVhHqJ3kJwZoQxnZba1DWFcuJc7yPqbD1SC9I9/rt2bXQfd7ziL8UwR9FQjHUS
	 Qwpts7k1shHopEseFW5qIbGyqZvQGeYsfG+m4lQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.15 0385/2214] HID: roccat: ryos: reject short special reports
Date: Wed, 18 Nov 2026 15:34:21 +0100
Message-ID: <20261118150026.087523655@linuxfoundation.org>
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
@@ -186,6 +186,9 @@ static int ryos_raw_event(struct hid_dev
 			!= RYOS_USB_INTERFACE_PROTOCOL)
 		return 0;
 
+	if (size < sizeof(struct ryos_report_special))
+		return 0;
+
 	if (data[0] != RYOS_REPORT_NUMBER_SPECIAL)
 		return 0;
 


