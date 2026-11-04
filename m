Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829169;
	b=aYkEKOcfj14CGAT2dkbmWJp6rzGO+txQtgR5J0/onlLDM07f6XHwkzRUiAbgam2durSI
	 QcVWRo7ljW5t+znHT9+ohdAkrt7vM3Cmu6lEyO2pl+c+ZwClvzZS3du0Z2+h8B9vnH7l5
	 hQxWi15pYtRmj7V83iwscba6TGW6NWSpx5mH3zw1JqlBkRKpY9/OC9fqbUaomPFsJK+J7
	 0ZnN1Qqx4Pe6FjEdHbyFFbUnFb+HGQqTCAW0YHBRaI42tN6T4pTtKnurMN2+8MtHjSsIc
	 f6ZLKMXNUqGdJ7wkE6fiG5lsguslj1tF40kt64c/mX7eMANt07no67al9sHEJIo9hcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/0VmOM6CMAPgNcgx7SwHNI2IvYV+G7+LL9eah+s8Oew=;
	b=ufVOOLzsqJKbkscpLQIoj3UWyku9FEd2MZ2GiAA+CqSVR11BI6GvgUFT0tPvTYg+lGA7
	 6M+NQcOrBpoNs7qgQOo1+mmNJs2qbOx82cX7oylZmH72erKDkqvWiAAkdVRp/jZZyTsWH
	 9v66pQebJB2+sn0QP/YqXNE9WvHs8YnnVll7I0cAMeuc+K+bk9z9BUAze6wZXn0JF8uMw
	 YA8fYEXlfGg0oNnLgQn+EJX7DHvuQMB6cuuG7bGln6EUH09L3irDHHwwSd9WIWwhT9gMt
	 I6hvJGHMBBSpdMS1YUvksRX6QaZdmBjNHXRYSiDngMpxbi7vWKOXgewkXE/aQdcy6ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GzZdxMpE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6FC60709A4;
	Wed,  4 Nov 2026 21:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GzZdxMpE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62D01F000C1;
	Wed,  4 Nov 2026 21:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829168;
	bh=/0VmOM6CMAPgNcgx7SwHNI2IvYV+G7+LL9eah+s8Oew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GzZdxMpEoTHaRMGCf6FHCTpvI0Ww+xh8g0JGXcoxufOdgb9ZD0A1mfYYewRw4u3rL
	 A8yfL9bHkUbOuTdZn6VjFdl1YtfZppY4T1kJjsjXVNkqavON3gP3Qx6iPKCQXIvMoO
	 akGnchBsRKCeMR+GZ+fpwYEc58LrmELWuxPfxheo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 490/547] HID: cp2112: validate response report lengths
Date: Wed,  4 Nov 2026 16:11:14 -0500
Message-ID: <20261104211052.295399839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1430,6 +1430,9 @@ static int cp2112_raw_event(struct hid_d
 
 	switch (data[0]) {
 	case CP2112_TRANSFER_STATUS_RESPONSE:
+		if (size < sizeof(*xfer))
+			return 0;
+
 		hid_dbg(hdev, "xfer status: %02x %02x %04x %04x\n",
 			xfer->status0, xfer->status1,
 			be16_to_cpu(xfer->retries), be16_to_cpu(xfer->length));
@@ -1463,11 +1466,16 @@ static int cp2112_raw_event(struct hid_d
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
@@ -1494,4 +1502,3 @@ module_hid_driver(cp2112_driver);
 MODULE_DESCRIPTION("Silicon Labs HID USB to SMBus master bridge");
 MODULE_AUTHOR("David Barksdale <dbarksdale@uplogix.com>");
 MODULE_LICENSE("GPL");
-


