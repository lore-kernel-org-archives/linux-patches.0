Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050294;
	b=oa4MoadQM7gdHsKUsa/lm2PUMECUIOXx8vNJQDl3cmYKuBAIt4WBsSv6Dm1rG0l+vYqC
	 pUB/goVib/nswWuBuTF4BIxXiM2Iyj3rte8umbZaZ9UtbmgYk2UuGxSYc6Ky2sYQMQFJY
	 cuUzmCFSfAFFK4iI/L/yCypzd5WxDuwY5Jy9JrGpjSr7W88l/7bKPnVk7sgFcjcqRxhvf
	 ZXrC/9+OS1ICGAwVdlSN7Lrff1znY6vmgFd0zBFIUiYDBC0lMVp7b3t1D5ZSH2RZvw6F7
	 bITqR/9ylUEUytfbgK3BVrUM3ENeU8bxd1etq6CFb+GCqkcQbglv+VOrWGJJIAACU3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+WSEm161JqE4S1qFXMSdMfRpHhdyidnFXopg7HG3fis=;
	b=mp8C92byddt0SEWmNs6rqot4HK0wtwKXkvYC6t+pXiItuyfACBvkj3nSqUc8e9fflHKo
	 lmJD/UrdOaPbSy4yTe0r2DQLvBMqpO8NgqwpdlCMYeKdLJY6DuqXX201y3zY1cjN8LbEA
	 7v6MVzOtXiohAVOJOjulGke3XyscKp9kwPVJlXzpZsbKZo4ELe5IuKBdwvdEhUjTZ6Mwz
	 5FhUl7ajR1+14rbePQQXvhHrpn9e3elCttfSiZc8rbezaKFzszwbDu1XaZVVcSsjt5AIn
	 uWxa/o8BMQWbOoZsn+JrSXnrkJixK+z4z+o+gIw7lbhXfsmwQ5SZbdQUxi+ewIA9mKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EFnkKjWO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB99606A339;
	Thu, 19 Nov 2026 01:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EFnkKjWO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203FD1F000C5;
	Thu, 19 Nov 2026 01:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050294;
	bh=+WSEm161JqE4S1qFXMSdMfRpHhdyidnFXopg7HG3fis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EFnkKjWOVpYDPAKt9pG8JvLl00sE2LkhTSNOXpJ1R1AciOhPW/13Ft4CLG0Q9w85D
	 csbRDALJAjsMlRKQLn0d5BKJ3HMyplBB7R1Ghfjq85uZmSSiLtUSTIVRR/e1pmVdf2
	 O/MvwXTbl43aysE22XLqnwI7EnJdcWEfsOlq8g4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2656/2857] ibmveth: return the error when set_channels cannot add TX queues
Date: Wed, 18 Nov 2026 16:01:30 +0100
Message-ID: <20261118150337.217023232@linuxfoundation.org>
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



