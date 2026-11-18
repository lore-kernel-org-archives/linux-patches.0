Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016586;
	b=NwP/0/mld4E3ymrdJugadPuyn9XCrMn+MhqcKvtqMOIToj6prJZP+4Xl1A5GtJ4yygNS
	 8UoPhszPeQZRibnHElPX9xcsvIBCNkhqtqFlQjPx50Cv/QgCS5vQ6czWp77THBHPzxdMb
	 4MbCVlk8i7mtYVCG6RgJ39gd7y0ONX9uXlD9rRkfgD8NTpr/prDPO8FbLPjUkzNyVjBWp
	 7t242ed2UjixUeBTb2oCrauHyfrIZGEIYhUwk4AbZJLSOn+TPa0yqVv62/GwEolVx+yDo
	 NN+V4jM1f7eM9NGfiUcPdUfYigXzNIILBry9QMvbyiJN5k2+BKJP9ditHcSIr+IZyuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dooq+e8X14w1STUB1g8GPmUkNogVYzXOnEAN7xBJf5s=;
	b=ua24gfrumvZthzvgiNE1yXGcqIFdHDAB7bWVsRRew2dipJWP2t342tijaClJFUTDvDUp
	 tA6RSyjNPIX1g5oqSsuVt6WdO0MYmb8LORyDXB3Vc5PHOkTNlvUGgumrchgnHB6da0pIj
	 nIBH5XUPDr07eyglUafFVMI2tqRxuYPBOkGaDvF8odA6AmSoMUvqIhlrsKhJvbMDMyu/1
	 6CRglqhjyBDrN1Z+xvkQwlr7ShQiPwjRS3p4ZhAF+IZPCVqYaqItbyuymcXS80BA9hsUx
	 IFGkMuK60soZpwG6MQcP/k0vmi6BVKmoDQR2fZZurkYpYxwY8I7n0kPdlF2vAWNqAIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sL4WvZ6I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A2860A2613;
	Wed, 18 Nov 2026 15:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sL4WvZ6I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296341F000C7;
	Wed, 18 Nov 2026 15:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016586;
	bh=dooq+e8X14w1STUB1g8GPmUkNogVYzXOnEAN7xBJf5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sL4WvZ6I9XtBHy+ZcYPoXcRTHkVteF/0ACOPGbybURk/RsGDaOQ1fUeYfy5vDWkXE
	 2DSdWtn1BVN/B3ZsRa5b/cE5tFJPhHNWe7N0xOv3ezntCqYiA071Mfshx04piin9Ul
	 vHiAGF2/3NYSmfqrtZQwnqGjyvMXI/lsV53e8lfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0581/2651] RDMA/core: Fix swapped list_add_tail() arguments in ib_add_sub_device()
Date: Wed, 18 Nov 2026 15:30:21 +0100
Message-ID: <20261118150308.644922197@linuxfoundation.org>
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
index 7a3ed5ecac001..05dd890b2ebd8 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -3067,7 +3067,7 @@ int ib_add_sub_device(struct ib_device *parent,
 	sub->parent = parent;
 
 	mutex_lock(&parent->subdev_lock);
-	list_add_tail(&parent->subdev_list_head, &sub->subdev_list);
+	list_add_tail(&sub->subdev_list, &parent->subdev_list_head);
 	mutex_unlock(&parent->subdev_lock);
 
 	return ret;
-- 
2.53.0



