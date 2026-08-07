Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FB831327A;
	Fri,  7 Aug 2026 15:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115788; cv=none; b=BER4/HABhEtuYe51SszPWVjmga/3yDWtQ6Ee/U1OcM6Z3IKOIW7/TI+ltwi7BDLTJEdwpmBd8gv/YttiQibtjVUhdvvsjN9LfhDy30RsDwSi2IiNIbYTdRpTjL0TG+jh1Gvc4uUNZQLx6zkrHFq0fdMsfolITohkaog+EhfeXVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115788; c=relaxed/simple;
	bh=hbGo79n/Dwn/LRDTLE8doqD+VDgVE0KHXo8zNZJAGuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hV4R7hf1XgLxhQ6437YH962gBc9m5g+B8w+prKWHVsU7FQfQN99MlCoiccVRLhGSkPDoFWXKINoeS0gTPi/VJ/t6q/1GXRRYnl7HUagCo0Wlz74NO7l4+XdI9zZYawrp16spXPSj+KwnTFIWOyXepl/8KGAOL2BldC5PSKGMh5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cNhoZp89; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cNhoZp89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34BF91F000E9;
	Fri,  7 Aug 2026 15:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115786;
	bh=1V9IefxIMtbxV0xYtMR496rSyKCRi5UQUJQvHLl9Rms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cNhoZp89ZoBErfHlXb1SwQieKkDkbjiDed0elrSi2BUExsSmx1+yMBWxhkVktwaLq
	 ZfLMcpOZfldc9VPXbtF2ImAze3uD4cAIusR7Y3y1pmNVn78T0NfcTcZgAb1NLDdgC5
	 JpeGymzLPN01GZk3mWyawOrje92Nial0LUXRUAwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oak Zeng <oak.zeng@intel.com>,
	Brian Nguyen <brian3.nguyen@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 390/396] drm/xe: Add page reclamation info to device info
Date: Fri,  7 Aug 2026 16:39:10 +0200
Message-ID: <20260807143432.688327084@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oak Zeng <oak.zeng@intel.com>

[ Upstream commit 9b1a0e0a15c97987fdf56a615f3d13995bafd042 ]

Starting from Xe3p, HW adds a feature assisting range based page
reclamation. Introduce a bit in device info to indicate whether
device has such capability.

Signed-off-by: Oak Zeng <oak.zeng@intel.com>
Signed-off-by: Brian Nguyen <brian3.nguyen@intel.com>
Reviewed-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20251212213225.3564537-15-brian3.nguyen@intel.com
Stable-dep-of: 6384271ac1ac ("drm/xe/pt: Reset current_op in xe_pt_update_ops_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_device_types.h |    2 ++
 drivers/gpu/drm/xe/xe_pci.c          |    1 +
 drivers/gpu/drm/xe/xe_pci_types.h    |    1 +
 3 files changed, 4 insertions(+)

--- a/drivers/gpu/drm/xe/xe_device_types.h
+++ b/drivers/gpu/drm/xe/xe_device_types.h
@@ -305,6 +305,8 @@ struct xe_device {
 		 * pcode mailbox commands.
 		 */
 		u8 has_mbx_power_limits:1;
+		/** @info.has_page_reclaim_hw_assist: Device supports page reclamation feature */
+		u8 has_page_reclaim_hw_assist:1;
 		/** @info.has_pxp: Device has PXP support */
 		u8 has_pxp:1;
 		/** @info.has_range_tlb_inval: Has range based TLB invalidations */
--- a/drivers/gpu/drm/xe/xe_pci.c
+++ b/drivers/gpu/drm/xe/xe_pci.c
@@ -591,6 +591,7 @@ static int xe_info_init_early(struct xe_
 	xe->info.has_heci_cscfi = desc->has_heci_cscfi;
 	xe->info.has_late_bind = desc->has_late_bind;
 	xe->info.has_llc = desc->has_llc;
+	xe->info.has_page_reclaim_hw_assist = desc->has_page_reclaim_hw_assist;
 	xe->info.has_pxp = desc->has_pxp;
 	xe->info.has_sriov = desc->has_sriov;
 	xe->info.skip_guc_pc = desc->skip_guc_pc;
--- a/drivers/gpu/drm/xe/xe_pci_types.h
+++ b/drivers/gpu/drm/xe/xe_pci_types.h
@@ -42,6 +42,7 @@ struct xe_device_desc {
 	u8 has_late_bind:1;
 	u8 has_llc:1;
 	u8 has_mbx_power_limits:1;
+	u8 has_page_reclaim_hw_assist:1;
 	u8 has_pxp:1;
 	u8 has_sriov:1;
 	u8 needs_scratch:1;


