Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618961;
	b=ae10+wRhUVuKFSVtb51xtxIVwDeHAteetRq7FDKqEPxoDUX5wCbDBlD9rsAhzkxU4IJ1
	 /jLJXbPNight0vzFDfR5y7HOUwxt+DCNwG78Ch1M/TI65FSRdlL++zz8nF3tqa+NyPgz+
	 WOlCBqBz/2pcS8zVwiLIIIcfYaHfwDjj9KxMLpeG8mnGdfuJ0w/VM7OfnFdDySD+MSDgP
	 Ohye6Sn6pcYMpv4L2NYPunht8OeIAwzm6Wbce/uIqM8QokwTMvjP+0cyA4GUFXvYD9QEL
	 WWjnGfyvkMHieAQBjIl28TtrUAaVP5Eo1E4xwk5eH5Y7UZV3m/wF/wWLLCtfH3hs8BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Rrc32RSUypwmIkzI5vlvcfQZOiMLPJ4k430nxHiq3rw=;
	b=UWiEbmk4Zjvcp38q5fQU/p9nSdJ0XeNjxdCCCjT0phMp2vEZYkvYmqA3+09XRIOUidqh
	 1mKfA22Dr1CydD2gJR+9kN0DCkXIn0jve9gGB6FEM/uQ1W+KvP21W7+ad6PBAcA3cwUnB
	 tH+s2hxMbN+YaBws0qo4J7FXqlRLKKntv8Wq1O3jjXFoU0X5abnZ0rcy0pSFzVFLSZwuU
	 xFEI/X0cGjPR7tezazQ71DLBfq7Rp6Pgr+Vxnqs4Xr1QXFERdPoiOWKlM0HpFPCcRjMzy
	 xC4gUECoR09Zd0FXU0WlVd7iBnT8FUwr7o89vk3gHuT67ryRfVPppsO3yd3+MpD3AOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="dugK/U2F";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7BF606A323;
	Wed, 25 Nov 2026 15:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dugK/U2F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1EA1F000C0;
	Wed, 25 Nov 2026 15:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618961;
	bh=Rrc32RSUypwmIkzI5vlvcfQZOiMLPJ4k430nxHiq3rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dugK/U2FQtwdKkvAOpnXiYduIJ9ErO/QprdRlYvtGNpqB7G4kRK+2/apwDeIQibyu
	 B0QZU8G4zth2JixD4w04s3aJcoDIUecU4TyflDRTaWEyKIA7/mFnVz2yEGb5voc/BK
	 fpvCbQVkEPOZimSRacNu+Ain4S2hsq5eU56mvlj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0443/1005] i40e: xsk: fix xsk_buff_add_frag() error handling in Rx
Date: Wed, 25 Nov 2026 15:29:41 +0100
Message-ID: <20261125143832.126029316@linuxfoundation.org>
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

[ Upstream commit a259b7ec09efec032d5521dc2eb751a959c11d15 ]

When xsk_buff_add_frag() fails, i40e_clean_rx_irq_zc() frees the frame
but stays on the current descriptor, so the next poll restarts from the
freed head. If the frags array was full, the retry passes on a frame
missing the freed frags, with its head already on the free list. If the
buffer is a duplicate, every poll fails the same way and the queue
stalls.

Free the current buffer along with the frame and move on to the next
descriptor, as ice does. The rest of the dropped frame is received as
a new frame. xp_free() skips a duplicate already freed with the frame.

Fixes: 1c9ba9c14658 ("i40e: xsk: add RX multi-buffer support")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Link: https://patch.msgid.link/20261102124950.958345-3-maciej.fijalkowski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 9f47388eaba53..624f85851a7d1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -459,16 +459,24 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		xsk_buff_set_size(bi, size);
 		xsk_buff_dma_sync_for_cpu(bi);
 
-		if (!first)
+		if (++next_to_process == count)
+			next_to_process = 0;
+
+		if (!first) {
 			first = bi;
-		else if (!xsk_buff_add_frag(first, bi)) {
+		} else if (!xsk_buff_add_frag(first, bi)) {
+			/* Drop what has been gathered so far. xp_free() skips
+			 * @bi if it duplicates a buffer that is already on a
+			 * pool list. Remaining buffers of this packet, if any,
+			 * will be processed as a new packet.
+			 */
 			xsk_buff_free(first);
-			break;
+			xsk_buff_free(bi);
+			next_to_clean = next_to_process;
+			first = NULL;
+			continue;
 		}
 
-		if (++next_to_process == count)
-			next_to_process = 0;
-
 		if (i40e_is_non_eop(rx_ring, rx_desc))
 			continue;
 
-- 
2.53.0



