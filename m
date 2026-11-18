Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060670;
	b=gJ+KK+QBSMWmaI2c1MhMej3H5FUn9lIC3esQSefOtnKBVsPxUdnWY2LgK0Kd1mgZ37Jv
	 5GPfunICXeSCUGAtDs+cwuXERa2/RCHEd+fydptYCGPFv/YhVJDQHtJCqC66R6fi0TCnf
	 Po1c/XEiRXIcYxyM6ylYcE+94qLLo1JuRIl1UY3LA6xiTcVIL6/hXF27TgVoQ6/MEDmQr
	 w3Cucx2RZXuoQnb6cfBxp6Xldz5AvATPFAZghea9SgW3zhOP5rmJ/HMumhcnMRe+eSYFN
	 rHNdDpPvpXJYrGSghZxPnHcAYjvEOaA/d2cTSgBKl3kc2Plp/OQCx3awN9hwGl119jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060670;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X65yA50Qt5+iv05Gr5+mbKuCazw/AWhoWQSHKf5St9g=;
	b=UHBQUNGVBhRpUtEBkwGYHtUpm8ELVXuZt7MKyMu0RcMGu+E8fXyynqmfFaqKkYmtUjv8
	 w6r2fNlTBwKjcpwLjJSuejiCCZYDXW07s0y/mRDcM+PIlvk/DLbiXACsQY9+E6Ha4ySVm
	 JYchk48XX8XN4g8fWlYTwHHB9FCZi0pwuRHZ6HgveFRb27tCS/cQ6BQrVpvZ9zjoidYF4
	 LRsvfsOaX5MhXYQTznqqMNO0+zPyiPdWR6pb918NrWQs/Mws65DPxlAjDD7QxVHhrs7wL
	 CB7K08BdUIHEZ2OxyDGjdxWX/7NBrm38wDbWmtFd85TWSE1HOaAioaJhL1oeDD5CIig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F04klvZT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644AA606A335;
	Thu, 19 Nov 2026 03:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F04klvZT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36141F000C4;
	Thu, 19 Nov 2026 03:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060670;
	bh=X65yA50Qt5+iv05Gr5+mbKuCazw/AWhoWQSHKf5St9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F04klvZTMQR1O/ooU3Q2biF6Q/Zao0cqcjswqJ5owMf2x9NROfE1tILEN6u7A/028
	 j1f8nlwsW6gkp5nojBIVGRfyFzhvKxVDaw8NuZS01cvFuWIF4BgQIJDW/RbSzv3ffc
	 KOmRbGlEbSdXm6X2kKesSPq7co9gmVdWuQHxSjr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1280/1848] RDMA/uverbs: Drop restrack ref on ib_init_ucontext() failure in GET_CONTEXT
Date: Wed, 18 Nov 2026 15:55:18 +0100
Message-ID: <20261118150013.201143801@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index 049684880ae03..05cc541c82090 100644
--- a/drivers/infiniband/core/uverbs_std_types_device.c
+++ b/drivers/infiniband/core/uverbs_std_types_device.c
@@ -230,6 +230,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_GET_CONTEXT)(
 		return ret;
 	ret = ib_init_ucontext(attrs);
 	if (ret) {
+		rdma_restrack_put(&attrs->context->res);
 		kfree(attrs->context);
 		attrs->context = NULL;
 		return ret;
-- 
2.53.0



