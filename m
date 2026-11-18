Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037079;
	b=xdAp3cDBIar/cJzgbBLBGPDdlKgKiaPe8JlFp1MjaptAlt3mDrRrhlNjocSUn0vQ0/6Q
	 tByEnbKujNgzDwATaBWdxJ/vb/YVMlzKhDgwlujHYMT8xtIQguiFc+LYqB6oshVUoePqw
	 1eoSU3zCaKwm5qlEqMdnMwuRlHLrrfBzAWnk/31CzvR8gGOK8XMb1LHVt4gHq+D047tVh
	 2O6Ji4CpSMp898GlWdr6X0Br+r2Mn8ohCKa7JMCb/zwj/FCuQ0cJlk8KsgBbFN49ymEqR
	 LubjO6MMlsARZ1YX34CzNvhFFPY7ZfdrSiBc4oh+Lbs5EiGBsg/x+OWShxNQexRRzRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/PMTriGXTP24NG+zgcZdJpUt+FjiTet7RI7KnTY/LQw=;
	b=HlxwZ7SrNQUnYi38NIwAYyNRpDdX9uS2CLcX3e1MUpRpzJHDOnlBMIiU8IQFJ67RkRrU
	 hEConcgMY5IXLZLBFmWcRJMU9Gnke7Yc73Avvmc6Mh5l/PDgfig/yaf1FDZH4zd05avr5
	 WVgU00UNwXSXWtv85PnKneS/3POlEERvBH+OJ6oEw6CaaXZO0BtLh4ZB8btsBGWjb8lYF
	 mO7NUZEayjZDh0z1KGQJ1TaoAnMiDsyu2+TINDSc0HdBE2ux7jnafGp6fQsHfW+1buXsx
	 1YoguO5zTZpNc7M/R9QTQqTQDm82twoNK40yZ0Zjy/RIZsw9C85P6P3BshT+kM9uAJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=asPndKhy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9245606A320;
	Wed, 18 Nov 2026 21:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=asPndKhy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1D01F000C4;
	Wed, 18 Nov 2026 21:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037079;
	bh=/PMTriGXTP24NG+zgcZdJpUt+FjiTet7RI7KnTY/LQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=asPndKhyV0akMi1UuNvkFeY9o9SxoydS9LdSWPyfXNfmeiIWZWKb/ZIuZjmP1xSua
	 aKIrUad11UE/EHpegX4UVKpRl9YM27hNQxQPghsLO2BtSjkbSIHGf360davrrsAHS3
	 8MuGEIX9oThhJyCoSSDZjSfgn6i4rbZqanYug42A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunhai Dai <daikunhai@didiglobal.com>,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1284/3318] blk-iocost: abort weight transfer on invalid donation weights
Date: Wed, 18 Nov 2026 15:31:46 +0100
Message-ID: <20261118150358.767307051@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d96113c421be9..99efec392dec6 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1965,6 +1965,7 @@ static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
 			pr_cont(": active=%u donating=%u after=%u\n",
 				iocg->hweight_active, iocg->hweight_donating,
 				iocg->hweight_after_donation);
+			goto out;
 		}
 	}
 
@@ -2063,6 +2064,7 @@ static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
 		__propagate_weights(iocg, iocg->active, inuse, true, now);
 	}
 
+out:
 	/* walk list should be dissolved after use */
 	list_for_each_entry_safe(iocg, tiocg, &inner_walk, walk_list)
 		list_del_init(&iocg->walk_list);
-- 
2.53.0



