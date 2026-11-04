Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831845;
	b=ODlBbpML1DjDeLor1AXTyEwCWefKmdvL8JDF2TIMytgzZ22IWIJTsK7J/KdcAY2PSRa/
	 fKsBqlfrXOLcCAr3EGIwskdcBP+i5YDFRwiy5LHUuCFOkCT+NkClg4iD2ToHOxBOACRia
	 nQlisk0p95UXl4onQe2mj2iaetzkHuzd8NFCC6oFo1FuPhcoOsmzzdQVkGUVZsB9hnVij
	 2fjcwGATijHYhjg/nPpAF0XWWMewyNXTN7QzWGIu9MlfadhW4cmvYuTntc9D+//WbHVTm
	 UIFAuzzKJlf857mSqAPTKwFooBaVpdC4WeXHMd64vy9IfubpPm3+O8pMj2d9Vnh2ZKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831845;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9htqhjVUHtjrDl/nvuc41MlslEQBI16lupbEM0oN+oY=;
	b=w8c11Rn2F/kNWMRw66DAMIDnDxGCT2C8/tbMPVPOjr8+j5NPciirD/P9evdMK65By3R4
	 NOpFZ49eq66BJC2UKsekK98Xqy7aP0L1lXE2geyRr+hZfFLZy/CVB8CvhcbRRiJ29Ecl2
	 fMT+G3UtptyjcN+Pnc3hLKObGZpS0hroVmLqO4Yn5JytEjCSnm6Mk7dYnfpgkZcI5e1a8
	 D9Fa2KghJ8DeMsEVzgTNtXutakZw+6wLZu+KFNLs0wE7SeWLSOmmGoWf9aM3kCPAjnA4h
	 BMDhBH8wAHPyR+kV45Uq4ADjx4QIjvrhS8YF9vmFc7zRkc5F3NxGGZiA9Ifk9Z/JU1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KZEy4qcm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BC6606A32E;
	Wed,  4 Nov 2026 22:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KZEy4qcm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B4D1F000C1;
	Wed,  4 Nov 2026 22:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831844;
	bh=9htqhjVUHtjrDl/nvuc41MlslEQBI16lupbEM0oN+oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KZEy4qcmCDAuxTcdIrYRDBlcYX8zSQX0YDWhH0q0yMZrUpkicA5mcIdLfzJ/XyAQ4
	 8MzuBjMXP04ZD2pvSm1EyGxQDkuKAnn1OJBgLGmqH37tA+COfeegh9c7ec8chi5tUS
	 HmtLfjafbCbTPXfC2D6migNeReLKyjCoAG/WkhDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 0950/1005] HID: cp2112: validate response report lengths
Date: Wed,  4 Nov 2026 16:11:23 -0500
Message-ID: <20261104211109.716655163@linuxfoundation.org>
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
@@ -1389,6 +1389,9 @@ static int cp2112_raw_event(struct hid_d
 
 	switch (data[0]) {
 	case CP2112_TRANSFER_STATUS_RESPONSE:
+		if (size < sizeof(*xfer))
+			return 0;
+
 		hid_dbg(hdev, "xfer status: %02x %02x %04x %04x\n",
 			xfer->status0, xfer->status1,
 			be16_to_cpu(xfer->retries), be16_to_cpu(xfer->length));
@@ -1422,11 +1425,16 @@ static int cp2112_raw_event(struct hid_d
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
@@ -1453,4 +1461,3 @@ module_hid_driver(cp2112_driver);
 MODULE_DESCRIPTION("Silicon Labs HID USB to SMBus master bridge");
 MODULE_AUTHOR("David Barksdale <dbarksdale@uplogix.com>");
 MODULE_LICENSE("GPL");
-


