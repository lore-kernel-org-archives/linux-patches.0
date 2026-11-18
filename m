Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023871;
	b=EHhhAEYAGBicxR8MaEZQJRVTXQkKNabDy/TBBH8pX4icZbh4pGKHSJO2w/Emyu5CTUIT
	 cYTHx785R2POa3w9RAIxf6GzxcnIvdpxfTxzoTdkcPmaMpsjQ7SlQz3dILyjVhVgXH1f7
	 DFsN6gYEnWg51bHwt4SB706Vnrc+LAcnEHlBZL+bXDuUOHh7A37dwy4I1pAHPn5ucxDHU
	 LUEZrZ9RirNyhblFGaWfeDEPpZVjO0GYPtlk+GHvksDIW+8tXufY2JabwYX4B3H1lVVYF
	 0miW0fSN6mFCxDumymLdZ3WWo/PgRK+QQu7pJU7VFkVYjaEVNd6C5PFMn7xN7UE7MNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HzRjGbq50+kVJer83KRSm+3A2nSFovx4eeukIvH+vbs=;
	b=DtcS/FSvQiyqSjxA7hpjQOLdCiNH6RJ5JdRWg6O7f877ny4+tjEaGm635QMnz8m1BVFf
	 RhAvOBV1S7qhgyr94RATEpzV8QCVO+5CvgMEMuJXEWinVY05zdvAnNB7eiy5E5Ro+00PZ
	 AyBSZLrW6sqGY6x+R78WymRASWttiocNRl4sTcgPz8kDLVvjfu6PtCz6SC0w5oSYSQwlx
	 VUg/nIFp0lvNFRtipLLeRI9y9c86LxvYQMuyH4eEcJtpp+8dbkOrwJJNxCAa5XhB3BreT
	 YMO59ln80N9DwTc7E0sSktprz7SCZ0/SLMqWmv37NlhOclx5G3jrY6GgyHBbjaI443g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MWYfuEOZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4189F606A325;
	Wed, 18 Nov 2026 17:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MWYfuEOZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9019C1F000C4;
	Wed, 18 Nov 2026 17:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023871;
	bh=HzRjGbq50+kVJer83KRSm+3A2nSFovx4eeukIvH+vbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MWYfuEOZWcTYRkNCktznNcPD2K8mhe1JVfqLFL9Lkn7eVIPBYaqSpuHHtaX2hGwV2
	 rx2cTZOc1sap82ot34wk+0uTFFZEPQBjeNS6OT2MLci38dD3ZBwK3Cerw39+hjF4x0
	 4qptpqnJVtxZZ970gZDdNKiydYZf9/6KWlgOB3+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0524/2151] RDMA/core: Fix swapped list_add_tail() arguments in ib_add_sub_device()
Date: Wed, 18 Nov 2026 15:37:39 +0100
Message-ID: <20261118150141.123839138@linuxfoundation.org>
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

[ Upstream commit fad7b0dcb0821c0f201df3d85065145857a6f55b ]

ib_add_sub_device() links a new sub-device into its parent's sub-device
list with:

	list_add_tail(&parent->subdev_list_head, &sub->subdev_list);

list_add_tail(new, head) expects the node to insert as the first
argument and the list head as the second, so the call above does the
opposite of what was intended: it treats the parent's list head as the
new node and the sub-device's node as the list head.

Because _ib_alloc_device() initialises subdev_list to a self-referencing
empty head, the misplaced insertion does not crash, but it corrupts the
parent->subdev_list_head list.  After adding two or more sub-devices,
only the last one is reachable through the parent's head, and
ib_del_sub_device_and_put()'s list_del() on &sub->subdev_list rewrites
the head pointers, potentially severing earlier sub-devices from the
chain.  During parent teardown, the reverse iteration over
subdev_list_head then skips the orphaned sub-devices, so their
del_sub_dev() callbacks are never invoked and ib_device_put() on the
parent is never paired, leaking both the HW sub-devices and a refcount.

Swap the arguments to match the documented intent: insert the
sub-device node into the parent's list head.

Fixes: bca51197620a ("RDMA/core: Support IB sub device with type "SMI"")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260916064435.2180-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 004952357e055..6d872c351ad0a 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2904,7 +2904,7 @@ int ib_add_sub_device(struct ib_device *parent,
 	sub->parent = parent;
 
 	mutex_lock(&parent->subdev_lock);
-	list_add_tail(&parent->subdev_list_head, &sub->subdev_list);
+	list_add_tail(&sub->subdev_list, &parent->subdev_list_head);
 	mutex_unlock(&parent->subdev_lock);
 
 	return ret;
-- 
2.53.0



