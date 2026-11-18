Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045909;
	b=uz02nsQt5BcWC9vUAIy/p+F2vLggvWx62NjKNF4Cs/PTo8uC3k/mH466AKCfyMCMByFK
	 afbkbw880Nr+vGg9fCKZmtzBgoMeEBc5ZVFKB20o0YnQ3KA/U+QSKY+/HVpq6AyhXHDri
	 ZloaNDh69C663/eIyq6CJkSLPdzH1ltGnuliluODLE8E/I2YQdeeiTOoCnTORrLAbQQRU
	 FLs2Iz4XNsA5EktE7w2iHTvsjoWmn6MgJfZJBGiBY4t/yHVNrderPfbnIXFZsuSorP9NU
	 LPzOVyz2GQTB6eISZ95Z0HAMcsaraWWTr0fBtCLF313EtuI4e7dUadaUB5tczlRCuPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ilD3MWg9VbMqTpXh6YGp+4FMe+nwWEI60IFVWSLgcUE=;
	b=HJpTgmFdmOa/sZKK3Qeoys/dkFNmGQC5BZrhDQk1NxAU9t4gB3I8gyZRsd20WhZe3UaZ
	 iqoI/Oz0lj9JoCMO7Rfs0MghCN1NV7tQ5OVYvRmF+/VlVbeAuPPYsEtvsSqPfu1W5BSpL
	 fSq1ERq4Sp2UkFLPcEcHCe/9iHzbOX5AO2VPeJwdq+5KiUtH8ZX1DG3FUzpnNZZN5CTKI
	 bm9umBKtG3esE90D6BvK8gRT/TEo5v13wM3qdSE8EQGtbyjcuEMEs6HXqiXFgPw4sp+6A
	 Okw/00+5EZrIkG79XrzT4sfBu9ApixvR7LG3EQ+3krzrbs+Z6apOZYb5XIpjpjR/g6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tUrjbv6u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4424606A325;
	Wed, 18 Nov 2026 23:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tUrjbv6u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF791F000C4;
	Wed, 18 Nov 2026 23:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045909;
	bh=ilD3MWg9VbMqTpXh6YGp+4FMe+nwWEI60IFVWSLgcUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tUrjbv6uMcWmIGnJtueyzWXAfVsBpp2URkz7mlRXHHfCoVDh4Uc4cpf+zS3p7j3y3
	 SCojyGOdGywvMVPD71zrmWhB4vIJr5ovVEOrUjURTYjqhcetKZdxoqk1oEFIQHqEva
	 ElpA9/9WK72BsgcFdB20yQgvxW3//mMbGBye3OAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunhai Dai <daikunhai@didiglobal.com>,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1092/2857] blk-iocost: abort weight transfer on invalid donation weights
Date: Wed, 18 Nov 2026 15:35:26 +0100
Message-ID: <20261118150240.941384926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 814ad657cc56e..7600aee06f840 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1949,6 +1949,7 @@ static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
 			pr_cont(": active=%u donating=%u after=%u\n",
 				iocg->hweight_active, iocg->hweight_donating,
 				iocg->hweight_after_donation);
+			goto out;
 		}
 	}
 
@@ -2047,6 +2048,7 @@ static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
 		__propagate_weights(iocg, iocg->active, inuse, true, now);
 	}
 
+out:
 	/* walk list should be dissolved after use */
 	list_for_each_entry_safe(iocg, tiocg, &inner_walk, walk_list)
 		list_del_init(&iocg->walk_list);
-- 
2.53.0



