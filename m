Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055108;
	b=nSK9H7jbH+NQyWi8/swSDIajQiIIIc4CDUxm5WR5TYViCIx+ukNOZzttNu4EtCDMpSMX
	 tn0SAcYVx2dX85+yOnFCP6iWt4TECGAixTgrA4O6URRirxITZKnCsJaz+3CtF421MX5Vg
	 Gdv+MfD/LShUCRLc/JM0zWhu1pInK0uWq+Djsd/ObBiabpdQMjB2wH6NWpp8R5rvV/0CR
	 MDqyI+0tZNIzCGnaY3pTvAqvmN9R5+62bwrPk8qG0mSSk+bhPP3b5BvOIJupx02v4mXZT
	 Psm9eE8vSAUP1sCT1jqxnN99ZM9cHNwjIjnCL47jOBbJX1HG592BLSdMsiksSlRfVLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+taVC5L09WQsGWCWfNKSNkBny/dqKgHSTV4GHEuiiQw=;
	b=V0n2QwjdtbpqG8hR7/GSS9rC6U4JYyPFl+ArpdyyljJV9Ryd1/v6Hr5K32oT7CIiR9Vd
	 8wBTS7k0egCopVB39SZc2kXMRpA3SXjGxrRP/rL/PMDdk7fU8P+M9x+yd0CKpjAlXC2ta
	 rLWHuxwdjG4/zC5Am+6UAg8vOA9HyrzIAOSPQhWEC9I0oKDo0Z8V/8gt4ellXJ1J6a73/
	 glgM0uis5KwfBuxtuBRpn2iKIpSpr5bXqgO8U0ijXdZZRQE17OF8+Z2m68OG86KoFMnsX
	 /hBJnh5h1X1IEiLkruYZ32rkGKnYGxkfFTioDQ/LV3+X1GN8esVbv3uqijLXoL0ypeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xO9gqHad;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E33A606A320;
	Thu, 19 Nov 2026 02:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xO9gqHad
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2549D1F000C4;
	Thu, 19 Nov 2026 02:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055107;
	bh=+taVC5L09WQsGWCWfNKSNkBny/dqKgHSTV4GHEuiiQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xO9gqHadkIv6jFXp7koSJm/no+gpC6hSi926/azfi4RTIgfgw8zZ0eKbLClNugJP0
	 xDnwSE87xa5dgM9H9/YMMiVYkn6DBq9SdHZTh+4xlIDI8n8NmM30oYat7TLzpKXW3P
	 giVdkGW1XUxuF4h+39Azt68UMdytJDpMGdyJGlYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1506/2214] RDMA/uverbs: Make CQ handle mandatory for WQ creation
Date: Wed, 18 Nov 2026 15:53:02 +0100
Message-ID: <20261118150112.226695124@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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



