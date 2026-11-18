Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033485;
	b=soAxxvMi3JniSI5MZHRDBKrqkz4f3BROMnhNZFzl0aDyvDT2rMz702+bsQu09Ked1PQi
	 VPCqAaFi/mHkg+SLdXwGQgjwEeYfqAqmhITWb4RkPGpLqGxh+8lDApKx39F5viD+yWYZC
	 wwJP+Dasv7lIrOZ0tX4t1qHmLUpqqRXgo3PN4v60HfB5OG1fOsDm09AieEP9ibHPh4Ytj
	 zu+9GlfqMpxkmHSeepKAn9xKoCD36iMCPSrKTp5EaqZS9VQur4fQI9UvDqFinfvFMD4Au
	 Af9/5MfLtNyrlnNA/SDqng43QKTSdu7BdesF+kJbHsfmOEzbKHoJ6r2eZ/ebqn/Hg/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zh5VXOnlrwhNBQRUV1zV6GN3PhF6nCvl/Up36nl2q8g=;
	b=xxNLdWalDjHhKrgp+mif2Lo4D6L6zBJ8Gph7Rzt6be6JZHZG6PH66WFPH+Dt3I2MU/0i
	 CpXCV3Gm7Der8A0BOijut++4aw5kcH97AjMZwVlTwRpLyFXkBCCQo9EWqrIT3j1PSAL58
	 hO0AJcrD7CyDtKhuqLb2f6qMkzVJercFxMsuccG5ZoclH6t2/c72O1d/mVYypBQhHvZAC
	 c9Ify9itD7hCaP28gXTjKvry7TsEbt5j6Kdlm3pO5iO3YCIZHXvwVdcou5dl4FT6fi8gE
	 cms3s+xMxRcEf3fD9vFslon/jdbBuHVJQe457z28QHOen1TGQUR9HqoSTIzV8Zk5DHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BFrTLxYv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106A1606A325;
	Wed, 18 Nov 2026 20:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BFrTLxYv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED381F000C5;
	Wed, 18 Nov 2026 20:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033484;
	bh=zh5VXOnlrwhNBQRUV1zV6GN3PhF6nCvl/Up36nl2q8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BFrTLxYv6kVQovnLS+eSAUg1uT9lrfcZFh8iu8ryoaWgk9aHh406YB2H/RGKYq7wN
	 7AHwNoDXQL+1ZYy8bdhHCapj2Sb6rnj6zFl1MfS7d7NspJCOZyEfGoHfRegqlvHOcz
	 7wqyuQuI6iyGS36NH2cueFvYevr8OtKUWTqqRKdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tu Dinh <ngoc-tu.dinh@vates.tech>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.6 0003/3318] xen-netback: Zero out sring pointers on unmap
Date: Wed, 18 Nov 2026 15:10:25 +0100
Message-ID: <20261118150313.710073008@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1523,12 +1523,17 @@ static inline bool tx_dealloc_work_todo(
 
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


