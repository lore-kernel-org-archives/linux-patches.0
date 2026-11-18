Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035505;
	b=hcmz4mWAxoUUgkzjsITVJT7iYpJLu891LXXey6kJTnACwYzhzLiVSIfFizOpRuVo04qK
	 PlsPZFd89RLRspL7eNbEBiVBZRazj5oSRiNuq3V72D8mAVAfIE/cYPMS+qDg5XV9uj17S
	 poNXsHQFToDFS9ixQAwD1TGFVLmNSmKTslyZfqrOyrVPdk161gQtmCrlGTLjQy/3S9DtT
	 rblRzIQLNtQ4f3B5rtKCokMuvm8ZRNf5ZtGKRxrWcCh1gschmVxkBXeErcRZNDX2QNM63
	 xzzwPgnOLpRJCJG9kP+VmhlrKHZveCcPtfz3UpAH8cTj2MQ6wkKqmD8jfN5bqWOzpbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n2nWKYmzuCmMnGgeybQdCjBgpOUToNkWGuny9YC4WJw=;
	b=e5NBbl+YW/iHzZX08he6bWeujtTTuIPv8mO6eNVUSv2CkJx2j1bCE0ASfGXXZwyVQNSr
	 JnEzWUobtEw/TEb4rZHNSB2Z3VgderpBMBjxO7wz01l+fdq5u0EWTZZzzeu2ewJPUI1B2
	 RUZlar1ykkJ0n0AIGMsyTnceOxgFRkFASiI+m0RTLoomdYbklP8TUU9EzGfPBP1d3lKNT
	 xgHBJ3k61cnueBYdxKml+WV8eR4Y+OQIf+XaCUGqJy03AqMD/DtZ5Ac34I7SEbqCEF0ik
	 O2rsAapkwZ0h3Zl7RIFSAGhRkC2+0t+B6RVXu3D3vtZ6mF2brVtzWOiAM6OTbUnEP2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FOHTeNMZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABAB606A31C;
	Wed, 18 Nov 2026 20:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FOHTeNMZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453981F000C4;
	Wed, 18 Nov 2026 20:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035504;
	bh=n2nWKYmzuCmMnGgeybQdCjBgpOUToNkWGuny9YC4WJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FOHTeNMZq7zTEmF5ZhlRRn8D6XdGy29Ki71lVTALYp6FECeJy2AVMCiG8dQK2GdDm
	 9d5R5kga/8yBM+yr2bllp9+IKdUAD/pvPMbGUHDXlH/4h+4MCmYIckkcRvDKe4R3Vl
	 gZ8YLRxXrd6sZ9LxCu3o7lF0dM+a81rXKYTuJ7Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 0727/3318] HID: cp2112: validate response report lengths
Date: Wed, 18 Nov 2026 15:22:29 +0100
Message-ID: <20261118150340.330203590@linuxfoundation.org>
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
@@ -1372,6 +1372,9 @@ static int cp2112_raw_event(struct hid_d
 
 	switch (data[0]) {
 	case CP2112_TRANSFER_STATUS_RESPONSE:
+		if (size < sizeof(*xfer))
+			return 0;
+
 		hid_dbg(hdev, "xfer status: %02x %02x %04x %04x\n",
 			xfer->status0, xfer->status1,
 			be16_to_cpu(xfer->retries), be16_to_cpu(xfer->length));
@@ -1405,11 +1408,16 @@ static int cp2112_raw_event(struct hid_d
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
@@ -1436,4 +1444,3 @@ module_hid_driver(cp2112_driver);
 MODULE_DESCRIPTION("Silicon Labs HID USB to SMBus master bridge");
 MODULE_AUTHOR("David Barksdale <dbarksdale@uplogix.com>");
 MODULE_LICENSE("GPL");
-


