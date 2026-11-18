Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031199;
	b=cLSxaC2IV3iMMwLIH6IdHKX/JKF/OBxxxJ2jqr/AMeblNbuZfNamYJZHQupmzHAnF2qX
	 jbAZVW9l/6XnHEF72wUhxX3vglOZ30X8ffAuV/JBAnvclvY8uF/UvFT7cOixClMJoewiJ
	 fNPPyQ4kw/kD2JSeT6luY6Ob41cNwu4FkV2fK2ZBiCA9aDVlKTX2SIhoW+CWY1AG7dcoi
	 WzG8IUq6nkjY3EHBcLVXwjTi1aMObzBhsydWzVR7do5XT+kmeW4ZRZc9GZ25lP5CIzjuv
	 cG3kEl9XRa7ls6UHCzeBSkG8hziN15nBWQd02oLV5sL+MV7q0tgo2OT+GujZ3AO6pcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hsKnxL2xQcA4eKZdlyGhxRfXnqzY22Ku9y/D2W0sU14=;
	b=SOZdyqvoaDWcM3mfUZG/5hzPuYgPlGSizRMgXFm3KJ3kQdXMvJEoZehhDXqODP1dXayT
	 qa/7d9XnCk3no5C23Br/BANsK+NC++o0fU32yj/9mBDlyPTT3gb8TF7MipFB2HBMv5aVF
	 chO5QYDovxwo4yPRh6tPX+zeujKBuKyUaw9VQpBIJRmxN5aeCMRiPJM2cfkGL1WT22T8X
	 U3xaEDHt2//45SelDG8xGCSccQNO3TiMb5ue+nlH/L8K8rhIeWB7jl3TJcSfTo6XfCFux
	 awvU65hqs3MHIYuPtgRN+yDk7ger0F/meYS/P0+YO4I3JTpjGXseeZ3v30bpNPPpVxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yDYLwisy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB05606A320;
	Wed, 18 Nov 2026 19:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yDYLwisy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717471F000CA;
	Wed, 18 Nov 2026 19:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031199;
	bh=hsKnxL2xQcA4eKZdlyGhxRfXnqzY22Ku9y/D2W0sU14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yDYLwisyV1QUpvoDyVD+/zk4zj/WFacpX28F97Nn2oppnu3CkhL0b7jYPExGUAfco
	 BIlOZNEc4W1gQ4lyQd48CDfdRrqXG7gp+/UDSZA2LKUCH+DE2nXxWPMi/12QPSghjn
	 Q1TYl1YpzCNTtjgEzb+bjHfjVBD/01KWMSFtZ5v4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0967/1756] wifi: mt76: usb: fix source overread in mt76u_copy
Date: Wed, 18 Nov 2026 15:51:34 +0100
Message-ID: <20261118150048.633508172@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

[ Upstream commit d435130cdd064b901d8ce5ada0322298e6a86a49 ]

mt76u_copy() rounds up len to a multiple of four and uses the rounded
length as the bound for memcpy() from the source buffer. When the
caller's length is not four-byte aligned, the final copy reads up to
three bytes past the source buffer.

Keep the original length for the source copy and zero the remaining
bytes in the transmit buffer so that the hardware access width remains
four-byte aligned.

Fixes: 9446248669968 ("mt76: speed up usb bulk copy")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925150556.2304003-2-yaojiale02@163.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index b39dbf22dfc1d..317b3ee648ea8 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -160,8 +160,10 @@ static void mt76u_copy(struct mt76_dev *dev, u32 offset,
 {
 	struct mt76_usb *usb = &dev->usb;
 	const u8 *val = data;
-	int ret;
 	int current_batch_size;
+	int len_aligned;
+	int copy_len;
+	int ret;
 	int i = 0;
 
 	/* Assure that always a multiple of 4 bytes are copied,
@@ -169,12 +171,16 @@ static void mt76u_copy(struct mt76_dev *dev, u32 offset,
 	 * See: "mt76: round up length on mt76_wr_copy"
 	 * Commit 850e8f6fbd5d0003b0
 	 */
-	len = round_up(len, 4);
+	len_aligned = round_up(len, 4);
 
 	mutex_lock(&usb->usb_ctrl_mtx);
-	while (i < len) {
-		current_batch_size = min_t(int, usb->data_len, len - i);
-		memcpy(usb->data, val + i, current_batch_size);
+	while (i < len_aligned) {
+		current_batch_size = min_t(int, usb->data_len, len_aligned - i);
+		copy_len = min_t(int, current_batch_size, len - i);
+		memcpy(usb->data, val + i, copy_len);
+		if (copy_len < current_batch_size)
+			memset(usb->data + copy_len, 0,
+			       current_batch_size - copy_len);
 		ret = __mt76u_vendor_request(dev, MT_VEND_MULTI_WRITE,
 					     USB_DIR_OUT | USB_TYPE_VENDOR,
 					     0, offset + i, usb->data,
-- 
2.53.0



