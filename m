Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF78433D9;
	Wed,  4 Jun 2025 01:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998890; cv=none; b=ccLHKZHzOBh6rknLifmoGODaAbJubSnaLqVbNTXMIu+MxNPPXdRTcxnxTMYrec+4wUBxbiHvD0EIu9eeCVEkRJspMX6nP9rfZ81y+Xh0ylWu2fSqVW27r0ShaYWfucBnukk9GK1qD/erXWPlqKoUoAs//S/x8NtEybalJCCRYbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998890; c=relaxed/simple;
	bh=UTGodAg1s9ok1dCkRdB3ZF5myQ6C3T5C46rwnQRvuls=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pgAib59EPUc/oLKOY38oSX8klfNSd5KAPLckm0WA486OftgLKHnd/PGaiVOXrzuINpl++aSUUIfPXFtHMTWsZ1LPvM/LYyLzkXH6PeP+OVz5Y3m65oP6O49rWCaiZ0Ib8W5QbpgG1jHikPgTFBmii77l43QprLvloaMiK6T7bHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GLU/a5ml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GLU/a5ml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2AA5C4CEED;
	Wed,  4 Jun 2025 01:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998890;
	bh=UTGodAg1s9ok1dCkRdB3ZF5myQ6C3T5C46rwnQRvuls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLU/a5ml9ZJhixKa/hDJtCUk/8076U2Ty+5TTn7oGYCECVjKGQaDMXRGAJvyZBZgQ
	 UMK/8LA9MzMIjuoDra7gDGrecFaxhVisp2OTuLvIZ34lG16TUJ0TXpJPU7LuJrUfSN
	 9wvwwiCu7GKXC8mRNZwyAGDytAkYfw6Nnyiyk8TP1lsvdPvdV3tMMGf/HGFeOla/EV
	 8EfeLWsCslmu/4kfIpYCkJSBtpY+MHrljRtOqcn7wgxh5ypScLRCUKYyHMxjCCMLHn
	 ntDruyEd/tHek4UKEUH8Zdr0XjXK3pQ6GCwr9U2c7rV31eS0SyEDRcuEI3hxtpf0lU
	 1u3ff59hIprgw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	pavan.chebbi@broadcom.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 71/93] bnxt_en: Remove unused field "ref_count" in struct bnxt_ulp
Date: Tue,  3 Jun 2025 20:58:57 -0400
Message-Id: <20250604005919.4191884-71-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005919.4191884-1-sashal@kernel.org>
References: <20250604005919.4191884-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
Content-Transfer-Encoding: 8bit

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 5bccacb4cc32cb835fe2fe100a210332c494e81d ]

The "ref_count" field in struct bnxt_ulp is unused after
commit a43c26fa2e6c ("RDMA/bnxt_re: Remove the sriov config callback").
So we can just remove it now.

Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250417172448.1206107-4-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees.
**Analysis:** This commit removes an unused field `ref_count` from
`struct bnxt_ulp` and the associated code that was waiting for the
reference count to reach zero during unregistration. Looking at the code
changes: 1. **Removes unused field from struct definition**
(bnxt_ulp.h:49): The `atomic_t ref_count;` field is completely removed
from `struct bnxt_ulp`. 2. **Removes dead code** (bnxt_ulp.c:151-162):
The commit removes a loop that was waiting for
`atomic_read(&ulp->ref_count) != 0` with sleeps, which is now
unnecessary since the field and its usage were removed in a previous
commit (a43c26fa2e6c). **Why this should be backported:** 1. **Code
cleanup with no functional impact**: This is a pure cleanup commit that
removes truly unused code. The `ref_count` field was made unused by a
previous commit that removed the sriov config callback. 2. **Follows
stable backport patterns**: Looking at the similar commits, particularly
Similar Commit #1 which was marked "YES" for backport, this commit has
the exact same characteristics: - Removes unused functions/fields -
Small, contained change - No risk of regression - Code cleanup that
improves maintainability 3. **No architectural changes**: The commit
only removes code that was already dead/unused, with no changes to
active code paths. 4. **Minimal risk**: Since the code being removed was
already unused (as confirmed by the commit message referencing the
previous commit that made it unused), there's zero risk of regression.
5. **Clear precedent**: Similar Commit #1 showed that removal of unused
code (`bnxt_subtract_ulp_resources()` function and making
`bnxt_get_max_func_irqs()` static) was considered appropriate for
backporting. This commit fits the stable tree criteria perfectly: it's a
low-risk cleanup that removes dead code without affecting functionality,
similar to other cleanup commits that have been successfully backported.

 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 5 -----
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h | 1 -
 2 files changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index 546d9a3d7efea..b33c29fdf8fd3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -148,7 +148,6 @@ void bnxt_unregister_dev(struct bnxt_en_dev *edev)
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
 	struct bnxt_ulp *ulp;
-	int i = 0;
 
 	ulp = edev->ulp_tbl;
 	rtnl_lock();
@@ -164,10 +163,6 @@ void bnxt_unregister_dev(struct bnxt_en_dev *edev)
 	synchronize_rcu();
 	ulp->max_async_event_id = 0;
 	ulp->async_events_bmap = NULL;
-	while (atomic_read(&ulp->ref_count) != 0 && i < 10) {
-		msleep(100);
-		i++;
-	}
 	mutex_unlock(&edev->en_dev_lock);
 	rtnl_unlock();
 	return;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
index 4f4914f5c84c9..b76a231ca7dac 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
@@ -48,7 +48,6 @@ struct bnxt_ulp {
 	unsigned long	*async_events_bmap;
 	u16		max_async_event_id;
 	u16		msix_requested;
-	atomic_t	ref_count;
 };
 
 struct bnxt_en_dev {
-- 
2.39.5

