Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3D41F8670;
	Tue, 27 May 2025 17:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367144; cv=none; b=YH/UdbIDKra7PjYygPvZldZgVAg22bvvU5vw4rqSvFYMp0Iv/oExaI7+FlU2f7a8Mm/Es1cWiZYg6ZHc0W0IxMydwLHm26s4xKvHtF/ZxRAEgAGHB7b0auMkix82R9xwSH5U9wK4ZStfiKQoxQ2PmXSnCoa6f+nUYh5UEwlgTfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367144; c=relaxed/simple;
	bh=WIWNxOqUaanJhc3j9ZFXRUZClUjZ14vLg8ATpjrTCLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFg+24GITDe24DeR5aTAFrHcwXklSnSmCqb8j4zb+JhDShqkVLCtPjdFC6FXOXOnTOpFlfUaDqX5ZhxZ9oMjiiS2Oc4JNz3JDAPOlElPWY+ZTE3PKUuLwVvTMhnXaID8D3KgAvPnjo1yTPegqNYnT8zVTbWq1hlFGzQ/nDafRKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NhPQIIxo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NhPQIIxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D27C4CEE9;
	Tue, 27 May 2025 17:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367144;
	bh=WIWNxOqUaanJhc3j9ZFXRUZClUjZ14vLg8ATpjrTCLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NhPQIIxoMZ99KmgZuXppU1RaWaPak69ppC+NIqNqJvAMEBvtbg+ZzRi1nyPWMrQgS
	 P4UA+22edjO0MFdMhb8r/kSnvH65sxH6uW+XC1ovTUGu7x8zKxLGQEe7TDRCKTqHpZ
	 7Xn+G0xHQzuA9hyqPfJp7Lt5LlDQx76LTpPAYSzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 293/783] net: ethernet: ti: cpsw_new: populate netdev of_node
Date: Tue, 27 May 2025 18:21:30 +0200
Message-ID: <20250527162525.016585246@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index cec0a90659d94..66713bc931741 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1418,6 +1418,7 @@ static int cpsw_create_ports(struct cpsw_common *cpsw)
 		ndev->netdev_ops = &cpsw_netdev_ops;
 		ndev->ethtool_ops = &cpsw_ethtool_ops;
 		SET_NETDEV_DEV(ndev, dev);
+		ndev->dev.of_node = slave_data->slave_node;
 
 		if (!napi_ndev) {
 			/* CPSW Host port CPDMA interface is shared between
-- 
2.39.5



