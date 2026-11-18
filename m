Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014377;
	b=nr4BU/qCl8DCS+CPKnfgQWO6XH+FE8AH4RStYrAFNbOPzNrn5AlxVJcZcSXonSRG5pbV
	 kAuxcIsDL3C0xc74KN1bQG8FhGbPGkN3ayh9giddrJUJ+KTkE63PY3WeeVuJzyr6yhLP4
	 rkbvnrnGXPYfkdajJc9/PoE4vp1oXs6xqUA0Et8FGDw7c23uxyGekRESgPnpDljnoxLG9
	 L7WfeFNNJLv2K07/kGsrJ0zlTMGo2lg2MCAU6vGzfzmCYp95wG5H+fxZKYEmvmiseBHVJ
	 M5S81wx7nG6hn2GyUkXGkqGQOaOfXqih7tE7JYx9rx6RiIXnEXYyMZUuJv4/vr/S5wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NVXDg4Z/1WombxysnaY1Whwu/OpOt1JF0Qi9yCA6NMo=;
	b=xzQtumIOkWAiMmXUqWS9rumOAexF5DrB1leQdpqwI3rrwTiMiPa1/bI3dRqjRJyRGaIq
	 v6PO6kwkt4lADSL8AqnCvyLOzRH9dDcl2qepEhVlHZlq0AvK/9I+b3c+RE48jomH/QDEK
	 jczMls9ibTefJ99J9bI+7sSs9DUx6Rr0MoXk1zOFz1ssP/3oM9tlsNakcrR5Y6vi2mbRr
	 yrraGBzAWtqrvobC3h0GwHvBHJ9KsohJ1z0rH2durc+sHimx+YHphl4oPVGlpKPCflqZR
	 7nsyF/mriYREQElZoqnnJvroLv92A2bnaHxasSlCk7W/a8g1JTD7pKoYugamzmFTibw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cri2VNQe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF9B606A325;
	Wed, 18 Nov 2026 15:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cri2VNQe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637D71F000C4;
	Wed, 18 Nov 2026 15:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795014376;
	bh=NVXDg4Z/1WombxysnaY1Whwu/OpOt1JF0Qi9yCA6NMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cri2VNQeE1vrd7AvOmWDGftOnl+ltIRb1w2zD/rj80KAu/Haguoh/2rtlg2FaU6Ha
	 fVt0H2VpZ7emsY+G46rjfJO7blE0z7AlCc6qeRgh+rzqlRcpkhF2WSoUzaGiWE7Eg3
	 KbPhVVKOijb+bBN1NIrcigfwwBvU4A80xAiDasWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tu Dinh <ngoc-tu.dinh@vates.tech>
Subject: [PATCH 5.15 0001/2214] xen-netback: Fix XenBus connection failure cleanup
Date: Wed, 18 Nov 2026 15:27:57 +0100
Message-ID: <20261118150009.938663654@linuxfoundation.org>
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


