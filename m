Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014386;
	b=XyB2xDqA6CBU8cgtE5We7dbDh6Y3a6izMeq4SB37R/xt/9GqnXVAB/7BFoPc9F7vvJ5y
	 Tm1I80LKZr5qb+5DgY5rahBbS+KHfrjIOsKPegLbfsV2WopVPwifK6L5VK+iESlGBK4mv
	 6QFXfNRcdGM8jK+7KzEqsmFmH0ulX/mHnuulBTPM8UR9mlvv5I1/z/IxmB/SCIlphMx4n
	 Z5SRDyznCZFRnLK8+g3HW1PSb+zzfUxo3qNbwg2RMeTJ82TayHVQZN5n+rsDh6/yuhAfD
	 bjBzJj6Jvb3P8/FFg3f84ZOm7WIFqO9aTAuVWjhORSLnRsWa7voP3LPJedxwDdSYXSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6FzRBpRTKf+yHGSCCTvrkLZU+rS7rUJw92YB921piLw=;
	b=ZO4aLh46EfEulv6eACDAWkdRj4tMwUyo8P/w/Fs8A6Em6zptZBbMAMQcsbNSed5Nd4Am
	 948U0lLZtp6NcHLQtfGmHCdsrINKCTM0KQEaECV7wOkAfigDdNJSjRI4aAORfGvaTKmPn
	 Qz87/G3MisvbrMoV9uSuTiPp/lLZ/JbdH6WEHQ5arFQ5dNq8CQNYGVfNC1Phffjelh4JN
	 efKP2S+w99W4GVgO1VYCIVOXoD+MdgmH+gf2ZxFQAVpo4/HZmTx/2UlOYSRCwyj3DIIsq
	 q0DFmDihyZcvl4LY+VLnQrotBjbd/XtD6kXg8eRz72ZIQVl7M9JGk6ClvUPEHGiEgIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wZHhS2/0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AE260A260B;
	Wed, 18 Nov 2026 15:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wZHhS2/0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797631F000C4;
	Wed, 18 Nov 2026 15:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795014386;
	bh=6FzRBpRTKf+yHGSCCTvrkLZU+rS7rUJw92YB921piLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wZHhS2/0z9cRQ0eeOhLK9S9al3FkTRxGp+LlVNfEey6AsBj0x7AeQXNREEFmutEch
	 vxMTFBQG+4f1FCKSjiIluk8aAsrf2XUH/rAUlZWBlJMKkA0cNEhKqcD1+gGL7N9mrw
	 vu6fId/jc94w/E7pfnHBqBsXImmu5N4Ve1DoZkAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tu Dinh <ngoc-tu.dinh@vates.tech>
Subject: [PATCH 6.1 0001/2857] xen-netback: Fix XenBus connection failure cleanup
Date: Wed, 18 Nov 2026 15:17:15 +0100
Message-ID: <20261118150201.375934721@linuxfoundation.org>
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

commit dc6d814562b65813556933dbda1015cef61dabf8 upstream.

xenvif_get_stats and xenvif_get_ethtool_stats capture vif->num_queues
under rcu_read_lock. We need to unpublish vif->num_queues before
synchronize_net to ensure that readers that come afterwards will not
read a non-zero vif->num_queues and attempt to access invalid queues.

This is the same cleanup algorithm as used in backend_disconnect and
added in commit b17075d5c198 ("xen-netback: fix race condition on XenBus
disconnect").

This is XSA-531

Fixes: 5fb756f1bbec ("xen-netback: Fix UAF when reading statistics data")
Signed-off-by: Tu Dinh <ngoc-tu.dinh@vates.tech>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/xenbus.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -731,6 +731,7 @@ static void connect(struct backend_info
 	unsigned int queue_index;
 	unsigned int requested_num_queues;
 	struct xenvif_queue *queue;
+	unsigned int num_queues;
 
 	/* Check whether the frontend requested multiple queues
 	 * and read the number requested.
@@ -837,14 +838,15 @@ static void connect(struct backend_info
 	return;
 
 err:
-	if (be->vif->num_queues > 0)
+	num_queues = be->vif->num_queues;
+	if (num_queues > 0)
 		xenvif_disconnect_data(be->vif); /* Clean up existing queues */
+	be->vif->num_queues = 0;
 	synchronize_net();
-	for (queue_index = 0; queue_index < be->vif->num_queues; ++queue_index)
+	for (queue_index = 0; queue_index < num_queues; ++queue_index)
 		xenvif_deinit_queue(&be->vif->queues[queue_index]);
 	vfree(be->vif->queues);
 	be->vif->queues = NULL;
-	be->vif->num_queues = 0;
 	xenvif_disconnect_ctrl(be->vif);
 	return;
 }


