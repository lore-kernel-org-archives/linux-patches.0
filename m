Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016399;
	b=Dze4HVGAlcGClSoNEcDBehQbe8IlS21Qz1POUzqdOOUmqnvRIEbVTvZoZ8sElN6cqMGd
	 wqm2sOXYJejJqmU9NDFp0ZBUzczaalxFu7grA+QyIhDQ0RqMZcRxGEm7I4Ou+YvxFVFBx
	 mxrUHCxZersfgTIq59qRB/eytMS7se4jIUqR3T2nrU3Xmg0M6fPIsLXDJhCGoK7FmrBay
	 qvyEsF3TY8Oy9VD3TgiMW+RlZBqR+nLOmeOZRgxecG7zbodI4sBzoU9vqQNRS/Sfbbt/1
	 qmRxo0+7S+fHDl22nu3VcY507i3El2Aga/XgtfG0J5o5NDVa6kDaTGx21ECry2O5Auw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016399;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mQ3iTiHb4JLuoG5MgAndRNWgt+Te0vWMcuwrtN3FdMk=;
	b=U9/l6Lw3pnxNs/BZtRKs3jqEDTuELyOsfFrWiwHdqAAAwJw9yYXcQ3TsK3wGqb42UE+f
	 RMiJ/Bpb+QOQ181Nnrjf1bpksJqg0Qm4V2luTd/vyTeKwjNNn2mFOZhjjtcBZIyvJ2yH7
	 GLgF3w5OCgCtdLuA6iN66V4SnbDHZ4ZUseoVETgiFgeU3oE0lejLuhPNLIvCPgUMIeoyM
	 gbNrIz9WcHYkM+kJsGCHGJhUgl0EIe3Wl5NDtKLD/uDd3CtqaqkIFtFoinHDyYK7CQ9x9
	 ZLMpRDoRVgGytu+tcocP2u70BXYhUc1xINi3nIFmYsTurq5YzuzkPq+1n88VnZQTIhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BG4GFqrV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4084460A2631;
	Wed, 18 Nov 2026 15:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BG4GFqrV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE231F000C5;
	Wed, 18 Nov 2026 15:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016399;
	bh=mQ3iTiHb4JLuoG5MgAndRNWgt+Te0vWMcuwrtN3FdMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BG4GFqrVV2bwCg2zw1ht+p7RJGl8TX2NOoNX5PrlrCjn4hgOxF6AO2JnHdqffpdHt
	 vHZRMaPkHkAar1QZd7k2OUr21EWAG4z2eK+DERGG82uZdKunTZt66EycAduoaOUsBI
	 xH/HK/ml5NaDHC/Fs0lpFxo8yJsmdGygU1UFawSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0474/2651] RDMA/uverbs: Make CQ handle mandatory for WQ creation
Date: Wed, 18 Nov 2026 15:28:34 +0100
Message-ID: <20261118150304.855370850@linuxfoundation.org>
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

[ Upstream commit f7d28791433d373ecdab7b00f60ddb504e858e0a ]

UVERBS_ATTR_CREATE_WQ_CQ_HANDLE is declared UA_OPTIONAL in the ioctl
method definition, so the mandatory attribute bitmap does not enforce
its presence.  When userspace omits it, uverbs_attr_get_obj() returns
ERR_PTR(-ENOENT) and the handler stores that error pointer into
wq_init_attr.cq without validation.

The bogus cq pointer is then passed to the driver's create_wq callback.
In the mlx5 case, create_rq() calls to_mcq(init_attr->cq) which applies
container_of to the ERR_PTR value, producing a near-NULL pointer.  The
subsequent access in get_rq_ts_format() triggers a kernel NULL pointer
dereference:

  BUG: kernel NULL pointer dereference, address: 0000000000000296
  RIP: 0010:create_rq+0x32/0x550 [mlx5_ib]
  Call Trace:
   mlx5_ib_create_wq+0x14a/0x210 [mlx5_ib]
   ib_uverbs_handler_UVERBS_METHOD_WQ_CREATE+0x1f0/0x320 [ib_uverbs]
   ib_uverbs_run_method+0x296/0x320 [ib_uverbs]
   ib_uverbs_cmd_verbs+0x1a0/0x260 [ib_uverbs]
   ib_uverbs_ioctl+0xa8/0x120 [ib_uverbs]

A WQ without a CQ was never valid; the legacy write path always required
one via uobj_get_obj_read() in ib_uverbs_ex_create_wq().  Declare the
attribute UA_MANDATORY so the uverbs framework rejects the ioctl early
when the CQ handle is missing, before the handler ever runs.

Fixes: ef3bc084a8ed ("IB/uverbs: Introduce create/destroy WQ commands over ioctl")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260911021557.2113-1-lirongqing@baidu.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_std_types_wq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_wq.c b/drivers/infiniband/core/uverbs_std_types_wq.c
index 7ded8339346f3..c23f455231bf0 100644
--- a/drivers/infiniband/core/uverbs_std_types_wq.c
+++ b/drivers/infiniband/core/uverbs_std_types_wq.c
@@ -140,7 +140,7 @@ DECLARE_UVERBS_NAMED_METHOD(
 	UVERBS_ATTR_IDR(UVERBS_ATTR_CREATE_WQ_CQ_HANDLE,
 			UVERBS_OBJECT_CQ,
 			UVERBS_ACCESS_READ,
-			UA_OPTIONAL),
+			UA_MANDATORY),
 	UVERBS_ATTR_FD(UVERBS_ATTR_CREATE_WQ_EVENT_FD,
 		       UVERBS_OBJECT_ASYNC_EVENT,
 		       UVERBS_ACCESS_READ,
-- 
2.53.0



