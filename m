Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029768;
	b=P9LFghsHjcXPAqBMcw+sFD8md9UOZSp2NmtcwglAmKvqQNFQLKtWrXzHCXtTTyKKFuPb
	 rS/36m+gbXNyaHSxam3hDyCU6Iaa8wRCTjkwh19izKKiHT5bie6a7jrXj1fI6h3p661Y2
	 Luw7XaK7O98THDeShPxfJlJNnwCzmXdo/Gcqut/nTGXEn8oXE3k2Ouw5i4YW5wTZ0znzN
	 gvB+jWmpur1sHjiPVHTpATkHcKWvxXN1vEHpskEhz6iRl0ZPvhnjCowukYcnzZfOU9Kx2
	 3Ia1680FMA9laQRcNt23IHbUgdnFrvtplP/L4yuxou0Pbic6mmsjde6mWbK9IQZ0udQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029768;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ELONq3Ms6is8ToMCNserPKgoVMEp3ku9MXhaQkoPH4s=;
	b=BQEJySwldehuxeK63tsUxti07jwrt9241DcdJGK0/kVCeJi/1lGUOPInX7p9CHnjFrGp
	 UIePvwjKDkruyt0F65vKlwzm1cy5v5UrZu7hKI2qjK42SFcVCaJqyhqhf48SB9a0d1gKx
	 qpOfEw7kF7p9kuyNBkDlbMzzXBW8r3eLyWnsmHRTlGAgDgfqWQGLCCNDXi4YH3iEcS/WW
	 vXJJA846hqZUxiAFkcQNGLXKXNGLX2eZhG1tZ63TVNJJHTiUyF/NHDVQIPUMtU338Qftv
	 akn8Ng3vrS50st8sfg9HrGnULEm2l566Xd4D9WgJ2tMx8hwF2fFD+zrx0XEzrw+cZDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xP+mPCWz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4F4606A31C;
	Wed, 18 Nov 2026 19:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xP+mPCWz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A881F000C4;
	Wed, 18 Nov 2026 19:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029768;
	bh=ELONq3Ms6is8ToMCNserPKgoVMEp3ku9MXhaQkoPH4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xP+mPCWzrraEgHye92PGaUg/K7fyLvdLirCSqTW/upAu1lV60aA/p7nHHp9ayg6Ic
	 vsBrXyB+sbvbNTe+YIMROoSGBf1P6Y6xj/SSeurCL85YeT9l8HLCzpTgdSsWNaYhNd
	 TMLzlJH2xf83VDFJZHb1eX8Ae5eHZI286wA8xZU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0465/1756] RDMA/uverbs: Drop restrack ref on ib_init_ucontext() failure in GET_CONTEXT
Date: Wed, 18 Nov 2026 15:43:12 +0100
Message-ID: <20261118150027.319555232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fb0555647336f..e028a1ceeb156 100644
--- a/drivers/infiniband/core/uverbs_std_types_device.c
+++ b/drivers/infiniband/core/uverbs_std_types_device.c
@@ -231,6 +231,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_GET_CONTEXT)(
 		return ret;
 	ret = ib_init_ucontext(attrs);
 	if (ret) {
+		rdma_restrack_put(&attrs->context->res);
 		kfree(attrs->context);
 		attrs->context = NULL;
 		return ret;
-- 
2.53.0



