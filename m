Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831851;
	b=l4+JHzIUwIcIaf2X95PoWC+ESr4bEE0lwlR6KHzM3nTQOEIz9UYGBtMJs/fiFdkRJfZg
	 3F5XzpWBMvqtz8LDk4P4D9nyyFKaHaoz9VtUaHZz3Id6BH6G0oH8E/oVGlQLumDL4JJnM
	 yZGLJQQ/KZMdX67DtgsBzfwDa/f4GAGkmywyT3TnpjUkyuJMsU2JgSHo0ObnuwbSEH16p
	 cB1EPad+7tw6DCAKLAUPomXH3aMmEd0D6T+Bplrl6tGeJmdfiYJdKQwjQrWgY4g4zW1nE
	 u/3iMVg1bAXls3LDn1DCOXwDJ9auj5X0m1HfOh1blXGUyuBUwyC5pFXIBpXSybOEE8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=enRkMAgNyN3OPanaHiYdy4JEayJJgOw9Wy0UVxgg0Uo=;
	b=cd1xZw+eJQIYOsU4u8kxF/CNPzUGdxvUAVlh9X4gmDHM/ALf99P6cjrB2qsIfcAXrltE
	 0idGpqXKkS+MsIAgZH4H8iGml00FraCwTQx3pEHArubavuWafWYFLU5n3OxwSslBSNxG7
	 CKyX+YPRn8pMm9MdPqCXGK0XeXhXIlQXaQvN/9v7w/BEkgeSdwomaSt/Go4VAqNVQK5NA
	 8iw7Hr7CMYmnKNUudolZmP6W9N7dz0xMaCEaE7ZlhV1uzeLQwAqlH23kQvVdGXVw72N0B
	 AwfPBQQ4NM/JTd22f5zifvFF7qzg+71UbV+z+bFnjZz4vFFlpwr+fcEXPKq94NnaJEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BhHCOpya;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE81606A328;
	Wed,  4 Nov 2026 22:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BhHCOpya
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7351B1F000C1;
	Wed,  4 Nov 2026 22:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831850;
	bh=enRkMAgNyN3OPanaHiYdy4JEayJJgOw9Wy0UVxgg0Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BhHCOpya6bM4esOtzNqGr2QPLC+LKYbASwtfmtwlq7E3bh4rshXOwXoJ/3yiQDmF8
	 nu3pjETevlawDq+aWMie6JFHHArzL6lq8h5A6OlOkzaga/+F5tAsi5myrA2rF4kWKt
	 nh4Jy9eWa7I+8p++qSMVr9mRhqdCVgIIfWD2Qn6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 0954/1005] HID: mcp2221: validate response report length
Date: Wed,  4 Nov 2026 16:11:27 -0500
Message-ID: <20261104211109.818814288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -858,7 +858,7 @@ static int mcp2221_raw_event(struct hid_
 	u8 *buf;
 	struct mcp2221 *mcp = hid_get_drvdata(hdev);
 
-	if (size < 4)
+	if (size < sizeof(mcp->txbuf))
 		return 0;
 
 	switch (data[0]) {


