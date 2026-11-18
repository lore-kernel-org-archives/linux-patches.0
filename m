Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042196;
	b=lep5lzdHMvdhsl/umy/7YeKq2ZhYVobmah8prgo0MhfFRIH2Q3Em19LIfW05fbrihpMN
	 SFlyj4qbAFh0moz9t1VaEjaQoIhrqI8834vdAaOu7HkawtAyh+iuzb+W41yOZS9TxeVtw
	 jh4xO4oc8QrsOvhnVCFnElP8EQnvoxHNcZ5h3Lvg6a3E9Z5DMY/xFXOnmtZTS0DRdAXzc
	 mC7fGFODRJgvwrX6XbInoEpLBKiOGS4q6HQnYqTHu6J/VrosR5INvnve7D9UbaN9+qCtk
	 3zSXXlrDieyX2jI63G7iX7Fk3VaPeFKuba/RLL3yH2S6KIT/h0Vx4qaIU4URWScG7yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LCxxa+YbUNFzYz0UFM6jgRGXMFfJBnSiHveszAr/mow=;
	b=FWeagQ8fbaVMs8SxXyMflXV6OYt8CzQUH5c3W4KgpR5tlKRw/XffBkevFO8oQ+j90qsW
	 +x41BCy9oTZMbtjArhNsG3bpiJNeUGIUe5YS1fnQWjujmA7AAp6yY9WVRHH7+CcQ8Zx0+
	 nevFb4avT/ujeI0wdbHhHE/1g/MOocHPWcw5rte68zo0/UxU4o7ARVal5gA4BFNe6h8zd
	 Kc70LY16xE1taxHMR227xWccedLJAlrfwPmT3MKv0kEBr+EalYu8DNGt+gNU12UOcy1bD
	 kHgFAwPgeZz3s2w2cP63kmjX6opZEJnlW3zViA04dCvqzTkKntTalcY2+jIDNM7KneQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="LMg/61XQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99E6606A31C;
	Wed, 18 Nov 2026 22:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LMg/61XQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7E81F000C4;
	Wed, 18 Nov 2026 22:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042196;
	bh=LCxxa+YbUNFzYz0UFM6jgRGXMFfJBnSiHveszAr/mow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LMg/61XQGURy5mDJCDF1AJd7jeByI1GqKw6o/hbK0looJipJhdapYwhQUVXW85mL0
	 5eOppMfmMgUjYlDB57bSPYpwLNEGhhv/GSctxBI8MAurCh2G8pgdpWXvS+5VfVnorK
	 3eGPFxjOoGT0noRRIzHw/kZQSk1/vjvi5zb4+Qbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3085/3318] ibmveth: return the error when set_channels cannot add TX queues
Date: Wed, 18 Nov 2026 16:01:47 +0100
Message-ID: <20261118150452.605270454@linuxfoundation.org>
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
index 9f5ab87ee5bc9..1475913c2541f 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1010,7 +1010,7 @@ static int ibmveth_set_channels(struct net_device *netdev,
 	struct ibmveth_adapter *adapter = netdev_priv(netdev);
 	unsigned int old = netdev->real_num_tx_queues,
 		     goal = channels->tx_count;
-	int rc, i;
+	int rc, i, alloc_rc = 0;
 
 	/* If ndo_open has not been called yet then don't allocate, just set
 	 * desired netdev_queue's and return
@@ -1035,6 +1035,7 @@ static int ibmveth_set_channels(struct net_device *netdev,
 		/* if something goes wrong, free everything we just allocated */
 		netdev_err(netdev, "Failed to allocate more tx queues, returning to %d queues\n",
 			   old);
+		alloc_rc = rc;
 		goal = old;
 		old = i;
 		break;
@@ -1045,6 +1046,8 @@ static int ibmveth_set_channels(struct net_device *netdev,
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



