Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288FD3090CB;
	Sat, 25 Oct 2025 16:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409460; cv=none; b=X88/pLtxNhywmNM85m3qLxcgrPNB1xO9qm8i4tfk9V78OHhDiBcS+Puuxslb3RHeVdbhmbaiT3orhtxeWt7u9SgRiOMRlI0+nQPJwlfkTHwUp+nD+N7p1rvAR8FTNDzWcpelcrssAaqe52vLeJ38nxNx3Xvi3kmy5IFb3QuvqQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409460; c=relaxed/simple;
	bh=DYbrjcg5nN5LP1aVaXSLPlizbR0Zl9bPOrw0viyuofE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3dABrcxfnqO1zZ5f+k1OPEZDhi2ixW8M2ftUji90MnzN2P4X2nvNxU/dSgfNBFflcNnZUDQuv4KCDeLke6ZU33bROwbK4PDA4zqjF8RYJPQpZpApIQNIKc+bJuWg31WLe2qmoZIVFS/LCQKxlq4bzPLXNxpbN2vEMcOag+5zBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j2CF3LXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j2CF3LXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5471C4CEF5;
	Sat, 25 Oct 2025 16:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409460;
	bh=DYbrjcg5nN5LP1aVaXSLPlizbR0Zl9bPOrw0viyuofE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j2CF3LXQTMb/633g0nhWqGAcTpwcYNloGgpFx+swkR6yM2DpVA8OWJUJHHJWktVNe
	 RFjXBKS0m2ifMVc+I8uh6VLD4IMTjVNRQHkCkowu4w5RimqykhvNjna1YTFfQVKX6Q
	 xheRA4jEwghWOpN92BcpEFrjYZ2ukap5zpzhR/KzzH3f8to5/5bzF9HmMCscce772N
	 091ixFGrnLSYCZsIBAh4MgCHwpIdEhY21M5Ukvj+OIxa3/BXDnEHZKuVvJRMrNP0ae
	 EKXpPXh1G5Yc7+yCQ0UJ8BtF+DBeEiAv5ABQZ9+GI7fprTTulVPuOXaW43TGbVAcHp
	 Fq5IA4zBpWVMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ce Sun <cesun102@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	xiang.liu@amd.com,
	tao.zhou1@amd.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-6.12] drm/amdgpu: Correct the counts of nr_banks and nr_errors
Date: Sat, 25 Oct 2025 11:59:24 -0400
Message-ID: <20251025160905.3857885-333-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Ce Sun <cesun102@amd.com>

[ Upstream commit 907813e5d7cadfeafab12467d748705a5309efb0 ]

Correct the counts of nr_banks and nr_errors

Signed-off-by: Ce Sun <cesun102@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fix scope: Corrects internal counters in AMDGPU ACA error accounting;
  minimal, localized change confined to
  `drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c`.
- Bug 1 (nr_banks undercount after free): `aca_banks_release()` now
  decrements `nr_banks` as it removes/frees each node, keeping the count
  consistent with the list length; see
  `drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c:79`. Without this, after
  freeing the list the `nr_banks` field could remain stale (non-zero),
  misleading any subsequent logic that inspects the struct after release
  (even if current users mostly recreate the struct).
- Bug 2 (nr_errors negative/miscount): `new_bank_error()` now increments
  `aerr->nr_errors` when a new error is appended to the list, matching
  the existing decrement in `aca_bank_error_remove()`; see
  `drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c:242` (increment) and
  `drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c:276` (decrement). Previously,
  errors would be removed and counted down without ever counting up,
  driving `nr_errors` negative and breaking basic accounting.
- Concurrency correctness: Both the increment and decrement of
  `nr_errors` are performed while holding `aerr->lock` (add/remove paths
  already take the mutex), so the fix is thread-safe and consistent with
  existing synchronization.
- Call flow correctness: The ACA error cache is drained in
  `aca_log_aca_error()` which removes each entry (and thus decrements
  the counter) under the same lock; see
  `drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c:540-556`. With the fix,
  `nr_errors` returns to zero after logging, as intended.
- User-visible impact: Prevents incorrect/negative error counts in ACA
  error accounting and avoids stale bank counts after release. This
  improves reliability of error reporting/diagnostics (including CPER-
  related reporting that relies on bank collections; e.g., the deferred
  UE path passes `de_banks.nr_banks` to CPER generation at
  `drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c:445`).
- Risk assessment: Very low. No API/ABI changes, no architectural
  changes, only adjusts counters to mirror existing list mutations.
  Logic paths remain the same; locking is preserved.
- Stable criteria fit: This is a small, targeted bug fix correcting
  internal state; no features added; low regression risk; affects
  correctness of error accounting in a driver subsystem.

Given the above, this commit is a good candidate for backporting to
stable trees.

 drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
index d1e431818212d..9b31804491500 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
@@ -76,6 +76,7 @@ static void aca_banks_release(struct aca_banks *banks)
 	list_for_each_entry_safe(node, tmp, &banks->list, node) {
 		list_del(&node->node);
 		kvfree(node);
+		banks->nr_banks--;
 	}
 }
 
@@ -238,6 +239,7 @@ static struct aca_bank_error *new_bank_error(struct aca_error *aerr, struct aca_
 
 	mutex_lock(&aerr->lock);
 	list_add_tail(&bank_error->node, &aerr->list);
+	aerr->nr_errors++;
 	mutex_unlock(&aerr->lock);
 
 	return bank_error;
-- 
2.51.0

