Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208155;
	b=vCeYxAYEVxwu4k0m2UKRiQktcia1h0r/xYOfsf5b7rI4MuZIvAgY+nhpiF9H8b0LtHIR
	 K7Kn2Y6L37xlokRffdEWgC97a3cyR1GGimaY99umXTLnOjw9+gMqWkL/kn5KVQhpQ5JWL
	 n6e06kuvKjxix7SXkvYf8W6LlIYWSIbvvoeF0XlHbYf96Aee62/xYy7W16qrEQwGKP6wU
	 +AMdN5HW158eIQUjMTYzuwAczj427epDNGHqcSRNL/8diU2ZDzCjfXdN+7jaeTPrACS/O
	 QauKh7qh1d3NqfLd8eFJpvwaX+o3WmCwGSByxb3YBmqpuU3MlbUJ4A3UuA2fwt1W1+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fnKp7G7Ht5DhzH6FJZws6ebRINCSicj0r0L9RCHegbA=;
	b=k0i7hpWRGwzrgjRM/EZSiDaxdFn/NseEc0F2OBmx20pkGBXGQXtI39/d5tdJh3TjNp4l
	 o8q4GT0POa4kPDyZmGCzsMmtW0K4I4csIMbLPPEuxuP93DnfyTkFtxCJ4+wZD8cijWa1i
	 w/GzZUOUDHrNSgTrYBTJkQJg4UWzLvJ5OnhtT+UPujOji8sDhkgrLGw/4mbBR1FERQpev
	 fi2Z5xif0i+AZsobT2qoMiGvnjpVaaA1Y7qlPrhI+LRtLPRcCYHEiPqHJxXwNeMUbl2bG
	 faeRTW4PpxIswLyZ/o5B0J36IJbs9J89JLorK+2evr06rGUfjJ3dVTSFGzeAADh6rkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CVmQzF/M";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D51606A31A;
	Wed, 28 Oct 2026 17:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CVmQzF/M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6944C1F01825;
	Wed, 28 Oct 2026 17:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208154;
	bh=fnKp7G7Ht5DhzH6FJZws6ebRINCSicj0r0L9RCHegbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CVmQzF/MmtXDxQePDUAtLUapBtLftUCGv1PO8bvA8ahamzzz8iLaaizLmH45s2fut
	 bzF4Tz1+Rtjt7z9qCgxhc80Nj0yQU8uskd7vRUPDKG63MfqTwo8QeJWwBTkjzC8Btz
	 lG6+8qWL/AyKgh3/ES0Lz+kQBs69wKP/SNpktXAQ=
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
Subject: [PATCH 5.10 021/516] nvme: add missing SRCU grace period in error path
Date: Wed, 28 Oct 2026 17:52:53 +0100
Message-ID: <20261028170004.030482525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index baad684d9eb36..8a476ed8099c1 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4019,6 +4019,9 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 	if (list_empty(&ns->head->list))
 		list_del_init(&ns->head->entry);
 	mutex_unlock(&ctrl->subsys->lock);
+
+	/* guarantee not available in head->list */
+	synchronize_srcu(&ns->head->srcu);
 	nvme_put_ns_head(ns->head);
  out_free_queue:
 	blk_cleanup_queue(ns->queue);
-- 
2.53.0



