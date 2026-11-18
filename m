Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029762;
	b=j8UllI4iq+6Gk0T8OHsFY5V6DOn+/UPOP1PSdAnbTYxBbr7hkDjXMHx1KlGbQMnP5aqF
	 7Pl35b7Ct3IGWRZrOW8gzNU26W5tn7hBL7j9u90yYV4a5lxv7NcpMFQeo/sQbV3sm9K0F
	 W8d54o9R4uLtJgC9aKUKm/YRboC9otDmJTowNY4f6YwiqXiEH4HUHARVhUO/cY75MKunF
	 +HWLYJtfFgCBWRY5ZfQJspUhsk9xD1FzOfjmp49nAbAVOYs8Ud8Hcr8Bnrg4ghnFENBSc
	 7fel/GjkXa+eU1/wRlbhcZ6OqCMUjzCxsGqXhK2sIdLBZshakHBIRcQpcsAbeFyxrzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fZbsfdzZDL7X81vsACB2LkOSr5QtLGlSEeIQhzQdvK0=;
	b=Ojt3WG4bs1FmtshWHvii1OwZkw/DJSSeJ0t9dbXlIFhOOw4N3wkec6K+x8YDm8lZSiQd
	 qx9NyUgUNMZquG/OEu9rwQbV4v3xckRQwyQ1EpEx7T6q8WcNdrLeDhp68QSlQ3mYswp1k
	 A+3s1CWmWw+GXTerzUOLAgx4MvUdOIcfEXH2ZhRkl0nE5mPJiGRU4kQYbSJ96N3kRw/cL
	 fNPIolaPot7ULnp9PyNzZPVayswB4791uUzQK0eREdbShFF+aKqFEtFu1IwreTKKmXQY7
	 zZB7nicyb8b0/pAwNa8bzKVCxIpf/gA0amQAhoN/8ETUwPv8FPgYDmlMv1l9PeoKvUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YaQAFkms;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB85F606A334;
	Wed, 18 Nov 2026 19:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YaQAFkms
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4929A1F000CC;
	Wed, 18 Nov 2026 19:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029762;
	bh=fZbsfdzZDL7X81vsACB2LkOSr5QtLGlSEeIQhzQdvK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YaQAFkmsckJ4xugeIu77mD8FhhM210pND9FWzX3I480GhrngDDckf+jdFr/wQ6lFO
	 KTgrZKcql1iK6L0jwTxF/ArqOaqcpsquKtKh/oxZGgemXGkB9v/mMHl2ytuuaeNLFe
	 7XutuXPbwH6Mpq/7xvbffxz7IEaKRDqsuUIeCCf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0463/1756] RDMA/core: Fix swapped list_add_tail() arguments in ib_add_sub_device()
Date: Wed, 18 Nov 2026 15:43:10 +0100
Message-ID: <20261118150027.202569301@linuxfoundation.org>
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
index d927270bab47c..bc9044f9978a9 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2846,7 +2846,7 @@ int ib_add_sub_device(struct ib_device *parent,
 	sub->parent = parent;
 
 	mutex_lock(&parent->subdev_lock);
-	list_add_tail(&parent->subdev_list_head, &sub->subdev_list);
+	list_add_tail(&sub->subdev_list, &parent->subdev_list_head);
 	mutex_unlock(&parent->subdev_lock);
 
 	return ret;
-- 
2.53.0



