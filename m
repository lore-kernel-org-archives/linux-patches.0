Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D4C2C325E;
	Mon,  2 Jun 2025 15:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877001; cv=none; b=geJIDc2NkXeLtIsKaS1UmhTmlRnzhanRdfmxXhP9eQwENLl6OaI//2K1AGpEB8aKwwEMH/ssBiYO1Vbc9NSZDoHETuxQBmUboDQNsHAq3xY5n01D1H0RW9bLc+wKzBjZPHwKfG67yeup8j/FRueiUoHqT0Uk6DWMmC2gXPpGDzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877001; c=relaxed/simple;
	bh=H0bvWsSCb4mMfjrYfGwUfh00cOZdGO79kjuogdZ5Poo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9YmON5jMy5MvV7LSOXDJdEdsV9nlkODR2UbMalPwyMwupHXd4FLtqErh6hEugbzasDx1m6+UwxrIDEb0juEJWLvO0+v4b+zcuXCXt+IjZ0mYLpUGqCXTEG3/CQbimKj1UmsMsi2aY8MaIItyrPm1uRFzO53iH6A+RtWtHZFElk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ddv2C+mV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ddv2C+mV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0774C4CEEB;
	Mon,  2 Jun 2025 15:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877000;
	bh=H0bvWsSCb4mMfjrYfGwUfh00cOZdGO79kjuogdZ5Poo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ddv2C+mVLQXFMumXdkeylWl2Sg1v7nUG1vn/8EsyK1fMubxLP0QOrxNfVevqFSwyF
	 kmiPNjMn36HNuQ+Epus0cu/Hjlngm9cTcf6ZIyuY8uK1S/opFp5e71jc9bifomUO7Y
	 HojkMUEcGzLKwiOVVDAT9ekt7i7/TxnhkInmkzMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/325] net: ethernet: ti: cpsw_new: populate netdev of_node
Date: Mon,  2 Jun 2025 15:46:26 +0200
Message-ID: <20250602134324.256337462@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6e70aa1cc7bf1..42684cb83606a 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1411,6 +1411,7 @@ static int cpsw_create_ports(struct cpsw_common *cpsw)
 		ndev->netdev_ops = &cpsw_netdev_ops;
 		ndev->ethtool_ops = &cpsw_ethtool_ops;
 		SET_NETDEV_DEV(ndev, dev);
+		ndev->dev.of_node = slave_data->slave_node;
 
 		if (!napi_ndev) {
 			/* CPSW Host port CPDMA interface is shared between
-- 
2.39.5



