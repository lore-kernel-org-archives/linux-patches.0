Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051911;
	b=UnrCqb6+gLyDU/7rIbOo9kAuVXiRLR9PDQBUg1RpHpOkYaxcgerwLI40N/LiNC7KG8vG
	 HStVXPjXH0EUKIUxrILMhjyEu72uoxt5VHmf9Rxo3CiMqVemsWrWFW+VPo0R3oyHyqqfW
	 sx81K/Dn0HhDYBNnuGfmmCo9eUo0R9WgY4i2owqqCuy4QJaBJVrooxg8mh573UJ+amRMI
	 E14gIP+0t5+lrM7llKYUfdN+H2GYT6uUkEcBEkVTSyccUJV9i3o1KDP0BAgwxEkSTO1dZ
	 zfUxzeY81YHgk99XBlujx2FTUCcmI3NHyvKi5z4PE6PWdV4t+keesHaMl2m/ftwMwFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051911;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fk8DHjCzur2MXVYNE2oI0bozSm7BAFSYG9McVby8zOA=;
	b=4HQyyVDKi1vylVIljjH4vWTFZaGAJb5KEBW5OQpW/Q9Hk+aOptugaTOnq8lAHfeH0HWd
	 mjJ/U3d1svBJ6P/iDpL79w3wj4UnQE9ZykzUXRv7pIko3tgT7PFs7+0nZlREP9cBVS1/3
	 jMm9aROs78pzELdvzRIaEC/JIXUiny6Mysz/1tB12uJjkdy4EB1hLvWTvyEXtPZ7T/BPA
	 57UvGUqq8uoiyY7K1xCqLhuR6s/8LQQEd9HXN9I7MZmI8zyuon5M/aLZRtXfJ2RW9aqa3
	 gkihecQInN3NDb3Ptbl3ZVO2duzBjd/y7fm281zVxHEm/1vCo1/2P8KGklvrVNIoATA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AJ7OUK36;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADCC60A260B;
	Thu, 19 Nov 2026 01:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AJ7OUK36
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0079C1F000C4;
	Thu, 19 Nov 2026 01:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051910;
	bh=Fk8DHjCzur2MXVYNE2oI0bozSm7BAFSYG9McVby8zOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJ7OUK36I1/G6BH06fkUxxYOh9qBQZi/ddIkIQEh6ruL5GYVBZ6tDsdu6qKfOeL8h
	 MFJKqMyACLQmajMTIevxzKN8V1dEYARah+zqSiBVJWkxnGa48BXuYz8Eko/HfXQxYZ
	 jnazsPUoJn74d9oi2+DX+xC2nXYe5yEc4vg+UWmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 0377/2214] HID: mcp2221: validate response report length
Date: Wed, 18 Nov 2026 15:34:13 +0100
Message-ID: <20261118150025.797564419@linuxfoundation.org>
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


