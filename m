Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94E2748A;
	Thu, 12 Dec 2024 15:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017272; cv=none; b=VZORf67g2bT2YlgdY4+/DtBq8MTscf15pu1xp2tk+z4zaH6zOiDCZQYEcEVbw4ccXeGRJUOR/EZYmjWTY2cOYdG8HSvgVLLJNy8uqu/YS4izA81cHZvkSAHo0f4bNr++Dpu5RCYvGuWZsKFMY0QZDINXKLQ9wGmwY6kH7TeCzxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017272; c=relaxed/simple;
	bh=g11rRTdbcTKYznC4spJO8FMa0Dd06ajhVFe9GkCW0jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAJpRbl0IfGyEMyz9aFB5Nvfd9lVVwjjt4slHo82ktAM+IhAE3DyX39uzyn6nGs0kcOu2klA/IkhIo+tqMYZhfhxW8tICCjUys6XzOq149j8yXM/MYm2K+kx+FQEfA/gv97sg8MDy9ygK1CWMZ8hthzZkTqAbhCgnaPJVNkLPBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPQoS0nu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPQoS0nu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0199EC4CECE;
	Thu, 12 Dec 2024 15:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017272;
	bh=g11rRTdbcTKYznC4spJO8FMa0Dd06ajhVFe9GkCW0jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPQoS0nuO/8L6ByoqIUZyAciqpeiOJ0B3NCU0/dnjyLTe0hh6I2TUWkJGmmSilqLS
	 aE1aq8eHhOL1OUVfS+wB7X6OLXQpokze2kVJJ8peSoM16QHkL5FCgYDYHhtAxiiCUj
	 EI3gylKPBVCigOELdCA6Z6Ax4B0AlUZjW8bVbFgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Harrison <John.C.Harrison@Intel.com>,
	Julia Filipchuk <julia.filipchuk@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 432/466] drm/xe/devcoredump: Improve section headings and add tile info
Date: Thu, 12 Dec 2024 16:00:01 +0100
Message-ID: <20241212144323.939242046@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: John Harrison <John.C.Harrison@Intel.com>

[ Upstream commit c28fd6c358db44c87a1408f27ba412c94e25e6c2 ]

The xe_guc_exec_queue_snapshot is not really a GuC internal thing and
is definitely not a GuC CT thing. So give it its own section heading.
The snapshot itself is really a capture of the submission backend's
internal state. Although all it currently prints out is the submission
contexts. So label it as 'Contexts'. If more general state is added
later then it could be change to 'Submission backend' or some such.

Further, everything from the GuC CT section onwards is GT specific but
there was no indication of which GT it was related to (and that is
impossible to work out from the other fields that are given). So add a
GT section heading. Also include the tile id of the GT, because again
significant information.

Lastly, drop a couple of unnecessary line feeds within sections.

v2: Add GT section heading, add tile id to device section.

Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Reviewed-by: Julia Filipchuk <julia.filipchuk@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241003004611.2323493-4-John.C.Harrison@Intel.com
Stable-dep-of: 5dce85fecb87 ("drm/xe: Move the coredump registration to the worker thread")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_devcoredump.c       | 5 +++++
 drivers/gpu/drm/xe/xe_devcoredump_types.h | 3 ++-
 drivers/gpu/drm/xe/xe_device.c            | 1 +
 drivers/gpu/drm/xe/xe_guc_submit.c        | 2 +-
 drivers/gpu/drm/xe/xe_hw_engine.c         | 1 -
 5 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_devcoredump.c b/drivers/gpu/drm/xe/xe_devcoredump.c
index d23719d5c2a3d..2690f1d1cde4c 100644
--- a/drivers/gpu/drm/xe/xe_devcoredump.c
+++ b/drivers/gpu/drm/xe/xe_devcoredump.c
@@ -96,8 +96,13 @@ static ssize_t __xe_devcoredump_read(char *buffer, size_t count,
 	drm_printf(&p, "Process: %s\n", ss->process_name);
 	xe_device_snapshot_print(xe, &p);
 
+	drm_printf(&p, "\n**** GT #%d ****\n", ss->gt->info.id);
+	drm_printf(&p, "\tTile: %d\n", ss->gt->tile->id);
+
 	drm_puts(&p, "\n**** GuC CT ****\n");
 	xe_guc_ct_snapshot_print(ss->ct, &p);
+
+	drm_puts(&p, "\n**** Contexts ****\n");
 	xe_guc_exec_queue_snapshot_print(ss->ge, &p);
 
 	drm_puts(&p, "\n**** Job ****\n");
diff --git a/drivers/gpu/drm/xe/xe_devcoredump_types.h b/drivers/gpu/drm/xe/xe_devcoredump_types.h
index 440d05d77a5af..3cc2f095fdfbd 100644
--- a/drivers/gpu/drm/xe/xe_devcoredump_types.h
+++ b/drivers/gpu/drm/xe/xe_devcoredump_types.h
@@ -37,7 +37,8 @@ struct xe_devcoredump_snapshot {
 	/* GuC snapshots */
 	/** @ct: GuC CT snapshot */
 	struct xe_guc_ct_snapshot *ct;
-	/** @ge: Guc Engine snapshot */
+
+	/** @ge: GuC Submission Engine snapshot */
 	struct xe_guc_submit_exec_queue_snapshot *ge;
 
 	/** @hwe: HW Engine snapshot array */
diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index a1987b554a8d2..bb85208cf1a94 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -919,6 +919,7 @@ void xe_device_snapshot_print(struct xe_device *xe, struct drm_printer *p)
 
 	for_each_gt(gt, xe, id) {
 		drm_printf(p, "GT id: %u\n", id);
+		drm_printf(p, "\tTile: %u\n", gt->tile->id);
 		drm_printf(p, "\tType: %s\n",
 			   gt->info.type == XE_GT_TYPE_MAIN ? "main" : "media");
 		drm_printf(p, "\tIP ver: %u.%u.%u\n",
diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index 2927745d68954..fed23304e4da5 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -2193,7 +2193,7 @@ xe_guc_exec_queue_snapshot_print(struct xe_guc_submit_exec_queue_snapshot *snaps
 	if (!snapshot)
 		return;
 
-	drm_printf(p, "\nGuC ID: %d\n", snapshot->guc.id);
+	drm_printf(p, "GuC ID: %d\n", snapshot->guc.id);
 	drm_printf(p, "\tName: %s\n", snapshot->name);
 	drm_printf(p, "\tClass: %d\n", snapshot->class);
 	drm_printf(p, "\tLogical mask: 0x%x\n", snapshot->logical_mask);
diff --git a/drivers/gpu/drm/xe/xe_hw_engine.c b/drivers/gpu/drm/xe/xe_hw_engine.c
index c9c3beb3ce8d0..547919e8ce9e4 100644
--- a/drivers/gpu/drm/xe/xe_hw_engine.c
+++ b/drivers/gpu/drm/xe/xe_hw_engine.c
@@ -1053,7 +1053,6 @@ void xe_hw_engine_snapshot_print(struct xe_hw_engine_snapshot *snapshot,
 	if (snapshot->hwe->class == XE_ENGINE_CLASS_COMPUTE)
 		drm_printf(p, "\tRCU_MODE: 0x%08x\n",
 			   snapshot->reg.rcu_mode);
-	drm_puts(p, "\n");
 }
 
 /**
-- 
2.43.0



