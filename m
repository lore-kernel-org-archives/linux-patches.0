Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044625;
	b=Ja1qg4uAWwQPMvNkJiq7y9cVx3x2wpIp8E6mFnnbyDu0b/tpEok9fYOKn7LPRLVDYl02
	 /vX+FJwoJmnTumM62zt94sK95kZVCWNYhMQLJoOfY97M+2MjRAMvWbpOft3Dv5MZ668Br
	 hfETQazQDLu3SRmKgNBVLgMpV5dzZjA4VwGFlZqK9Pi+UWwLJfru959cA0zEe63qrYJtK
	 lM1yigccs4WtOiiRKqbiDW8lync0GjwyCqL+vquDJYp2dyFLwsX08hXoUkKspfY0XXcnH
	 9Y/sqL7lxANT4DiPz/HkQxhBerCZYFc16+wRw1a3DCMakDatTpBSZh3HNjA35VCueGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fNA4pewBgWlpPukskJ13q9m/8ebzSQanS+toX7Dq3Kc=;
	b=2oovsVGVugGpAfMnusAwQXgjtUoT684dJS00JqTltPCxJf+OsLCtZ4EbMC6wUZYqCNoB
	 OHe87uCFYRB3PYj2uJCR//Nk8wk2SD36QMci0KpNiZz8OGGvTd74ec3gIv+olxuC1xVnr
	 7Bu138eaSOT5xCd8nTs/DEX35lx3v+qei62HLU2RDb2MhOIRYZXPmfteB9khSugkrj/GR
	 azZk+jhnNIc7jodEW7rFotfx6ukN5z30yA4u7bdmPKzIZx0/0HzWsJ6Ci4RmERGBNxpup
	 xVRup7N5QCC7Re5kvfqdRt1mm8hdSYSEpXfclIP74uZ0HUrXw5mRhMQ4GrYzPkEFrLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JNo/tw09";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856E160A2613;
	Wed, 18 Nov 2026 23:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JNo/tw09
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFFD1F000D4;
	Wed, 18 Nov 2026 23:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044625;
	bh=fNA4pewBgWlpPukskJ13q9m/8ebzSQanS+toX7Dq3Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JNo/tw09Emq4YpMZSEN7UITWpmuWHzR/VO70/AO+GX2MPh4nviSl2ptym8PKJ5DpX
	 CBJzxSd/SpvRy8Q/9FqIG8SHwJkd7oUgn0HF8jhAT+rkSYQ2+L9dTFwSoxZdZz7cpy
	 AH5+jkMk13FocF1WtK/415yOuqw5O6XMTOo46YBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 0635/2857] HID: cp2112: validate response report lengths
Date: Wed, 18 Nov 2026 15:27:49 +0100
Message-ID: <20261118150224.372428509@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1434,6 +1434,9 @@ static int cp2112_raw_event(struct hid_d
 
 	switch (data[0]) {
 	case CP2112_TRANSFER_STATUS_RESPONSE:
+		if (size < sizeof(*xfer))
+			return 0;
+
 		hid_dbg(hdev, "xfer status: %02x %02x %04x %04x\n",
 			xfer->status0, xfer->status1,
 			be16_to_cpu(xfer->retries), be16_to_cpu(xfer->length));
@@ -1467,11 +1470,16 @@ static int cp2112_raw_event(struct hid_d
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
@@ -1498,4 +1506,3 @@ module_hid_driver(cp2112_driver);
 MODULE_DESCRIPTION("Silicon Labs HID USB to SMBus master bridge");
 MODULE_AUTHOR("David Barksdale <dbarksdale@uplogix.com>");
 MODULE_LICENSE("GPL");
-


