Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618980;
	b=PZS5g0rzfeiTklMmPerSeynK1Lfj60oufYvIQfZYQqCCnrHG234YoFskAAARdyxJXfec
	 aW2GXfh0hz5GdLl1p8pv4HdrOhI5MvfyZF3s1FNoVCK3sPTNAog/kcjkp13TJ3o/+zj8p
	 pp9NYAkwmk8rMnSqe9XMZ/2lPAWbnqgDOvghUyD83nka8HCQZH06h4brG2eoWbpvjE56X
	 xgu9QR/WG0Rcz9SDkosCKPG00ym+ZTseluixM9VksWL8Ws/z//wOecyUhsd8aVEBr0CKD
	 1nkeG5CUWARn2CTSAgNq3sLbkjYSDLoS9CdeuguhmLZddP0oVjEJFjenEriIpZp0c1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=M9csYQyH9f8paD8Q/OLfAsoIpGfJ/VG9mvkQPRNY588=;
	b=KCpGftpnIvYTnluZLEVkwGPHhKNlwwk+rCKAUBh7ZlqWDyxYb/r0eqE6wD5eiNJICuKP
	 6NF+GuOPrDoxgg7FpGcaTozJ8Wuw4DqEVzQNPZVtBa+1p2ixGv2xhd95YL3eesxgLThK3
	 LvNVABhL9qdNGqbHLZ9tJeibs8BSDtEgh9WfAGzm0oOAE5L8KQ/kLz38jbqKOOH+4vt52
	 lb7L92ZhmMPR6JcnPO+CpjOyjiGNzUY/jvqhvp6NxxMD7GoYGVTGdRkDO+77Ut0BJrvzi
	 EU03zxUywe0PlVFrfY2juuVo9mC12i/8Ow1JR55paajQgEFxt9ATCL4iiWuFFihioUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eo2eYec3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188F1606A329;
	Wed, 25 Nov 2026 15:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eo2eYec3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299191F000CF;
	Wed, 25 Nov 2026 15:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618979;
	bh=M9csYQyH9f8paD8Q/OLfAsoIpGfJ/VG9mvkQPRNY588=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eo2eYec3wKoddPHWDKzIW5rGrx+brOs+q2N5QnuS3drQjzaCVRhPL2O93tc5ajkl8
	 O4GT1SQmJ/3dBcj/X+pdmbazkrK8k7ZIc6AdVfzYQdm9Dh81wT2fTJzkRyQ2Aeqvlg
	 KEbfoGLGmozYpon6qCCBGmfAON+Ze0NRMge2o1dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0448/1005] ice: xsk: free stashed Rx frame when cleaning the ring
Date: Wed, 25 Nov 2026 15:29:46 +0100
Message-ID: <20261125143832.243198206@linuxfoundation.org>
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

[ Upstream commit d5e7a86b7cd6c38a628635baace7eb2fdce14a43 ]

ice_clean_rx_irq_zc() stashes a partially received multi-buffer frame
in rx_ring->xsk, with its frags on pool->xskb_list. next_to_clean is
already past its buffers, so ice_xsk_clean_rx_ring(), which walks
next_to_clean..next_to_use, misses the frame, and ice_vsi_cfg_rxq()
later clears the pointer via ring->xdp.data.

The buffers are lost to user space and, as the pool outlives the ring
across ifdown/ifup or a reset, the stale frags are taken as frags of
the next frame. Before commit 93f53db9f9dc ("ice: switch to Page
Pool"), the frame was tracked by rx_ring->first_desc and leaked the
same way.

Free the stashed frame when cleaning the ring.

Fixes: 1bbc04de607b ("ice: xsk: add RX multi-buffer support")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Link: https://patch.msgid.link/20261102124950.958345-9-maciej.fijalkowski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index bf14ed8f87a3b..0c1ce3e86a45b 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -912,6 +912,11 @@ void ice_xsk_clean_rx_ring(struct ice_rx_ring *rx_ring)
 	if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
 		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
 
+	if (rx_ring->xsk) {
+		xsk_buff_free(&rx_ring->xsk->base);
+		rx_ring->xsk = NULL;
+	}
+
 	while (ntc != ntu) {
 		struct xdp_buff *xdp = *ice_xdp_buf(rx_ring, ntc);
 
-- 
2.53.0



