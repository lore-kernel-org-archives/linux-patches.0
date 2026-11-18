Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024868;
	b=ouGE7HY6SwJhWbBBSVkVHFpng7MyC0xvl4yUAfiJFHHdLE9lRAu7KoWgnHuG84p1WRkd
	 zfTGbtRtzrQHHOrkWNw8ERdQmpYZuh/7YTMDhV4Tk5z455uzNFGzdy2uM9FiE8WNtddvp
	 8D1UYuNWj+67AoVj1hxkn0K075szVA+phMzzRazf0sHxD3egyb0SzP6f/2/V70iuMnz/m
	 64BslX234tPcPoZFlN8/1ZkmSDl2P+gpw5VS/XxCc4uH0ILFfgcT9hAwXRAfPhLalgBqV
	 +SdKxGwA9tJIZpIiG/SOvKWJz92snrUaKI/L9p9Gu1gTxLs60bMHyyrwO5VbEYhyAIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bZDaKN8QHeB6ErnNoVeMQCObMjh/PMKSdI0GC9DYIeI=;
	b=fmf09eBTgD2yEprWEcXeqF4yYskvFh8YEog2KTUnvhZtE5QAYqf+7oXvJ1IdLgXP7vI/
	 JkrWy7zdl1CfTCPZquGN9hc34unFDDRdGhi74OqUiEykxaM4aZjMa1o9A1/n7RnN0W8aT
	 tLhWgfV3wGAv1FlQdpKEXupE+ragqAX79mEh9kQ90XWDVZH7T9vYD1lSie1SJ9P53crvc
	 x25BprIJStOLFOPRKo+T1NAE9BZ8iYQhGBDX1LrZSiLWqHUI+36CO3/Pwzjg0iMqXvBux
	 x5YNWUmz3XEIXSv3K0/ueGHzIPOHWvo84yXoXDQJHArFSemF6lWO4zCg3R1NMZDEMwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0+S5kK7o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D602C606A320;
	Wed, 18 Nov 2026 18:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0+S5kK7o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBE91F000C4;
	Wed, 18 Nov 2026 18:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024867;
	bh=bZDaKN8QHeB6ErnNoVeMQCObMjh/PMKSdI0GC9DYIeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0+S5kK7onmJ32LbkP1spzIwWarvV+goKhCZk+LVJRnQZBr4ZiTaZl6Mer8eq1cIvd
	 33hiSR2QSKqfDcw2bQRixhMOVXtHjstnaetAhEshY0RvbVx5BFYa6qtsCHEgMH4+em
	 81S/pu3s8cZLuS83esw5sdOXv3xix9wU8t8ZOS9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhijit Gangurde <abhijit.gangurde@amd.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0878/2151] RDMA/ionic: Fix XArray initialization to use XArray flags
Date: Wed, 18 Nov 2026 15:43:33 +0100
Message-ID: <20261118150154.281174692@linuxfoundation.org>
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

From: Abhijit Gangurde <abhijit.gangurde@amd.com>

[ Upstream commit 2eca9c14e66a1f71c089fe5c3afb2d339da3023a ]

xa_init_flags() takes XArray flags (XA_FLAGS_*), not gfp flags, even
though the parameter is typed gfp_t. Passing GFP_ATOMIC leaves both
lock-type bits clear, so xa_lock_type() resolves to XA_LOCK_NORMAL for
qp_tbl and cq_tbl.

Both tables are used with the IRQ-safe accessors: xa_store_irq() with
GFP_KERNEL from process context, and xa_lock_irqsave() from the event
queue path. When a store needs to grow the tree, __xas_nomem() drops
the lock using the recorded lock type before allocating:

	if (gfpflags_allow_blocking(gfp)) {
		xas_unlock_type(xas, lock_type);
		xas->xa_alloc = kmem_cache_alloc_lru(...);
		xas_lock_type(xas, lock_type);
	}

With XA_LOCK_NORMAL that is a plain spin_unlock(), so the sleeping
GFP_KERNEL allocation runs with interrupts still disabled by
xa_store_irq(), and lockdep annotates the lock with the wrong class.

GFP_ATOMIC also happens to set __GFP_HIGH (0x20), which collides with
XA_FLAGS_ACCOUNT (32U) and silently enables memcg accounting of the
XArray nodes.

Use XA_FLAGS_LOCK_IRQ so the lock type matches how the tables are
actually accessed.

Fixes: e8521822c733 ("RDMA/ionic: Register device ops for control path")
Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
Link: https://patch.msgid.link/20260925093638.3032149-1-abhijit.gangurde@amd.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/ionic/ionic_ibdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.c b/drivers/infiniband/hw/ionic/ionic_ibdev.c
index 73a616ae35023..40e8faf82437e 100644
--- a/drivers/infiniband/hw/ionic/ionic_ibdev.c
+++ b/drivers/infiniband/hw/ionic/ionic_ibdev.c
@@ -314,8 +314,8 @@ static struct ionic_ibdev *ionic_create_ibdev(struct ionic_aux_dev *ionic_adev)
 
 	ionic_fill_lif_cfg(ionic_adev->lif, &dev->lif_cfg);
 
-	xa_init_flags(&dev->qp_tbl, GFP_ATOMIC);
-	xa_init_flags(&dev->cq_tbl, GFP_ATOMIC);
+	xa_init_flags(&dev->qp_tbl, XA_FLAGS_LOCK_IRQ);
+	xa_init_flags(&dev->cq_tbl, XA_FLAGS_LOCK_IRQ);
 
 	ionic_init_resids(dev);
 
-- 
2.53.0



