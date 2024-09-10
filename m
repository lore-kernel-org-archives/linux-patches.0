Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8ABEEC9;
	Tue, 10 Sep 2024 09:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962307; cv=none; b=PTNUJPGJ178JgNkI4jh0ejxrLBPP5K2g0pXbG1XUWjZKhzac/z9Lj0dyVHvQpC2t090vYekd5NUIWXIP4PnK6xGtX1ysslBo8yoXHZ6UwxNh/OJxFqAYLMNU7zDwE9IuSSk4GfyuxpCOo8KQMeyC9xVnMfCOtOdY3SJ1Gz/efmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962307; c=relaxed/simple;
	bh=f8/mC497iKN1ns4zbcICCW6c/HwykwVR27XceAz/xq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUPwPFAP6v2fxsQvsZp9sslXy534posV7UC/s0HvMG2YBBV5w3OlqtRlxCw9t92h9iCV7qIN/zvAphr/r0vmqd8pl6OAKEtN2sjnNQFpBqsWiuNBj6U0uN6FE8JWtruIqiG9fl3ZXy30hop7XpCaaILxS8xAS4hi6aP9oZET1VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NClgQdsh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NClgQdsh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84ABC4CEC6;
	Tue, 10 Sep 2024 09:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962307;
	bh=f8/mC497iKN1ns4zbcICCW6c/HwykwVR27XceAz/xq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NClgQdsh2d9d/V7MqhxNBfCeNsPKndUp92Z2f3vU8nIpRJYCNU5saRonsJICCfyTf
	 t4pm2AfEWwAXvEd3rXXC5nnsmXUAyBS9j3+8H3PX8JgyKpTnneP7ObvyBHKXQJoGZ5
	 BR/EUzyIWWIKucND1F2t4UQck5+FFkeJFcVXLloI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiwen Hu <huweiwen@linux.alibaba.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 365/375] nvme: rename nvme_sc_to_pr_err to nvme_status_to_pr_err
Date: Tue, 10 Sep 2024 11:32:42 +0200
Message-ID: <20240910092634.882981730@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

From: Weiwen Hu <huweiwen@linux.alibaba.com>

[ Upstream commit 22f19a584d7045e0509f103dbc5c0acfd6415163 ]

This should better match its semantic.  "sc" is used in the NVMe spec to
specifically refer to the last 8 bits in the status field. We should not
reuse "sc" here.

Signed-off-by: Weiwen Hu <huweiwen@linux.alibaba.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 899d2e5a4e3d ("nvmet: Identify-Active Namespace ID List command should reject invalid nsid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index 8fa1ffcdaed4..a6db5edfab03 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -72,12 +72,12 @@ static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
 	return nvme_submit_sync_cmd(ns->queue, c, data, data_len);
 }
 
-static int nvme_sc_to_pr_err(int nvme_sc)
+static int nvme_status_to_pr_err(int status)
 {
-	if (nvme_is_path_error(nvme_sc))
+	if (nvme_is_path_error(status))
 		return PR_STS_PATH_FAILED;
 
-	switch (nvme_sc & 0x7ff) {
+	switch (status & 0x7ff) {
 	case NVME_SC_SUCCESS:
 		return PR_STS_SUCCESS;
 	case NVME_SC_RESERVATION_CONFLICT:
@@ -121,7 +121,7 @@ static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
 	if (ret < 0)
 		return ret;
 
-	return nvme_sc_to_pr_err(ret);
+	return nvme_status_to_pr_err(ret);
 }
 
 static int nvme_pr_register(struct block_device *bdev, u64 old,
@@ -196,7 +196,7 @@ static int nvme_pr_resv_report(struct block_device *bdev, void *data,
 	if (ret < 0)
 		return ret;
 
-	return nvme_sc_to_pr_err(ret);
+	return nvme_status_to_pr_err(ret);
 }
 
 static int nvme_pr_read_keys(struct block_device *bdev,
-- 
2.43.0



