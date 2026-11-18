Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023877;
	b=tPdU1yEPBnXn10+rUlmHeyRg5FKPUgExqSVWWf5tlMF+oAc117ctElf1rZsGwZAGA5Lw
	 BQWUcA5NIV0i7RhBYzNzUkuOGhoQlCKtB9W0NV+RdicFd+Pdj3xqxs/4DoePOc/+7f55w
	 4FsrIr5gcfnUNoLCirwCtQYKmvkom/LGmAV3B70gIquGVQPSkP+OUiZ+niEd0siS/nGA5
	 5DbdxM2R/TGu0bqGc3prWEh5VXgc+VsvukWWQBLBUvF5wrCvbhuXKYkSKIinFZJgdT8Ee
	 utc+YThP51nKTACE/nzl0Qg/Idt5ItdULQxacdGF7iI83/NnRBYERK3yxp3Cu7XPerg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QJ9/FWFkNrMAn1na/4urKgjLxMZ1i8zrOKIh9mJIhgQ=;
	b=J92ZzYbAKwgSMYdmJ/i++l+6i5wMD57u2XlwT6yJ+AkQLVZKN6WrsUvaWakPszlsag46
	 t0OPNnwYbnp1x0yoLvXqWvRrxQ1ZGDRPcFUNYVmmaDaMj9L/BOswwFxxPwlOVzpWjslOK
	 Ueu8iD/9Rf8Hmcb+5lq7XQFv5un8M/W8Td52LW5nYpK+H9XhPxgMTvK7QOh8MJ5inE2e3
	 oNXTGo+28C3KZdZVozC8oOSjho4NwPmJswleMW8QzyaX8wB76vBY9BlFhhnZQiTcv2U+a
	 cCTjONYp2aUwWSSvqG9mxHtsB55+ubjXL4DiTO81bfdZBn15SafzTSNoPZZx9WSJUUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BOBjkqKg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086D9606A320;
	Wed, 18 Nov 2026 17:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BOBjkqKg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABA01F000C4;
	Wed, 18 Nov 2026 17:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023876;
	bh=QJ9/FWFkNrMAn1na/4urKgjLxMZ1i8zrOKIh9mJIhgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BOBjkqKgw+AtR2jD1/7AITCqICTm1NwAsRkMHH8eEE46D0NI7zuA0MLq/J9077q7y
	 oVwzV1O30WwRPserVeUqGAXyljfROT4ieJrSVeNa2cZKu+0Bw0rZcH8bpn+a4/r/P+
	 SXix9xj1U2pEx5P0bNuqUXliSr/Tl+9uIlkYBp+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0526/2151] RDMA/uverbs: Drop restrack ref on ib_init_ucontext() failure in GET_CONTEXT
Date: Wed, 18 Nov 2026 15:37:41 +0100
Message-ID: <20261118150141.190154423@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 9dcacdc41083cccff74292851bf9fde999e0731a ]

The UVERBS_METHOD_GET_CONTEXT handler allocates the ucontext via
ib_alloc_ucontext(), which calls rdma_restrack_new() (initialising the
kref to 1) and rdma_restrack_set_name(NULL), the latter attaching the
current task and taking a task_struct reference.  When ib_init_ucontext()
subsequently fails, the error path only does:

	kfree(attrs->context);
	attrs->context = NULL;

without first calling rdma_restrack_put() on &attrs->context->res.  The
kref therefore never reaches zero, restrack_release() is never invoked,
and put_task_struct() is never called, so the task_struct reference taken
during set_name is leaked permanently.

A local user with access to an RDMA device can repeat this path (e.g. by
hitting an RDMA cgroup limit or supplying invalid ucaps) and leak one
task_struct reference per attempt, eventually preventing those processes
from being reaped or exhausting memory.

The legacy ib_uverbs_get_context() path already handles this correctly
at its err_ucontext label, where rdma_restrack_put() precedes kfree().
Mirror that ordering here.

Fixes: a1123418ba10 ("RDMA/uverbs: Add ioctl command to get a device context")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260916085529.1838-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_std_types_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/uverbs_std_types_device.c b/drivers/infiniband/core/uverbs_std_types_device.c
index a28f9f21bed89..a93a73b1a2fd4 100644
--- a/drivers/infiniband/core/uverbs_std_types_device.c
+++ b/drivers/infiniband/core/uverbs_std_types_device.c
@@ -264,6 +264,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_GET_CONTEXT)(
 		return ret;
 	ret = ib_init_ucontext(attrs);
 	if (ret) {
+		rdma_restrack_put(&attrs->context->res);
 		kfree(attrs->context);
 		attrs->context = NULL;
 		return ret;
-- 
2.53.0



