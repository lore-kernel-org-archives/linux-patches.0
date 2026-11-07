Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065563;
	b=ZNBUxliPeEXKOiVL9iu+8UQcr0n4jBlDPbnMJDw9gxrF8hkctGF73t56Rf9wSp8UDNYK
	 W6BEVMxWPOgK5jAibnQcRUYNpq/23wHUVbuBHcLPuLbhtU+++1Oa78ChRGPVhCRmVhT15
	 CNiVDKJMNRPJyEdChAbJm1jR3zKVKGuA/wSbZNQEwSPhg/67DmkcUpJlSiFFE9vvCNwUC
	 sgVfn1nUS1h2R1e/RQiPHsES218p3zMAMq34770ecUUHsrfYcjFtwVfx50TxZnlJGoFX5
	 Q+IgVvHLP4WKqQ/o9wjfVZodRZkxZkv3EHdAkkAZzlo+QPyLTzAgthF42w1Ls95wiQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065563;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=99kS51Cza0bq37DqKUQhoJMujxWEMMCGX4alWFElH+Y=;
	b=PDTjuVYm1Y04IV3PkzZd2U5zGJ7BUWS5jqAPvSOszgUIM9o5Cpv1uE4Ujs5gO7N0i9EC
	 IwQViKqE3tlu44GyMn4atPn/R7FOhkZ8dVCi4S5L4WcfItF2g5SDyzGI7c+go1hhYBuel
	 ciq4Wv3YxIYl92epU/Pk3Prh5Vwj2C+TB699QXLayCImp1V3G6augWOwKSTd00L45yhu9
	 G3B6lEM4FAZO6+i/t2fY3FpkZKYG/sbSoj6NE3rSigoZaY4VQG3Hgtt/TIJ0pVfb+N3K9
	 SUmxRff/GkNU1fSZA+e+VcT0j7TbPzK+kuddif3oFE5d6Zg+zjb/ufjiczNIQtl+afA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U3NSRtfO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7D0606A339;
	Sat,  7 Nov 2026 15:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U3NSRtfO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D33C1F0089F;
	Sat,  7 Nov 2026 15:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065563;
	bh=99kS51Cza0bq37DqKUQhoJMujxWEMMCGX4alWFElH+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U3NSRtfODsftMbvTa1rIhXoZgxJQ1x5gKY3GhI7sztSnNzHzbaI9ONIlapfhAtc39
	 AmIJM9JGsEuPK+eMCa23YX+fOFskJNYxIRb285ilOjP3kpZDMNL9/cGKWOE1GdCyag
	 X6GpiZN66/cj3Nag9yi1HNr7BGs57Pp52XiaEcw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunhai Dai <daikunhai@didiglobal.com>,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1231/1257] blk-iocost: abort weight transfer on invalid donation weights
Date: Sat,  7 Nov 2026 08:58:47 -0500
Message-ID: <20261107135013.344218174@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 2745bffcd5eef..7b8af094ab370 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1956,6 +1956,7 @@ static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
 			pr_cont(": active=%u donating=%u after=%u\n",
 				iocg->hweight_active, iocg->hweight_donating,
 				iocg->hweight_after_donation);
+			goto out;
 		}
 	}
 
@@ -2054,6 +2055,7 @@ static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
 		__propagate_weights(iocg, iocg->active, inuse, true, now);
 	}
 
+out:
 	/* walk list should be dissolved after use */
 	list_for_each_entry_safe(iocg, tiocg, &inner_walk, walk_list)
 		list_del_init(&iocg->walk_list);
-- 
2.53.0



