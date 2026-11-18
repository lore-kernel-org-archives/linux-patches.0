Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014379;
	b=HXXMB5PkH9vvbAn5zZzpq5tbFJcZQOKbd498DqPyns4VkcP1TOu1XuGFcBghpLw6YNoA
	 sgbVWVmnva21biXShOLXCFzfJkl/KBNWmvB+kSANBJYhjP8WTGuofG5jnTxTqbyxXB1zH
	 psTrGLYMsQI2jNf96WRg1cJ5trJhtoFQtkomEhizb/lI1rrQ7VCG7SPPJE7mxoeM8cTkP
	 ZIPKIZNTinXmMKnjYW7Z+ZSCESZvux94Fj5vMmxbghgZPAhfqaZxYg3moaSD/q6EkqzqR
	 F7bGvAPQvlOCeWl0KvCysmM3D6XUV+zVdf0D0uCetd11ZKrA9PkEjF7yXSXllDrfppQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014379;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qo5WaN0HrFxmL0ob1vN1PCK2b1k8e44K7IVdXpd6CG8=;
	b=TcWMrFn7Vq7SlcTJ0rgaz6ZARiCDWPjiem1y/5OGFGqBvi1rM8apxAr5RZXhPSpgQUis
	 0bbrtsOGRrJ1br8U9K/rbLNyAk3Uq+REoMzWCYJ5JOusg8EZctgBmWbdgl/ZKZHjJGQas
	 yU7lkeYfDSQa0KE6eMcN0sN0vYUB9FPuHYLHGB13mFVb664a4h5scHqtD99svPy8JDbC5
	 v9nfWD7afL1I5dyFxeFiqyySbqXg4sQDeonu6qx9R6h9XMqNxf5zKBqzz8D+kCLxWHRkh
	 Ai/pWIvrYg0rMZ/Lu+qDRMEz0mpm2hfJmKbg8avP1wZKqpK7/zty8rX4O5wDzkegnmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wCVSeS35;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA952606A333;
	Wed, 18 Nov 2026 15:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wCVSeS35
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3573F1F000C4;
	Wed, 18 Nov 2026 15:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795014379;
	bh=qo5WaN0HrFxmL0ob1vN1PCK2b1k8e44K7IVdXpd6CG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wCVSeS35rlZpYDAbPcnXs4uQcwpDIIT3+svlaFc/AHBIWBrzpCitBxNwjS4ct+S7d
	 sMzwOH+DxI8IOHgEyH9w463ZAF9y6k3+5dVw82DFAFLIWlDFXMWwU9bl0BoN1Cysyj
	 RxSCcsYZ2TJzRpvkBCHF1ysxfRCj2eYrrbYcC5fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tu Dinh <ngoc-tu.dinh@vates.tech>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.15 0002/2214] xen-netback: Zero out sring pointers on unmap
Date: Wed, 18 Nov 2026 15:27:58 +0100
Message-ID: <20261118150010.108006832@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1535,12 +1535,17 @@ static inline bool tx_dealloc_work_todo(
 
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


