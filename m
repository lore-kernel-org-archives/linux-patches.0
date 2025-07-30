Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4E0275AE9;
	Wed, 30 Jul 2025 09:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868944; cv=none; b=icv6eXt9C4ajbuJXmi5fHqElkCyS0XUlvBPLB0rChNSzUeOPiapJDXkcH5I39HrXLLPvQarOy/Lrj9WFd1Priw9YJRwjUgpGDkFZ7crpzPlbio25kz7boDb2V8FauAyQ2bmvBth0LJ+/Epo9Lxc4EVOtELhVMTeP1W4YYhv6NC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868944; c=relaxed/simple;
	bh=b0bepjW1Ipi/X932vRhh4TXxeVCWFPU3l5/++QfcE7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXzH9Wt3kjKNtqSlpLq74IlKa3YXxtg8B+GOrP76bgV5IapDzR/QUB1YTY79nh8rwsVbrV/2XYnUH01PyvbtJd6MmfX7bmL3kb+qU7W2QN44SEckIeTBb6tr1VXPguZwlAcPygH8OTOX7OFrseQZuUu1xbe/6VbOvz4dFy712AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4uxrhKf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4uxrhKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE8DC4CEF5;
	Wed, 30 Jul 2025 09:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868944;
	bh=b0bepjW1Ipi/X932vRhh4TXxeVCWFPU3l5/++QfcE7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K4uxrhKfbaHj8IM9F63gFW9WStDLjZW0qInP5olxx+1evN0vIsjjzNnCAg8Roa6Yo
	 GifYdrE/0ERiBuzZPE60mWn+OH3hUIOlVqytB6ZrnY3tQgwqQUrwv1VDFAikvOdAhf
	 ND0kDH2UPcj8UbIB+OOPTQiKMCkyRI3KrZdguYw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Badal Nilawar <badal.nilawar@intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>
Subject: [PATCH 6.12 114/117] Revert "drm/xe/devcoredump: Update handling of xe_force_wake_get return"
Date: Wed, 30 Jul 2025 11:36:23 +0200
Message-ID: <20250730093238.246476008@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomita Moeko <tomitamoeko@gmail.com>

This reverts commit 9ffd6ec2de08ef4ac5f17f6131d1db57613493f9.

The reverted commit updated the handling of xe_force_wake_get to match
the new "return refcounted domain mask" semantics introduced in commit
a7ddcea1f5ac ("drm/xe: Error handling in xe_force_wake_get()"). However,
that API change only exists in 6.13 and later.

In 6.12 stable kernel, xe_force_wake_get still returns a status code.
The update incorrectly treats the return value as a mask, causing the
return value of 0 to be misinterpreted as an error

Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Cc: Nirmoy Das <nirmoy.das@intel.com>
Cc: Badal Nilawar <badal.nilawar@intel.com>
Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Tomita Moeko <tomitamoeko@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_devcoredump.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/xe/xe_devcoredump.c
+++ b/drivers/gpu/drm/xe/xe_devcoredump.c
@@ -197,7 +197,6 @@ static void xe_devcoredump_deferred_snap
 	struct xe_devcoredump_snapshot *ss = container_of(work, typeof(*ss), work);
 	struct xe_devcoredump *coredump = container_of(ss, typeof(*coredump), snapshot);
 	struct xe_device *xe = coredump_to_xe(coredump);
-	unsigned int fw_ref;
 
 	/*
 	 * NB: Despite passing a GFP_ flags parameter here, more allocations are done
@@ -211,12 +210,11 @@ static void xe_devcoredump_deferred_snap
 	xe_pm_runtime_get(xe);
 
 	/* keep going if fw fails as we still want to save the memory and SW data */
-	fw_ref = xe_force_wake_get(gt_to_fw(ss->gt), XE_FORCEWAKE_ALL);
-	if (!xe_force_wake_ref_has_domain(fw_ref, XE_FORCEWAKE_ALL))
+	if (xe_force_wake_get(gt_to_fw(ss->gt), XE_FORCEWAKE_ALL))
 		xe_gt_info(ss->gt, "failed to get forcewake for coredump capture\n");
 	xe_vm_snapshot_capture_delayed(ss->vm);
 	xe_guc_exec_queue_snapshot_capture_delayed(ss->ge);
-	xe_force_wake_put(gt_to_fw(ss->gt), fw_ref);
+	xe_force_wake_put(gt_to_fw(ss->gt), XE_FORCEWAKE_ALL);
 
 	xe_pm_runtime_put(xe);
 
@@ -243,9 +241,8 @@ static void devcoredump_snapshot(struct
 	u32 width_mask = (0x1 << q->width) - 1;
 	const char *process_name = "no process";
 
-	unsigned int fw_ref;
-	bool cookie;
 	int i;
+	bool cookie;
 
 	ss->snapshot_time = ktime_get_real();
 	ss->boot_time = ktime_get_boottime();
@@ -268,7 +265,8 @@ static void devcoredump_snapshot(struct
 	}
 
 	/* keep going if fw fails as we still want to save the memory and SW data */
-	fw_ref = xe_force_wake_get(gt_to_fw(q->gt), XE_FORCEWAKE_ALL);
+	if (xe_force_wake_get(gt_to_fw(q->gt), XE_FORCEWAKE_ALL))
+		xe_gt_info(ss->gt, "failed to get forcewake for coredump capture\n");
 
 	ss->ct = xe_guc_ct_snapshot_capture(&guc->ct, true);
 	ss->ge = xe_guc_exec_queue_snapshot_capture(q);
@@ -286,7 +284,7 @@ static void devcoredump_snapshot(struct
 
 	queue_work(system_unbound_wq, &ss->work);
 
-	xe_force_wake_put(gt_to_fw(q->gt), fw_ref);
+	xe_force_wake_put(gt_to_fw(q->gt), XE_FORCEWAKE_ALL);
 	dma_fence_end_signalling(cookie);
 }
 


