Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F4413BC3F;
	Wed,  4 Jun 2025 00:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998698; cv=none; b=kbdTIB2IXczN1g2uRKG3VRAwijZelqXU3JJkVNeUk9B/LTBoKTpye572l5lCLzeOqYvHCeboTkYzui4ylwf2Lf+k9m/vaLtW9BMiqirmFqkxoWiCezDGQ9NqrgfLb1MO6m6BeGUjTQ7DlfObAmRAFFsoe01O3L+xOG7QVx+Kz0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998698; c=relaxed/simple;
	bh=s/me1+62kGYLH4mhES7l9HBWFwaooK8xv4VKWBK8m7o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P9h/c53O4djyAG8RDgM+itR9VwmQj29FmZ/G3RCIDJcEgwyq4M3ENzdbkZwOmXUcrIF7zGRzajIj6Nvny0Gqrv+YuoUIBqCaW9NfQHD2L20USejefXjGTBXiDjPYNbGGtzpzxV69XaPi6g1tIFaXv9vVs51DHfX5ARim6XzjSy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R7O+qfCi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R7O+qfCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF86C4CEED;
	Wed,  4 Jun 2025 00:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998698;
	bh=s/me1+62kGYLH4mhES7l9HBWFwaooK8xv4VKWBK8m7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7O+qfCiZjn1vu/nnOa2Knqh4VMlNonXGp8sCiuTHX7HQEqWFGvIjW6FYAZWbvGRa
	 /TcK27R0Zxo+xrUmhre29Ky8UW1Dk17D/rnBpQDdc0tC+dWdltzFBGY7VITX4iRXIH
	 Zku9qJVDJXQuIIIS64rN1MgQblqF6w3bPeJ3n29kdlv4BBPnscEb0ctm6SS1smUxuW
	 ShpgknDJ1iTcAR98YAS9BaLIQZM1nhHHyWyqHHX9HYg9AXYnCOcAGOCNPD+UIw2K6y
	 PxyP+dQbAwT6Lrewc5eC2TF9Ozq8Pe6Nyj+/dlC8ve5PjRLRmAUqaduCAdMXRh1j38
	 i7rskDBFDQvVQ==
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
Subject: [PATCH AUTOSEL 6.14 080/108] bnxt_en: Remove unused field "ref_count" in struct bnxt_ulp
Date: Tue,  3 Jun 2025 20:55:03 -0400
Message-Id: <20250604005531.4178547-80-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005531.4178547-1-sashal@kernel.org>
References: <20250604005531.4178547-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
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
index e4a7f37036edb..40b2c477c239f 100644
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
index 7fa3b8d1ebd28..f6b5efb5e7753 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
@@ -50,7 +50,6 @@ struct bnxt_ulp {
 	unsigned long	*async_events_bmap;
 	u16		max_async_event_id;
 	u16		msix_requested;
-	atomic_t	ref_count;
 };
 
 struct bnxt_en_dev {
-- 
2.39.5

