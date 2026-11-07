Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061779;
	b=O0KRC06MdBcV669DfG4bGKCzAmMo1Fgt6wEavdqXxuFy58IO2GretYaKWprA6YoNOES2
	 GwNTZwn8hYnKsY0ivkYZpVvyTUle6FnNP196mZ/90AVJQvCowiG8PlpriHdBWhUoXj5SY
	 RwdCBTdeJaUNBvRTPBLjd+hDX0yuLFfReC1XO/yO3/Vwit3zA/8+UuVVSKxAryF7t4I/0
	 9RPjU9BeKjtBqJOz9c54ur72qcsABGorCMLLqYEPdig6XLokxogeioGRGr/E4be+rayBg
	 ROlxp6zS2+sag07W5Z7Lw+MCgoE1CJm0WIcuEjR3HOP3QZheIuGdp9avFJ8/pf0fn+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RgUEcgfFwrSkX6hRvgN3W/sMYQfw4XvQpTtNipfGG8Y=;
	b=yuvpjlKx25oBWmSEuO5MFBhiPYajsAAPsWzEXinogk3avL8gQzqXb0FzaQTM7aoYl9Lk
	 Exw6UzSjQspOGCX2aZspimyX+uF6qWTYoFUo1QdB78umTP5kvMsahVlHyUKdnQnd4UV/j
	 S9QB4takQY4QKSpi1yLERHqLNctT23gGbPU+6ZyuHCeXU1FwrzO9MkvdsP9MnxmISMtkw
	 34MIx5rbChQ5j1omL+qsCrM4mSApoU5fJ3x0yS3YVtErJJekJAip+wrW2+meCURzvzAsG
	 PYMZ4WGhBNZIkkZrcR1WLGDhA9LEH7tsFwAzX+M8zUaSYsR+TC32i/MoUUDi2qNvYIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z+H5shgY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4681B606A326;
	Sat,  7 Nov 2026 14:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z+H5shgY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA861F0089F;
	Sat,  7 Nov 2026 14:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061779;
	bh=RgUEcgfFwrSkX6hRvgN3W/sMYQfw4XvQpTtNipfGG8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+H5shgYKxYjKWXhpM9yMBPGSrEk8lI5UGRtsWWsJ4J/8Xb2hsD4ZBFGmxwH+B8lH
	 YGjo9y6cCxPicUuBjWevRgmJtkZ+1c6ymdvlX5kfDFGR9IeEivXQ2f+nD3VVVmkEUI
	 ef+F22MrZXsKkdra3x2uXQHmyx4q5qHQQV7oIyi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 0811/1536] HID: cp2112: validate response report lengths
Date: Sat,  7 Nov 2026 08:47:07 -0500
Message-ID: <20261107135020.325757913@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit fc54e71a063c0dcc4bceba6d0f71805a9b84082d upstream.

The HID core invokes raw_event callbacks before validating the report
length.  cp2112_raw_event() reads every field of a transfer status response
without checking size.  For a data response, it reads the length at offset
two and copies that many bytes from offset three, again without ensuring
that the input report contains them.

Require a complete transfer status structure.  For data responses, first
require the header and then ensure the clamped payload length fits in the
received report before copying it.

Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw_event length validation to hid-asus.

Fixes: e932d8178667 ("HID: add hid-cp2112 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-cp2112.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -1369,6 +1369,9 @@ static int cp2112_raw_event(struct hid_d
 
 	switch (data[0]) {
 	case CP2112_TRANSFER_STATUS_RESPONSE:
+		if (size < sizeof(*xfer))
+			return 0;
+
 		hid_dbg(hdev, "xfer status: %02x %02x %04x %04x\n",
 			xfer->status0, xfer->status1,
 			be16_to_cpu(xfer->retries), be16_to_cpu(xfer->length));
@@ -1402,11 +1405,16 @@ static int cp2112_raw_event(struct hid_d
 		atomic_set(&dev->xfer_avail, 1);
 		break;
 	case CP2112_DATA_READ_RESPONSE:
+		if (size < 3)
+			return 0;
+
 		hid_dbg(hdev, "read response: %02x %02x\n", data[1], data[2]);
 
 		dev->read_length = data[2];
 		if (dev->read_length > sizeof(dev->read_data))
 			dev->read_length = sizeof(dev->read_data);
+		if (dev->read_length > size - 3)
+			return 0;
 
 		memcpy(dev->read_data, &data[3], dev->read_length);
 		atomic_set(&dev->read_avail, 1);
@@ -1433,4 +1441,3 @@ module_hid_driver(cp2112_driver);
 MODULE_DESCRIPTION("Silicon Labs HID USB to SMBus master bridge");
 MODULE_AUTHOR("David Barksdale <dbarksdale@uplogix.com>");
 MODULE_LICENSE("GPL");
-


