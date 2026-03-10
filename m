Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26B42BF3E2;
	Tue, 10 Mar 2026 11:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141207; cv=none; b=FSmRJJj6pWrGj5z9cYoQQTI9jj+WiIqAWmW4pxpdwDlsojtZBgGGbIX7rYIjTl1DlbnkrEJMtKjiJdKBYO+kSpE5QqfoOW5U9gR3QIL3iCDWOzZzz4GZ4/aOIc5O71Rdj15h6t69qetoGH9TfeCFfo3S3Fkaotup5ZIyxNWtM/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141207; c=relaxed/simple;
	bh=ySYaSDGAKy+2J5SRWkuD2JQ1gld474Dl6NQPknsULc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AY35YUxmjL3L4TO+OGZdArwDHRiJWU1WnUyazm2CUgaUzg0Bx6zqo/SaiEn2UuPHMp/HJzAlW6njZQtwi3ITGzllyeEz+L2IXURlVGEpn4ik623eluIFYr/siYBeo9VIVMBEeFfpocD0I7WEqwJeoQNr2O5kcbBL/AYJua4b3Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ESlJmWsZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ESlJmWsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7A0C19423;
	Tue, 10 Mar 2026 11:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141207;
	bh=ySYaSDGAKy+2J5SRWkuD2JQ1gld474Dl6NQPknsULc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ESlJmWsZr1Z7c/0FwIub6CZwA8mAq4Y6MZ3ft8CZiDjicOUIErJdmpn/3uvi4q0wd
	 iqPUtIF2HrelVfRSjZY/ZndOqzHHauyIpPXxJZKZ2t807JjM8F8mzERBzFGBK9vaey
	 t2YT+IRGUR7vlxNnk7umtP3XTap4ry/R3n/3H041ycIxS/j6FMwzLMT+AZfpCNBZ8E
	 uLK8BQXu++r100rxyoUykvxVhP8WkyN8Nv1sgQ1p2o9bb9lx69R6BLWQTkvzIvX7+7
	 7x+686iy2jchJ6p6y0aWFJkCmpgWaSNcIGkd4E1HS2Qr/rgJ2B+B9iAwRpxhyAAgUv
	 o6oybVm9uJBUQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lizhi Hou <lizhi.hou@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 208/311] accel/amdxdna: Fill invalid payload for failed command
Date: Tue, 10 Mar 2026 07:04:15 -0400
Message-ID: <b669e70087a19a3373c5e2571432076b91488cd2.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 89ff45359abbf9d8d3c4aa3f5a57ed0be82b5a12 ]

Newer userspace applications may read the payload of a failed command
to obtain detailed error information. However, the driver and old firmware
versions may not support returning advanced error information.
In this case, initialize the command payload with an invalid value so
userspace can detect that no detailed error information is available.

