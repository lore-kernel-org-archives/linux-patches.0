Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829175;
	b=17Xz8gyjvM/yb+6UMQcMleJxZqzcgYPlEwi7oEg3C7i3xOQKn4HuLA/Anv7RtFKyn/q2
	 EDpEGC4Rr8IN5JNIgZBegEhcakXEEn092F3aldO5Gu0bVolnDsFLZiq4/gORXpQcXhtuH
	 hEjw+bdqw/tJmIzmVG5X+di/DlboR4BBnIUUHaq+whcCF9IwaelxpMm2XOp2caB1RxhtN
	 ysCdgimNOLdhclNIeHf2vlt4/2OJnqCSHUBePDx4/7BBxherZjbVnZ5XlyOl6roYfcVXv
	 40gH+VsH1u4NP0oO4RfgDH2MejhUOlkJLWXijWK2AAcUVDYD0k+OlIMjQmtjpfjgYrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RTo2t/5Tn2tNK1oNIEzGxfImJhTEjsCpU+Qv30i8MT4=;
	b=Zc44lLSDslM2MSPAH2AzMtI6uUbaZ5Dud/mrT/v04igxcI6BKhuUtm8QPvNaU9M4ENI6
	 i/+nSYyQXHNlynW6W+zCmwNF2PlrcuhPfWAMeJ61SZP7aORCIiBOVFpMGP/Jen4TdbxJz
	 Rx61MdSON77BsExAfprS1aQyeIYYQ1YUWhxlnyqPtgvv+vimcuirw8Rfl1cAPtxgr0ivk
	 uOSJjtZ7I1CIKJz+2G6P6viHFr80dlqMpk1HAZWa+WUv4tLWYfJB4ScIG7qo/p+w/xvjr
	 pJkkqlHHJQmaSxz5wd2hXJIg2cYg1Zswk3DywbQ0g108jO7vV+bQ1whEOCOJ+1r81gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EBgPdO7T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6F660709B5;
	Wed,  4 Nov 2026 21:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EBgPdO7T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3FE1F0093A;
	Wed,  4 Nov 2026 21:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829175;
	bh=RTo2t/5Tn2tNK1oNIEzGxfImJhTEjsCpU+Qv30i8MT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EBgPdO7Tar42NTDlXUVtTYLh884nZ8o00R7xF/dXbGvUqgkCLi3MtO6mWZVhM/Ljt
	 muo8VBk0JgmwUwnEsXEV47tFfp52BXbdM1q+kxAmb0qQVEYn/qS1IHttw2H1CJmrNt
	 UIORAYDJdaMoV9ZkSHy8A9cTlYsJx8QKvcCq2JSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 493/547] HID: mcp2200: validate READ_ALL response length
Date: Wed,  4 Nov 2026 16:11:17 -0500
Message-ID: <20261104211052.381842958@linuxfoundation.org>
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
@@ -301,6 +301,11 @@ static int mcp2200_raw_event(struct hid_
 
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


