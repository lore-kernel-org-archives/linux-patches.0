Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C984E2CCC0;
	Tue, 27 May 2025 16:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365024; cv=none; b=sG2hLDeK1hkrzEmKhXPJYlmRVA64DSSksNbZ3EBAK2dmSoOGpbXpwUetDVNLZYf6mkeUbjODIfPj1smhZBkoqyjGc1NGLR5sRnlpmM7A11HlTnJfVe/wjp8lgrV1Gy2D4A68FoCW7SVDliNHf7q/JDBkpMM99tDZ0q2H0ReXKsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365024; c=relaxed/simple;
	bh=fCSZgxRJWN+lGmi2n+7yi+7N5izPfmAia9QDvQdKaX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMG5GiH7ID9e1Lb2YTXfcISG8kzzQ6+C5Wiylj8LasGUXyNbkrKwJlfp1G87Dqo53ec1tYXDuaVwhj+weag1wH734WC8Wrb6N9EJ8PvkCNihPjPB3y59i6xxoLgiTyCOGmXlX64qgoZJecwIzzyKwkyR3269OD7708mIDrK+iq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gP/+euZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gP/+euZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FFDC4CEE9;
	Tue, 27 May 2025 16:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365024;
	bh=fCSZgxRJWN+lGmi2n+7yi+7N5izPfmAia9QDvQdKaX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1gP/+euZDO1Scw2upbYbngrDp3wqtPNFotFY3CUShhtPi9YD/aQSSyjyt7+7HmL0H
	 V+/Zun0HP+MsTvjuwssHhHhNRCzOLaYnEEr5qmfxgGw1LyVryXUN+bJhoP6yxWoDHU
	 6QyDhHN4t0jTXN5cEy4Cpy825PmV6JsSZ/r0ZDsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 242/626] net: ethernet: ti: cpsw_new: populate netdev of_node
Date: Tue, 27 May 2025 18:22:15 +0200
Message-ID: <20250527162454.846107283@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

[ Upstream commit 7ff1c88fc89688c27f773ba956f65f0c11367269 ]

So that of_find_net_device_by_node() can find CPSW ports and other DSA
switches can be stacked downstream. Tested in conjunction with KSZ8873.

Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://patch.msgid.link/20250303074703.1758297-1-alexander.sverdlin@siemens.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpsw_new.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 557cc71b9dd22..0eee1a0527b5c 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1417,6 +1417,7 @@ static int cpsw_create_ports(struct cpsw_common *cpsw)
 		ndev->netdev_ops = &cpsw_netdev_ops;
 		ndev->ethtool_ops = &cpsw_ethtool_ops;
 		SET_NETDEV_DEV(ndev, dev);
+		ndev->dev.of_node = slave_data->slave_node;
 
 		if (!napi_ndev) {
 			/* CPSW Host port CPDMA interface is shared between
-- 
2.39.5



