Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D68A1DD9A6;
	Mon,  6 Jan 2025 15:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177689; cv=none; b=NbDSROUB/NBmCnwfwkwwQfKwiFeGUiB6U68vJgIwxjzTOhi8dGAUN5qpBmFj7FYmQgU1lX16wxs548Hg7oO02+JIRWL9Zi7B4PRTbTCHwzH6bR4hQoXPj8I/wTMnlKVXPIlOeUSxwqtdeix9hrJFgiVD7TH00jrNMIE6nZfsgZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177689; c=relaxed/simple;
	bh=R5ytUBjOpU0atyZqS+CvA+XPAFwCHjg1BULbfhEVLTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SoESHk6uVKZ65oKDsAjA4KFqiIU9jAtJ3DZjTiTWLCeizROb/KYhqYj+t+8H0N5anFR+3IyXONRW2JuV+kodxVMMEe6qVajXJlNep8b66uyN0p3dRODC1NRyClHBtDMOr0sSpeA7JOKNihR23nfI64qRfiz28tR+sg1vrsGwrn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjnkKvoH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjnkKvoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736FBC4CED2;
	Mon,  6 Jan 2025 15:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177688;
	bh=R5ytUBjOpU0atyZqS+CvA+XPAFwCHjg1BULbfhEVLTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjnkKvoH/o1L3HOdx6a6IW4ODzLqPYBW4DFS+25DgGEB8wsgL8wZ0PWLI1CW4EesI
	 hfV+qTzlKqSt+TtG/zUcK2h6fpu1NpXNocGiPMcg20kV9pzfl1AdUd9omAIrMxydHi
	 xovqNfoZbbeykD1mbhqXciYlLJaWpFrt+HnZWS3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Chiara Meiohas <cmeiohas@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/156] RDMA/nldev: Set error code in rdma_nl_notify_event
Date: Mon,  6 Jan 2025 16:15:10 +0100
Message-ID: <20250106151142.652669307@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

From: Chiara Meiohas <cmeiohas@nvidia.com>

[ Upstream commit 13a6691910cc23ea9ba4066e098603088673d5b0 ]

In case of error set the error code before the goto.

Fixes: 6ff57a2ea7c2 ("RDMA/nldev: Fix NULL pointer dereferences issue in rdma_nl_notify_event")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-rdma/a84a2fc3-33b6-46da-a1bd-3343fa07eaf9@stanley.mountain/
Signed-off-by: Chiara Meiohas <cmeiohas@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Link: https://patch.msgid.link/13eb25961923f5de9eb9ecbbc94e26113d6049ef.1733815944.git.leonro@nvidia.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/nldev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 7dc8e2ec62cc..f12189986303 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -2802,8 +2802,8 @@ int rdma_nl_notify_event(struct ib_device *device, u32 port_num,
 			  enum rdma_nl_notify_event_type type)
 {
 	struct sk_buff *skb;
+	int ret = -EMSGSIZE;
 	struct net *net;
-	int ret = 0;
 	void *nlh;
 
 	net = read_pnet(&device->coredev.rdma_net);
-- 
2.39.5



