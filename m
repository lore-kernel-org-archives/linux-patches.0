Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831850;
	b=E9yglQtmTcOACWmciwOHxFbb0T5wLsgeYdZUn8JPBLlazy73P7yZkIuqXX2jj7QKK4QP
	 HgeidAQMY/vgHvSvgaaSvpO9dvhm8HJG7ZezX8Ymf1+dHCf5+3nC4AFD1VI99hcNaWwa1
	 yx8zt0Mf8wqW2ikiEXPeXMX4n9HmumgYbeRQqeXOMs9qQnnPpL1Z8ONNWxg4y06dIiWVR
	 IfMH7pBgSbOR/NqKI8TtZTRTb6bvSerHHkYeWFGQ4yw8qaPrMyBVfrjKEjQBVNOO31dxE
	 7fTVhaR6+WhzHSjFrmym9Z5HlFiwUVpBUhJjmhGbZC/BxuNNNfGLPxM88n9a6MLvD1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=77LgI4Uw2XuLJ6OYq2iljOTp1Ed1lQjj+P33PqJJAZQ=;
	b=kKq2gRwLwhBcZU0uy7iPkm2wo+u0Or72TjJKOSJavWZo3/KcUybD9J/2DTK2GB0tJZHj
	 1xcso5PrBquagUrU9CVFV9L4W+T805n/UNeYXEY9mX5nS/GjYLq+SeZPZeFqzpuJYjTuY
	 jy+LeBHKmIsaC5/F1zle9Lh5JNAlkF0VQLNNF2Safqn+oxGPgmDTpHAoD62olqsawxLVt
	 ncqjlqXn0IHowMnmuPwohIrDb2kO15QQucF718mYhMyZYxhoKjJnz09ZAbvO23DU8ryrW
	 v2Um654EZrpVnU1twMQNV62mtcU0QR1QkPKUBCZwsvaOGeNHxJ2tSBz2KQR0ZaxYDNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B3d2zSFF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A35606A328;
	Wed,  4 Nov 2026 22:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B3d2zSFF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57531F000C1;
	Wed,  4 Nov 2026 22:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831849;
	bh=77LgI4Uw2XuLJ6OYq2iljOTp1Ed1lQjj+P33PqJJAZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B3d2zSFFYidBxEE7fxq3jzF8WHE4lPB4HmREJQ8/zkOD+RUePSRbhVIEkq8myGTT+
	 1TLLDhpjAcoAwQe8ZJtUtHCr08wdQjez2DhjTjoBTo2O/NvVyzLApR6bbfDKxff2zw
	 lEy6nVvpocgWeUe0zM30XVAKks0hWYXT0P+LXiiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 0953/1005] HID: mcp2200: validate READ_ALL response length
Date: Wed,  4 Nov 2026 16:11:26 -0500
Message-ID: <20261104211109.792344037@linuxfoundation.org>
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


