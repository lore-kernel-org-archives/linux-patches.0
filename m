Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF74245033;
	Mon, 30 Jun 2025 21:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317262; cv=none; b=DbWNQddlAe8bEO5/H6g9jNHATRz6NmnCHEn9emwE3/0ZtwGRaKXn5C/mcSRR/h8Nemz1n5JLHY98J9w3js3dH6CQysDf0lE5qDb3wvl22Vdq0qyxwgreALE9RknDBBG8zEFjp6tPEEFtEXaCNP2yQQUd31Mt4Lj6PzPsyfbjJCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317262; c=relaxed/simple;
	bh=a+r6daiSNKy80Kyt3rwgyl0O5+OZkNFlUuxHXphhwVg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oI+I9qLsQJ88+paaU+wcJPfLUUBygdOU8xBxpGkmrvGJzy2yjbpjN3m3sDEou8MDiBiN6T9o+axoa34f66o3lDKRfJUf2zCRUvkFk0zMXvkmHlryEXASqLo2iOrcrhKu8eVLx0j9ayL+bmOKvV+S5oMY2FgCVx7PYQsh5fyYT7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BQ4t8n6y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BQ4t8n6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC8CC4CEE3;
	Mon, 30 Jun 2025 21:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317262;
	bh=a+r6daiSNKy80Kyt3rwgyl0O5+OZkNFlUuxHXphhwVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BQ4t8n6yek+2XVhnUbhvrEqa2hmQwju5KgffJdZNSxZWgbWLYiC5PklPu5iRp+ExI
	 CCamNJBg8IPPZxns69ql1w2yTTmHjM7H/v5EWJNQhZHn970aPuytS8vVBvRNLA9+sf
	 3NNH/z4WZITFSM0orpEo5R8XUP+weIK8/L5KwNyJgMiPTVpixENQqS5UVdomBnDfi8
	 UfJKPvdWwfpJVnbkoyGUNjYHonUpm72G1Yu3c+KAcsLNG4S5mGtjXrjFHbJ+i8zU63
	 bN0copCsFDFEybvPt5g2ECFsFdnFHDvgMkRcF3zXU5Kn4BQBDeqUpnWZjsVyv8gkqP
	 McZei6cg8rtsg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Long Li <longli@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	kotaranov@microsoft.com,
	shirazsaleem@microsoft.com,
	leon@kernel.org,
	shradhagupta@linux.microsoft.com,
	mlevitsk@redhat.com,
	ernis@linux.microsoft.com,
	haiyangz@microsoft.com,
	peterz@infradead.org
Subject: [PATCH AUTOSEL 6.6 09/14] net: mana: Record doorbell physical address in PF mode
Date: Mon, 30 Jun 2025 16:46:34 -0400
Message-Id: <20250630204639.1358777-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250630204639.1358777-1-sashal@kernel.org>
References: <20250630204639.1358777-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.95
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
index 9ed965d61e355..d3c9a3020fbf6 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -28,6 +28,9 @@ static void mana_gd_init_pf_regs(struct pci_dev *pdev)
 	gc->db_page_base = gc->bar0_va +
 				mana_gd_r64(gc, GDMA_PF_REG_DB_PAGE_OFF);
 
+	gc->phys_db_page_base = gc->bar0_pa +
+				mana_gd_r64(gc, GDMA_PF_REG_DB_PAGE_OFF);
+
 	sriov_base_off = mana_gd_r64(gc, GDMA_SRIOV_REG_CFG_BASE_OFF);
 
 	sriov_base_va = gc->bar0_va + sriov_base_off;
-- 
2.39.5

