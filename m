Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DE83064A9;
	Sat, 25 Oct 2025 16:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409669; cv=none; b=cOJkCGqYHahLrgp+Nv//1kTWjgSPLSp8BEoW7iBOrCOjPPLYBHammBfn9WKoaZkZAIqVN3rebjTJBq865uCTYAmjdqVWX5kgpMfTb2qgo8Im6m/kdH834jw77D902tdv6ecc9KnLf0zIh6y7ndBPZpG4UaixeAQjYcOIqqrQq7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409669; c=relaxed/simple;
	bh=xQZK4uLLtGRjL5ZWHx8WxBgKxJ62sIzQXB4sPhO00uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EdUqKAb+4089iVps9Gi3D0pLdPBzkLvYGJ9P0IX8LR9t/M3y8Fyrl7ye1k3O4xYrDrZAgY8GkOTFPwpbbsJQ3JN/DWx54hVI+7SlLLcN7uuiCV6kDBiW3eMoqmSQM+AuKFLU+3S2zixJVJcL+JRu5YS8MwGQ35Lbcp2eReDmdMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rhkYJwxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rhkYJwxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9226C4CEFB;
	Sat, 25 Oct 2025 16:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409669;
	bh=xQZK4uLLtGRjL5ZWHx8WxBgKxJ62sIzQXB4sPhO00uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rhkYJwxtaMWZKqatFlGe7zKAtqqdv8KjYfB4NYJ/OPVmBAiTEekjy+xK4A6+gty5o
	 KfZdbO8iLzaBS1/HEGsBQJbA5ieFjU8UkEGRoKsZUFQxNu6fE0vyuE80lcqY0pCm9t
	 hiFQXsE4VYtaRs05gH8GKk1CHg5gqOut4i8wQdzGd+OncCVVuZc/05KiUDN+8/Uoc1
	 k0HOCWJCNQJQxvs68B3114Ca9RcARUShwhhSvZQNEHJ153Iu6lfI9DTsotzBfdhnhJ
	 zBhG3l/FcokrBvvQY6tIctWOokx7+fvJ3XFB7W3hvXga5vNaFZNwEZu2ybUqfGgaWG
	 qj63CmQo8uMOA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jdamato@fastly.com,
	ecree.xilinx@gmail.com,
	noren@nvidia.com,
	gal@nvidia.com,
	alexandre.f.demers@gmail.com,
	dxu@dxuuu.xyz
Subject: [PATCH AUTOSEL 6.17-6.12] selftests: drv-net: rss_ctx: make the test pass with few queues
Date: Sat, 25 Oct 2025 12:00:44 -0400
Message-ID: <20251025160905.3857885-413-sashal@kernel.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit e2cf2d5baa09248d3d50b73522594b778388e3bc ]

rss_ctx.test_rss_key_indir implicitly expects at least 5 queues,
as it checks that the traffic on first 2 queues is lower than
the remaining queues when we use all queues. Special case fewer
queues.

Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250901173139.881070-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - The test `test_rss_key_indir` implicitly assumed ≥5 Rx queues and
    could fail on devices with fewer queues. The patch makes the test
    robust on systems with 3–4 queues by tailoring the verification to
    the queue count. This corrects a real test bug that affects users
    running kselftests on lower-end hardware.

- Specific code changes
  - Queue count awareness and early skip:
    - `tools/testing/selftests/drivers/net/hw/rss_ctx.py:119-121`
      computes `qcnt = len(_get_rx_cnts(cfg))` and skips the test when
      `qcnt < 3`. This avoids running the distribution checks where they
      don’t make sense.
  - Preserve existing check for many queues:
    - For devices with >4 queues, the original logic remains: verify the
      first two queues get less traffic than the remainder after
      restoring default RSS distribution
      (`tools/testing/selftests/drivers/net/hw/rss_ctx.py:181-184`).
      - `ksft_lt(sum(cnts[:2]), sum(cnts[2:]), "traffic distributed: " +
        str(cnts))`
  - Add a correct check for few queues:
    - For devices with 3–4 queues, instead of the sum-of-rest comparison
      (which is ill-suited for small N), ensure the third queue receives
      a significant packet count
      (`tools/testing/selftests/drivers/net/hw/rss_ctx.py:185-187`):
      - `ksft_ge(cnts[2], 3500, "traffic distributed: " + str(cnts))`
    - This aligns with the generated 20k packets; with uniform
      distribution across 3–4 queues, a 3.5k threshold is conservative
      and avoids the previous false-negative behavior.
  - The earlier part of the test verifying that setting `equal 2`
    restricts traffic to the first two queues remains unchanged and
    valid (`tools/testing/selftests/drivers/net/hw/rss_ctx.py:165-173`).

- Scope and risk
  - Change is confined to kselftests under `tools/testing/selftests/…`;
    no kernel runtime or ABI impact.
  - The logic is minimal and targeted; it preserves existing behavior
    for devices with >4 queues and only adjusts validation for small
    queue counts.
  - Regression risk is low. The 3.5k threshold is permissive given the
    20k packet generation and normal RSS distribution, while still
    detecting misconfiguration.

- Stable criteria assessment
  - Fixes a test reliability issue that affects users running kselftests
    on stable kernels with fewer queues.
  - Small, self-contained change with no architectural impact.
  - No new features introduced; purely a test correctness adjustment.
  - While there is no explicit “Cc: stable” tag, stable branches
    commonly accept selftest fixes that improve test reliability and CI
    signal quality.

Given the above, this is a low-risk, test-only bug fix that improves
selftest correctness on a broader set of hardware. It is a good
candidate for backporting.

 tools/testing/selftests/drivers/net/hw/rss_ctx.py | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/hw/rss_ctx.py b/tools/testing/selftests/drivers/net/hw/rss_ctx.py
index 9838b8457e5a6..4206212d03a65 100755
--- a/tools/testing/selftests/drivers/net/hw/rss_ctx.py
+++ b/tools/testing/selftests/drivers/net/hw/rss_ctx.py
@@ -178,8 +178,13 @@ def test_rss_key_indir(cfg):
     cnts = _get_rx_cnts(cfg)
     GenerateTraffic(cfg).wait_pkts_and_stop(20000)
     cnts = _get_rx_cnts(cfg, prev=cnts)
-    # First two queues get less traffic than all the rest
-    ksft_lt(sum(cnts[:2]), sum(cnts[2:]), "traffic distributed: " + str(cnts))
+    if qcnt > 4:
+        # First two queues get less traffic than all the rest
+        ksft_lt(sum(cnts[:2]), sum(cnts[2:]),
+                "traffic distributed: " + str(cnts))
+    else:
+        # When queue count is low make sure third queue got significant pkts
+        ksft_ge(cnts[2], 3500, "traffic distributed: " + str(cnts))
 
 
 def test_rss_queue_reconfigure(cfg, main_ctx=True):
-- 
2.51.0

