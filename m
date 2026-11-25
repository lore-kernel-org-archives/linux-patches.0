Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618837;
	b=n0ucCUJWu/4GepNEzKlhGCeAp+WE2bCTEHTgPBx2qZt8OJCXpp/YYRzjFBbGNQUuV7bD
	 HZwwEjKFJgrt6dUrrdwe6rhzgz6FqLEEQVNCQYAJyPjElj583WohZTF7zhPo4kthUhxdo
	 QFAv1Zb4rI+IG8cZUyxsLAKWu3qxQ8gAshwm47Bdnt0V0DnIRH1jOMMHI504eIRU8nnhG
	 xC7GnANJyx9ubLG91gT8Id/OFl5vWYGXXyylUpWFiGjQ0v9hUikmxq25l1QuaKg6DGygQ
	 ZHw56iPPCvZzgUOvOXHvUS2CIq9CeZjQRN6ZeBMKqlhfD+tjlujI2PSu3TzHJj58YdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sq23CaTePTR/hi1bxB3pP99Tpu9gGVWGK9KRGM44cB0=;
	b=N39xVyFxL7sKXY2HW9RIwm41+alDspCiXIFMSMYtgehi5zajQ/FJ0+zahUI8B6Q0a9A9
	 /9Q3ajYLE20GakFSnbUcC7MolBE+a7jnzQPiLmhio9GYNnot3OnkEppSEtD7mHrBnHe7F
	 eYf+KRZ3wyPkG2Bh6kqkPe91zNnJXU3Vt+pXJBL+I7sxEXsFPMs3jQZ6JKPWxT+gaRZgg
	 ui+Fhq/y1S4COMoAlBDYFIbPTk/zlPC4R002t1yLIZrMIZBTVrMTcl6d7MrLDuRa8Jy55
	 iHAplxH4yiDEfyh7eDGeg2jdDWzrknXG3SAXc0RoI0BTIUpFr8cq4glpc+9QPHMqmMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZjkztWhq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04ABB606A321;
	Wed, 25 Nov 2026 15:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZjkztWhq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80001F000C6;
	Wed, 25 Nov 2026 15:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618836;
	bh=Sq23CaTePTR/hi1bxB3pP99Tpu9gGVWGK9KRGM44cB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZjkztWhqQkkLwWSAaHCjfysqM6RbcHqtibKIt1jZjoHpBP1OTkntp+zqWqw/RFZ7v
	 qyXYAYUYnuYaERBq0Ko4Z4KwZ+uwMNbxbUNMq0AZ4EzEk+fF9vcfSdC1fZ7ts42Sf+
	 f0mXpe9998l8lOEk5vSb10/M7axXIJYrOx+FfYcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthik Poosa <karthik.poosa@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0402/1005] drm/xe: Access GT MMIO after pcode init
Date: Wed, 25 Nov 2026 15:29:00 +0100
Message-ID: <20261125143831.163773647@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinay Belgaumkar <vinay.belgaumkar@intel.com>

[ Upstream commit fc0ba46fd8278ed3e3a2c111b25036cb62dfe078 ]

Allow pcode initialization to complete before we start poking around
the GT MMIO space during resume as these accesses go through sgunit.
We do write to MMIO registers in xe_wa_apply_tile_workarounds(), but
those are in uncore space. Those accesses remain viable even during
d3cold suspend.

v2: Clarify about xe_wa_apply_tile_workarounds (Karthik Poosa)
v3: Add fixes tag (Anshuman)

Fixes: 95d0883ac810 ("drm/xe: Ensure GT is in C0 during resumes")
Cc: Karthik Poosa <karthik.poosa@intel.com>
Reviewed-by: Karthik Poosa <karthik.poosa@intel.com>
Signed-off-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Link: https://patch.msgid.link/20261027174351.619929-7-vinay.belgaumkar@intel.com
(cherry picked from commit 638d116d755ed89628ad07bde33ae7d7658db834)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pm.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_pm.c b/drivers/gpu/drm/xe/xe_pm.c
index a5289a9df8d25..06ff27641ad19 100644
--- a/drivers/gpu/drm/xe/xe_pm.c
+++ b/drivers/gpu/drm/xe/xe_pm.c
@@ -239,9 +239,6 @@ int xe_pm_resume(struct xe_device *xe)
 	drm_dbg(&xe->drm, "Resuming device\n");
 	trace_xe_pm_resume(xe, __builtin_return_address(0));
 
-	for_each_gt(gt, xe, id)
-		xe_gt_idle_disable_c6(gt);
-
 	for_each_tile(tile, xe, id)
 		xe_wa_apply_tile_workarounds(tile);
 
@@ -249,6 +246,9 @@ int xe_pm_resume(struct xe_device *xe)
 	if (err)
 		return err;
 
+	for_each_gt(gt, xe, id)
+		xe_gt_idle_disable_c6(gt);
+
 	xe_display_pm_resume_early(xe);
 
 	/*
@@ -677,13 +677,13 @@ int xe_pm_runtime_resume(struct xe_device *xe)
 	xe_rpm_lockmap_acquire(xe);
 
 	if (xe->d3cold.allowed) {
-		for_each_gt(gt, xe, id)
-			xe_gt_idle_disable_c6(gt);
-
 		err = xe_pcode_ready(xe, true);
 		if (err)
 			goto out;
 
+		for_each_gt(gt, xe, id)
+			xe_gt_idle_disable_c6(gt);
+
 		xe_display_pm_resume_early(xe);
 
 		/*
-- 
2.53.0



