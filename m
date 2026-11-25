Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618971;
	b=acFdBil0CQRaEIJjQIF/pOqCAAUReE2DlTnpIS2KJOHp5OsWiTbN4qwoXN0k1e9hsInj
	 HXPgJo5UvuL40Wh8fdhjzjXFdpKjcke1E46uNtCWR5SLAkP33P0RLYPUUKD+YeZR1RXrD
	 Wt8NH+xlhuiHYPyqHPeqyc52wlEXIn9FgX0INSaQUxyizN6SPYb3EKa3syzeu6uoOp+TP
	 kTEvOR82DDfc6sgRlwLZlCQJV+t0/O2vkGnXRbxf3KtOWk3KWpyt4No6pXY7ppoWV6H94
	 oCWXiG6lQnLqrztcfXK33byY7yv09yLzf78H8sM4elzNjfA+Cy2P3UURZxsU0HKBMQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=PPnkEKksq0UlZwawl2YNuu4vHdCoUHOFCdFwvzm1gYY=;
	b=Fh9JYfhUuzPQJUgtW3AWmQNRFHMEvgdc4bEx6oKkCrKyVnVc7Zmz4Bd4phPwH3yKUEvj
	 2Z6E9tG5s+CVRzN9RmgOZ1yGHr0ZZi45uQCoreSL8EqImOXWis+b1sjm0rkhroyK1bWEO
	 uoC1181xgiFh498Eg4Yuyz5S5J9ZBbjixTv7X9PS7PKhYkiu9Vq4uqMjHejMEtecLsKtX
	 2vcoADaUhCorseQH2jdLu5CZ/3F8o5vpztGSkS/OM1QD4jc8qj9Zc6UX59gTWPNwwy2Pj
	 29r9jQ9SeGbupx7iaFQZKm192Flr+r75ZjHTXF+1YHC5iTmsEtgmY3HIdn0FpG+hkow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mVqn9JXa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B4C606A31E;
	Wed, 25 Nov 2026 15:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mVqn9JXa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7201F000D1;
	Wed, 25 Nov 2026 15:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618971;
	bh=PPnkEKksq0UlZwawl2YNuu4vHdCoUHOFCdFwvzm1gYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mVqn9JXakAvDmdasp5YU7SzZaXh66oICwbOQeCkkOnxYBtUrYh8/H9FEG6nk2bOTW
	 tcIxjXuX4m7AYwPwLkSLBjiElpS7ALXLSf08rg0vlWQl62bhQCWvtRzf4Ajby2zQJr
	 /cJj9BJIYWv0ZGpcT4KTD/kBQ05Ke+7EtJgea1yY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0445/1005] ice: xsk: do not free in-flight frags on XDP_TX completion
Date: Wed, 25 Nov 2026 15:29:43 +0100
Message-ID: <20261125143832.171931388@linuxfoundation.org>
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

[ Upstream commit 5a9b5e315e101dfa02af5d8d3b27d893ba3e5566 ]

ice_xmit_xdp_tx_zc() takes the frags of a multi-buffer frame off
pool->xskb_list but leaves XDP_FLAGS_HAS_FRAGS set on the head. When
the head completes, xsk_buff_free() frees whatever is on the list at
that point, which are the frags of a frame still being received.

If ice_xmit_xdp_tx_zc() completes such a head while cleaning the ring
before sending another frame, xsk_buff_get_frag() returns NULL and
xsk_buff_xdp_get_dma() dereferences it.

Clear the flag on the head once its frags are on the ring. As
xdp_get_buff_len() then covers only the head, count Rx bytes before
running the XDP program, like libeth does.

Fixes: eeb2b5381038 ("ice: xsk: Tx multi-buffer support")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Link: https://patch.msgid.link/20261102124950.958345-5-maciej.fijalkowski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index ea8ac0fcdf6ef..bf14ed8f87a3b 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -493,6 +493,11 @@ static int ice_xmit_xdp_tx_zc(struct xdp_buff *xdp,
 	tx_desc->cmd_type_offset_bsz |=
 		cpu_to_le64(ICE_TX_DESC_CMD_EOP << ICE_TXD_QW1_CMD_S);
 
+	/* Each frag is now freed via its own Tx buffer. Completing the head
+	 * must not release what is on the pool's frag list at that time.
+	 */
+	xdp_buff_clear_frags_flag(head);
+
 	return ICE_XDP_TX;
 
 busy:
@@ -592,6 +597,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring,
 		struct sk_buff *skb;
 		u16 stat_err_bits;
 		u16 vlan_tci;
+		u32 xdp_len;
 
 		rx_desc = ICE_RX_DESC(rx_ring, ntc);
 
@@ -634,6 +640,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring,
 
 		((struct libeth_xdp_buff *)first)->desc = rx_desc;
 
+		xdp_len = xdp_get_buff_len(first);
 		xdp_res = ice_run_xdp_zc(rx_ring, first, xdp_prog, xdp_ring,
 					 xsk_pool);
 		if (likely(xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR))) {
@@ -648,7 +655,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring,
 			goto construct_skb;
 		}
 
-		total_rx_bytes += xdp_get_buff_len(first);
+		total_rx_bytes += xdp_len;
 		total_rx_packets++;
 
 		first = NULL;
-- 
2.53.0



