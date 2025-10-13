Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6EA30B505;
	Mon, 13 Oct 2025 15:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369538; cv=none; b=ua93/9pflTGdt2YaC+yeyj03y6ME/mk7vvIZ7nIgCkctIXCOhi12kk4QbeER9MsEDyqtFyMNuwbYqK2ZSSHQB+9hTvIMjUU8ydTtHandwO79tgXeFQI5T+NXR8ZBB5CTPa9TO7mzz9xXrDEhZyDPiQ3KOZ90uAcJ0W0vx4S5Gdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369538; c=relaxed/simple;
	bh=Q9r0+TZHDDO+8A8uPBZTmXQaZ8vckD2qRxJH2FzCpHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntvTC5vtpRRCYL7t6OqWh0QAOIFd2Y7TNEKqcH2RzdLAsFY9IhFSlCUMlDNYLWIzlMILuN1EY9brTgGEAjUILnbAKc5jgvvp3j2QZem5wRVS8/ccXHGjCoi1kKk5KYvXNYu0HewU8bInBAGdRpv97saj5BK3gx44L4KmfuZ/alM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUeC5ZYW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUeC5ZYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF20C4CEE7;
	Mon, 13 Oct 2025 15:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369537;
	bh=Q9r0+TZHDDO+8A8uPBZTmXQaZ8vckD2qRxJH2FzCpHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NUeC5ZYW7F6lKp3Gqc4i1HZXI0gOB+x8vH92OBY0oo/wWJ5kAuLP9EhZR0JN6cZIE
	 MbpkmWq0xyTIO1h/6EzTHGioQDvCVV2sPZiqO++zE6sHtZbkyC9z0HiQsmA2ma+hqy
	 5wGLHkFAi62CKpHdvOIEQ281LC7DMIIHVR7os9Tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 282/563] accel/amdxdna: Use int instead of u32 to store error codes
Date: Mon, 13 Oct 2025 16:42:23 +0200
Message-ID: <20251013144421.487305982@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit 24de3daf6179bce3710527b8292d7ee6f1b56393 ]

Change the 'ret' variable from u32 to int to store -EINVAL.  Storing the
negative error codes in unsigned type, doesn't cause an issue at runtime
but it's ugly as pants.

Additionally, assigning -EINVAL to u32 ret (i.e., u32 ret = -EINVAL) may
trigger a GCC warning when the -Wsign-conversion flag is enabled.

Fixes: aac243092b70 ("accel/amdxdna: Add command execution")
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://lore.kernel.org/r/20250828033917.113364-1-rongqianfeng@vivo.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index 2cff5419bd2fa..cda964ba33cd7 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -192,7 +192,7 @@ aie2_sched_resp_handler(void *handle, void __iomem *data, size_t size)
 {
 	struct amdxdna_sched_job *job = handle;
 	struct amdxdna_gem_obj *cmd_abo;
-	u32 ret = 0;
+	int ret = 0;
 	u32 status;
 
 	cmd_abo = job->cmd_bo;
@@ -222,7 +222,7 @@ static int
 aie2_sched_nocmd_resp_handler(void *handle, void __iomem *data, size_t size)
 {
 	struct amdxdna_sched_job *job = handle;
-	u32 ret = 0;
+	int ret = 0;
 	u32 status;
 
 	if (unlikely(!data))
@@ -250,7 +250,7 @@ aie2_sched_cmdlist_resp_handler(void *handle, void __iomem *data, size_t size)
 	u32 fail_cmd_status;
 	u32 fail_cmd_idx;
 	u32 cmd_status;
-	u32 ret = 0;
+	int ret = 0;
 
 	cmd_abo = job->cmd_bo;
 	if (unlikely(!data) || unlikely(size != sizeof(u32) * 3)) {
-- 
2.51.0



