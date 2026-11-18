Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014392;
	b=xx+WZM8pEoErncyxgwxzrCWA0uz7dKqc3TbM47+l3pvkWGj5BHkFQiR0JyW8WJE2vQQR
	 5qH6/rc/CGAYUOPYiND0Oai73m+o0fVkaoTdlCM0aa69u0VEADa8sx0M4b8JIUXSY3pwA
	 ptO300V1esjq5dFeNmpLvC+NAfjr/gQhhqJTEcEuYP0emx2cSgR20w3U4T/RfpShirXvN
	 IZxIOFYwUOnSjn11gpi7cHRegolEqKmwZLyP5EzMz97HhwuEQ0uQNdovzk/2B3Y5GlqXQ
	 4c24LsT72pJNq6u1zhCZ56HV+vZd6j0HebcCMcBm5af3y1d1e4hKKPgU6Kye6rc3yAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9UEYyMFdojC5RMoHDFnEfwZYddC5w5h8R0j3moHyro8=;
	b=zJ9gpCY4RF6kCzTfv4okQrTGW4VB3N35m+HSlceBMv24jKcaYPR1rXU4e5qfX+fdatbR
	 wtXvvIRBzYkM3xIB1C11QDm3AUo1SfNCyePA3a0agOXPf60ufmCG+mZS4HDkavWNBXBZs
	 gqgi+rM453XlrGdDfFP9VgDFVMf8Y7jPkaCRCgQ9A+bwfFfaWmu/BEvHN3IMasp0IECzY
	 J8yYQA9+UQ7Glx9S0Y/5DonOfqC/R6lZpl+VuTsrJQYPUQ9xzSBXFpvzWwJy4RrAhgf1t
	 rU7CCEJEzX3b6SiXKCOG2CebNQFH/M5J8QVcYbseVYFXNZj8IdYT4vnQRrF8kOAqoNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y+p+aIaL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83A9606A335;
	Wed, 18 Nov 2026 15:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y+p+aIaL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF31B1F000C5;
	Wed, 18 Nov 2026 15:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795014392;
	bh=9UEYyMFdojC5RMoHDFnEfwZYddC5w5h8R0j3moHyro8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y+p+aIaL5zCDr028Ggc2Jw20OMO82MbMhdnS6dUzU2OC4jY2LrSa85PHKcfVuhLFW
	 CrDnedTiAopYpC4cvCEw8ueT/Vu0mEt4FWs1nLbSe8n8GSP9iRFPXUiWjVysFkGF4v
	 oT5BZOIki2/1qUEBgWlowQGWJL/D6FJ3qNGtpc88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tu Dinh <ngoc-tu.dinh@vates.tech>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.1 0002/2857] xen-netback: Zero out sring pointers on unmap
Date: Wed, 18 Nov 2026 15:17:16 +0100
Message-ID: <20261118150201.412149919@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


