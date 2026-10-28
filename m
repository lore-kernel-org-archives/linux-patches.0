Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210421;
	b=O+5qv7QNOQqCZcohf0IRBaMZSB3VxPuAXJeVSWOePfJsOQhi22a+k8Tl/VAHNowLkUH+
	 Q5wJhd4yX/qHcuOcF7xjhrrxlyC7wUlZ/0kpGnqf73gKRHLoOehPxMR48e82MPRmabcVp
	 FjYr6p5HDD/4I7hromcC4rGtU7NeylXGneQHAIuoNNPCpJX1tef3UOR8dMvP8MnaJbZeZ
	 3MBu1k9TimUpg/aNQNpkYLrYvR3t9uxg7FNJwGgvDM9uIvZszC5eOkoYDaHT5ZdMdXleA
	 VgT92M+RMcDZYIIoS9MYUjHahT57h/aqbmO5VTbk6pNsXD5nXCB0TLH1o+tVwp9SfvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210421;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xqdzEarw5kLj/rKazPKZ1OVuS60BSQjuvYHX6cpQANI=;
	b=ZE70jhtl52BIH3x9A7grQlhUJRF7ljkoLxxTdo/cTSPp4Oyoq2N3faNRd4V4yT21WQLO
	 rjaOlj9Sywc46eDBaXwDIgatjtJm6OvDKAGJrSeknQ5vQMESyGwh0tJP6yE3npelCtk+c
	 c3hDcwDD/6Kc7635fY7j8nDxeadFn2gnV+U5OtLL/U/pNepk7udT+1jTEon2BKlSSblzt
	 6tGh6FZ32tq7AM7WLQvnkv8RRKBnc/giaIS1PUCMJvrLCmZW27cC/m5wpZl+gVPm/n/gw
	 fJ5cdL8hmgzAQUPv87mVE00h3z1IFMbPvIjuVlYhmF83MT0sdLUptXFdzuUlxDbgS3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iyoouDSV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D133A606A31A;
	Wed, 28 Oct 2026 18:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iyoouDSV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333111F01825;
	Wed, 28 Oct 2026 18:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210420;
	bh=xqdzEarw5kLj/rKazPKZ1OVuS60BSQjuvYHX6cpQANI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iyoouDSVUPJZtQWn3I9m94M0/ZF3jU1ZomcDX+Ex5r4/YD4B5CwfiMfOQMd6zbbbb
	 fSYCJWahe14RRlaUxitg0uyeAvWYCz0LkrmEwdaBgdEKv2S9ML6HAVfhcZc8G6kDrT
	 ckbCEargWOCOxjKX+Y5FCP6kFmnYgfb+Os/TwrQQ=
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
Subject: [PATCH 5.15 020/571] nvme: add missing SRCU grace period in error path
Date: Wed, 28 Oct 2026 17:52:47 +0100
Message-ID: <20261028170008.502081469@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d34c732baee54..97c6d6aa4ccf5 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3953,6 +3953,9 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 	if (list_empty(&ns->head->list))
 		list_del_init(&ns->head->entry);
 	mutex_unlock(&ctrl->subsys->lock);
+
+	/* guarantee not available in head->list */
+	synchronize_srcu(&ns->head->srcu);
 	nvme_put_ns_head(ns->head);
  out_cleanup_disk:
 	blk_cleanup_disk(disk);
-- 
2.53.0



