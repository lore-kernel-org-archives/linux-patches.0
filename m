Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060590;
	b=Wrc/Xmm23+Mlis0tzDlI3wE0SWlSONJ7J453y4G77/vxPD4Bu90NfjLwxhNHVEaXS9t/
	 ZzJkjeREPW53VBFOUqbM3fE6sRxfD6/hwh0VqKyCLz7GL7d5b/a+xfrEz1TZmox2Fi4mE
	 KFbu85H8USmBRFtXW1omW8hPD23CXGbgh7tYnP/3qudpxQQNXoLJZl6ZfUmNcnOqWsVs/
	 ixHZsHpxrbbT9lHhw42zGi27w9zcoW5my4M3Pb7RwG1ez5AQpUeaNumY3XijMQjRyBvqu
	 IhzCJnDA2+pAGq4Hor70yW8/nPxZ3mKDCcBoa0311WASOalDoMNMl0/08jf1mGmrxKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y89YkA+wCqP9lpYzn6np4hW+cefCI08WEyFOFeaSgkI=;
	b=UopxC0exmfX4iTiH3X+fwFo1JR5/OVADwxPuAaPl6Nn6JhO2NMP+8lAHZuss8DN37yuN
	 t3nEDE6QafOOEWELw4tFIaxE94CFH4SdE6KNSOMFIrKzEunNfbmKhD4z37MRKtAnE70aj
	 DxJBhobiJKYVOXbH6pb1LaNrUspoK1n92kcOvP+OkTuJZs6/Oq1KO7bP8jY0XWoQo2Tg9
	 +KiGPgviDGyRfJF8KYpSn8HHJaYbNfJlXV9XKW7g4tfCJxAxJOzGyNWjD/M3YLwUMFSQc
	 rP1DCj87ki0L9wIXo9jp5KNphn6zS9oF+L9H/2fToK4pNENJW2DbHRe2yuVy0z6ML8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gjOgUOjj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CE6606A325;
	Thu, 19 Nov 2026 03:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gjOgUOjj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C801F000C4;
	Thu, 19 Nov 2026 03:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060589;
	bh=y89YkA+wCqP9lpYzn6np4hW+cefCI08WEyFOFeaSgkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gjOgUOjjq2QZlv8+WMVWGInWugZb9Fe+zIbKrrPu4vIT7Y2XeZraMi31pgsRP59eu
	 2bJ9QkxsJng6Vl+VxZ9P++fbFxTOtbMBHhIb4TFBEVweBpbYweerWbPkAW1BDdbHI6
	 uu87Q0VPVw9EANKmNaPNOKM8j3bp5e4ucmUJJDOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1254/1848] RDMA/uverbs: Make CQ handle mandatory for WQ creation
Date: Wed, 18 Nov 2026 15:54:52 +0100
Message-ID: <20261118150012.253141191@linuxfoundation.org>
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
index f2e6a625724a4..5525c99064bc1 100644
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



