Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027567;
	b=HvXhzLDvu7W772gb7EWUGjH645TT3N5cH/dbu6Ink038px9kJK1oDtTGWrtTjOQIinrj
	 dXBvPIY3TOhYMSAU9VfensRayQINQKlxqnBV+mdnVFRtkU1dikhxFsV/Q3oCit7U22775
	 3ILsIsyRED3YZO1ssy+FbwGHP1iwuv+LZRzNoDcJhQS8Ck7UWp/Twe9Wt0RWU/X3OaVMB
	 vDdCjYKtxWRiQ2SvpUOGdajusRHSbOjRuNPLtw6bZHLpHiu04NnyK4j4ZTDv5BvSrLX4U
	 JNqv/PlplYNldH20w5sqypRtAV6HzTWH7ebKGOViu3x7v0pBPj5KBFWeI6FpcYVLOCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fdH24ulKXpSVrv+bf3rein71oBA5NOnASntHRJJX0TQ=;
	b=27vaK22fjT4IiO734hag6VV2kfnLN40Scc96F/dJ44cd4oAjQNUEFUdkAHEEsXvPQ+ic
	 t4MYAK1OpfHS30uEVujdN44H/0X3VjlTbGTS1Dv89C5AVX1uTdmV0Pyz7+gwNtf702MNe
	 K7Vv5NzGnLjA62YY/lvx6c1+HYTlMgD6xrM0L6EUh+stsJhSlKTejyY5DvF1Aa9edRA1n
	 HAFze+V8C/FUopYXf1b0CLDl5753zMA/iuFfPSD6scmaSJo5uYpPoQXhV7YmkZNfGTnKJ
	 QCTQsRD4jeUAB5UbyLy3acFwAjn1HR27pbmIXGJ3ocxU9ZPCF/SQlA9VYoAbDtjydxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nGDMz1XD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AFA60A2604;
	Wed, 18 Nov 2026 18:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nGDMz1XD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08211F000C4;
	Wed, 18 Nov 2026 18:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027567;
	bh=fdH24ulKXpSVrv+bf3rein71oBA5NOnASntHRJJX0TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nGDMz1XDh6j27lhz0Yazd6PoHNK1ezZr6yuBe8H8lN03sm4FJR6hQv5vWnDxWUEIP
	 RjmKPa8D5KELNplGD7RK/FVum3JmLmqOIm28hYF3TdQaJyLlKoHDz6tIX3CkjRZC4y
	 ltZWVgys/aFL7YeP7E2I5Md+5aH1CHsJ/eogZBTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1836/2151] ibmveth: return the error when set_channels cannot add TX queues
Date: Wed, 18 Nov 2026 15:59:31 +0100
Message-ID: <20261118150228.681380655@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2d6f61bfb4953..8fddded94a5b6 100644
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



