Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048373;
	b=BZLtb9tKVV2mwY4o+sYT2OOWZ1PdEuMiJzy7v4ag8w2KBccCcBa7U7ieUnxzMaanIkQV
	 FV+3fcDkShLspqsAv5GK8uCB7zjs9NFnUKkiyjxR1lApgiu2/5h/2kKljLh02ocbsa3t5
	 BP8Nt1Eg4pLDzQJD8Rk4H/olNt4dboDnLeG283rkAZeGwlgw2Pamx7HHEY9JG2ivpyZdB
	 UTQi7INpEpLm4qslAzdBxhSgLFjazepLem1yb7AmdrsHHmVN+NJgHgVJZJ1z0aWmVRx/9
	 jXrNEfgb3NCY51H9bZDKK72ECPClCpKDPgGYOtL+k6EDWxKh2kf5l/Vz8GkQmF6eYGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=631G+lF0Mz9t+4+3vuFgf9EwJvY9EiZ5p/DPilvukMY=;
	b=nkAbfWKoa+UF0JxXciJXiBuwX/IIdQrnMsSYKXyEJnPUaf27WhWxesc7OnLnksZ917jx
	 dYRAtsOSnGpcglUbpktCHA+wWha211PxCqN2du4nww2lxc3PrAPu/0fDEALO7CQ1/CJQW
	 2dd2uOdv6VaCq0DTrbnpfa7Hmvqz3ANRnQjL6957D5iwyqbCPk4A1qXrU9wstFKCnhqIq
	 cyVvnThdOXRIybsIziPgxyg0ADdtdTMKpZlaAsAY9Ti0c03WImlgPXvbgzABwkZ4qGt6S
	 S8h6UZR8s2VEtzl5P0WhyTn6Ay6YkrBlrv64qCyAbjUD60MoHIF81bdNRJwkfJ/p/wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=trhdLdPP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D68606A32C;
	Thu, 19 Nov 2026 00:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=trhdLdPP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9540A1F000C4;
	Thu, 19 Nov 2026 00:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048373;
	bh=631G+lF0Mz9t+4+3vuFgf9EwJvY9EiZ5p/DPilvukMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=trhdLdPPjTdy5eD8GngWZkzqhXh3Q/T7CDTOOChOm+Hur3fkCcLdDWXqXYSwU+Q6u
	 kQQ+XlqCeWjQ21ZETiDj8DUdgvLFDv7c/EBRNZWNFBZHtnuzDYsQxQWzxiZy0Ul0nP
	 R9C3XLCJGNTTnHO2G3QxFRhBnf9p9F4NJfz0bxvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1971/2857] RDMA/uverbs: Drop restrack ref on ib_init_ucontext() failure in GET_CONTEXT
Date: Wed, 18 Nov 2026 15:50:05 +0100
Message-ID: <20261118150312.363065668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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



