Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A91530E84B;
	Wed, 28 Jan 2026 15:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615800; cv=none; b=OpXxMdL6yVSR95OWt5BJYb1gpvCtQp8KuXEFWreKV6DqT9lD2/eM4tac7mrz0suqBxqeEs0NQHYQUgg18jKbmTtTUY2KyhpjLDUfIvLafWLHvHS5IwOOCYxDUnzHv+9+U+7CAwSG4OLNQR1iJh5t5J+Rf7ILGuIh0S0O6CfYsR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615800; c=relaxed/simple;
	bh=EVs4kYKepU8rjJ3+OPL3uqkR/vX+DqZMZdvdN0ee5R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDXGQ3Czob+KTuD0jBVbD/LorSvYZM9kMxufDYcOqGCRrBE0kQnjDnneHylS/Flpn4KdPdi2Q/5scqk3qgo7UVaN7svlrqGYUVzWL6iYozvIFVxVZ/QxNwBCkgkAhi+H0UnLrk88U5Si/PyGf+3/3ejIl4GzpggP4FjCAT49kSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dGgeJPBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dGgeJPBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3687C4CEF1;
	Wed, 28 Jan 2026 15:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615800;
	bh=EVs4kYKepU8rjJ3+OPL3uqkR/vX+DqZMZdvdN0ee5R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dGgeJPBLfX4f8/V1KKjc25IjwNETUQfPddBfu929M1P2K9mYJmEDrsiKv45fym9px
	 r989138x7+ZAlFoiPcBhshU1ujNwUfZ5vtNnZAVU4TxfLaeDwhLuANCZIgshUPR0MM
	 fq3FEigMAq4SE2E/252Y4ZpX38a6cy0EAXISzxJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 117/227] Octeontx2-pf: Update xdp features
Date: Wed, 28 Jan 2026 16:22:42 +0100
Message-ID: <20260128145348.675287478@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit cdf8de9c6bfe94508d251cb290ee66e34e6f3368 ]

In recent testing, verification of XDP_REDIRECT and zero-copy features
failed because the driver is not setting the corresponding feature flags.

Fixes: efabce290151 ("octeontx2-pf: AF_XDP zero copy receive support")
Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Link: https://patch.msgid.link/20260119100222.2267925-1-hkelam@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index e808995703cfd..a7a7bc0e1b675 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -3255,7 +3255,9 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
 
 	netdev->netdev_ops = &otx2_netdev_ops;
-	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT;
+	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
+			       NETDEV_XDP_ACT_NDO_XMIT |
+			       NETDEV_XDP_ACT_XSK_ZEROCOPY;
 
 	netdev->min_mtu = OTX2_MIN_MTU;
 	netdev->max_mtu = otx2_get_max_mtu(pf);
-- 
2.51.0



