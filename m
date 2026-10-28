Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213275;
	b=L1zO2WWEwXIBxxoNS4+XwaRhDrhWbg5bW5z42CfAxzdQJHg+Spsxz+uNkc9ORXKB1hcv
	 3smunqtyN6MwvV9OFBZ9qCppCynyEx3L0vOg5f9Feyu28iFI/rgL8+Wv1KUoMhixUvLbp
	 e8FXLmlhVijtFpJtC2/CL/svgQuwIUUImO8Jo2BivD3rqBSyEpudibJov6hdK8gdvVJGe
	 m+ZP7fYyZKzJEb2VdAx2ZT1tllHJQK1aum/VYLiGCbGq1KDfxLkBScn2TxAnj4zEXpcG4
	 hcJxeoWbMxxTnniAdM5aujHGycG+f9NXrkroCUvESs7PPGrlIv3qKY+/vLHg3inGkfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u1ZchMLdww3Gb1rMWgKPLVnMC6xHITiqKBXpldIwN6A=;
	b=30HjL8SO0rqdv7a4ykjqIbwhZjhJDkG07hFSJwrf6ReUHbheMDR0gn0/gQH0NSaQCFx+
	 AfuR0Kqnv1tvM2F2f9uZUiYn265xT/X/LOmfTFbX43VeuEKjIACNir7QzlfV4aNQ4mNuD
	 T6bnbIxCMVq4lh3ut4d/J8GHINUxUCjSMDYsAhvCMVYRHAUXMMZfDVcEMC3cIU6WpE5wP
	 JPhsbEn50ILpa1WuQC/xt594z8dmhVEy/mzrZQMS5gt8CFs7MRwbKBCMEkuYeM+9BpgoM
	 0gLPUQHLZF6rN71pv7MCqkjICpwbkMzljBhefXULQtRVa4lt6vrZKUEB5HnDAMiR1vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FaWFXjhj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA955606A31A;
	Wed, 28 Oct 2026 18:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FaWFXjhj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070E91F01825;
	Wed, 28 Oct 2026 18:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213274;
	bh=u1ZchMLdww3Gb1rMWgKPLVnMC6xHITiqKBXpldIwN6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FaWFXjhjthGNTghOHXPlr/iGiNVJayLrFZufWTGslPzbXMyUV8Qd9JlX/2tP07JfM
	 porpNWE+1BTUXaa6laa20T/fwWJftVwsRPaH2rxBpP1tJndydhuVKbrsQAhckpMdRv
	 Jz7ssCFW4YhIuNfCkWTzf6L4ibFOHwa09XF+/wVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Dave Marquardt <davemarq@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0449/1887] ibmveth: h_free logical LAN on open-fail after register
Date: Wed, 28 Oct 2026 17:42:25 +0100
Message-ID: <20261028170509.448190074@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
@@ -630,10 +630,6 @@ static int ibmveth_open(struct net_devic
 	if (rc != 0) {
 		netdev_err(netdev, "unable to request irq 0x%x, rc %d\n",
 			   netdev->irq, rc);
-		do {
-			lpar_rc = h_free_logical_lan(adapter->vdev->unit_address);
-		} while (H_IS_LONG_BUSY(lpar_rc) || (lpar_rc == H_BUSY));
-
 		goto out_free_buffer_pools;
 	}
 
@@ -649,6 +645,9 @@ static int ibmveth_open(struct net_devic
 	return 0;
 
 out_free_buffer_pools:
+	do {
+		lpar_rc = h_free_logical_lan(adapter->vdev->unit_address);
+	} while (H_IS_LONG_BUSY(lpar_rc) || (lpar_rc == H_BUSY));
 	while (--i >= 0) {
 		if (adapter->rx_buff_pool[i].active)
 			ibmveth_free_buffer_pool(adapter,


