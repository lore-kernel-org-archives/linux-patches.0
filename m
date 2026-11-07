Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061784;
	b=fjUaIwjIOl1sc0rl0MP52xhICqM4MjblosUO/yAevDtxSxeZdFe4dNK/QWtoXTwQZBxn
	 i29YxEHuhUEpQaeG6/8alGejSnJIsD5VQxe4QVzDpj0AYIbsreL37SlINX7QR+gWftCjb
	 pJ/a4It3ML25eL9YnVzYeG8jBLMnJ+AY6HkgI7ehOumsBuSMrdN5odrH4UeBlxRFCtURv
	 YOGxM+xHoUSd5cY3IT7MTwhEX5lyVGaIxBZtfJpqcQUe0MSwMu6HYj5RiEwwJW1km7xKe
	 4aLHYi5LW1wpMddMtEJMlsNtVUvjanCg5pMQZR3LfmPxRg7wsAcb4sKyAp6dSQY1kIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061784;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NfjAWgGrBiMR+ipFDU7CPp4hUVIRtL0U+6lvWz9+za0=;
	b=Y4PUBehzq+Ps2gRMgu0CBTbDUqzgeFdEjHLylNMoCUu/KcUqEldX9zC2mEnVibdJXPlS
	 4BXMQKhk13DM8Gw7LPaFUsqie8mGV58Cc7dxud3OiunM39EHmid8AgbguSqB8YrhuElSa
	 aILPoyEz4kriE1LEx+mfKFU/EGbmWn0oYxSOawUwgfJgt0IaCRDp1BpkntnADEVY26nc4
	 D0LrGAZ2tvgi+QnQ+UENWYAr4pfLXsdlWH91cBNcpBkp4ErtX/UrCi5JHm2NgTDllGRjE
	 68BhLKOa9S6rvOyBjxkfEGC2910NoMNQM77auAQkELobFlJxmzOIdXR7TQcV9NFGhDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kOAWpX/b";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2591F606A32C;
	Sat,  7 Nov 2026 14:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kOAWpX/b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80E41F0089F;
	Sat,  7 Nov 2026 14:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061784;
	bh=NfjAWgGrBiMR+ipFDU7CPp4hUVIRtL0U+6lvWz9+za0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kOAWpX/bLBiALg+EkXRSTXEhB8K4nZB01sD8zkolI+WAd+qGoNcvYI4AUPBupGqnk
	 +inVHx03uCQEoMYISbYli/Pe8Zh5+puxsChFQE/q32AV5DVV5AAqBRQ80i8q+ylUUq
	 gAx08KmBsHVUThScTVUvJRyMLyjexFahVAsnCrKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 0814/1536] HID: mcp2200: validate READ_ALL response length
Date: Sat,  7 Nov 2026 08:47:10 -0500
Message-ID: <20261107135020.406788481@linuxfoundation.org>
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

commit 26ce0e6bf0b27fc6a2f490f38555dfd0a27c9605 upstream.

The HID core invokes raw_event callbacks before validating the report
length.  mcp2200_raw_event() casts a READ_ALL response to struct
mcp_read_all_resp and reads fields through offset ten without checking that
the response contains the structure.

A one-byte READ_ALL response reproduced the issue under KASAN:

  BUG: KASAN: slab-out-of-bounds in mcp2200_raw_event+0x24b/0x3a0
  Read of size 1 by task hidtrigger/89
  Call Trace:
   mcp2200_raw_event+0x24b/0x3a0
   kasan_report+0x139/0x170

Reject an incomplete READ_ALL response with a protocol error before reading
its fields.  The common completion path then wakes the command waiter with
the error instead of leaving it to time out.

Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw_event length validation to hid-asus.

Fixes: 740329d7120f ("HID: mcp2200: added driver for GPIOs of MCP2200")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-mcp2200.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hid/hid-mcp2200.c
+++ b/drivers/hid/hid-mcp2200.c
@@ -296,6 +296,11 @@ static int mcp2200_raw_event(struct hid_
 
 	switch (data[0]) {
 	case READ_ALL:
+		if (size < sizeof(*all_resp)) {
+			mcp->status = -EPROTO;
+			break;
+		}
+
 		all_resp = (struct mcp_read_all_resp *) data;
 		mcp->status = 0;
 		mcp->gpio_inval = all_resp->io_port_val_bmap;