Fixes: aac243092b70 ("accel/amdxdna: Add command execution")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260227004841.3080241-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c    | 23 ++++++++---------------
 drivers/accel/amdxdna/amdxdna_ctx.c | 27 +++++++++++++++++++++++++++
 drivers/accel/amdxdna/amdxdna_ctx.h |  3 +++
 3 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index 01a02f4c3a98d..9fc33b4298f23 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -186,13 +186,13 @@ aie2_sched_resp_handler(void *handle, void __iomem *data, size_t size)
 	cmd_abo = job->cmd_bo;
 
 	if (unlikely(job->job_timeout)) {
-		amdxdna_cmd_set_state(cmd_abo, ERT_CMD_STATE_TIMEOUT);
+		amdxdna_cmd_set_error(cmd_abo, job, 0, ERT_CMD_STATE_TIMEOUT);
 		ret = -EINVAL;
 		goto out;
 	}
 
 	if (unlikely(!data) || unlikely(size != sizeof(u32))) {
-		amdxdna_cmd_set_state(cmd_abo, ERT_CMD_STATE_ABORT);
+		amdxdna_cmd_set_error(cmd_abo, job, 0, ERT_CMD_STATE_ABORT);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -202,7 +202,7 @@ aie2_sched_resp_handler(void *handle, void __iomem *data, size_t size)
 	if (status == AIE2_STATUS_SUCCESS)
 		amdxdna_cmd_set_state(cmd_abo, ERT_CMD_STATE_COMPLETED);
 	else
-		amdxdna_cmd_set_state(cmd_abo, ERT_CMD_STATE_ERROR);
+		amdxdna_cmd_set_error(cmd_abo, job, 0, ERT_CMD_STATE_ERROR);
 
 out:
 	aie2_sched_notify(job);
@@ -244,13 +244,13 @@ aie2_sched_cmdlist_resp_handler(void *handle, void __iomem *data, size_t size)
 	cmd_abo = job->cmd_bo;
 
 	if (unlikely(job->job_timeout)) {
-		amdxdna_cmd_set_state(cmd_abo, ERT_CMD_STATE_TIMEOUT);
+		amdxdna_cmd_set_error(cmd_abo, job, 0, ERT_CMD_STATE_TIMEOUT);
 		ret = -EINVAL;
 		goto out;
 	}
 
 	if (unlikely(!data) || unlikely(size != sizeof(u32) * 3)) {
-		amdxdna_cmd_set_state(cmd_abo, ERT_CMD_STATE_ABORT);
+		amdxdna_cmd_set_error(cmd_abo, job, 0, ERT_CMD_STATE_ABORT);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -270,19 +270,12 @@ aie2_sched_cmdlist_resp_handler(void *handle, void __iomem *data, size_t size)
 		 fail_cmd_idx, fail_cmd_status);
 
 	if (fail_cmd_status == AIE2_STATUS_SUCCESS) {
-		amdxdna_cmd_set_state(cmd_abo, ERT_CMD_STATE_ABORT);
+		amdxdna_cmd_set_error(cmd_abo, job, fail_cmd_idx, ERT_CMD_STATE_ABORT);
 		ret = -EINVAL;
-		goto out;
+	} else {
+		amdxdna_cmd_set_error(cmd_abo, job, fail_cmd_idx, ERT_CMD_STATE_ERROR);
 	}
-	amdxdna_cmd_set_state(cmd_abo, ERT_CMD_STATE_ERROR);
 
-	if (amdxdna_cmd_get_op(cmd_abo) == ERT_CMD_CHAIN) {
-		struct amdxdna_cmd_chain *cc = amdxdna_cmd_get_payload(cmd_abo, NULL);
-
-		cc->error_index = fail_cmd_idx;
-		if (cc->error_index >= cc->command_count)
-			cc->error_index = 0;
-	}
 out:
 	aie2_sched_notify(job);
 	return ret;
diff --git a/drivers/accel/amdxdna/amdxdna_ctx.c b/drivers/accel/amdxdna/amdxdna_ctx.c
index e42eb12fc7c1b..4e48519b699ac 100644
--- a/drivers/accel/amdxdna/amdxdna_ctx.c
+++ b/drivers/accel/amdxdna/amdxdna_ctx.c
@@ -135,6 +135,33 @@ u32 amdxdna_cmd_get_cu_idx(struct amdxdna_gem_obj *abo)
 	return INVALID_CU_IDX;
 }
 
+int amdxdna_cmd_set_error(struct amdxdna_gem_obj *abo,
+			  struct amdxdna_sched_job *job, u32 cmd_idx,
+			  enum ert_cmd_state error_state)
+{
+	struct amdxdna_client *client = job->hwctx->client;
+	struct amdxdna_cmd *cmd = abo->mem.kva;
+	struct amdxdna_cmd_chain *cc = NULL;
+
+	cmd->header &= ~AMDXDNA_CMD_STATE;
+	cmd->header |= FIELD_PREP(AMDXDNA_CMD_STATE, error_state);
+
+	if (amdxdna_cmd_get_op(abo) == ERT_CMD_CHAIN) {
+		cc = amdxdna_cmd_get_payload(abo, NULL);
+		cc->error_index = (cmd_idx < cc->command_count) ? cmd_idx : 0;
+		abo = amdxdna_gem_get_obj(client, cc->data[0], AMDXDNA_BO_CMD);
+		if (!abo)
+			return -EINVAL;
+		cmd = abo->mem.kva;
+	}
+
+	memset(cmd->data, 0xff, abo->mem.size - sizeof(*cmd));
+	if (cc)
+		amdxdna_gem_put_obj(abo);
+
+	return 0;
+}
+
 /*
  * This should be called in close() and remove(). DO NOT call in other syscalls.
  * This guarantee that when hwctx and resources will be released, if user
diff --git a/drivers/accel/amdxdna/amdxdna_ctx.h b/drivers/accel/amdxdna/amdxdna_ctx.h
index 16c85f08f03c6..fbdf9d0008713 100644
--- a/drivers/accel/amdxdna/amdxdna_ctx.h
+++ b/drivers/accel/amdxdna/amdxdna_ctx.h
@@ -167,6 +167,9 @@ amdxdna_cmd_get_state(struct amdxdna_gem_obj *abo)
 
 void *amdxdna_cmd_get_payload(struct amdxdna_gem_obj *abo, u32 *size);
 u32 amdxdna_cmd_get_cu_idx(struct amdxdna_gem_obj *abo);
+int amdxdna_cmd_set_error(struct amdxdna_gem_obj *abo,
+			  struct amdxdna_sched_job *job, u32 cmd_idx,
+			  enum ert_cmd_state error_state);
 
 void amdxdna_sched_job_cleanup(struct amdxdna_sched_job *job);
 void amdxdna_hwctx_remove_all(struct amdxdna_client *client);
-- 
2.51.0

