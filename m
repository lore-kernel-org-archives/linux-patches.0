Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618974;
	b=jIJM8Z8SbQREnRfRDSgHCHO1YYeo4xyq4xz8HAkS8T8RXCdflNu9rv6ZfQuaU7ekttXk
	 JFwRWYvWD5UqiHGNy98TB2SVvolau2UxEh6NO6X64JDNuZRQuQ8vkfC36mZq0sdLu9yNS
	 RDPJvesp05mOlQ5D5i9Zy1DMqdsnJ1aY2gCpmpetTzL67U+N26zj+LoVnLxBpcKFJCMBk
	 HM7j6c3u4TEjvIUft3PblPohMxFnfIwMPYg0UqcfvdfFitL6Vg3c/pXobfhExxDjuXya/
	 o/tuk7qOShZeln+bCXyYP16XUI9Dp+88JBbKjJlkQzl2/l8NjUs+yR/EGnx+K73nqGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=T8SMdBQo+AasW5RvyIHWC9yd+ARUtZTNkd6Z9Lm096E=;
	b=pHIhjo7E4GdWAJsEEcwD16XCp7TKUQhSiuwmnjSxDhnQXBU4Edb89IQkqjhqc5iua2cm
	 wWX4OAAYfPEU+jt2fvD02Xs79zi5jVwFhKLCQ0KucYPxPpkatQ5+tZEcU7ge06+C+vFpp
	 7fQemSi3gchDggUb/oYFXO094FGhz+Px9Vf2u1upHX3uxukakBYExJiWI1yYQ7DPNCFow
	 aarxEU2cBwt2RgZVZgbUr6rLoIG3Qka9BkLhdAy+vAwh4a40ClyxaowdNr0RtCHSYIEvy
	 sPuisRhAFhfOcLlERPrKxXrdG3Qd6tcJ6Q82nKASztL1Q0KGXA9dJVzoLEZaAsIzMmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sd6QyGCL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E07606A321;
	Wed, 25 Nov 2026 15:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sd6QyGCL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7029A1F000CA;
	Wed, 25 Nov 2026 15:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618974;
	bh=T8SMdBQo+AasW5RvyIHWC9yd+ARUtZTNkd6Z9Lm096E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sd6QyGCL2Sda4LnDkC9bXPgXzXi8TO05RaUE1oATyBdRVn97KsWd0E3cAiLpIbjUE
	 p06rfcriY880TNfnchMgrZLW8Oc/Aho6H0ZV81NxDMalYifi8G+8GvgZo+BVj/isli
	 uyfDaA8QR3Ywv3UJ/eSoENfUYC+8Lz8jRMhbMmhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0446/1005] libeth: xsk: do not free in-flight frags on XDP_TX completion
Date: Wed, 25 Nov 2026 15:29:44 +0100
Message-ID: <20261125143832.195351417@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index a452b7828ce4e..249b1c7407881 100644
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



