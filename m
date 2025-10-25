Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAE6304BAF;
	Sat, 25 Oct 2025 16:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408791; cv=none; b=cx+z8QFpak3XqMrcXwf0PvkVHs6eHydTCrgZNHoN2xpGxIsWL34tQ84jTHNSGTBwRrRr3j0UI/1wfGMyXhEGJkM8EgYHrICZ6RLihZVqdKRukf30zeq5mw6s/6Sn/jUD5OQYXGRw11oZHPlRS0KhhjHI2v8XilAFW4rOqiES2a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408791; c=relaxed/simple;
	bh=3HAkMJcO7ME+K1UEAYvFUsJyuig8YC1GCgd672ka0Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KNt7kYc3thxN2BWwamtqySOkL2u3qDNEMpAVumOk4WsbPS8659fzxxXQckbvBaGjPpAysKUUiTfl9wzm+IpGZmm8bedCOa7scLcTY2cEjKl0oj179kQTxS/YEN87POpFhI6DPbWWfv4xJFzkoB935Hfg3S/QjEE3atdMHQ9B2Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eg5uHaSe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eg5uHaSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC6AC4CEFB;
	Sat, 25 Oct 2025 16:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408788;
	bh=3HAkMJcO7ME+K1UEAYvFUsJyuig8YC1GCgd672ka0Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eg5uHaSeepvtGBVWlzG3geIHu0YnG07IrYhodrxRkcjPizuByz70ftwBisYq3RgA1
	 xDO0eQY/g7rHzalCbJ9encqtiSKKc9xRDuLbG2XmJWh2voFINCo/zm8k3bYqjlgN++
	 peq0oaECAjU9KeaSXojsA3w3vZe8FMNKRME8vozg/cDAX4w5oPimQeAF7t2s20BXY+
	 +ysK7ipB8My30pebR3jRiq76wZMPGtSSj+i+OPUyh4aZfonKPiKuK7eeUZkZBsjiIT
	 wEsKsDRdR9X2sWBxBnjtG22yVSRk4WWFSLmoSm5fu//IytMSRyDkv9XF6yvQBytCyA
	 jQAfCxYN7PFvg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mohsin Bashir <mohsin.bashr@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	horms@kernel.org,
	pabeni@redhat.com,
	alexanderduyck@fb.com,
	sanman.p211993@gmail.com,
	lee@trager.us,
	alexandre.f.demers@gmail.com,
	suhui@nfschina.com
Subject: [PATCH AUTOSEL 6.17] eth: fbnic: Reset hw stats upon PCI error
Date: Sat, 25 Oct 2025 11:55:00 -0400
Message-ID: <20251025160905.3857885-69-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mohsin Bashir <mohsin.bashr@gmail.com>

[ Upstream commit b1161b1863c5f3d592adba5accd6e5c79741720f ]

Upon experiencing a PCI error, fbnic reset the device to recover from
the failure. Reset the hardware stats as part of the device reset to
ensure accurate stats reporting.

Note that the reset is not really resetting the aggregate value to 0,
which may result in a spike for a system collecting deltas in stats.
Rather, the reset re-latches the current value as previous, in case HW
got reset.

Signed-off-by: Mohsin Bashir <mohsin.bashr@gmail.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250825200206.2357713-3-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed and where
  - Adds a single call to re-latch hardware stats on reattach:
    `fbnic_reset_hw_stats(fbd)` in `__fbnic_pm_attach()` so stats are
    consistent after device reset, including PCI AER recovery and PM
    resume flows (drivers/net/ethernet/meta/fbnic/fbnic_pci.c:524).
  - `__fbnic_pm_attach()` is invoked on both PM resume and PCI error
    recovery:
    - From PM resume wrapper:
      drivers/net/ethernet/meta/fbnic/fbnic_pci.c:544
    - From PCI AER resume handler:
      drivers/net/ethernet/meta/fbnic/fbnic_pci.c:593
  - The reset routine itself locks and re-latches all stats fields:
    drivers/net/ethernet/meta/fbnic/fbnic_hw_stats.c:544. It uses
    `hw_stats.lock` for most stats and relies on RTNL for MAC stats, as
    documented in the function’s comment
    (drivers/net/ethernet/meta/fbnic/fbnic_hw_stats.c:558). In this
    tree, `__fbnic_pm_attach()` wraps the reset with RTNL (`rtnl_lock();
    fbnic_reset_hw_stats(fbd); rtnl_unlock();`) to satisfy
    `ASSERT_RTNL()` when `netdev` is present
    (drivers/net/ethernet/meta/fbnic/fbnic_pci.c:521–526).

- Why it’s a bug fix affecting users
  - After PCI errors and recovery (and likewise after suspend/resume),
    the device is reset and hardware counters may be cleared. Without
    re-latching the driver’s baseline, reported stats can become
    inaccurate or exhibit wrap-like artifacts. The added reset ensures
    accurate stats reporting post-recovery, matching the commit message
    intent.
  - The commit acknowledges a possible one-time spike for systems
    collecting deltas, which is a normal and acceptable behavior when
    re-basing stats after a reset.

- Scope and risk
  - Change is minimal and self-contained: a single function call in the
    driver’s reattach path.
  - No user-visible API changes, no architectural changes, and no impact
    to the fast path.
  - Concurrency is handled: `fbnic_reset_hw_stats()` uses a spinlock for
    most stats and relies on RTNL for MAC stats; the caller holds RTNL
    around the call
    (drivers/net/ethernet/meta/fbnic/fbnic_pci.c:521–526), consistent
    with the function’s comment
    (drivers/net/ethernet/meta/fbnic/fbnic_hw_stats.c:558).
  - Only touches the `fbnic` driver, not core networking or PCI
    subsystems.

- Stable backport criteria
  - Fixes a real user-visible issue (incorrect stats after PCI/PM
    reset).
  - Small, focused change with low regression risk.
  - No new features or architectural churn.
  - Clear, intentional behavior with locking correctness.

Given the above, this is a strong candidate for stable backporting. If
targeting older stable trees, ensure prerequisites exist: the presence
of `fbnic_reset_hw_stats()`
(drivers/net/ethernet/meta/fbnic/fbnic_hw_stats.c:544) and that the call
site holds RTNL when `netdev` is present (as done here).

 drivers/net/ethernet/meta/fbnic/fbnic_pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_pci.c b/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
index 28e23e3ffca88..c4d51490140eb 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
@@ -489,6 +489,8 @@ static void __fbnic_pm_attach(struct device *dev)
 	struct net_device *netdev = fbd->netdev;
 	struct fbnic_net *fbn;
 
+	fbnic_reset_hw_stats(fbd);
+
 	if (fbnic_init_failure(fbd))
 		return;
 
-- 
2.51.0

