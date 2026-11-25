Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618983;
	b=x33yJKVnklv79E+za3YnhXtGye0KxPi0yqzjkHKoi7TiiBtzzvaYBx/mIz5Q+oRe+kE9
	 9nRICKK3XcMtT0mWbxeY2ZYyE+AAOzVO0h8caTKeIMQQVrQ8C4Yzon6bsLW20jr6osgFM
	 i8FB5DJMdpkCjooIY6SmInhLaXhy3xxMlicljTJLujmczQwQqbDVi/WzqZ3a7yGQ3aT77
	 vcEiWLJIHwdXfJX5o/RF9zmtLeYpQSOuicK4wy8YQf5x4a9Z9Aox4os332QhJvO4wdEwB
	 x+4I/ozvYVme/UEa3uuj7u6KIPEIC8CT0QhWB8TroGBXS7uRhdN+pT2S5XQLSV6dBrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618983;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=DfZpmB3hrZ3dtqgcc0cLtIC6IURZSfj+kGCnK46g/Ss=;
	b=PuVnIaDafaE56wKSLrPnTrra3EHeGL6sQtrx0YMzrwMVlHlgaruKvw4EsvBBAf/HrR8s
	 OhjoB/t9IRfQE05YHeoOO4KE+5xVT7pTxe+67aUsJaIz4sl2vAjktOOCnth6mHRiNNs1p
	 Y6o1NHk/CJ2ccC4YpB0KKbQKw113UDgK4HwslZWdUc0S6z1qYeUDAi7MrVYVROGtnuOFZ
	 EwRM1JGzh/d1Xcwzs9JqKe0gKbcnK/cw6PkvJQF98h7hF84+Ho+fKat0fL2su1way6WMG
	 4/0q3AjIIN+u2gStl45D4YeJtHqSpd0ZI09UwFi3/mv7qh0lmnkVdeOgJU4aHUwjJRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T2l7ZqRM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2B2606A323;
	Wed, 25 Nov 2026 15:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T2l7ZqRM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E1A1F000C6;
	Wed, 25 Nov 2026 15:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618982;
	bh=DfZpmB3hrZ3dtqgcc0cLtIC6IURZSfj+kGCnK46g/Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T2l7ZqRMoXnqOm3EuYUfqqVj8HXwHi+zvsFMSmssD3sU6HV5fusSI2XOIYa1fCWB6
	 891MriQd8S1FrrGFGIIAZ0ZIYya3VQKyt2nnsL0jy7/LdRiHb2G6eRYaRtl9la4hcG
	 xylHXMpi1uYh47skmhcBU6DqhEtDSVlOf1jInZ7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0449/1005] idpf: free stashed XSk Rx frame when releasing the queue
Date: Wed, 25 Nov 2026 15:29:47 +0100
Message-ID: <20261125143832.265936353@linuxfoundation.org>
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

[ Upstream commit 3cbee39da8251098e2631a106fafcaebc7c8e66b ]

idpf_xskrq_poll() stashes a partially received multi-buffer frame in
rxq->xsk, with its frags on pool->xskb_list. Nothing frees or clears
rxq->xsk on queue release, as idpf_rx_desc_rel() only returns the page
stash sharing its storage for non-XSk queues.

On ifdown, the buffers are lost to user space and, as the pool outlives
the queue, the stale frags are taken as frags of the next frame. If the
pool is disabled on a running interface, the queue restarts in page
mode with rxq->xdp.data still pointing to an xskb of the pool, which is
freed later. The page path then takes it for a partial frame, writes
frag info through it and returns it to a page pool.

Free the stashed frame and clear the pointer when the XSk state of the
queue is cleared, while the pool is still attached.

Fixes: 9705d6552f58 ("idpf: implement Rx path for AF_XDP")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Link: https://patch.msgid.link/20261102124950.958345-10-maciej.fijalkowski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/xsk.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/idpf/xsk.c b/drivers/net/ethernet/intel/idpf/xsk.c
index d95d3efdfd36f..5a0a1d8a7a866 100644
--- a/drivers/net/ethernet/intel/idpf/xsk.c
+++ b/drivers/net/ethernet/intel/idpf/xsk.c
@@ -134,6 +134,11 @@ void idpf_xsk_clear_queue(void *q, enum virtchnl2_queue_type type)
 		if (!idpf_queue_has_clear(XSK, rxq))
 			return;
 
+		if (rxq->xsk) {
+			libeth_xsk_buff_free_slow(rxq->xsk);
+			rxq->xsk = NULL;
+		}
+
 		rxq->pool = NULL;
 		break;
 	case VIRTCHNL2_QUEUE_TYPE_RX_BUFFER:
-- 
2.53.0



