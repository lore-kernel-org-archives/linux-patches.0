Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016592;
	b=IOKEKfK9YSwbENcU5zEGGfR9ldRkI6bVbYwcjGZ+K+Is4/E6pAQ5+lcOGJvATN5eDlot
	 g3K/EC1TPbGfdUIhyYSGHWZaXFvlrIoLatoFX2Y5haZKs/0h7IcLcCnvtkQH9EjGTnX8Q
	 Rx09TAEkIgr8Hn4LAQdWA64PNuqioYav/NGuWHTqdq5GZQ3EUdCFZsfnabxANtKgC/QZU
	 uEwlfBte4S94jvwWps6nMErUFk/NtudwUO46L89T6ru4HNTOMvGAHPSu3lFR1omhwFBKg
	 HnDlK92f/gvKdNtkcpGxKY8Qa2QunYC+BNMY3MPx1VWS3uCJFlO2lW4p2+TJ9RQ0uSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sDawJke/Ysn6YqAiLTJ7jsyOqMoAm/LlqXtPoX4TGxM=;
	b=y6fxWaVeXEC/QFd+FGEicVxjT50R8J709AI2yds456D+REiYwyidMwL92VyaF7lAfsfl
	 jbMJshhrluk5g1KylLREfeHN6yNGz9qtam5ppbx+1v1y1Q5dymPKLeR2/Fp3GA1d5nrIo
	 xoj5pJfXWNTzJwLVmCYGDoDww+VhnHUH3UGrKla9aP7PUTuXeAJSLoSVrQ18rLX08Vi1j
	 i/YYKT6FxBLJovwvVqHFoEQqKY6cAGwYYx0h6+w25OVEOohraIBRcqwKHUtM0R4+CdL1O
	 zQok/bgqC/bFyl7dt17D+0E6ivEpuXSMIuaxOGVSqey+vra7+XATodEwqxYp9O45Iag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WFMMJT19;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5462606A330;
	Wed, 18 Nov 2026 15:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WFMMJT19
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02161F000C4;
	Wed, 18 Nov 2026 15:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016592;
	bh=sDawJke/Ysn6YqAiLTJ7jsyOqMoAm/LlqXtPoX4TGxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WFMMJT193C+KstUksCQXWVM1kIkFt0S9JWJ/bcO7oBmtqp5m7oE8kc8DqiLdUrNPj
	 cSzqNQVsispuHpKo+P6qbkyLYDADGBVuveBY4EiP8QoHu7fX1vJJ6p8e46dZwJKHEy
	 g3lmxA4W2WviR4urjoi8B+x4P3cquaVglDVPrd90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0583/2651] RDMA/uverbs: Drop restrack ref on ib_init_ucontext() failure in GET_CONTEXT
Date: Wed, 18 Nov 2026 15:30:23 +0100
Message-ID: <20261118150308.715722304@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ce0a7de004056..db65032e80b4a 100644
--- a/drivers/infiniband/core/uverbs_std_types_device.c
+++ b/drivers/infiniband/core/uverbs_std_types_device.c
@@ -272,6 +272,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_GET_CONTEXT)(
 		return ret;
 	ret = ib_init_ucontext(attrs);
 	if (ret) {
+		rdma_restrack_put(&attrs->context->res);
 		kfree(attrs->context);
 		attrs->context = NULL;
 		return ret;
-- 
2.53.0



