Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D1B1A76A5;
	Tue, 30 Jul 2024 17:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360732; cv=none; b=XMYJOd4vkpdvpI70Bq9VRBcIDRtYel3qZs9CyrqSJIqPDgTEZOhErJopSQ8rby3657hqdVzlI294anwyowQN/6T1YX7Izjys4Ducl2DMqD2WDAqYXCFqeazk0r3aoDqNkc5q4H+AUVPo9FryZMoU+vmI2rII5ZSaBsNzJz8reus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360732; c=relaxed/simple;
	bh=LlIqln0o6XOTPjmF8wB2yXQetn9O6IPdYvb1dXXndQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9CE09pSdaoeKk9/sgifgSt8TZ3Ftuq17jVM8vYMUSW4klZbLIz4MQ1Fp6uzA2W6Z89w+xxR6KBFo8XmSTVbMSHclV7n3C3J9EmFYnc45uABI15tEpZJPbTBJQUfEtitMHWU9G2cWAQJV+rZxb6FeIo6xWK4et7y+hqMu8iB39E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJiT1EjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJiT1EjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECC2C4AF0E;
	Tue, 30 Jul 2024 17:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360732;
	bh=LlIqln0o6XOTPjmF8wB2yXQetn9O6IPdYvb1dXXndQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJiT1EjPRaLNQ9bWUYnflTBTTAHPAyfydCUcw7GMwTFf4EEFvoqXSdYU38D40944v
	 HuxCnCCN2qgq6fc87bqxtAM2BeQUk79aJRId9Y6zCq+FwbYUqo1drL4q1TE1/DkdR4
	 dT6aSBk79ACpcu+5tsPhklXA1C9v6rsm2iw1WlO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 789/809] drm/xe/exec: Fix minor bug related to xe_sync_entry_cleanup
Date: Tue, 30 Jul 2024 17:51:05 +0200
Message-ID: <20240730151756.130519044@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

[ Upstream commit 408c2f14a5d3d7ac4824b96e52693ab271efb738 ]

Increment num_syncs after xe_sync_entry_parse() is successful to ensure
the xe_sync_entry_cleanup() logic under "err_syncs" label works correctly.

v2: Use the same pattern as that in xe_vm.c (Matt Brost)

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240711211203.3728180-1-ashutosh.dixit@intel.com
(cherry picked from commit 43a6faa6d9b5e9139758200a79fe9c8f4aaa0c8d)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_exec.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_exec.c b/drivers/gpu/drm/xe/xe_exec.c
index 97eeb973e897c..074344c739abc 100644
--- a/drivers/gpu/drm/xe/xe_exec.c
+++ b/drivers/gpu/drm/xe/xe_exec.c
@@ -118,7 +118,7 @@ int xe_exec_ioctl(struct drm_device *dev, void *data, struct drm_file *file)
 	u64 addresses[XE_HW_ENGINE_MAX_INSTANCE];
 	struct drm_gpuvm_exec vm_exec = {.extra.fn = xe_exec_fn};
 	struct drm_exec *exec = &vm_exec.exec;
-	u32 i, num_syncs = 0, num_ufence = 0;
+	u32 i, num_syncs, num_ufence = 0;
 	struct xe_sched_job *job;
 	struct xe_vm *vm;
 	bool write_locked, skip_retry = false;
@@ -156,15 +156,15 @@ int xe_exec_ioctl(struct drm_device *dev, void *data, struct drm_file *file)
 
 	vm = q->vm;
 
-	for (i = 0; i < args->num_syncs; i++) {
-		err = xe_sync_entry_parse(xe, xef, &syncs[num_syncs++],
-					  &syncs_user[i], SYNC_PARSE_FLAG_EXEC |
+	for (num_syncs = 0; num_syncs < args->num_syncs; num_syncs++) {
+		err = xe_sync_entry_parse(xe, xef, &syncs[num_syncs],
+					  &syncs_user[num_syncs], SYNC_PARSE_FLAG_EXEC |
 					  (xe_vm_in_lr_mode(vm) ?
 					   SYNC_PARSE_FLAG_LR_MODE : 0));
 		if (err)
 			goto err_syncs;
 
-		if (xe_sync_is_ufence(&syncs[i]))
+		if (xe_sync_is_ufence(&syncs[num_syncs]))
 			num_ufence++;
 	}
 
@@ -325,8 +325,8 @@ int xe_exec_ioctl(struct drm_device *dev, void *data, struct drm_file *file)
 	if (err == -EAGAIN && !skip_retry)
 		goto retry;
 err_syncs:
-	for (i = 0; i < num_syncs; i++)
-		xe_sync_entry_cleanup(&syncs[i]);
+	while (num_syncs--)
+		xe_sync_entry_cleanup(&syncs[num_syncs]);
 	kfree(syncs);
 err_exec_queue:
 	xe_exec_queue_put(q);
-- 
2.43.0



