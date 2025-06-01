Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE5F2571BC;
	Sun,  1 Jun 2025 23:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820321; cv=none; b=lw12VUrTu8XpOLVgbrfrqd2rd1a0YmLIjyuM5q9OjPfXelNb+k6ZWCZMzGeLseW8XCbKLy2bXyIJuBBVi3jMHUBVMtLsjiitpf/K3ncJUV7vL5d32v/HOFKwQV1SDumiQcA2oRjO2ZH63OpGFT+jKCJNMYkC+X/xIBPUNbCEb7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820321; c=relaxed/simple;
	bh=Wx9moxBJg0u9iJwD2G9mfpY65uiQWo92GZwGPbDeGAQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GAGraxTm0UOvZWC3Hpc6fOSHS+Op7s2dJmeCdjkS568/1r8GcabnDSTALbFXTbtQDz0dUboY5jZJW0dRkBIfl5yGm+gHYOaOnGjINNFJz9zHtJHl/JtH8zMLT4j++ecpFme0+xM+2fDE0cMrVnijxOxPu89inp6htBx9ELwzXoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oqP3d35E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oqP3d35E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07B6C4CEF1;
	Sun,  1 Jun 2025 23:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820321;
	bh=Wx9moxBJg0u9iJwD2G9mfpY65uiQWo92GZwGPbDeGAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqP3d35E32nK0UtRxCoRI0OmpCHtNWEa+VKOcVO+MGlWtplk/FVQzOlErRyeSqkcc
	 SoX0bLwm8dvq3QyBRCQ+9fN3qzJTK2nHwXQNCFMXM7wpE0hj7yXnxE7/VV0iN3xQqt
	 wBM8b4DXfnciubO46RPAU3A/0GSpLQTXl76m0FK0dVvFnvQ3dwr0Pc8E1dGp5SNLKp
	 IElmeLGuGY/lx5lMGvvxQh5kc8rAZBw66hOg5e/VTXREjad1w4K/NdD6U8mt1am/LT
	 RQymsCq9hSirlAm/Knto13luUxe7MXnJVwx8SoZNWQDPzeCMvveGvrvr248m7WFpBB
	 /9mq9sHsnETNw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 017/110] drm/panthor: Don't update MMU_INT_MASK in panthor_mmu_irq_handler()
Date: Sun,  1 Jun 2025 19:22:59 -0400
Message-Id: <20250601232435.3507697-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601232435.3507697-1-sashal@kernel.org>
References: <20250601232435.3507697-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 6c4a3fa26799785c1873aacabcfd9b2d27e8dc97 ]

Interrupts are automatically unmasked in
panthor_mmu_irq_threaded_handler() when the handler returns. Unmasking
prematurely might generate spurious interrupts if the IRQ line is
shared.

Changes in v2:
- New patch

Changes in v3:
- Add R-bs

Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20250404080933.2912674-6-boris.brezillon@collabora.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees for the
following reasons: ## Analysis of the Bug Fix **Code Change Analysis:**
The commit removes a single line from `panthor_mmu_irq_handler()`: ```c
- gpu_write(ptdev, MMU_INT_MASK, new_int_mask); ``` This line was
prematurely unmasking MMU interrupts within the interrupt handler
itself. **Technical Issue:** 1. **Interrupt Handling Architecture**: The
panthor driver uses a two-stage interrupt handling approach via the
`PANTHOR_IRQ_HANDLER` macro: - **Hardware IRQ handler**: Masks
interrupts (`gpu_write(ptdev, MMU_INT_MASK, 0)`) and wakes the threaded
handler - **Threaded handler**: Processes interrupts and automatically
re-enables them at the end (`gpu_write(ptdev, MMU_INT_MASK,
pirq->mask)`) 2. **The Bug**: The `panthor_mmu_irq_handler()` function
was prematurely unmasking interrupts in the middle of processing, which
could cause: - **Spurious interrupts** if the IRQ line is shared with
other devices - **Race conditions** where new interrupts arrive before
the handler completes - **Interrupt storms** in edge cases ## Backport
Criteria Assessment **✅ Fixes a bug that affects users:** - Could cause
spurious interrupts on shared IRQ lines - Potential for interrupt storms
affecting system stability **✅ Small and contained fix:** - Single line
removal - No architectural changes - Minimal risk of regression **✅
Clear side effects analysis:** - The fix aligns with the designed
interrupt handling pattern - No negative side effects expected since
automatic re-enabling happens at the proper time **✅ Critical
subsystem:** - GPU MMU interrupt handling is critical for memory
management - Affects system stability when GPU is in use **✅ Driver
maturity:** - Panthor driver was introduced in v6.10 (relatively recent)
- This is a bug in the core interrupt handling logic ## Comparison with
Historical Commits This fix follows the same pattern as **Similar Commit
#1** (drm/panthor: Fix ordering in _irq_suspend()) which was also marked
as backport-worthy. Both commits fix interrupt handling ordering issues
in the panthor driver. Unlike the panfrost commits (Similar Commits
#2-5), which involved more complex architectural changes to interrupt
handling, this panthor fix is a simple correction to align with the
existing interrupt handling framework. ## Recommendation This commit
should be backported because it fixes a clear bug in interrupt handling
that could lead to system instability, the fix is minimal and safe, and
it corrects the implementation to match the intended design pattern used
throughout the panthor driver.

 drivers/gpu/drm/panthor/panthor_mmu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
index 12a02e28f50fd..8192f1de599a9 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -1713,7 +1713,6 @@ static void panthor_mmu_irq_handler(struct panthor_device *ptdev, u32 status)
 		 * re-enabled.
 		 */
 		ptdev->mmu->irq.mask = new_int_mask;
-		gpu_write(ptdev, MMU_INT_MASK, new_int_mask);
 
 		if (ptdev->mmu->as.slots[as].vm)
 			ptdev->mmu->as.slots[as].vm->unhandled_fault = true;
-- 
2.39.5

