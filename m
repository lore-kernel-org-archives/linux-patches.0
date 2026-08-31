Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2DC47ACF1;
	Mon, 31 Aug 2026 13:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184538; cv=none; b=mr6d+trpMS5qdU0utI0ZSm+a32RLHOouEidygSBoQJGkGW7EZXzuIIoGygDnqBQla7zB5dk3LbhNLsPma4ws624NNgtKwRkHJLZCSwLvoFzhHjH+ooxv//apR04UbgU6r0lcdbDkHHf4QdwfaJLVAnDbwFJ9Kn+lqzAMU6isTds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184538; c=relaxed/simple;
	bh=z2ckaUxiqhMwGJJm1j54eMrOwuQh4LgZpopd41r2C/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZHzQqibRnnmGGtcRl7acBj93//38NA5WQelDa189/ntNHz5fDYDPDbBoLrQKa/PdYRWPPkBeReZNaRttqfj2VnjWx5qUtLciiXasWefISy9QfelfeILLqEQmM8UG/ex0EeCMsYTGY69/16Si9WI6Ws4UIqZiDmII8bNsIDs+3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3F7E/W5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3F7E/W5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D1D1F000E9;
	Mon, 31 Aug 2026 13:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184536;
	bh=MM+YxIjI7HJhe1q0aPYSkqAbx2BJAXJgvK4t2GKwiyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3F7E/W5pn0mi7qPjmpxdz5pMoL3iH/PpYCi1LC/K8h5ieJZD+WUT1vMBYEU682gg
	 LrTVjvW3JARIBhpMEpAGcQf1uqDWNwrUXlLTkWig45daB9Is1MsglCcWIsYA/6mrKU
	 Ox/jpbKcUlpKcWlFYF8c22cocciiqYd8BdrbNMNk=
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
Subject: [PATCH 6.6 43/91] nvme: rename nvme_sc_to_pr_err to nvme_status_to_pr_err
Date: Mon, 31 Aug 2026 15:34:31 +0200
Message-ID: <20260831133401.971314347@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 4a3f00262a04 ("nvmet-tcp: bound SGL data length before allocating command buffers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pr.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -72,12 +72,12 @@ static int nvme_send_ns_pr_command(struc
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
@@ -122,7 +122,7 @@ static int nvme_pr_command(struct block_
 	if (ret < 0)
 		return ret;
 
-	return nvme_sc_to_pr_err(ret);
+	return nvme_status_to_pr_err(ret);
 }
 
 static int nvme_pr_register(struct block_device *bdev, u64 old,
@@ -197,7 +197,7 @@ retry:
 	if (ret < 0)
 		return ret;
 
-	return nvme_sc_to_pr_err(ret);
+	return nvme_status_to_pr_err(ret);
 }
 
 static int nvme_pr_read_keys(struct block_device *bdev,


