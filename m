Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058066;
	b=izYrJFCYD90x/FyP1BoAQ3wuoJbYsQSUBYePK6NEX2FKzFmBq3mDWx40RIPISP1gc+Db
	 P9i4qHiYn9fICsKbuE7X3yGWxjjoDkUwvk/ZtJry47tPs5okUleaWLck4OM/3W5r6MGGg
	 QpQOzuQEPAxXzc85FK47H2DW+1W/dfC8d0pEll8sGALnn/qGLIjIBruwHTnM4rmefl201
	 i6f0gRUpXHzBs/5D4RFoIf2rVazPQ2rn95T/AwDrvk7pgoUHY7jHYvQ6Zz3D0+VTxihdW
	 fL4eZu7oOOnUBK10KqmOgCmI1GHwdqhF87+7oco5Xx23vrZtDE7OFkL8vmVljY9x5NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uotTabVlF+HMaho4z2U+9duE06MckCTwIDbMa/rs438=;
	b=UDmQAnQRLmtR2s0bcA2OpMDawiVuO6S2XTiTjdkrJdUNOswHcESRAWFckGCf7fja7A73
	 SvJmOS/hfL28qgs6Q/p2n0H3UXafRxxLO0GZcPqv6s4SdsY8OueDQhxG+Kv6PqaeR6ezy
	 cVtnkKPLz3gKWvdkDK2C9RtsH1Dp6KkH81buS0TF0TNy0SK93V3ORVsfiDhAt18hECc1q
	 Qhup7gwV2T5R8B65a5ku0F3bdYFCBlMynibZVrBLVKBnH6JdyF4qbti0nQH6t7Qz49vfZ
	 TkGurObwxfd4+UkByhrporHh6+TasckQUfZokXl8fglFVu5qTRr5IigTo69NqXHhK4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="R/+bYPhd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AB2606A334;
	Thu, 19 Nov 2026 03:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R/+bYPhd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163C81F000C4;
	Thu, 19 Nov 2026 03:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058066;
	bh=uotTabVlF+HMaho4z2U+9duE06MckCTwIDbMa/rs438=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R/+bYPhdOWrPiBh4g9brovVLOKcgGAY//+L91ZEi6+mBhwltWaK8Fo/MRkPEYrrvT
	 9HijswxTwV87bPeGeiuxqQ+D6GYExz8YCd6SVaEXz3klnmT5vhPVyjZpWAYHk1RPuC
	 ERUAQ7U6KrBFuxUCWOwxlR09EPzmCZGZyJsy0XwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.10 0312/1848] HID: mcp2221: validate response report length
Date: Wed, 18 Nov 2026 15:39:10 +0100
Message-ID: <20261118145925.313724052@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

commit 1ae40774d386b7a51e4799200106429a7e14e8ec upstream.

MCP2221 responses are 64-byte reports, but mcp2221_raw_event() currently
accepts any report of at least four bytes.  Several response handlers read
far beyond that minimum.  In particular, the I2C status response reads
offset 20 and copies ADC samples starting at offset 50.  Other GPIO, SRAM,
and flash response handlers also access fixed offsets beyond byte three.

The HID core invokes raw_event callbacks before validating the report
length, so a truncated response can cause an out-of-bounds read.  Require a
complete protocol report before dispatching any response handler.

Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw_event length validation to hid-asus.

Fixes: 67a95c21463d ("HID: mcp2221: add usb to i2c-smbus host bridge")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-mcp2221.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -739,7 +739,7 @@ static int mcp2221_raw_event(struct hid_
 	u8 *buf;
 	struct mcp2221 *mcp = hid_get_drvdata(hdev);
 
-	if (size < 4)
+	if (size < sizeof(mcp->txbuf))
 		return 0;
 
 	switch (data[0]) {


