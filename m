Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058772;
	b=wrbKR8lbfmPAdDlEGvMv4KbUr0DoKjTW+s61tz3mMB4o4ZBKYwx8Y6BIIWiVrSAeIX4A
	 TC5nzri0Kgx9YM6Rqb1TOXIhq2vPO8X+r6UdEN6CdtYMtQplJIw5MWahOr6Gq3SSX6PL1
	 ExxGFN/N0Y+wvETtkmHutdIOyCEAV3PnjghSx1mVxVydrEQx6lgu8uWVHLWZ8sH+TCJDS
	 pLyrFXFpLb35VLfW6ARhwRvGWoFi1VOGNAe3uMYg9pjV6+O0iNslt4ECj8mDjxoiVDpZZ
	 aN8aSqIKjIn7iejSdC0cJepKiA2y+p7nIXF45KMR4QD+d6TWBOwBpIi6Flal/tH+7OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P1fr4AiE5e5uDYRuQXC1UfuK6YwZq4bK/FZ5sqbzMc0=;
	b=p7JGCYGypyELO7v3sBoiCl3RAMZEVryENkzgmeGfLOC7YgHLc2EFYjUqNIU44Er9pRG2
	 qhxxYIs6JJ5A9D8LCOGHiABi6mZxLCTjP05anvEck/SqCj+6yFOap2l2/rWTphLvrFKDl
	 gU4h2FQFMlbjw334sk+yVlGnR44mRWET9u+ZzfP19Mr7ZjJ+cAHGgpK7MjOUzbjmbVm4x
	 kIl2vWQctDA2TS5tskdABWKxUPhwdQxxf55Qu+j8bCmaCe9Ch36DmS02hLMns8KisYRk0
	 CNEr7BxThq7HXbWNmMZASA3ibnxE8hzauZLcBMgLqRYNI9nKkY8Giafz0cVgsTsaDVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SoL2zXix;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B088606A337;
	Thu, 19 Nov 2026 03:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SoL2zXix
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B721F000C4;
	Thu, 19 Nov 2026 03:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058772;
	bh=P1fr4AiE5e5uDYRuQXC1UfuK6YwZq4bK/FZ5sqbzMc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SoL2zXixKbSDkQuMBcnuHZz8pOua6XQywyynVIXK5EFns3bJtgYRTU+dddBIZ4lN4
	 WFEfJoyCLpEy9N8a9PrmrloDaY71m9spJxb9BP9GqyRBIwQC4ID2YfCaqt9/Flfp8j
	 +CAZ4nf0gWP1o4yGxnPer9+Na8wERoPaLLZNmRp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunhai Dai <daikunhai@didiglobal.com>,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0604/1848] blk-iocost: abort weight transfer on invalid donation weights
Date: Wed, 18 Nov 2026 15:44:02 +0100
Message-ID: <20261118145940.630317520@linuxfoundation.org>
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

From: Kunhai Dai <daikunhai@didiglobal.com>

[ Upstream commit c810ee88cdab27f443c32270dc7c0eaad2cca3f8 ]

transfer_surpluses() warns and then keeps going when the donation
calculation produced invalid weights.  The following propagation can then
divide by a zero hweight_inuse, so the warning is immediately followed by a
divide error.

When the check trips, abandon this period's donation transfer and release
the walk lists.  This trades one period without donation for not crashing;
the invalid state is not expected on the normal path.

Developed with assistance from Claude Code (Anthropic): the assistant
analysed the failure path, drafted the change and ran the checks listed
below.  The author reviewed the result and remains responsible for it.

Fixes: e08d02aa5fc9 ("blk-iocost: implement Andy's method for donation weight updates")
Cc: stable@vger.kernel.org
Signed-off-by: Kunhai Dai <daikunhai@didiglobal.com>
Tested-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261019125412.3123895-2-daikunhai@didiglobal.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 98866b3bfc275..46f2b01c782a3 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1914,6 +1914,7 @@ static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
 			pr_cont(": active=%u donating=%u after=%u\n",
 				iocg->hweight_active, iocg->hweight_donating,
 				iocg->hweight_after_donation);
+			goto out;
 		}
 	}
 
@@ -2012,6 +2013,7 @@ static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
 		__propagate_weights(iocg, iocg->active, inuse, true, now);
 	}
 
+out:
 	/* walk list should be dissolved after use */
 	list_for_each_entry_safe(iocg, tiocg, &inner_walk, walk_list)
 		list_del_init(&iocg->walk_list);
-- 
2.53.0



