Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622026;
	b=BHz2fHoqn0Kn3KJwB9KEnbQJaqIh8VGlUQAiNGhwiI5NlY4iyt0vNUOKPPQc3mcaRfmR
	 NiJ629OYwVnpHI2D2CKcJRruZK8hMBGRcDOsTGQcvUOvuMI4fzkddjpFhhYy9Q2YtJ7nw
	 tSWFyWwGn1hmmBOFqIg0XTya9tfO9Lm2ob11Z1Oiq3+C4LG+pOgOnDdfhNIcR1sXKhf1v
	 4jXUXKPK94u7CxJvYq54LNckrz5G28SZzXNmLVoUsKU+i6Im4QjcjTiXzSiPbPnzuqHEe
	 AjmxPd6pIVvLHq88yiMzM4hGTlSN3Mvh/br5DRU5xtrOPVfGOb7vB/5ZbEMUW9V/D3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=5qcjMZ8aqgyclhlRusve/ToHfq8+tCbUgUTKmPCDOEs=;
	b=JrTXpL0+8MHyfmgoQ7G8klQTUEqPwh/+PiyD9iHdD+WT6WoSdzZY+2BYrviX4US1Fuhm
	 zrCMjgAx+hCiIWl8QVFqfHThkCPeNTXOFN+qka92v+a6bTjoir/8YyYt9G/YAdo5Pu6Ej
	 NiQegA38tiupd0RBnPXUFcK+QysGM0CT+GLqvEONaya2MQDlHc4ugTQLWWE06ZMV66rj+
	 lX2JhBKbClcjfydvJ6W6PCu1zXDQLuSIJzdbInC/LmmX7XowiAAbApfCioMu0KtGRHN4E
	 XHCr2erG5xSWodYG5hJZR3NVd1BbuTg7U5SsDX0Hph4ykLMgJdoBNopPfoLxULdR0RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VSi/KRlD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB99E606A327;
	Wed, 25 Nov 2026 15:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VSi/KRlD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FB31F000C6;
	Wed, 25 Nov 2026 15:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622026;
	bh=5qcjMZ8aqgyclhlRusve/ToHfq8+tCbUgUTKmPCDOEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VSi/KRlD6umjpnDpuQUwVIT3D3yEzgBj5WTUiDf/NSlR+KLOXTZ+tX1WMxFDxZtUC
	 HHcBD4iHyMw53AZn40guO6AjV7sws+FXz8ij2VykSWjEfX9QKlc0p6HY5EtoSLkQWA
	 GsuRbMzxdPfkoo0mwNlcG6ozp1UEAsgkbrqcFgac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 400/990] idpf: free stashed XSk Rx frame when releasing the queue
Date: Wed, 25 Nov 2026 15:29:27 +0100
Message-ID: <20261125143831.470438847@linuxfoundation.org>
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
index fd2cc43ab43cb..463c6852f8c99 100644
--- a/drivers/net/ethernet/intel/idpf/xsk.c
+++ b/drivers/net/ethernet/intel/idpf/xsk.c
@@ -132,6 +132,11 @@ void idpf_xsk_clear_queue(void *q, enum virtchnl2_queue_type type)
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



