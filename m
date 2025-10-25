Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743D6302170;
	Sat, 25 Oct 2025 16:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409474; cv=none; b=uRvRg4uItBqwDpeXZ7XZ7bhZZ8riWKNBzpyNJ1OiSLSKDhmHPdxivNUblut1576RGJLLNF2sExIbGrtDPJI3kjASraSdTogitUy6Zv+x8Wj+gwiNkSFf5+YjhX+JvMhfF/gfkhHJpom4DdwGTBQ593tf65nJLj/otRq7ZNhFPts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409474; c=relaxed/simple;
	bh=GTxVOa0VbUSL1MuHYcq/Cc8rrGIluIhNb90I3U7hTGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J+RAghfmzdCNLUL6xQdVhURZmEL59nDY1HRT1/T2Nlv+cdi6n+5sm7fMgVfyIjIqaq7vfFBdtNjfiPxkInW18GYzndilze/FpxxpG1a81R5+1gTLdG6S1egM3AYzn3bxUVU1CW0qO76JY07KcrDzbcal56iEAemH2ZYiBSDKSTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qCH+YTNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qCH+YTNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723B6C4CEFB;
	Sat, 25 Oct 2025 16:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409474;
	bh=GTxVOa0VbUSL1MuHYcq/Cc8rrGIluIhNb90I3U7hTGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qCH+YTNVqJh7OYKAw+6HADWuP70NqG3OMydbueYj0wzMyYrf14SSSk4/vq3OvgK0D
	 aIgswLPKqbKEVGc1baYBs+qGKefDYVtw/Q0WyidxVMK/KB1VK48PeY3MVdiRYimkhg
	 9hYoT9q2oux/oQFJY9OHal1RHRn80LFIH9lU6J3HVhvmg/14FdQ8352qv0qyw8TtC0
	 CLNUe2NmUtCRB2APLpu4YG4aiQTdBzk/4lnTQQN0UkPvJXW/B/ptyk9R30kpfapO84
	 2lf2f3K7dtMdsh94S+yiVK66RbNlLMkdFwdNPO4yV9K8yY5FPDvQmKXGi/sqZA1GVq
	 /nL9la4uDl2Gw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yue Haibing <yuehaibing@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	dsahern@kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.10] ipv6: Add sanity checks on ipv6_devconf.rpl_seg_enabled
Date: Sat, 25 Oct 2025 11:59:29 -0400
Message-ID: <20251025160905.3857885-338-sashal@kernel.org>
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

From: Yue Haibing <yuehaibing@huawei.com>

[ Upstream commit 3d95261eeb74958cd496e1875684827dc5d028cc ]

In ipv6_rpl_srh_rcv() we use min(net->ipv6.devconf_all->rpl_seg_enabled,
idev->cnf.rpl_seg_enabled) is intended to return 0 when either value is
zero, but if one of the values is negative it will in fact return non-zero.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Link: https://patch.msgid.link/20250901123726.1972881-3-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - In `ipv6_rpl_srh_rcv()` the decision to process RPL SRH uses
    `accept_rpl_seg = min(net->ipv6.devconf_all->rpl_seg_enabled,
    idev->cnf.rpl_seg_enabled);` and then checks `if (!accept_rpl_seg)`
    to drop packets. A negative value for either sysctl makes `min()`
    negative (non-zero), which is treated as “true”, unintentionally
    enabling processing when it should be disabled. See
    `net/ipv6/exthdrs.c:497` and `net/ipv6/exthdrs.c:499`.
  - The change bounds `rpl_seg_enabled` to 0..1 via sysctl, preventing
    negative values and restoring intended boolean semantics.

- Code changes and their effect
  - Sysctl registration for `rpl_seg_enabled` switches from
    `proc_dointvec` to `proc_dointvec_minmax` and adds bounds:
    - `.proc_handler = proc_dointvec_minmax`, `.extra1 = SYSCTL_ZERO`,
      `.extra2 = SYSCTL_ONE` at `net/ipv6/addrconf.c:7241`,
      `net/ipv6/addrconf.c:7242`, `net/ipv6/addrconf.c:7243`.
  - This mirrors existing practice for boolean-like IPv6 sysctls (e.g.,
    `ioam6_enabled` immediately below uses min/max too;
    `net/ipv6/addrconf.c:7246`).
  - The sysctl table is cloned for `conf/all`, `conf/default`, and each
    device. Critically, when cloning the table the kernel only fills
    handler “extra” fields if both are unset; since this patch sets both
    `.extra1` and `.extra2`, the bounds are preserved for per-net/per-
    device sysctls as well:
    - See the cloning logic guarding extra fields at
      `net/ipv6/addrconf.c:7315`–`net/ipv6/addrconf.c:7318`.

- Why this is a good stable backport
  - Bug impact: Admins (CAP_NET_ADMIN) could inadvertently set a
    negative value (e.g., -1) and expect “disabled”, but the code
    interprets it as enabled due to non-zero truthiness. This causes
    unintended acceptance of RPL SRH packets, affecting system behavior
    and potentially security posture.
  - Scope: Single-field sysctl bounds change; no functional
    restructuring or architectural changes.
  - Risk: Minimal. Values >1 or negative will now be rejected, aligning
    with boolean expectations. No in-tree code relies on non-boolean
    semantics; `rpl_seg_enabled` is only consumed as a boolean via
    `min(...)` and `if (!accept_rpl_seg)` in
    `net/ipv6/exthdrs.c:497`–`net/ipv6/exthdrs.c:499`.
  - Consistency: Aligns `rpl_seg_enabled` with other similar sysctls
    that already use min/max bounds.

- Conclusion
  - The patch is a small, contained bugfix enforcing correct boolean
    semantics and preventing misconfiguration from bypassing the
    intended disable path for RPL SRH processing. It fits stable rules
    and has very low regression risk.

 net/ipv6/addrconf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f17a5dd4789fb..40e9c336f6c55 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7238,7 +7238,9 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.data		= &ipv6_devconf.rpl_seg_enabled,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = SYSCTL_ZERO,
+		.extra2         = SYSCTL_ONE,
 	},
 	{
 		.procname	= "ioam6_enabled",
-- 
2.51.0

