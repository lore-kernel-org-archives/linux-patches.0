Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014371;
	b=ChcJ91QTr7LlwTYeARXCIFvJ/xCPencvbYGIYD9VbfkSkm/2dRdYNyfJ1HADoROSKHXr
	 zAaXzDq/u+OZ2/VmOCDCvxKnfmtAcezqi4/DG7L4Iy570PcvtK2n0m8Hy0h5LKvdS25aR
	 sfUmIvim6lIJcRJftN7NAPyf6gcn+T1MESw0rnUGFQiEIbAVZBhdCUGN8Mm6ekjemz+rf
	 mF6Irw9eLRztJ84ltZqGNCDISBkVgAMZNYu0FcUCgUqn3azCrCw9zxpjoB1qaDac7KAyC
	 zfb1ZRJvcISUP9WTC1bs5ph43FLdHBtJinQ4s5tnO+ViCloRejdEG+FhTLdhROx0pSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CAcs3gJaU6NOluKbY3wY92vZfjitFaNI6HTVfOpinbE=;
	b=a0jYMTPJyTBfS4PAc/iGUNMeJiwqp23upj1oifQ3jU4o3N4nZwUpHGrqjei+vv3gHFdB
	 NlvmATpKjA2jiwm5RXTw/cYPGyUQNNcNmGtuaFqeMyXyKsN2DvOmIt+kD8yrtvE4UB+0s
	 ycYUKKEX4Ds1xy6+PpT+8vIdxj8b9skhi6C2PlPuAGZ3o/yL83Fzos1sF9kkECbyldDGH
	 R6dlRvfR81rOFErgc3YcFfmWqIQADkd10tXjkkrbHF5ijuGAngzmSTV964MP0ECqFMeUe
	 JxuoF2CIFr+FZ+8yHnb6L3QmzrNcF97wOKZu3heIkscq4GZekDywS9JboJUu5lPTkXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jeEgMcID;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EA6606A320;
	Wed, 18 Nov 2026 15:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jeEgMcID
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2BC1F000C4;
	Wed, 18 Nov 2026 15:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795014370;
	bh=CAcs3gJaU6NOluKbY3wY92vZfjitFaNI6HTVfOpinbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jeEgMcIDL4sq0cs2m9ynhkfq9MeUKWh6P7H1Ynef0kfDMIqmphrtCwAxiYimSqBoI
	 GHfjhS8r7OmXrevpIsvDuO0zLYadYntH3mDMHBeRdTIn0CbVEACKXKj2d4zYEL772w
	 Q4/+c/WNOeRbhCm+MFmEw7HNHf73UI5V1Vx0ALZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tu Dinh <ngoc-tu.dinh@vates.tech>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.10 0002/1848] xen-netback: Zero out sring pointers on unmap
Date: Wed, 18 Nov 2026 15:34:00 +0100
Message-ID: <20261118145911.343660449@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tu Dinh <ngoc-tu.dinh@vates.tech>

commit f96f16592a32430a0582309d73a873b6d3ee2bdb upstream.

If xenvif_map_frontend_data_rings() fails when a ring is already mapped,
it unmaps them via xenvif_unmap_frontend_data_rings() which keeps the
ring pointers unchanged. xenvif_connect_data()'s cleanup path calls
xenvif_disconnect_queue() which in turn calls
xenvif_unmap_frontend_data_rings() again, which will attempt to unmap the
pointers a second time.

Zero out the ring pointers after they are unmapped to avoid this issue.

This is XSA-532

Fixes: 2ac061ce97f4 ("xen/netback: cleanup init and deinit code")
Signed-off-by: Tu Dinh <ngoc-tu.dinh@vates.tech>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/netback.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1534,12 +1534,17 @@ static inline bool tx_dealloc_work_todo(
 
 void xenvif_unmap_frontend_data_rings(struct xenvif_queue *queue)
 {
-	if (queue->tx.sring)
+	if (queue->tx.sring) {
 		xenbus_unmap_ring_vfree(xenvif_to_xenbus_device(queue->vif),
 					queue->tx.sring);
-	if (queue->rx.sring)
+		queue->tx.sring = NULL;
+	}
+
+	if (queue->rx.sring) {
 		xenbus_unmap_ring_vfree(xenvif_to_xenbus_device(queue->vif),
 					queue->rx.sring);
+		queue->rx.sring = NULL;
+	}
 }
 
 int xenvif_map_frontend_data_rings(struct xenvif_queue *queue,


