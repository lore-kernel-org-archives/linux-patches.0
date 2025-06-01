Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184DD28A1E1;
	Sun,  1 Jun 2025 23:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820623; cv=none; b=JbRSDbUzW9P0CinDBUisCtaMtQ27bAc0o3QlXa0VhBlGigMgMkjQgRBVmIxcBtmWJyvjmAj5A3nJYzlW7tVqYl0fcJSAr5nn8Y3E4pCzyGr4uN/xdlt6t+1CwAY0wgoRj15fNIFOLILH30uKwTRbdcaoZTaTZKmwJDH6N52CvFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820623; c=relaxed/simple;
	bh=fZcNULaNScuBdadMlBXDkv77WZQQ+aZbLrpcKrnFHRo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CDzSwcK7+9Cm4hGpWUXXNBg+e9U+jnFujPNeClbXlomG6KeB7gQI8tZi24gXrM1iRWNNWpfIt0Kh/zMQx2NFXC8mV4hkOVW1fkFL/LrOD0bgDTknpqTFAb62SFqEbsoa8xYbpW9YKa6Kc1NKykF3T+aNB3/XPsruOmD+LbZA/Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rD9scHA4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rD9scHA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900A6C4CEE7;
	Sun,  1 Jun 2025 23:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820623;
	bh=fZcNULaNScuBdadMlBXDkv77WZQQ+aZbLrpcKrnFHRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rD9scHA4Tnfadjwepe7MqYODtVctzM0zvLbqciCvcTivL0z/OjVYMk6krkj3DVzen
	 e1aFdZzdn1pd6CmL2ttVtrluJfpe+77/6MbhhitBbArQ03JozLCNnB5Wyzu2vX+LOI
	 MRyM+ZvkvjIuUUES9E0qZfnmsXZta5WYCqD65eIVgFAP/+d1IzkrWXeqqh0e5/z8uW
	 VYKAg+hml4s+I7r/0LDSyPen9+6tdGrk1f8WMHb7vtaQRqdjN0hQlOhKpBfRN/+0Bi
	 gx305gfi36jtzq1fKIhR1VOQJljL/xbbxL6GmWn/NyNVPzGyFbl3jR7gZ6faorIWZB
	 Ogvx6+dEwL2NA==
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
Subject: [PATCH AUTOSEL 6.14 017/102] drm/panthor: Don't update MMU_INT_MASK in panthor_mmu_irq_handler()
Date: Sun,  1 Jun 2025 19:28:09 -0400
Message-Id: <20250601232937.3510379-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601232937.3510379-1-sashal@kernel.org>
References: <20250601232937.3510379-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
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
index 1202de8811c2a..68929327c31ca 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -1710,7 +1710,6 @@ static void panthor_mmu_irq_handler(struct panthor_device *ptdev, u32 status)
 		 * re-enabled.
 		 */
 		ptdev->mmu->irq.mask = new_int_mask;
-		gpu_write(ptdev, MMU_INT_MASK, new_int_mask);
 
 		if (ptdev->mmu->as.slots[as].vm)
 			ptdev->mmu->as.slots[as].vm->unhandled_fault = true;
-- 
2.39.5

