Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B9444AB62;
	Tue, 21 Jul 2026 21:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670702; cv=none; b=gjMlrQMgXszkPL5JI91SwRKgPSlgN3OWCtwO5SfCVnJC/PAdSYO83gk7N4kyamDuBIwOyoZEZJDxHzuRGOZEsGtj73x17afx/SVxiwuuWN+BHobPbeM7HytouOCLvNs3qc2lj2AgYpylvjtPoS8y2jXGbYkc4MHmnLErqfQAbtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670702; c=relaxed/simple;
	bh=U6wIVeor9Un5muGRxHB1aRZ5ymbGz69hAdC+jDjXyjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNKyqnii9EAu2sAal5sz8M5QDaU4nz+B+X+gOaSJO9zRDJiBhH1Y/kiErrJGZdP4AAnZU9Hb0euUOPissDFO5jmItHBFNKYOvhfjpKm6RsMFlDzRI4/rwuYS5OMb2iUodszTnwd0haIWooEg++0+9uir4bV7rBteT9NwnOOI9X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FaA6oHM7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FaA6oHM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CDE1F000E9;
	Tue, 21 Jul 2026 21:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670701;
	bh=mtDGiCJgOMRMOuglPu0bet9/5jLGm7BTULhMz2R2+JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FaA6oHM7Uj5dOvYuAHWAf/bnVR4a9RaFap4AeHtx2dBWicmgJQnzAUSnWqnHw8nJf
	 TVdPnpXLc/J8mfEJ5MVKzBIvranQ1d1vzYNxYc3BkpIONh5yNQdX9dKIb1U/jefy/l
	 3nt1d8AVn9z8Bz/WanoI3oYcuFQcMsg8CgiqHapg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1033/1067] nvmet: remove superfluous initialization
Date: Tue, 21 Jul 2026 17:27:14 +0200
Message-ID: <20260721152447.690052212@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


