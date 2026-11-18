Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021422;
	b=Rik1iownDgaSMjV8Vs3P5APN9xCkbyyIxsWgmklt6g5Bz106dbVgwRAKuu0h2Mh0tJQp
	 2opi4BFe/AoGr4RmH9/TUrgJFUJHhwxSoggpDuX86QPGUcZNylRIeN7Vdh+iW1p5lW2Kv
	 m8POOwFePsza/nHFbW4b3Sd1euF8XD9a47RyEja+dotQe3q1egyYs9iARGUiVpfs889Mq
	 Pqyn5i+AjhRB5cMf0Ra7HXHDN2lU3EuNGgiOGx22sOGPXBcwK2BCvhhjgWxGJS8Pn+nnU
	 sZxEpbF6eaJCD5NPMEYEDBm2JhB3FT1QR5ebrF7eHZpoChnogzW/Rdo10BHAgAXZk1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E4aNPDLFsJfF0FTQEiCMTcVBGmkerWI8sbplr9tQEPw=;
	b=QGZxaLWc25zYQGP8mPg85FrTZHFe+oeBKgRe9IaCiWMEK1aSPDwNetSAEsXzryxQ7lJu
	 g+VP0sJ7qBay9foZYM7gEjBmMpUukYwyM7iIJFWaegZi49q8+j0soEIXBg03fbvxlCH+7
	 FRLX0ridRqa4nkTzv59J0BXfcQb1h2Gaf5cUjotrBD8zBjbK4zago/LbuuD9BBwyjjDvd
	 5nND66XiiKb+/jY0f6gIwcERaPafvIoBkU8WmwqTzFI3I3+i9dvDltEG7+C0R5/amNZP/
	 bnPJwxWXbm7RA3YvvySjAQcf7cQE7rkuAS9v7QO7Lp38EmLNrffK5+Q+btPQNC3Ze6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZT8bd/ZH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD0160A3822;
	Wed, 18 Nov 2026 17:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZT8bd/ZH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD95D1F000CB;
	Wed, 18 Nov 2026 17:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021422;
	bh=E4aNPDLFsJfF0FTQEiCMTcVBGmkerWI8sbplr9tQEPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZT8bd/ZHFezGkYJBZqRj7GlONStY+y1zpFPkFRASmiYcDbV5sKsC1vanMmp4U/XiV
	 YWfE6XZ7hzUOCSjHw7pyxZ4iL3X4p7etkae9jZkwBfrxgCknZQWiHJyoJqSaeQl4yV
	 eBYHCLUIBUYj77+CbFRJlB67a7D8t81aBjK+qShs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2274/2651] ibmveth: return the error when set_channels cannot add TX queues
Date: Wed, 18 Nov 2026 15:58:34 +0100
Message-ID: <20261118150407.202087325@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 42aa9f7bd49de..48bc4406396bd 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1177,7 +1177,7 @@ static int ibmveth_set_channels(struct net_device *netdev,
 	struct ibmveth_adapter *adapter = netdev_priv(netdev);
 	unsigned int old = netdev->real_num_tx_queues,
 		     goal = channels->tx_count;
-	int rc, i;
+	int rc, i, alloc_rc = 0;
 
 	/* If the device is not open (including a failed close/open with
 	 * IFF_UP still set) then don't allocate, just set desired
@@ -1203,6 +1203,7 @@ static int ibmveth_set_channels(struct net_device *netdev,
 		/* if something goes wrong, free everything we just allocated */
 		netdev_err(netdev, "Failed to allocate more tx queues, returning to %d queues\n",
 			   old);
+		alloc_rc = rc;
 		goal = old;
 		old = i;
 		break;
@@ -1213,6 +1214,8 @@ static int ibmveth_set_channels(struct net_device *netdev,
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



