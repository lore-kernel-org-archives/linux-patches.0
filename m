Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032720;
	b=4LCC/AHrSfGChDf87vcV1L1U496459mfKiF+rRKdYWEgT/Ztll3Dk9cdZrDEUZbLq8x/
	 Rf2nzMVNPfr8uGQKvJoCmdqt/p+4DOPfXpTA/fxTsMDQonib1p/+KCTXfakBal7K9bl/n
	 UBfGkh2JyxSQr0XkxIjjjXdoc1A89mJ/TlqXx5r5LONxRgqdeO85hIdV0YwjURPpoaK3/
	 P/5M+wC3H0cwAaH7zLVz/nW+KgKGXvwTpk6VqIIlxFFFib9naGn1PndUc8iOdhSyGcsNj
	 FNNjM9o90VaI55eCqmWi3OkGGnvDNYp98f2GReO8FP8d4SnayG2gQQw/qfWDHoC2eDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MHsCfi8bkCI238/TfX8vSz9vf/D68ZwAlh4EXHBLQNo=;
	b=WqdAVsZct5x7x6/UtxyroqgMv9HgopQkIOmGRLxbg5S9MWK4uwWod6RSeL8b4t3bmbka
	 5F2sO/VlyK7uLCOtBx6EKCVJdJV5v8wOUFhEhwRqbWxnmUtn1hpC6jqCbfU6WvBhzDreq
	 n85o3zNRfmjnJndaIK5w92FlWQNRFdtZLXjyLgyRnfVang+/0VQK+ojsJlSGuOH9/tq71
	 v7epaPpbMJleLARZo0Y5AQ1o5xg7THPe30m7SFpTIDbVIBdb0o44mL0a7lK+FlNJ3lNmq
	 3vZEzdU1ZZ38Tn5dOgASWz+dFZ9/m09cMo5rOfQrNBjvzq7+5GnLjW3SPVAX0fkoU/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K8MRLbpi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C586660A2611;
	Wed, 18 Nov 2026 20:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K8MRLbpi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234CE1F000C5;
	Wed, 18 Nov 2026 20:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032720;
	bh=MHsCfi8bkCI238/TfX8vSz9vf/D68ZwAlh4EXHBLQNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8MRLbpi7aRXk+Zl3NybksQgR5bypjA9Mlii/YZsiRbIPc8/BjCOp6UtD8WaDC7ib
	 c4E/iD9U+1UJRE5kpFD1msrqhv3SgA8/xc8zq8Tki4K+2CRUnm6mE/+Q7vBByjrme3
	 1MzrQiJlI0ahcjxMm2ZnaR0rbpY2kg4LEHPiiyRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1468/1756] ibmveth: return the error when set_channels cannot add TX queues
Date: Wed, 18 Nov 2026 15:59:55 +0100
Message-ID: <20261118150107.471303080@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingming Cao <mmc@linux.ibm.com>

[ Upstream commit 16abfa871dc840e55f1726408c5994c66a9773e2 ]

When ibmveth_set_channels() cannot allocate a TX buffer for a new
queue, it falls back to the old queue count, and the successful
netif_set_real_num_tx_queues() call then overwrites rc. ethtool -L
reports success while the queue count is unchanged.

Return the allocation error when the fallback succeeds.

Found in review of the ibmveth multi-queue RX series and confirmed by
code inspection. Tested on a POWER10 LPAR with the TX buffer allocation
forced to fail by a test-only module parameter (not part of this patch):
ethtool -L tx 8 now fails with -ENOMEM and the device keeps its four
queues and passes traffic. No kernel selftests cover ibmveth.

Fixes: 10c2aba89cc0 ("ibmveth: Ethtool set queue support")
Signed-off-by: Mingming Cao <mmc@linux.ibm.com>
Link: https://patch.msgid.link/20261013182926.30417-7-mmc@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmveth.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index ec99d60e239fd..bb7c21db535c3 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -987,7 +987,7 @@ static int ibmveth_set_channels(struct net_device *netdev,
 	struct ibmveth_adapter *adapter = netdev_priv(netdev);
 	unsigned int old = netdev->real_num_tx_queues,
 		     goal = channels->tx_count;
-	int rc, i;
+	int rc, i, alloc_rc = 0;
 
 	/* If ndo_open has not been called yet then don't allocate, just set
 	 * desired netdev_queue's and return
@@ -1012,6 +1012,7 @@ static int ibmveth_set_channels(struct net_device *netdev,
 		/* if something goes wrong, free everything we just allocated */
 		netdev_err(netdev, "Failed to allocate more tx queues, returning to %d queues\n",
 			   old);
+		alloc_rc = rc;
 		goal = old;
 		old = i;
 		break;
@@ -1022,6 +1023,8 @@ static int ibmveth_set_channels(struct net_device *netdev,
 			   old);
 		goal = old;
 		old = i;
+	} else if (alloc_rc) {
+		rc = alloc_rc;
 	}
 	/* Free any that are no longer needed */
 	for (i = old; i > goal; i--) {
-- 
2.53.0



