Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216154;
	b=ClSkDJ3e3GdMAUtBcPW4De2tcH0fbWLIjZtqoicF8SWunSj8C2y91EzxVPc+w99ZZyXD
	 +7zr6/0Mp/HsCaFcZIhrVRnL253ZuHIFg3D9hWnasCwQx/hlX737H4FAktYBVI0z9016y
	 hKlEKuQMCnuWv62lyQhlgmGkCkdZR0uGkOi6NT6MAewwHnmJh++vQU+0efgOk0OTyp6+q
	 mIlovyShrExi9boCiNjhzOUrAb7BIvEFaw7qaubbG5SX1ivTDcQyUXcYv3McW/jGNvuDX
	 cm8L8w5yInj7JD899lll0sdBk8OZfeprT382LR8On6DGomJRZ55bOw27VEF2amQLGFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=D0Xgjpv4YyGmasw8l6SF5/vMWOC8aNmazfevvSSUtSQ=;
	b=mAp3U8gktfPIFp/VfYVXeb8eTO9d3x/ObSgV6zjvu2/BvYieIjGz2lEtS1m5BPvwtoKe
	 pzZR7y+xKU7LlAP74QWRknbqY4jIJCxRui7IJDXO+FNh6JV4oNMLXNXzvSNdY/eMJASZ3
	 6UVNfJ0rcZvdnzprJkcUQmdFQZls7lHSJ8LZzQ2rQqRCG06yCvMijpCfA4M/slN7VHatw
	 cVUbP6HqnTE25rocpgU2SVrkRv6nt8xq/CK9+bRFZxPhxcHbSZfeEscV3li+DU3DrDlb6
	 prAxHMm2+LzgkxXE2Cifvlq1Z2EgAWKEz0T3yXkI/K6aviH25qoLQuaqvjJbY9vPVxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QVtpKV1e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B776C606A31A;
	Wed, 28 Oct 2026 19:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QVtpKV1e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF351F01825;
	Wed, 28 Oct 2026 19:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216153;
	bh=D0Xgjpv4YyGmasw8l6SF5/vMWOC8aNmazfevvSSUtSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QVtpKV1e2s5qEknlbGURztN75Laa8CZ6NLJDvFP7H6RmVBdUiQNaaV8fYPISNMvjY
	 8qLo1GwEyg9goA/BM7OjtpE2dnKVRevZuLC1q612KlqQmvs9uA07drTFDeWXg4GEs/
	 2EkSZTJp7EVXTgsgFsY4VTxh8h/NprM7/wrC7vic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Florian Pradines <florian.pradines@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1416/1887] HID: mcp2221: fix OOB write in mcp2221_raw_event()
Date: Wed, 28 Oct 2026 17:58:32 +0100
Message-ID: <20261028170531.680511573@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Pradines <florian.pradines@gmail.com>

[ Upstream commit f097d246677b03db814c5862f368cea341b76a00 ]

mcp2221_raw_event() copies device-supplied data into mcp->rxbuf at
offset rxbuf_idx without checking that the copy fits within the
destination buffer. A device responding with up to 60 bytes to a
small I2C/SMBus read can overflow the buffer.

Add a rxbuf_size field to struct mcp2221, set it alongside rxbuf in
mcp_i2c_smbus_read(), and check rxbuf_idx + data[3] <= rxbuf_size
before the memcpy.

Reported-by: Benoît Sevens <bsevens@google.com>
Signed-off-by: Florian Pradines <florian.pradines@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>

Also set rxbuf_size in the SMBus block read paths, which fill rxbuf
directly instead of going through mcp_i2c_smbus_read(), so the new
bounds check does not reject valid block reads.

Stable-dep-of: db2333f88729 ("HID: mcp2221: clear rxbuf after I2C/SMBus transfer completes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-mcp2221.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/hid/hid-mcp2221.c b/drivers/hid/hid-mcp2221.c
index 99a0f55a02779..4e52af7ec43f6 100644
--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -93,6 +93,7 @@ struct mcp2221 {
 	u8 *rxbuf;
 	u8 txbuf[64];
 	int rxbuf_idx;
+	int rxbuf_size;
 	int status;
 	u8 cur_i2c_clk_div;
 	struct gpio_chip *gc;
@@ -289,12 +290,14 @@ static int mcp_i2c_smbus_read(struct mcp2221 *mcp,
 		mcp->txbuf[3] = (u8)(msg->addr << 1);
 		total_len = msg->len;
 		mcp->rxbuf = msg->buf;
+		mcp->rxbuf_size = msg->len;
 	} else {
 		mcp->txbuf[1] = smbus_len;
 		mcp->txbuf[2] = 0;
 		mcp->txbuf[3] = (u8)(smbus_addr << 1);
 		total_len = smbus_len;
 		mcp->rxbuf = smbus_buf;
+		mcp->rxbuf_size = smbus_len;
 	}
 
 	ret = mcp_send_data_req_status(mcp, mcp->txbuf, 4);
@@ -504,6 +507,7 @@ static int mcp_smbus_xfer(struct i2c_adapter *adapter, u16 addr,
 
 			mcp->rxbuf_idx = 0;
 			mcp->rxbuf = data->block;
+			mcp->rxbuf_size = sizeof(data->block);
 			mcp->txbuf[0] = MCP2221_I2C_GET_DATA;
 			ret = mcp_send_data_req_status(mcp, mcp->txbuf, 1);
 			if (ret)
@@ -527,6 +531,7 @@ static int mcp_smbus_xfer(struct i2c_adapter *adapter, u16 addr,
 
 			mcp->rxbuf_idx = 0;
 			mcp->rxbuf = data->block;
+			mcp->rxbuf_size = sizeof(data->block);
 			mcp->txbuf[0] = MCP2221_I2C_GET_DATA;
 			ret = mcp_send_data_req_status(mcp, mcp->txbuf, 1);
 			if (ret)
@@ -804,6 +809,10 @@ static int mcp2221_raw_event(struct hid_device *hdev,
 					mcp->status = -EINVAL;
 					break;
 				}
+				if (mcp->rxbuf_idx + data[3] > mcp->rxbuf_size) {
+					mcp->status = -EINVAL;
+					break;
+				}
 				buf = mcp->rxbuf;
 				memcpy(&buf[mcp->rxbuf_idx], &data[4], data[3]);
 				mcp->rxbuf_idx = mcp->rxbuf_idx + data[3];
-- 
2.53.0



