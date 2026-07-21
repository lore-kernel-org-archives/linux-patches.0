Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAA345A2A1;
	Tue, 21 Jul 2026 21:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667885; cv=none; b=Pj6pNv7swtpJFHl0750cEyJ9zenm2C+MTDWV05Mp1RCwFC1lkc34hoaVMcjs3+d0scKTxx/eZMcWH6HNJeiYkGEteS4QW+ia7kVBdzZBayAMB1TKkkh1jNjfq/6RNGZK6wikclHQ81DvAKT4hHwk9X1UUcWvwZDSs4eFz98ucnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667885; c=relaxed/simple;
	bh=ZHm1fS4ewKvpH1oFw26TljMioUtAqcxkyicK64tJVGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRz4o6JMEYXdP15n9+UCxiAbhBlPq2qoWyRC78sUHV/0zJL/WwTZq9dTH36mk4ipwpQwqPPVu7LK8OCK0KjPCyVSd0B79Z+vZEWhXiyO2Ps3BPuYJtdYUeNh4F22kt9crc/a0KSn+NdIZbBKK7DwH3knE7K3b4idnn2R4fGwAwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0BABn17; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0BABn17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F4C1F000E9;
	Tue, 21 Jul 2026 21:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667883;
	bh=NjHeIRkK3C4FI73QQ44C+/j/O7U91zTE03LAFKGxTdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y0BABn17gNFPoKvo7vQrt2Rw54yRbdWXi4biCtSuvc4oni0JTh3aNv1+aegOKK/Zu
	 /SY6qJMFnZrb/C/C0qLoOA6g9tLtlOeAekLNT9kgdLdRx179Vo25wIUYNlp0CbLJ1c
	 obIvpsFbCm/tIPdf/Mrwam2y7k6s7hogajFqzhD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1228/1266] nvmet: remove superfluous initialization
Date: Tue, 21 Jul 2026 17:27:45 +0200
Message-ID: <20260721152509.282661625@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Chaitanya Kulkarni <kch@nvidia.com>

[ Upstream commit 8d30528a170905ede9ab6ab81f229e441808590b ]

Remove superfluous initialization of status variable in
nvmet_execute_admin_connect() and nvmet_execute_io_connect(), since it
will get overwritten by nvmet_copy_from_sgl().

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 3a413ece2504 ("nvmet-auth: validate reply message payload bounds against transfer length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/fabrics-cmd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/nvme/target/fabrics-cmd.c
+++ b/drivers/nvme/target/fabrics-cmd.c
@@ -209,7 +209,7 @@ static void nvmet_execute_admin_connect(
 	struct nvmf_connect_command *c = &req->cmd->connect;
 	struct nvmf_connect_data *d;
 	struct nvmet_ctrl *ctrl = NULL;
-	u16 status = 0;
+	u16 status;
 	int ret;
 
 	if (!nvmet_check_transfer_len(req, sizeof(struct nvmf_connect_data)))
@@ -287,7 +287,7 @@ static void nvmet_execute_io_connect(str
 	struct nvmf_connect_data *d;
 	struct nvmet_ctrl *ctrl;
 	u16 qid = le16_to_cpu(c->qid);
-	u16 status = 0;
+	u16 status;
 
 	if (!nvmet_check_transfer_len(req, sizeof(struct nvmf_connect_data)))
 		return;


