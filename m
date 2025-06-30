Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF579236431;
	Mon, 30 Jun 2025 20:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317153; cv=none; b=m7Ldndv6libuI7m3QoHnHefSsyqZz/w62CTgthGDt2ldc0fYGnVcGVOvFkJsEsPzmRKWl9XGma5Z6U0i7sGP7lY3HucBs957y8OgFY8ZjvxdKGZddDVCnFiM7mK1aSMvQKDVAvVtteQ7tJTei9MHumHjU9OlLXsIGT+y9Yh97fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317153; c=relaxed/simple;
	bh=x/OQSmll0rU7RLBirjUsxnq9teIsMUEZ9zaz5aKkSTs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aysuRAWSrDm9ooQ5xVeSi3x9j1jGn4qJ4WKrhYq3pGuHWkF8graXlCSoeDWFR0aDEKQzxPA7fr5028SuliH34au8DEaInBYsaipy0UjnfnAqiIJseeonijzmYe0f3H7WEm2Egc43YmUdvl/yphVPNVpPHcMOvMpT7jA+xVFROqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A54cx7aT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A54cx7aT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4A9C4CEEB;
	Mon, 30 Jun 2025 20:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317153;
	bh=x/OQSmll0rU7RLBirjUsxnq9teIsMUEZ9zaz5aKkSTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A54cx7aT6EAKHNdBANmra7UOjZvENMjT9SIDjJNqO/p3Otfog1oIm61Wm5KH/5L4k
	 07NiqCDdt8Cd0rVq4G8VeELucgIM70qcQBYtPRH6JvJBtdR1hpwhIG7/N0OeCC5QGj
	 IH1/jfMBNb9qFQBuFXuQ2nc8eW1FuHvJcsSkzQB646skTwZ4EHNa3uxuImrr8IJ2Kk
	 chMA1gE15ydbfVgFegPEJpuhso6T/SxKN3lwXi3x1GEl7GFxmg9TBmde26u+JB6Jdi
	 i8CGi3ThJ++nxoLAl9AgSQZ4CT5b/I0hfhL5yd79F0s3kU0zJseT9efpljdaOv+Ff7
	 y+I1dPGPsBRPg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Long Li <longli@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	kotaranov@microsoft.com,
	leon@kernel.org,
	shirazsaleem@microsoft.com,
	shradhagupta@linux.microsoft.com,
	mlevitsk@redhat.com,
	ernis@linux.microsoft.com,
	peterz@infradead.org,
	haiyangz@microsoft.com
Subject: [PATCH AUTOSEL 6.15 16/23] net: mana: Record doorbell physical address in PF mode
Date: Mon, 30 Jun 2025 16:44:21 -0400
Message-Id: <20250630204429.1357695-16-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250630204429.1357695-1-sashal@kernel.org>
References: <20250630204429.1357695-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.4
Content-Transfer-Encoding: 8bit

From: Long Li <longli@microsoft.com>

[ Upstream commit e0fca6f2cebff539e9317a15a37dcf432e3b851a ]

MANA supports RDMA in PF mode. The driver should record the doorbell
physical address when in PF mode.

The doorbell physical address is used by the RDMA driver to map
doorbell pages of the device to user-mode applications through RDMA
verbs interface. In the past, they have been mapped to user-mode while
the device is in VF mode. With the support for PF mode implemented,
also expose those pages in PF mode.

Support for PF mode is implemented in
290e5d3c49f6 ("net: mana: Add support for Multi Vports on Bare metal")

Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/1750210606-12167-1-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
detailed analysis:

## Critical Functionality Fix

The commit fixes a missing functionality that prevents RDMA from working
properly in PF (Physical Function) mode. Looking at the code changes:

1. **The Problem**: In `mana_gd_init_pf_regs()`, the driver was not
   recording `gc->phys_db_page_base`, while the VF initialization
   function `mana_gd_init_vf_regs()` does record it (lines 50-51 in the
   existing code).

2. **The Impact**: The RDMA driver critically depends on
   `phys_db_page_base` in its `mana_ib_mmap()` function
   (drivers/infiniband/hw/mana/main.c:535-537):
  ```c
  pfn = (gc->phys_db_page_base +
  gc->db_page_size * mana_ucontext->doorbell) >>
  PAGE_SHIFT;
  ```
  This physical address is used to map doorbell pages to user-space
  applications through `rdma_user_mmap_io()`, which is essential for
  RDMA functionality.

3. **User Impact**: Without this fix, RDMA operations would fail in PF
   mode (bare metal deployments), making the RDMA feature completely
   unusable for those users.

## Meets Stable Criteria

- **Small and contained**: The fix adds only 3 lines of code
- **Fixes a real bug**: RDMA functionality is broken in PF mode without
  this
- **No architectural changes**: Simply records an address that's already
  being recorded in VF mode
- **Low regression risk**: The change is isolated to PF initialization
  path
- **Similar to previous stable fixes**: Commits #3 and #4 in the
  historical examples were both doorbell-related RDMA fixes that were
  backported

The commit essentially brings parity between VF and PF modes for
doorbell physical address recording, which is necessary for proper RDMA
operation. This is a clear functional bug that affects users running
MANA in PF mode with RDMA requirements.

 drivers/net/ethernet/microsoft/mana/gdma_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 4ffaf75888852..3dc94349820d2 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -31,6 +31,9 @@ static void mana_gd_init_pf_regs(struct pci_dev *pdev)
 	gc->db_page_base = gc->bar0_va +
 				mana_gd_r64(gc, GDMA_PF_REG_DB_PAGE_OFF);
 
+	gc->phys_db_page_base = gc->bar0_pa +
+				mana_gd_r64(gc, GDMA_PF_REG_DB_PAGE_OFF);
+
 	sriov_base_off = mana_gd_r64(gc, GDMA_SRIOV_REG_CFG_BASE_OFF);
 
 	sriov_base_va = gc->bar0_va + sriov_base_off;
-- 
2.39.5

