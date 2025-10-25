Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E1B2FF17F;
	Sat, 25 Oct 2025 16:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408993; cv=none; b=vBG7G4PIyQYLDr/iNX/lypH1fJ/+nG4+Xv4IDUcjGUxQDEA4vUsgNk8HucphxzdxJGWivwlfxKA2aTQXsMMHctYXu+dkLIr/ZMFP6s2Nf4tnIPFohxoWkFWPQZH0AFJGO/bDqtALdtOE1XHUneYybaQ0qsBshKB6htkstWCRwK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408993; c=relaxed/simple;
	bh=BQCsZ/euEk4mk5VUcdP0eXtTQrwVCGsm/RVd3a4cC88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dah+nxBSdLGm1V7LS70NZnqLTskS60S+JMDmHGBrngCJqjUwuW+Ikathk9Ey+42pGTX/G4CfOgUkpGvrmMAzEKTeinAp2d42Y4o0KaX2qTXLkLZyya7k5SSWBtT33zacNjVGvydfgpijCIX8ICDQcuaz3p4ye3j2sR0WDdAn2ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FOKdqBlR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FOKdqBlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6837C4CEF5;
	Sat, 25 Oct 2025 16:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408993;
	bh=BQCsZ/euEk4mk5VUcdP0eXtTQrwVCGsm/RVd3a4cC88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FOKdqBlR9FFYsgnsFC1LukI2Y8SYz2ClwfOib+nLEsGEwLyKMR0pEY+5GwzlEHZrP
	 1IfhyD2mRZ6tAzlE1NucZ/DSJ9OHllARaE0qOWLCjcpqVHC3chn+p949nIEkylA13f
	 zSndit+NJ2n3c1oZ3zBVpgomLTHWRqpnEkXhmz/URAB/NbwKnRnB5NfzAIfGnFsmSV
	 THpemKd1qIc6m5PUmurKVZGlLbD6DFfg0t7x6Oo+xvvxU0DrFRkd4+dOOKyIkBKuSJ
	 msWNr34/MXo5RDX6HZEKsoc9Fq++1TnzVU5UmYKeqaPqcA7Sh5I4E5fzRU7R7jBFKD
	 g35idBgcTUw/A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	kenneth.feng@amd.com,
	kevinyang.wang@amd.com,
	boyuan.zhang@amd.com,
	siqueira@igalia.com,
	arefev@swemel.ru,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-5.10] drm/amd/pm: Use cached metrics data on arcturus
Date: Sat, 25 Oct 2025 11:56:36 -0400
Message-ID: <20251025160905.3857885-165-sashal@kernel.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 2f3b1ccf83be83a3330e38194ddfd1a91fec69be ]

Cached metrics data validity is 1ms on arcturus. It's not reasonable for
any client to query gpu_metrics at a faster rate and constantly
interrupt PMFW.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed
  - In `drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c:2327`,
    `arcturus_get_gpu_metrics()` currently calls
    `smu_cmn_get_metrics_table(smu, &metrics, true);`, i.e., it always
    bypasses the cache and forces a PMFW interaction. The commit flips
    the third argument to `false`, switching to the existing 1 ms cache.
  - The callee’s API explicitly defines the third parameter as
    `bypass_cache` (see `drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h:122`),
    so `false` means “use cached metrics.”
  - The common metrics helper implements a 1 ms cache window (see
    `drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c:1013-1041`), only fetching
    fresh data if either explicitly bypassed or the last fetch is older
    than 1 ms. The per-ASIC table initialization sets `metrics_time =
    0`, ensuring the first call still fetches fresh metrics (see
    `drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c:274`).

- Why it matters (bug-like behavior and user impact)
  - The current arcturus path always bypasses the cache on every
    `gpu_metrics` query (see `arcturus_ppt.c:2327-2329`), needlessly
    interrupting PMFW for callers that poll frequently. The commit
    message states cache validity is 1 ms on arcturus and that frequent
    queries “constantly interrupt PMFW,” which is undesirable and can
    degrade performance or reliability.
  - Using the cache still guarantees data freshness within 1 ms and
    avoids spamming PMFW when clients poll faster than that. From user
    space, the only observable difference is that very high-rate queries
    (>1 kHz) won’t force a new PMFW read each time; metrics can be up to
    1 ms old. This aligns with the existing caching design and does not
    change the ABI or data layout returned by `gpu_metrics` (the rest of
    the function remains unchanged; e.g., field population and
    `system_clock_counter` at
    `drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c:2373`).

- Scope and risk assessment
  - Change is one boolean flip in a single ASIC-specific path, no
    architectural changes, no cross-subsystem effects.
  - It leverages existing, well-tested caching in
    `smu_cmn_get_metrics_table()`; behavior falls back to the exact
    update path after at most 1 ms (`smu_cmn.c:1022-1035`).
  - Initial fetch correctness is preserved because `metrics_time` starts
    at zero (`arcturus_ppt.c:274`), so the first call is always fresh.
  - Potential side effects are minimal: clients polling at sub-
    millisecond rates may see identical metrics across calls within a 1
    ms window, which is explicitly intended by the caching policy and
    called out in the commit rationale.

- Stable backport criteria
  - Fixes a real, user-facing problem: unnecessary PMFW interruptions
    from high-frequency polling, which can affect performance and system
    behavior.
  - The change is small, contained, and low risk (one-argument change).
  - No new features or ABI changes; it aligns arcturus with the existing
    1 ms caching policy implemented in common code.
  - No major architectural changes or complex dependencies; the function
    signature and caching logic already exist in stable trees.

Given the minimal, targeted nature of the change, its alignment with
existing caching semantics, and the clear benefit of reducing PMFW
interruptions without altering user-visible interfaces, this is a good
candidate for stable backporting.

 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
index 9ad46f545d15c..599eddb5a67d5 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -1897,7 +1897,7 @@ static ssize_t arcturus_get_gpu_metrics(struct smu_context *smu,
 
 	ret = smu_cmn_get_metrics_table(smu,
 					&metrics,
-					true);
+					false);
 	if (ret)
 		return ret;
 
-- 
2.51.0

