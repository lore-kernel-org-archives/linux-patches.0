Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3702923BCE7;
	Mon,  2 Jun 2025 14:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873469; cv=none; b=gLsGbIIcKUeTSrk1A6PItR6mIntZQR1mc5kZ0tMo6H5Dw/tKWYsP8X7C/jsQYW4G1JHWYYpy50fmKR1eIOCbc0EN0xV2z8zspu+WiY61UC1I7oPtAk9OYjl/BqhaE7HkV42u8SML4+wMJzg4Z018Nw6slkDRMupBXBmGjODV15c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873469; c=relaxed/simple;
	bh=bXZ9cNlJlhmNXn1aSi9PPyEbGcwpFKD0moVCvix72jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fj3r0OzKl+YQ+reRuJFZaci9tpGB56z0zr6nQnzYPp4InizNDjVtP2oArG+PBsfRyH9KSXdDZBUvPucgb2WZal1qAzFiMTcrm2ZiVIEx00VFpA8jQrJNo2Xk3p0qE+HttaQFDftd5PNHnuGKlDwwLaZuPjXJPhuUfAsViaQXkPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MeMiGKlE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MeMiGKlE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3A1C4CEEB;
	Mon,  2 Jun 2025 14:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873468;
	bh=bXZ9cNlJlhmNXn1aSi9PPyEbGcwpFKD0moVCvix72jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MeMiGKlE8BVP3TuKEXRwDlOz4F7P/RrYIVg/dMvIFHv04YbdOWfEMSiIhaOAp07QO
	 EfH48HX1CeLcdphI2lYQ1+DkAa5kvYD5QxIhayX1H6VZn7+Oc2srVtvgRlWvbWjIwH
	 zgdS4JdY1bfn1662ZfHSCCiegKCQs/vTIr1h2V9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 151/444] net: ethernet: ti: cpsw_new: populate netdev of_node
Date: Mon,  2 Jun 2025 15:43:35 +0200
Message-ID: <20250602134347.039932283@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9061dca97fcbf..1c1d4806c119b 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1416,6 +1416,7 @@ static int cpsw_create_ports(struct cpsw_common *cpsw)
 		ndev->netdev_ops = &cpsw_netdev_ops;
 		ndev->ethtool_ops = &cpsw_ethtool_ops;
 		SET_NETDEV_DEV(ndev, dev);
+		ndev->dev.of_node = slave_data->slave_node;
 
 		if (!napi_ndev) {
 			/* CPSW Host port CPDMA interface is shared between
-- 
2.39.5



