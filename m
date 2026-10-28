Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212099;
	b=XyR+5HIkuXE/+XR/pTP2btRsaq3mF0nxIosrpc5L7JPS0/ObE3YiItJ2kozSnR5KP6He
	 BhWc9NsUJ0o55x9krQjMJ6cBR9UDKpB+6MRlf4pYZBU2f8QY6XVEdq3Skla148ovk+NFu
	 oKIKM/dvm1uNOfIgNmpKMT+eiAWC4+q5wwkzuqOv9IsrFqPCnpyQfhnqc5g0JWc+wToGi
	 +KSFaCEvNSPNWr2uR48OV3eIAevunhFGgs4QAPLrvCf40n/AwsDneHBKjow4J7u60+9tq
	 aoQbDPeEzK9106WD4QvxLzMUjoDQlkozWW3xg+xxT6pCqDUI99100AC3m9YFZPLBZxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=30Oe9zNb9LXG9nRUZhk4gFY08bkyE25nnluT2HCvZoE=;
	b=eI+7f7GfOf/iWwLExeE9QP1BmBxJjsaSGgzzFSVQgnz/4id9BSKZBA1frqyRDoU53qdw
	 yAi4KI43BmS+dpM915wUyX2Nr8cehYt1DBlAZiuhRRRljNlUZTwDxv5lVDcnw7UYdQN5S
	 dV5drWKu9XIG6RTfivME+782avgE8TDhyDI5c+rdbCzIzpf04EFDygCDd7dwZ5LIaQOqc
	 NFW7qJ6vdqFrKTiZPmkDs8JbKpK3nYEwP/m6czrxDpZKfLx7N8Pe52Sfjw//dCfW4jhey
	 zZntg7zE/6YLb1zBGjSzr2gfqTfYBJLzmoFembch3dOyS8B7RKgD8ASJIae+5OiBsQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hgZPQF+7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C14606A31A;
	Wed, 28 Oct 2026 18:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hgZPQF+7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BE71F01825;
	Wed, 28 Oct 2026 18:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212098;
	bh=30Oe9zNb9LXG9nRUZhk4gFY08bkyE25nnluT2HCvZoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hgZPQF+7Yc6JtH8Dv8AmxdpXnhMEoem2HGcf1/q/QnqCmDEPqKDF0CPy2mJZIqNGw
	 dliXA7yxVrad2194LuI6uC/8alY1lQAw2lTpG4oNLMXNLyK1HspMDHCJ3T1dkeMZW5
	 Z//SeE09lJteoNDpk/Udofcgu8s8gNxB7y4bHHAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0037/1887] nvme: add missing SRCU grace period in error path
Date: Wed, 28 Oct 2026 17:35:33 +0100
Message-ID: <20261028170500.069870090@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit ef248d5de4469fb6bbaf8dbe0c4c47800080d648 ]

nvme_alloc_ns() error path at out_unlink_ns removes ns from the
namespace head siblings list with list_del_rcu(&ns->siblings) but
does not wait for SRCU readers before freeing the namespace struct.
Multipath code iterates the head->list under srcu_read_lock() in
nvme_find_path() and nvme_mpath_revalidate_paths(), so a concurrent
reader can still hold a reference to ns when kfree(ns) runs.

The normal removal path in nvme_ns_remove() correctly calls
synchronize_srcu(&ns->head->srcu) after list_del_rcu() to wait for
in-progress readers. Add the same grace period in the error path.

Fixes: ed754e5deeb1 ("nvme: track shared namespaces")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
[ Adjusted patch context to account for missing last_path reference-counting code. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 66600341bd6aa..1faef93ce4ba6 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4437,6 +4437,9 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, struct nvme_ns_info *info)
 	if (list_empty(&ns->head->list))
 		list_del_init(&ns->head->entry);
 	mutex_unlock(&ctrl->subsys->lock);
+
+	/* guarantee not available in head->list */
+	synchronize_srcu(&ns->head->srcu);
 	nvme_put_ns_head(ns->head);
  out_cleanup_disk:
 	put_disk(disk);
-- 
2.53.0



