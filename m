Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622001;
	b=eBh6XnYe8/L/ZGo2i+V1OzQzMVMYzZm+YgDR2LDbooqsAv4PPmNENx8+QU8gOBVTLh9m
	 B+1k8EFp8Eds1Or6/lbVkGM7ubI6NoLnBdfSgMkDSuiN8HpJfwPZUmXJdAhUTj9GBta+S
	 ERBQV68/ivQBOY4JJYfMJCwAF+8aNu0/MXHnqVVvXUnhjsV7ZUTELTrpwluK3Tg0QihG9
	 kr5YeEuWEmH7aodkdghgzaB86U6zUI0xvBsFJJyeSWGvmzjG5UFhYz2/VNfmqFQaWXGhP
	 ow3cJXPh+uGGSa96h3LfZblQj2dcBsGnhkuUbcstCo3zbZ+4QjnP94ol3kCCHMlesig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=h2mV3LxQyQeCKZYoIXTrBiz5xWSYlA/LvD9mCbLFajE=;
	b=eq2vBSFCmfLk0MBB59GCzdTURN12xai5zscjPQaC3Eka8EIhrZuqIRPir3tIxVHOygST
	 cvpPzPNlZjWPyrZhlfFn4/a+APUPcz8kIwJrR4FRHLXsQ4K1YdcvOZpHb+aKbkzFrkH9y
	 XUtcJedF7+P5c4mb7QSag0HH2mznXGiQqcU34dfa/WC7djFTflEV7hnXyHTWC1j6p59+V
	 fdVEuCNZPvmSehD/UHCBbo9D3rGRY1iMEOeunp4DJ5CzpJrvnvpiox6ObpvMly3G3A81n
	 Kpoz4LdMcyfKfoQ3hZKwbOGShJTcVR5NEq1kdT5868La0HGZXOdZQVRdmflBdmpp4XQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jKqOp+ko;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1AE606A321;
	Wed, 25 Nov 2026 15:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jKqOp+ko
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713D11F000E0;
	Wed, 25 Nov 2026 15:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622001;
	bh=h2mV3LxQyQeCKZYoIXTrBiz5xWSYlA/LvD9mCbLFajE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jKqOp+koGULWBjEwJZPTuHPxpCSULNXof2g8egGAK3hsGoFNHLHTIKruAd2ji3oEZ
	 fuOja47CqncUmeQEhmaN1xAlAsyiLDCrSpN5kPtpmMvaq902fzPQXVOhIOrn6TtDo1
	 +q7oN4AqqNwHu6pDGKuoS9eOU0GJqyOpan0/QdZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 397/990] libeth: xsk: do not free in-flight frags on XDP_TX completion
Date: Wed, 25 Nov 2026 15:29:24 +0100
Message-ID: <20261125143831.398407722@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 90e5d84086d95ac45197028b98ad9059b245fc1c ]

libeth_xsk_tx_queue_bulk() takes the frags of a multi-buffer frame off
pool->xskb_list but leaves XDP_FLAGS_HAS_FRAGS set on the head. When
the head completes, libeth_xsk_buff_free_slow() frees whatever is on
the list at that point.

The XDPSQ can be completed by a bulk flush while the frags of a frame
are being queued, or by its cleanup timer while a partial Rx frame is
stashed. Those frags are then freed while in use, and the frame being
queued is sent truncated.

Clear the flag on the head once all of its frags are queued.

Fixes: b3ad8450b4dc ("libeth: xsk: add XSk XDP_TX sending helpers")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Link: https://patch.msgid.link/20261102124950.958345-6-maciej.fijalkowski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/libeth/xsk.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/net/libeth/xsk.h b/include/net/libeth/xsk.h
index 3d77e72a8cc81..edc0eba471c44 100644
--- a/include/net/libeth/xsk.h
+++ b/include/net/libeth/xsk.h
@@ -77,11 +77,17 @@ libeth_xsk_tx_queue_bulk(struct libeth_xdp_tx_bulk *bq,
 	if (!libeth_xsk_tx_queue_head(bq, xdp))
 		goto out;
 
-	for (const struct libeth_xdp_buff *head = xdp; ; ) {
+	for (struct libeth_xdp_buff *head = xdp; ; ) {
 		xdp = container_of(xsk_buff_get_frag(&head->base),
 				   typeof(*xdp), base);
-		if (!xdp)
+		if (!xdp) {
+			/* Each frag is now freed via its own SQE. Freeing
+			 * the head must not release what is on the pool's
+			 * frag list at that time.
+			 */
+			xdp_buff_clear_frags_flag(&head->base);
 			break;
+		}
 
 		if (unlikely(bq->count == LIBETH_XDP_TX_BULK) &&
 		    unlikely(!flush_bulk(bq, LIBETH_XDP_TX_XSK))) {
-- 
2.53.0



