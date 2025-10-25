Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B89303A1A;
	Sat, 25 Oct 2025 16:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409172; cv=none; b=DCFFEphJjiu/PrgpDMTUqZLSwx1qeOdFdZRKn1TNpO/7MUpC85Q9MxmRkU3FUZMFK3jqckKIbGbEHCh3Zcz74PTt+M01zxEX+TehcV+Epn4i7x2xvNZp8cd2L1quXhQ1rYwAVAlJECk4+2HKEU2jM1yrkWSFN0pA+5CWrt7H8Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409172; c=relaxed/simple;
	bh=bhjmNycavTx9SKMSjN5+rFGtU28kgwO7XO7XDfPh2eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XFhYl+tA5tCh1CLufMej+NZTn4owaApeHXu6R1ZPfEBaIfmq9i1gAN/7IWnEr4NYYQp84AXGK9FR+6pSndAQEfzkhsxvDn6ou8OokJmV9bqA6p0Teyk/O0mDZ/ksTGobG4QIe8eIz6EFRU0XlKSaVv6fFTKn6ZiQZBh1343w0b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NoLuJ5Mb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NoLuJ5Mb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC18C4CEFB;
	Sat, 25 Oct 2025 16:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409171;
	bh=bhjmNycavTx9SKMSjN5+rFGtU28kgwO7XO7XDfPh2eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NoLuJ5MbDlqn+mnQfvcn1iYO/Qw5ruJEZl/+tTdUnVV3ojstDDic7G4mOku25uTnc
	 +wKVm8WQKJgteWFRMszFTKAcsEuptHPXd/27o0UI5un96ds18n6eDHBEDyBezjO4AJ
	 dU/t3CTCYoMhtkITgHPSPVy3QBG4k2BQtForQMfZ4H2DYGEiuFmDVDGQcKr/JodB6L
	 VH3ANxCpctdQwBXJdJc4hQCSwjP/viE6rI8xwH1chNTW2WBLTW+cOKn6biAByMrVpc
	 J3XuHE4nEr+HhvY0bHJNBo4p0wlMkJcze+Cnv/8ETVzmmNYJNRlPsLc4b2aKhVgWN2
	 1cYYXnNf8cKHw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	siqueira@igalia.com,
	Hawking.Zhang@amd.com,
	alexandre.f.demers@gmail.com,
	linux@treblig.org
Subject: [PATCH AUTOSEL 6.17-5.15] drm/amd/pm: Use cached metrics data on aldebaran
Date: Sat, 25 Oct 2025 11:57:40 -0400
Message-ID: <20251025160905.3857885-229-sashal@kernel.org>
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

[ Upstream commit e87577ef6daa0cfb10ca139c720f0c57bd894174 ]

Cached metrics data validity is 1ms on aldebaran. It's not reasonable
for any client to query gpu_metrics at a faster rate and constantly
interrupt PMFW.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Rationale
- What changed: In
  `drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c:1717`, the call
  `smu_cmn_get_metrics_table(smu, &metrics, true)` is switched to `...
  false`. This flips the `bypass_cache` flag so Aldebaran’s
  `aldebaran_get_gpu_metrics()` uses the cached metrics instead of
  forcing a fresh PMFW query every time.
- Cache semantics: `smu_cmn_get_metrics_table()` caches SMU metrics for
  1 ms and refreshes only if the cache is older or bypassed. See
  `drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c:1023` (1 ms validity),
  `...:1034` (updates and timestamps cache).
- Consistency with existing Aldebaran paths: Other Aldebaran helpers
  already use the cached path, e.g. `aldebaran_get_smu_metrics_data()`
  calls `smu_cmn_get_metrics_table(smu, NULL, false)` to reuse cached
  metrics (drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c:618). This
  change makes `get_gpu_metrics` consistent with those helpers.
- Why it matters: Forcing fresh metrics on every `gpu_metrics` read
  causes frequent SMU/PMFW interactions. On Aldebaran, cached metrics
  are valid for 1 ms (as the commit message notes). Using the cache
  avoids needless PMFW interrupts when clients poll faster than 1 kHz,
  improving firmware responsiveness and reducing overhead. The returned
  data can at most be 1 ms old, which is within the defined validity
  window.

Risk and scope
- Minimal change, localized to Aldebaran: One boolean flip in an
  Aldebaran-specific function; no architectural or API changes; no
  cross-subsystem impact.
- Behavior impact is bounded: Only affects callers that poll faster than
  1 ms; they now see properly cached values (up to 1 ms old) rather than
  forcing a fresh read. This matches the established 1 ms cache policy
  in `smu_cmn_get_metrics_table`.
- Safe initialization: Metrics cache is initialized to 0 so the first
  fetch always refreshes
  (drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c:250).
- No security or correctness regressions: Reading slightly-cached
  telemetry is expected and already used elsewhere; avoids performance
  pitfalls from excessive PMFW interrupts.

Stable backport criteria
- Fixes a real-world issue (excessive PMFW interrupts / overhead under
  high-frequency polling) that can affect users.
- Small, contained change with low regression risk.
- No new features or ABI changes; aligns behavior with existing cache
  policy and other Aldebaran code paths.
- Touches a single driver component without architectural refactoring.

Given the narrow scope, clear benefit, and low risk, this is a good
candidate for stable backport.

 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
index c63d2e28954d0..b067147b7c41f 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1781,7 +1781,7 @@ static ssize_t aldebaran_get_gpu_metrics(struct smu_context *smu,
 
 	ret = smu_cmn_get_metrics_table(smu,
 					&metrics,
-					true);
+					false);
 	if (ret)
 		return ret;
 
-- 
2.51.0

