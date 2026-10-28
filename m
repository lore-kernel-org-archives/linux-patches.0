Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209176;
	b=ORAAo5ROU6sXzCI7vrDjTQcqyCyU5rARBfFJxLzaSMSDrRPBUP/C7lNxZ4k9JSbGpfMz
	 65uAwmgbdcX0eKvbNwXLP7sKZ8RRaXcILQfmNFx4M6QHAcCIOLY2tA9BbYOKKmAZy0jFy
	 Wf/mzjs3wYSGnZvWtwBLMzr0yoFX12ARx96sMvvgsxMpg2XLwTHWO+/eKyX6TFF9ec3R3
	 KWawA+oPE4xSMPIDyOLbgFf3amAOOQKZfdmXzV/ppMIE2rw+2+hg3xLprQhdoJvwv7G2R
	 sh1wloxfhd7PTP4qln358ykHLZt/imN1RG8f9VdahIleMfKLCqeYHIQaDx+S43q9/Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209176;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jccuYInvJAQoNr3iaJCvhajNTv1Gg0D4xyBfS3emAVE=;
	b=O5mytlB55RqbNqUkHyHKQ1H/yqn/AaCGevRSB1fF9Vcpz8IGDxiJcRXMAxt8T1VRqDQR
	 98EBN3KBwRzAIjOcijKQX/9CKayOklt9GY9LsOkawaaWWfdrKoo5olxepR1gyM6SDzZaR
	 P8Bo17BP/7SmvL4Oy2YEA5BBzGvGAko7Hwx9YN9iG/cm0KgoI1lJGV6NUUFny8N7o6rWd
	 ZWrpBzS/JwNbATl2ZAYyIufkcMsrWCpB/mFzWWmStNQqlYBqWxXf4iRucGPxx9IuE6ACs
	 16kFNycg/HmkUFAOn/4wi+EmCw5C0xKm+ki3oXQIfHNhG/iiYLQYb1CtjgCFYNqTC8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uDKowaoG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63199606A31D;
	Wed, 28 Oct 2026 17:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uDKowaoG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F3D1F01825;
	Wed, 28 Oct 2026 17:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209176;
	bh=jccuYInvJAQoNr3iaJCvhajNTv1Gg0D4xyBfS3emAVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uDKowaoGaKPg8zW+eT7FoiOVxukajDt5AzXABjsdpqTMyPxf5XWNyRuD4PvMDZMWE
	 tgbInOYIhgybt1LeFyWpmnCm2q1Awq0OT6PRwWatLvdVqCrdAVxY+W/XqjjyMXU9ad
	 lHV81lRg02G5Ly02fnHguxk22k1EJexVH8W8Hhq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Dave Marquardt <davemarq@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 326/516] ibmveth: h_free logical LAN on open-fail after register
Date: Wed, 28 Oct 2026 17:57:58 +0100
Message-ID: <20261028170011.210768771@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Mingming Cao <mmc@linux.ibm.com>

commit af0524bf4ce1a4cbd2946aa81751582951cfcab5 upstream.

ibmveth_open() registers the logical LAN, then allocates the RX
buffer pools. A pool failure jumps to out_free_buffer_pools without
h_free_logical_lan(), so PHYP still owns the buffer-list page when
it is unmapped. request_irq() failure already issued the hypercall
before taking the same label.

Move that h_free to the shared post-register unwind so both paths
deregister before the buffer list is unmapped.

Fixes: d43732ce021f ("ibmveth: properly unwind on init errors")
Cc: stable@vger.kernel.org
Signed-off-by: Mingming Cao <mmc@linux.ibm.com>
Reviewed-by: Dave Marquardt <davemarq@linux.ibm.com>
Link: https://patch.msgid.link/7a56fbfb9e0674f011f4e310fbd7dfd8e67c30aa.1790357373.git.mmc@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmveth.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -597,10 +597,6 @@ static int ibmveth_open(struct net_devic
 	if (rc != 0) {
 		netdev_err(netdev, "unable to request irq 0x%x, rc %d\n",
 			   netdev->irq, rc);
-		do {
-			lpar_rc = h_free_logical_lan(adapter->vdev->unit_address);
-		} while (H_IS_LONG_BUSY(lpar_rc) || (lpar_rc == H_BUSY));
-
 		goto out_free_buffer_pools;
 	}
 
@@ -632,6 +628,9 @@ out_free_bounce_buffer:
 out_free_irq:
 	free_irq(netdev->irq, netdev);
 out_free_buffer_pools:
+	do {
+		lpar_rc = h_free_logical_lan(adapter->vdev->unit_address);
+	} while (H_IS_LONG_BUSY(lpar_rc) || (lpar_rc == H_BUSY));
 	while (--i >= 0) {
 		if (adapter->rx_buff_pool[i].active)
 			ibmveth_free_buffer_pool(adapter,


