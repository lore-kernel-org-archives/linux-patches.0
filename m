Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621991;
	b=P04wJZd47larncuWDoGXSa2RWzmtAkf1uGWK1ITdhwust6LbCjeFB9Sn0U6JWOFSMYT+
	 JhJBiGagSd/GRA12+wqLHe4Phjs5B7kLEUcqnq4hNc0y2AHm3xgv3tBgH5b0uzlLlCkQ5
	 txZ3yulnfUh2d0/r4Gl22mtkIZDXM75LdS+c2qEam6T0f4NLMAOCHjN73jqxwAyfc8UXM
	 PzYeyBjCfZdhoYdfI6xdoaNvIXlamb+G26MENs7oNh55wz8Sfq6QBNv5RFluQ1p1h0tUM
	 cjFDRNN26bgRqG8zMwlzkAIlvFrwezDc/0GoW16BbRJc20NW5hzbmZc7/lTls+uQ4cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hHF7l1wtYeWROeTzeR6ujnINv+MrHz3P8JvJJTEGjDE=;
	b=jL+JwrmMxZJdZ9T8uicgd1jYzovZzdPegvEc8ZU3+b5tkIEkPoPcSFSCHfx8FhI9E9rO
	 R5BIojDezgr4cWYsrP9FmP1R39T9w1AUgywG94PyFvyvMOAOVFW3OpzpEcXLcvHoO5XDI
	 1nJ90yD0lAicB67a/oT7yjg4C9sXPE5ChpK0w5ZjaSp3zqtdrPTFFFoZLzOPteQ0s9g37
	 0m5PjaW+3D8oQkBdZzli98YcMa7/SPLw2wqHuOTXYRLdnFuQAJPSbus8ORnCpldAHJDCz
	 uKJdQfRfX2Nk+i8S9KS/GVVlFy/AF2blIdmidNn78O0V8mvhgx6UctrGhV3VjwrqozQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pG3AxFfW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B178D606A31E;
	Wed, 25 Nov 2026 15:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pG3AxFfW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE9D1F000C6;
	Wed, 25 Nov 2026 15:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621991;
	bh=hHF7l1wtYeWROeTzeR6ujnINv+MrHz3P8JvJJTEGjDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pG3AxFfWoPxX6JPaRNIflZGF7ND5TeV7x/LrdNPMyZVOmbAuaP7gCLyzPb2Ax9aL0
	 8qS4QXD8cVCa45pJkegV/6bKG0M4IJj6HorY6Voo285A9von18ey0Su2RNrdOU6GY1
	 P0l7hj8R9ZRKQ08Yky3LtQDfZG3EqNwX788Pn434=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 394/990] i40e: xsk: fix xsk_buff_add_frag() error handling in Rx
Date: Wed, 25 Nov 2026 15:29:21 +0100
Message-ID: <20261125143831.326766051@linuxfoundation.org>
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



