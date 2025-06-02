Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCC81FCFE2;
	Mon,  2 Jun 2025 14:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875636; cv=none; b=b8KSwWZzt2lGo2nVmmplk09Z2mcNEcFfcYDMFQPQe+70xRJbrdhKgu0APOa6HFkif8utZJMSjK5E1k8YiNOZyDOooFaEoZGvfzDsf85AzhAkHjn1oQ1ChkuUcP6yzsKGih/FqbE9xJOflI58OOelsOnpfp4vT29Npq9mgDq61eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875636; c=relaxed/simple;
	bh=gy13HvDUyaGPk/foVtk/pWXXzphSBHfahGRpyq0Znd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tF8yRiPY6SAf6cFp2VUQgziTVYVuEt6vSexT2C1Y89aVcV/+AkA2pBCf8TXxb+h9/h60Km/W3RtBA5eL32BqGeRRCMl24f+CW26++e63fyHFvF3RGYECjNsgIJ/XCADM4gsFoTW4IDJTGeyloC9WF70cCy/OfCzl4golh/1Yzg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJSkoBeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJSkoBeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53BEC4CEF0;
	Mon,  2 Jun 2025 14:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875636;
	bh=gy13HvDUyaGPk/foVtk/pWXXzphSBHfahGRpyq0Znd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJSkoBeEV8znTZkjS6LN7D7eeNw88nY1xypMMZZtqpS7b6T3d87bqRt2R4fuZSMKc
	 pEcqWNAqgk35Qx8GVBTX6HNpsOpgUx4FISopIHZIvd0QDkWLQJSe7NqqV690rVb8bk
	 p3vDI25vBGVEUHD3AYlAQGARYVp451UCvt5nqnnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 166/270] net: ethernet: ti: cpsw_new: populate netdev of_node
Date: Mon,  2 Jun 2025 15:47:31 +0200
Message-ID: <20250602134314.010363976@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a1ee205d6a889..d6f8d3e757a25 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1427,6 +1427,7 @@ static int cpsw_create_ports(struct cpsw_common *cpsw)
 		ndev->netdev_ops = &cpsw_netdev_ops;
 		ndev->ethtool_ops = &cpsw_ethtool_ops;
 		SET_NETDEV_DEV(ndev, dev);
+		ndev->dev.of_node = slave_data->slave_node;
 
 		if (!napi_ndev) {
 			/* CPSW Host port CPDMA interface is shared between
-- 
2.39.5



