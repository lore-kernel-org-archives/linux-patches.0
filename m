Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052954;
	b=3oWHWz0mgQQllh9TpBhz97hC83mScUK1c6cmOStWHw+dDcE1LjWaVXfO+u6sAHbJ2GFy
	 yUVf6zsoOcbvJF2kaG4urlBJk6KfFXZfj89/x51AyMyMnvfDE3PU+72z6A7DpIoVCrWea
	 XcDa8/kC7b96vMD9AeUlYfARlwNasxmM8Gj9v2OlSiDwvwmwnVNMtxFTyLNiL5VovndH0
	 e8axdV+0IBuHRQxV/BUMSVVquYJh5hZ4Wbie3dsZFMcb/7n1BHfrJMPRxdfV/Dz4Nt8qD
	 65hiYLG8GrB7WQrLZhaKQFdn19+gwtr/LMt7QgJJf3y7KL+jCSE6khFxYsW6w3lUuEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5ZPnUGElz5ObviFrS59Qygh9VcEagyyxl9S0go3qnhg=;
	b=ygQ9Mo8q0+j0F8piLOtPOVL7FDXD5jjNRZIXZhX5CZvliR7oZoKbVm2J174AQTSrP6Kt
	 Hn+SPucOLt1JJgiaZ5S62cXELPI1dCkj3hRBZLNZQZLOO3RhXrti2yHXqpMvR3zrHBAt0
	 mfSDScNZHJIzYh6uzQtu0Sb37Zrifc8SZWsTN9j9LCYyoT0uf0+mW6NUQMCt1F22Xm/1H
	 JWmJKlGq1Le1vZsz+XrkzNiDc9qoEWRjz2rFqZ+2er/dZwdWN4GtXcDKRjovv1sPVSEGh
	 /g3K1/HQP5No5Y3AgfMPHfqkEdGkxr0SQCY764mPlyRwRZTejbTCa8L3wNDzPMMStrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=duS655M0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE10606A31C;
	Thu, 19 Nov 2026 01:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=duS655M0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DAF1F000C4;
	Thu, 19 Nov 2026 01:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052954;
	bh=5ZPnUGElz5ObviFrS59Qygh9VcEagyyxl9S0go3qnhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=duS655M0s2xaMt9xX/NXKx/WracrYTUFjHpe2VF6l9MCVp5SuOdSfsfR5qxJMHhhc
	 D1OUvuW9Sf2pMkAafzwx4Pe0n009+rM8UGDyc7MwvdQl5TS0uhZs+IIMKHIsukKp7j
	 wvcXQMUhdZUtYutxmIdP6we4ttXNarAcotaXebWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunhai Dai <daikunhai@didiglobal.com>,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0748/2214] blk-iocost: abort weight transfer on invalid donation weights
Date: Wed, 18 Nov 2026 15:40:24 +0100
Message-ID: <20261118150041.711671999@linuxfoundation.org>
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
index cec885e805100..496aa2d4c435a 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1960,6 +1960,7 @@ static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
 			pr_cont(": active=%u donating=%u after=%u\n",
 				iocg->hweight_active, iocg->hweight_donating,
 				iocg->hweight_after_donation);
+			goto out;
 		}
 	}
 
@@ -2058,6 +2059,7 @@ static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
 		__propagate_weights(iocg, iocg->active, inuse, true, now);
 	}
 
+out:
 	/* walk list should be dissolved after use */
 	list_for_each_entry_safe(iocg, tiocg, &inner_walk, walk_list)
 		list_del_init(&iocg->walk_list);
-- 
2.53.0



