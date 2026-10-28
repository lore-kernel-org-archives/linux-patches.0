Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213634;
	b=Qx1d78XTCb9FRP0dOCAYVaJ0LnsyFQ8Y8XBRvO+Pyw0oNalZF1apanKa9VSSjv+hUxCG
	 5lUawJs64xvGyC/5Q5Xzd6v50J/8A5lw756mW8wfmiUK3/23O5vwjm4VE2xtNE2bBxbyK
	 A4rP2DvLbozhyfCwY6RMu4yP/SmFsUcUl0zKwS/JbBo48eVE2UP8wWn1FCPYEScyt9wGZ
	 Zvf44geW0B9FTtcccaACdoCYICnFzRM9DDDZP9USnj//VD9A+hsUlqN8q350YejPtLCqc
	 UEdkQUIe5ogTrxaAZG4sewkQkUkS9WCjAWzYVObb2b1Na0XNzjpUew6mtveEChj4Ihg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Nsdkrfskann/rttalQ7W23i9k92h4o28mSSzFthI5c=;
	b=ZddhqBSdZ9ZOow9cejOtZ9JhqXFBsa6+j4gI7MAl1n1u2IC172uuO6PSZwrDJ5/1cGlt
	 0xK7KJPl45vyXsGDVQ+GPzilp8LD5XYruPJPR/aF4L4EVswiLlBUIavnUUFSMegw/KlCC
	 7rKuEETwMRmjb+ibuuMR3EUj6yT4iv2P7wiKeeNMypA4Cq4erP6JhYUa4DR7qI+nFjG4v
	 AmKMMZADuSibTTyKKdYqJNiEdfVu5xuenQCFo+HzuPKcRUS/w5elfjyWRQ2GaBcoDgDUR
	 GpOJnm1fWiJ+XHUjuy1RW4QVi58TkTUp7klxZX9fRv026ne6qrQ5vZPsMQyQtXulSzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LqVY3icF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FCB606A31A;
	Wed, 28 Oct 2026 18:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LqVY3icF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1BA1F01825;
	Wed, 28 Oct 2026 18:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213634;
	bh=8Nsdkrfskann/rttalQ7W23i9k92h4o28mSSzFthI5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LqVY3icFMBMJXWQ+6rmmm9HKhrhZUK/SC8vIUh11Cd41EoIjM+NsDLtorKgubDDzX
	 G+j4U6s+oy1Q7SL4/sTh7G6DMszCgoysCwZtSaOyyUOH8SoDPbH3HLX7dnLhmWAunc
	 Y3WPNzFJ4iwaxkkFemw3YlU4gF8xN04+69d4isUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0573/1887] blk-cgroup: dropping parent refcount after pd_free_fn() is done
Date: Wed, 28 Oct 2026 17:44:29 +0100
Message-ID: <20261028170512.446859922@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit c7241babf0855d8a6180cd1743ff0ec34de40b4e ]

Some cgroup policies will access parent pd through child pd even
after pd_offline_fn() is done. If pd_free_fn() for parent is called
before child, then UAF can be triggered. Hence it's better to guarantee
the order of pd_free_fn().

Currently refcount of parent blkg is dropped in __blkg_release(), which
is before pd_free_fn() is called in blkg_free_work_fn() while
blkg_free_work_fn() is called asynchronously.

This patch make sure pd_free_fn() called from removing cgroup is ordered
by delaying dropping parent refcount after calling pd_free_fn() for
child.

BTW, pd_free_fn() will also be called from blkcg_deactivate_policy()
from deleting device, and following patches will guarantee the order.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230119110350.2287325-2-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 3a33ec0af8419..34b89029ba434 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -94,6 +94,8 @@ static void blkg_free_workfn(struct work_struct *work)
 		if (blkg->pd[i])
 			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
 
+	if (blkg->parent)
+		blkg_put(blkg->parent);
 	if (blkg->q)
 		blk_put_queue(blkg->q);
 	free_percpu(blkg->iostat_cpu);
@@ -128,8 +130,6 @@ static void __blkg_release(struct rcu_head *rcu)
 
 	/* release the blkcg and parent blkg refs this blkg has been holding */
 	css_put(&blkg->blkcg->css);
-	if (blkg->parent)
-		blkg_put(blkg->parent);
 	blkg_free(blkg);
 }
 
-- 
2.53.0



