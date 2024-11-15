Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E825126C17;
	Fri, 15 Nov 2024 06:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652980; cv=none; b=afYq+AZbUwYQxrcHLWZtooVFoeM7dEqoD7a2Iy09hHGMqN7m829vCrVgq2jEjgEVYq/XWnnmhEa4UAlQtzZ8Wt89MpbfW+M8+3+6kUUXTJPq8CsoHru98CWG6Rft3v2a+AKnU1u/aWazwxS2wdHdgGTMufggPaGgTCNqbrz1vRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652980; c=relaxed/simple;
	bh=iVhtID9v1oDO4HXznVIx4/k7JCPktUWibIkXvVFrNbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JswuvXNMN/Kv3tOJE7sYuYEgVCgjOAb4iF7uDL8pM5MXcUcsdgJGEIYv1/DX3+hvVwK2S+cfDnHvNjbGczIFZ7V5E7w6nfYGGlD7sii1GATvr4qGt8K6FcUoo+NkvY5SVJPzlffBRr6MDLxnaqPWM1cmcVF9A4xz28jtpvFHNe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/mN5sM/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/mN5sM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93AA1C4CED2;
	Fri, 15 Nov 2024 06:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652980;
	bh=iVhtID9v1oDO4HXznVIx4/k7JCPktUWibIkXvVFrNbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/mN5sM/r9mOsTVO9UKCVY1BdpC9yPJIVDrD+xKVKZOcwJjMb3RxDch+q9vV94I9U
	 ndZgGVmWyuXzrVaVoou3gOjmtWTOcyQi8yYVajBewkDHtd5cXaMz0wUNNPlNRCLJSF
	 o6O/5CpqypwCJlKseeRY7nI7EEuFdIk8q+4sTzM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qinglang Miao <miaoqinglang@huawei.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/66] enetc: simplify the return expression of enetc_vf_set_mac_addr()
Date: Fri, 15 Nov 2024 07:37:20 +0100
Message-ID: <20241115063723.249949245@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit d4b717dd2009f9003a5b4844a0e0ae0370d4c506 ]

Simplify the return expression.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: badccd49b93b ("net: enetc: set MAC address to the VF net_device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_vf.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 3a8c2049b417c..af287b6d5f3b7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -85,16 +85,11 @@ static int enetc_vf_set_mac_addr(struct net_device *ndev, void *addr)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct sockaddr *saddr = addr;
-	int err;
 
 	if (!is_valid_ether_addr(saddr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	err = enetc_msg_vsi_set_primary_mac_addr(priv, saddr);
-	if (err)
-		return err;
-
-	return 0;
+	return enetc_msg_vsi_set_primary_mac_addr(priv, saddr);
 }
 
 static int enetc_vf_set_features(struct net_device *ndev,
-- 
2.43.0



