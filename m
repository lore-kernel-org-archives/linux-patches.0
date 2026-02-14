Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A632556E;
	Sat, 14 Feb 2026 01:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031177; cv=none; b=bFuHZJArlLI/MLK7iey3jXjd+Px6H9mwZU56wUZNTKU1RU2ZbQ5DiGxM8abI9o/Jq0UT+1EeKCi1hKY5AiUX82E7II6lXrITd68ezPntZFIL0wZg9OKfYK5HUGKdiowzXi3Ei8DxCvt+6clHW7zfHqecA8KZIX/CUlod/lnxJ2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031177; c=relaxed/simple;
	bh=PnjpoUZCJrTJjK7qgjZ2ZrUAbr169HeBkPO4IK7fAPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n5oun3Uw7h669KsP0JCRsL/ffev/4y8r78v9peHH0ViDZ7Fa4y+THcI0+1CsiRHnLvUKPKLr6Me5lEawHeXWc65UXNxQbXhvbLf9HUzIB7pdAoilIGuUKgEiodcNWITU2ExAQkAKAzzITkpnxQ6Mrdhu65le5Ak7H2DeuakbO6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bHwYksyv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bHwYksyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B61BC116C6;
	Sat, 14 Feb 2026 01:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031177;
	bh=PnjpoUZCJrTJjK7qgjZ2ZrUAbr169HeBkPO4IK7fAPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHwYksyvOrcq2IqYAopOa56KTpXzFuu7ZPZacugzKW+eTXiu2QvFQwnVfZOwsXcy8
	 g7k0aovsTJKKW7pu/vLjD+thUlZe2ZZYRDtrfklP1hNPHLhhV181jVKXkktQXsl60R
	 8QH1GkZBwymB/6q6sAc02r7UXSSEz9zIrASdLYD7s39nZdVjEAzM0h25ZoreYLA92q
	 K/yeVV7efemkRAgQQ4R45qoN97PdfZTNAiVUmBMOsr80Vn724IoOV9brZ3XZgfEPbk
	 8Dz8PAkNzpzQD5chTcRUCaRP9qpZKU0wM2PaI3dEXLwBnmxiyCQXsR6ZgmEp+iDVzw
	 iWUTE6vRfEYkA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tim Huang <tim.huang@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Hawking.Zhang@amd.com,
	Likun.Gao@amd.com,
	lijo.lazar@amd.com,
	yelangyan@huaqin.corp-partner.google.com,
	flora.cui@amd.com
Subject: [PATCH AUTOSEL 6.19-6.6] drm/amdgpu: add support for HDP IP version 6.1.1
Date: Fri, 13 Feb 2026 19:59:30 -0500
Message-ID: <20260214010245.3671907-90-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tim Huang <tim.huang@amd.com>

[ Upstream commit e2fd14f579b841f54a9b7162fef15234d8c0627a ]

This initializes HDP IP version 6.1.1.

Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Tim Huang <tim.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I see SMU 14.0.4 and 14.0.5 in the soc21 reset path - these are likely
the same series of GPUs (Strix Point) that use HDP 6.1.1.

Now let me summarize the analysis:

## Analysis

### 1. Commit Message Analysis

The commit subject is "drm/amdgpu: add support for HDP IP version 6.1.1"
and the body says "This initializes HDP IP version 6.1.1." It was
authored by Tim Huang and reviewed by Mario Limonciello, both AMD
engineers. Signed off by Alex Deucher, the AMD GPU subsystem maintainer.

### 2. Code Change Analysis

The change is a **single line addition**: adding `case IP_VERSION(6, 1,
1):` as a fall-through case before `adev->hdp.funcs = &hdp_v6_0_funcs;`
in the HDP version switch statement in
`amdgpu_discovery_set_ip_blocks()`.

### 3. The Bug

This is not merely "new hardware enablement" — it's a **missing case
label fix**. Here's the critical analysis:

- **SDMA 6.1.1** was added in commit `a02cfac90fbd4` (v6.9-rc1)
- **VPE 6.1.1** was added in commit `155d46835c316` (v6.9-rc1)
- **HDP 6.1.1** was never added

This means since v6.9, a GPU with these IP versions can be discovered
and probed, but the HDP function table is left as **NULL** (because HDP
6.1.1 falls through to the `default: break;` case).

### 4. Impact - NULL Pointer Dereference

When `soc21_common_get_clockgating_state()` (`soc21.c:1011`) is called,
it unconditionally dereferences
`adev->hdp.funcs->get_clock_gating_state()` without a NULL check.
Similarly, `soc21_common_set_clockgating_state()` (`soc21.c:978`)
dereferences `adev->hdp.funcs->update_clock_gating()` without a NULL
check for NBIO 7.11.x GPUs.

With `adev->hdp.funcs` being NULL, these will cause a **kernel NULL
pointer dereference crash** (oops/panic) on any system with the affected
GPU hardware.

### 5. Scope and Risk

- **One line change**: Minimal risk of regression
- **Well-understood pattern**: Adding a case label to an existing switch
  fall-through, identical to how 6.0.0, 6.0.1, and 6.1.0 are handled
- **Uses existing code**: Maps to the already-tested `hdp_v6_0_funcs`
  function table
- **No new APIs, no new features, no behavioral changes** for existing
  hardware

### 6. Stable Tree Relevance

The bug was introduced in v6.9 when SDMA 6.1.1 and VPE 6.1.1 were added
without a corresponding HDP 6.1.1 entry. Any stable tree from 6.9 onward
(6.12.y, 6.6.y if SDMA 6.1.1 was backported there, etc.) that has the
SDMA/VPE 6.1.1 support but lacks HDP 6.1.1 would be affected. The fix is
trivial to backport.

### 7. Classification

This falls under the **device ID / hardware variant** exception for
stable. It's a one-line addition of a new IP version to an existing
driver's switch statement, using an already-existing function table.
More importantly, it **fixes a NULL pointer dereference** crash on
affected hardware.

### 8. Note on hdp_v6_0.c Register Handling

There's a minor concern: `hdp_v6_0_update_clock_gating()` currently
checks `IP_VERSION(6, 1, 0)` specifically to use `regHDP_CLK_CNTL_V6_1`.
HDP 6.1.1 would use `regHDP_CLK_CNTL` (the `else` path) which may or may
not be correct. However, this is orthogonal to the commit — at worst,
clock gating configuration may be incorrect for this variant, but the
kernel won't crash. The more critical issue is that without this commit,
the kernel **will crash** with a NULL pointer dereference.

### Conclusion

This is a small, surgical, obviously correct fix that prevents a NULL
pointer dereference crash on hardware with HDP IP version 6.1.1. The
one-line change maps the new version to an existing function table,
following an established pattern. The bug was introduced in v6.9 when
other IP blocks for the same GPU were added without the corresponding
HDP entry. It meets all stable kernel criteria: fixes a real crash bug,
is obviously correct, is small and contained, and introduces no new
features.

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index fa2a22dfa0487..f9e0e80c4c186 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -3059,6 +3059,7 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
 	case IP_VERSION(6, 0, 0):
 	case IP_VERSION(6, 0, 1):
 	case IP_VERSION(6, 1, 0):
+	case IP_VERSION(6, 1, 1):
 		adev->hdp.funcs = &hdp_v6_0_funcs;
 		break;
 	case IP_VERSION(7, 0, 0):
-- 
2.51.0

