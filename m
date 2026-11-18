Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023667;
	b=GcomL/DMSz8ZMUfNeRcATC9i7M9IWj2vgi6GOVOXY0AEMG4Lq0Z8f5yUT4fo/APLvjU9
	 nstgK6zz0jhZYfhujKbHVRdNIc5VbtUufCoaAnS4w6Im8sf65IwyE1l4/i0zrvD4QFMXT
	 DBDIFsK7Fa0W5Oz94TfFSVIDD5Q6Bo4RRhkp2ni3/ZikYY6xHNX/y0aoGyVdTUupG8T1h
	 avEYlfC508/U9fs0zxx0E4jGREjFIQILAu5wuJVYvv84ydiyb0Ty3LbMxB5kgQjRWpn2H
	 YbPMW9jwuocTDrZN0zLoOoCmF5iZkRlOsLOt5SpSJTedG6ryDJ8PCWUYiGTfTuqA+ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023667;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a0v1LPy4BgI3tkTkQaR+CKmbSJfRLCv+2naSdDE4ZOE=;
	b=G/atYiQsJn1fwnP5wR4h5k9csKrkjxKQ2IB9QZ36ELLvHKoCLfLvvRyfxeo8pKna6yrI
	 9b420Nx2EswIJ9CQC18tDhO/EcJFr7z9FzY1cQ7xHGhjZFENboKxO8EzQZrZaTLeCGtjr
	 tH1y/uFguy9cHLzcnlBh9VU+gXM/cYYe/1hOqrfcN7IXDdZZnRaqlC9EBK21Czluh2UYd
	 XRBXyhJC/90efj+UMT/iA/3FKOU83i5UrDAUUBadk16m2wkAq0wn95sukBHjpTMs+euHF
	 WnKwTSjfD4uzBIkAHGnLcdtcJAKvoN7kt31YTsql3vJK6vIURfBuVrKg/pzeuUZkOiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O0SJdtyq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50CD606A31C;
	Wed, 18 Nov 2026 17:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O0SJdtyq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0817B1F000C4;
	Wed, 18 Nov 2026 17:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023667;
	bh=a0v1LPy4BgI3tkTkQaR+CKmbSJfRLCv+2naSdDE4ZOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O0SJdtyqexv41nnTk3V4Z9G5eN2qOjEGc4wnTmEkyCSmOFmsnx1T1Hr20Jae1mPFI
	 nCCtmkvkqLAbh2mC5uEjf6Anc6+82abyHp5VpqjKHaoi5QpNiQsg2gNLGqH6/CGCSk
	 vFiAliPEU8H1VRpRkGCa/r3E8SLcVgs4KzkWZuYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0451/2151] RDMA/uverbs: Make CQ handle mandatory for WQ creation
Date: Wed, 18 Nov 2026 15:36:26 +0100
Message-ID: <20261118150138.460418594@linuxfoundation.org>
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



