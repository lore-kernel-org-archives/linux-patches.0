Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D57629A0;
	Wed,  7 May 2025 19:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644651; cv=none; b=oD7i+RQGm6p0AZSgRypQ0nRlVCWYuyEiKSZKB1aj1Xxjs4ScA78rPq44CmUtafe3HUyrlhpETFmFeEacg3Nsy/bn3DUUQMCUehLGti+fg7Yzc3f8Kdjx494DiuCgv7W3bDNa1hVy+gGapdbtN8x22trU8s5BS10DUCxYhlcRqEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644651; c=relaxed/simple;
	bh=fOPAJvQ0GCLjGlyD+IwvPMyg5KrYmc16zlm5RoySdng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABVk7/9+ge/jqhCBck7/apIQczUjFyiGH8JUZN1l5NzHmKP8XsRarXVaSkn59sP3QvZPt/5mWyodHgTNs38P6kfsVP3hVvT3u+7bQUVCeg9otkPFATk7bSb/Ztb0OcpJIWJM5xtrlrqBaIhfLUDVTW+juHjBVy1FdGvqcHAFEp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBaRxCxp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBaRxCxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB64C4CEE2;
	Wed,  7 May 2025 19:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644651;
	bh=fOPAJvQ0GCLjGlyD+IwvPMyg5KrYmc16zlm5RoySdng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBaRxCxpAuHpyAadmeC7Pg5xPyg8xneWX30UWr/P/E7xrKrP7OaoDwBJ9GZZ3wtHh
	 NIWnjY2ItwaZndFwoIc+hEzAmVU+U/zV9GK2Jkhh6+SaxybufGZ/Bz7I1Alg4A2e4J
	 0q+Vns0QLb86tUpNLtpn9r0xivgjx2J9SzVfB53I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 112/164] bnxt_en: Fix ethtool selftest output in one of the failure cases
Date: Wed,  7 May 2025 20:39:57 +0200
Message-ID: <20250507183825.511188448@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 8e6cc9045380f3f0c48ebda2bda5e1abe263388d ]

When RDMA driver is loaded, running offline self test is not
supported and driver returns failure early. But it is not clearing
the input buffer and hence the application prints some junk
characters for individual test results.

Fix it by clearing the buffer before returning.

Fixes: 895621f1c816 ("bnxt_en: Don't support offline self test when RoCE driver is loaded")
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index b901ecb57f255..36da52c0b9af6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -4848,6 +4848,7 @@ static void bnxt_self_test(struct net_device *dev, struct ethtool_test *etest,
 	if (!bp->num_tests || !BNXT_PF(bp))
 		return;
 
+	memset(buf, 0, sizeof(u64) * bp->num_tests);
 	if (etest->flags & ETH_TEST_FL_OFFLINE &&
 	    bnxt_ulp_registered(bp->edev)) {
 		etest->flags |= ETH_TEST_FL_FAILED;
@@ -4855,7 +4856,6 @@ static void bnxt_self_test(struct net_device *dev, struct ethtool_test *etest,
 		return;
 	}
 
-	memset(buf, 0, sizeof(u64) * bp->num_tests);
 	if (!netif_running(dev)) {
 		etest->flags |= ETH_TEST_FL_FAILED;
 		return;
-- 
2.39.5



