Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052031;
	b=Qp8cS9wF9J4DrViE1ZZBm4JqAWpqcjkf/XXuVioHqwSPJgi097G3k+LisD+FP9O8P41b
	 wFne6pDXni0QZbuKh9zIdmYZ/30JA0sz0y5jiavRQ94Bbh+tNVDcMuZCbeevFxGKszyTx
	 f8V6KBti56+P1bicEDIOBvd/kO3Xm5R76gOzbfFMSKWlqsb4PxG2/tRQqpqiqkqYXhZae
	 QBubk7XbvyOk9vPrn4O4q40an9viqXwhj/Lug2Om+F1grtYuxN0GphwmnG6zmjpbZlf1i
	 ZQMBrliQXKm1r7fgR34/yKLdZkvGDtOJcjaLf/jF9GatZZl5VfuiFlSHPxNfhRSPEDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3naa4x6Iw9az5zINxAfnT90P2FLHj3TGVDpFT6rdq74=;
	b=mJCdJ+EBF4IDTfwAdAA3FNZytYoz40wHew9ez+2CNTEug2WS+73MdfnVUFfZK/Oh5Li+
	 fHz4ZuJtQjTzfKpJrIAfwid52HgJEJTFKsV6sS5/pbLl5srOY9Dwuw7bCvVnc4GuIouct
	 r5qtGFQ5vudmodlhvJJwo4G+cHe4D/wLYN7LW1Hxze0cxvwLykfyr/KMuoHxld9+rCWwt
	 SPkuVYvz9SnA14Nj7skBTGCckLEBb0wjC3xRaCYla+JK1k58vL2s28hTNsgL0I1UvSHA3
	 I08oE+/sz6oDlbo2XKvqhrh9vy/mRijHAw5F+fTc04PJ4w2yQ2C22dG/QbEbKEqiBNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dvzse8yQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCA1606A320;
	Thu, 19 Nov 2026 01:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dvzse8yQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A8D1F000C4;
	Thu, 19 Nov 2026 01:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052030;
	bh=3naa4x6Iw9az5zINxAfnT90P2FLHj3TGVDpFT6rdq74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dvzse8yQHf0NN/XUH0z9/OarFSgFHviHc/ukFMDbmbZqYUevZkJqRsTvNRQn76PJR
	 RLyhccmwx9wk6H/w8Fq2X5MdYWHs/kkXs+dftSUjVpaoNdRTjFyQULm987aF+CBRiP
	 VKm20GvR+BVG1KPGKT7UwDfYKCLciSnaRg+sUlKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 0369/2214] HID: zydacron: validate key report length
Date: Wed, 18 Nov 2026 15:34:05 +0100
Message-ID: <20261118150025.488938066@linuxfoundation.org>
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

commit 9932c9af185f8586e883d44ca562c12f4487c762 upstream.

The HID core invokes raw_event callbacks before validating the report
length.  zc_raw_event() verifies the report ID in byte zero and then reads
the key code from byte one for report IDs 0x02 and 0x03 without checking
that the second byte is present.

A one-byte report reproduced the issue under KASAN:

  BUG: KASAN: slab-out-of-bounds in zc_raw_event+0x54c/0x580
  Read of size 1 by task hidtrigger/93
  Call Trace:
   zc_raw_event+0x54c/0x580
   __hid_input_report+0x2ef/0x3a0
   inject_store+0x479/0x490 [faketrans]

Require both the report ID and key code before processing the report.

Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw_event length validation to hid-asus.

Fixes: d0742abaa1c3 ("HID: add omitted hid-zydacron.c file")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-zydacron.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-zydacron.c
+++ b/drivers/hid/hid-zydacron.c
@@ -114,6 +114,9 @@ static int zc_raw_event(struct hid_devic
 	unsigned key;
 	unsigned short index;
 
+	if (size < 2)
+		return 0;
+
 	if (report->id == data[0] && (hdev->claimed & HID_CLAIMED_INPUT)) {
 
 		/* break keys */


