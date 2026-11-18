Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017875;
	b=U417A6qj0YOm+8bwoN9ZVfY96x/Q71UXdRxwq+DPDfku+5fyiFRqcTCCSGTx+Yiz4LWS
	 /lKA9qJHBWwcHUbMVEQ3hFJE8jedELbX/AazOBpjy8L2Vim90LNU9XAOEaibz1hKDfni0
	 JDPCgo6Ltji0K52aiEPWyMSttJwNZUed5o0G8BSTW1L3pmof+6FFX1goe2bRZmuvn8b14
	 +NQw9YvlUY3MARQwsOmm7oejZGaUg6hQKlMU3ydd2g88Sv0dqBP6IAnc8BSOnnLEQjF3U
	 3aOY4FfrN7BYNOk5/Ly8qU9OrToO85XtbkI3c3r48vokARwADClJN9Ea0mu2ho8o5VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y622jfH9rpWI/WD1wGoEwhXzaOPBOBfYEOYn4whMXSM=;
	b=VLOER/JCiEICKhy+1tVKxZLDy50XPD7aWafrOMbwANz6aOKrVkaVj3GbRIy+fe4CrQav
	 m+CXZfig1kL2PKk85M+5qW2IAFcakb/lye4ixMr+y6eAGE/+IepJ5L6WcDWzwmHdrcYqd
	 qvHLiaK5UcsApG2Qcn636bgd4j1885FynIPC0atO+lbITx/X4iOGGAo1AwjhpZge30+u+
	 xI1m83s0anDzc0eX3Yle1GIB8gS1iGS+a2QSLWcWvZ4Apo07yNfF7WZWfAlodXa3X7Zhb
	 M8/CK5jRdr/Kh5zcVoUm1fwjeE/7Xpr2u5VUfFnWFYZfgTOwM4poQGJufbEY1q75hVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="e/XgXy5P";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D9A606A325;
	Wed, 18 Nov 2026 16:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e/XgXy5P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5571F000C4;
	Wed, 18 Nov 2026 16:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017875;
	bh=y622jfH9rpWI/WD1wGoEwhXzaOPBOBfYEOYn4whMXSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e/XgXy5Pu2oeHwF+IbTAIKyD7Jc37Grfd+uqczAgSReyofOl2jK7XWbvmiSc0I/L8
	 1xqlGbow1VcCfHH4sUgALg1hqO7e2N6R1tYZOi5SwHxjiVmTgM3uT+FSVA/RWYB3Ft
	 OACE5lQJZzvEiYYnSKbKYi60vzYp645ejrmt+fZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhijit Gangurde <abhijit.gangurde@amd.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1038/2651] RDMA/ionic: Fix XArray initialization to use XArray flags
Date: Wed, 18 Nov 2026 15:37:58 +0100
Message-ID: <20261118150325.334527209@linuxfoundation.org>
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
index cba7809ec3d92..fa79732c2f7d3 100644
--- a/drivers/infiniband/hw/ionic/ionic_ibdev.c
+++ b/drivers/infiniband/hw/ionic/ionic_ibdev.c
@@ -320,8 +320,8 @@ static struct ionic_ibdev *ionic_create_ibdev(struct ionic_aux_dev *ionic_adev)
 
 	ionic_fill_lif_cfg(ionic_adev->lif, &dev->lif_cfg);
 
-	xa_init_flags(&dev->qp_tbl, GFP_ATOMIC);
-	xa_init_flags(&dev->cq_tbl, GFP_ATOMIC);
+	xa_init_flags(&dev->qp_tbl, XA_FLAGS_LOCK_IRQ);
+	xa_init_flags(&dev->cq_tbl, XA_FLAGS_LOCK_IRQ);
 
 	ionic_init_resids(dev);
 
-- 
2.53.0



