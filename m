Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211394;
	b=oJK2pAsEVNgtMcdunbOYNNb2yeoeTaLcYT+GeV2XhLVYoJaC7jbQDvM4MxlpPqweeFli
	 eeQI/IdhUamd3Q6lPWOlNuXr5/7hThQNOBBngJ0OLZLpMsWo6rfVeDq+HixkWcFrs/tkO
	 brsjS2ceVaDc1J+Z6dTGj0kZJNzEgDXo4qgwzEmnfLcNt3rpaHPeIF6EWldhyWOSPtAcT
	 LW6Qsy7wgpJJu4EW+puaEexI6JjexJz0wLAhLhy5xStJM/lMzwv9q8yc5g024pB7m1KLm
	 /SgiMBvzKtypD4+4zU2LHMT1KvsWg8om6RqyQFNLJcjWCN2Xhqg/0Cl5veQM3SIzbiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4MJEabgqZdZMJZjVntX4LBgNlZuHVm3DnYSAia6KLqk=;
	b=w6/EGsgpOl7NsGI/v1D896ny79kvyiyr62pUeDllfeFDtACaPt+LSMHbR2qJ8DbC4QIK
	 6CWPk1cP3QxdY04AB333+igq9C8q30OrIl6+z0aAOQnKQjoB78iyF0vWx0wL85VZZW3MP
	 VbyTZt1BtGApgkM+3p29tSogXgox3sFQaqggeHMspNtKBfJ9rcpvU8rU0KzZQVYjTM+ON
	 jafczo1AJIZ18jJOgNExsBcadnu/CK9Ilg7Wd4i0TL9EuUJrZ5kBBJfWY8hJJerKVoOhV
	 MH5rvk1ucDhn5YuYhllLrS5LbYOZ2iwDePIzQ5B7tNjAinJFGVynqMbuEW7Q7OOQFFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Swi7NdDm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A39606B452;
	Wed, 28 Oct 2026 18:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Swi7NdDm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA35A1F01825;
	Wed, 28 Oct 2026 18:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211393;
	bh=4MJEabgqZdZMJZjVntX4LBgNlZuHVm3DnYSAia6KLqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Swi7NdDmDpwTa+rw0T8+Kw6DgWXoasi0a8iU8ohv8FCTaxgDgf4kxkDKYxxZtwH6p
	 40CA38Nb2VUe1B7hZdvZOfxmYHVQs6VjVG9BEbBB4pfIYAmUfL0c6Zs6eNZRyZXuV6
	 F5ywqsQtPjhNUWZv5vSStxkIWUMbszWoeVhe/+2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Dave Marquardt <davemarq@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 360/571] ibmveth: h_free logical LAN on open-fail after register
Date: Wed, 28 Oct 2026 17:58:27 +0100
Message-ID: <20261028170016.557936322@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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


