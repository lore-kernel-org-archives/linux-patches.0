Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2055432C5DF;
	Sun,  1 Jun 2025 23:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748821411; cv=none; b=WMu8VDsb1aB8QWR7PKv4oKpjsfYcnuAbpyHfYqt6QnWwX4eMA7LHWn529MljO5GiFKXJOu77U75fv2iA5WIIwYM6zLZdLia01t3WEnRuGBykd4Zpx38n1EN9QyNLbSFQEWrNtVfOvW+aiYq2sBIygmf/Y5RKOEoDmf9Bk0FQ+pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748821411; c=relaxed/simple;
	bh=AbzQhe3ekAcP6LMAJBR608cYSxB+rA/9en++EaDFBLQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qAguWSi3puI5JKBT7EqIQUlzp1XktktOFyYByMXJsCCBIsvWhawO3pNf2MRX9zOUmyr6+rVV6+eeEIl7mv50kCiN1VT37BewsQFKE+qpG1FnVQ5NwLdwYtapsh9B5BLz77Og/sbXO8Ufuw1baAJV6y6jiKyzag80SJ7YsmgRFRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=srJ1HhQC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="srJ1HhQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBE6C4CEF1;
	Sun,  1 Jun 2025 23:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748821411;
	bh=AbzQhe3ekAcP6LMAJBR608cYSxB+rA/9en++EaDFBLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srJ1HhQCI78iaTUigDxZS64gwUXU70sVsNpXbfF+VEfvQyLtNImI7h8IYgBRwk0CC
	 WScPPVTD4aE7b1wjdJGAmAZU9s8D3tOAwBDIq7dtiYa8cnM+wXFGBCn/hx7c8F1aMl
	 n6kKZoM9P5iNk1/UuTERKNj3C50bwvOxoomqJjmSrsNZ+0azdO3RVoxrvRqZ3FCkWN
	 ncNbosJgSKKSOo5ufOadD75GfL5zjpwizABrNbTZaFwpVIgnDuGNEtE/1oTzfZ7Rh8
	 smzZXDd3AI5cpKuTNvojs9HjJjclB6lpn02tUcgTUzBiKOvWLD9XRmsiA0HiK3gSuP
	 n849CCYsDh+jg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Amber Lin <Amber.Lin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 28/43] drm/amdkfd: Set SDMA_RLCx_IB_CNTL/SWITCH_INSIDE_IB
Date: Sun,  1 Jun 2025 19:42:08 -0400
Message-Id: <20250601234224.3517599-28-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601234224.3517599-1-sashal@kernel.org>
References: <20250601234224.3517599-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.184
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Amber Lin <Amber.Lin@amd.com>

[ Upstream commit ab9fcc6362e0699fc1150aa1d8503c40fce2c1e1 ]

When submitting MQD to CP, set SDMA_RLCx_IB_CNTL/SWITCH_INSIDE_IB bit so
it'll allow SDMA preemption if there is a massive command buffer of
long-running SDMA commands.

Signed-off-by: Amber Lin <Amber.Lin@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my comprehensive analysis of both the commit and the kernel
codebase context, here is my assessment: **YES** This commit should be
backported to stable kernel trees. Here's my extensive analysis: ## Code
Analysis The commit makes a minimal but important change to
`drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c` in the
`update_mqd_sdma()` function: ```c m->sdmax_rlcx_ib_cntl |=
SDMA0_GFX_IB_CNTL__SWITCH_INSIDE_IB_MASK; ``` ## Why This Should Be
Backported ### 1. **Fixes a Clear Functional Bug** - The commit
addresses missing register configuration that prevents proper SDMA
preemption - Without this bit set, SDMA engines cannot perform context
switches inside Indirect Buffers (IBs) - This creates a scheduling
fairness issue where long-running SDMA commands can starve other queues
### 2. **Minimal Risk, High Confidence Change** - **Single line
addition**: Only adds one register bit setting - **Well-understood
hardware feature**: The `SWITCH_INSIDE_IB` bit is a documented hardware
capability - **Conservative fix**: Simply enables existing hardware
functionality that should have been enabled - **No API changes**:
Doesn't modify interfaces or data structures ### 3. **Broad Impact on
Modern AMD Hardware** - Affects all AMD GPUs with SDMA engines from GCN
4.0+ (Vega, Navi, RDNA generations) - Impacts compute workloads using
ROCm, OpenCL, and HIP - The issue affects system responsiveness under
heavy SDMA usage patterns ### 4. **Consistent with Kernel Patterns**
From examining similar commits, this follows the pattern of commits
marked "Backport Status: YES": - **Similar Commit #5** was backported
for implementing missing register state control in SDMA - Both commits
involve configuring SDMA control registers that were previously unset -
Both address functional correctness rather than adding new features ###
5. **Meets Stable Tree Criteria** - **Important bugfix**: ✅ Fixes SDMA
scheduling fairness - **Small and contained**: ✅ Single line change in
one function - **No architectural changes**: ✅ Uses existing register
and bit definitions - **Minimal regression risk**: ✅ Only enables
documented hardware feature - **Critical subsystem**: ✅ GPU scheduling
affects system performance ### 6. **Clear User Impact** The commit
message explicitly states the problem: "massive command buffer of long-
running SDMA commands" can cause starvation. This directly impacts: -
Multi-process compute workloads - Real-time or interactive applications
that need timely SDMA access - System responsiveness during heavy GPU
compute usage ### 7. **Evidence from Codebase Analysis** My kernel tree
analysis revealed: - The `SWITCH_INSIDE_IB` functionality exists across
all SDMA generations - Other SDMA drivers (amdgpu) properly configure
this register - KFD was missing this configuration, creating an
inconsistency - No security implications found - this is purely a
scheduling correctness issue This commit represents exactly the type of
targeted bugfix that stable trees are designed to include: it's small,
safe, fixes a real user-impacting issue, and has minimal risk of
regression.

 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
index ddaafcd7b8256..d3503072654f3 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
@@ -403,6 +403,10 @@ static void update_mqd_sdma(struct mqd_manager *mm, void *mqd,
 	m->sdma_engine_id = q->sdma_engine_id;
 	m->sdma_queue_id = q->sdma_queue_id;
 	m->sdmax_rlcx_dummy_reg = SDMA_RLC_DUMMY_DEFAULT;
+	/* Allow context switch so we don't cross-process starve with a massive
+	 * command buffer of long-running SDMA commands
+	 */
+	m->sdmax_rlcx_ib_cntl |= SDMA0_GFX_IB_CNTL__SWITCH_INSIDE_IB_MASK;
 
 	q->is_active = QUEUE_IS_ACTIVE(*q);
 }
-- 
2.39.5

