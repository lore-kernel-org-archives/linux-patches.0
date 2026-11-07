Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063788;
	b=z7y5IA2wyDjxWMurlDtMkfzQLIcz193S6yLqCc8FmvXTlIjW1vTmlkkRh1nshst7PpBf
	 v81mhj+uaRxLeNVr5hcjJPBWiGY9g4PQ9Ge4ZvFHb47D7GPOh8R/If2QtJvfLzqZMi3//
	 y+0nYaB2p1nzx3t1wwCDzu562pL1FmGp2WHJ/5482Svtr/8jxMXPsw+EmUVRJiegUusad
	 4NoKJk6VOJtWWSog5lmBlNq/1XMV+ncKVKC+i6H8eJjXe3tKxRPzgVBitQEfqCPSVETgc
	 kVj5CfPMPw0exvEi7iQABsiMuizgvR0NvP6gnNfMoLLaGZPGtZS+xZqtnZ9NhGQajMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063788;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vmyaRtvG8IU3J6XOsWSowUtnVY4ypikZOGPrdlysBVs=;
	b=Y0kCtpzzReUEiSqomS2NXhw9EfGBjFbIiEAzV5nu1cwJNkK/gGeJWFathosgDwrk1jYV
	 9y9SRY+2DVuku970n9Q3kuiDDDLTTjUsXnbCN6KEF5Qv+64zt4C/T8TxoDWBjXcSkV6QY
	 EpCej1QAiOSOTXKtSs8ZuAzAyIy0G+nEpdkmw6gAnjCs2egY91USwxteNGvbGB03rCHCu
	 ifj1K07Eq9pnu/wxZRpyLvciiW+mSNXuNrC0uiUxvH5XCIHwUK3813NMcQpeS5bHJLsUy
	 uR/JRQKbl8E2BXlGHLTMNp8ZCbCZkLnIzg7Ch9Tgem7ES9/h+V1NnBZzDTPiZRq4CiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hWZfoAei;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFFA60A3818;
	Sat,  7 Nov 2026 15:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hWZfoAei
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5081F008A3;
	Sat,  7 Nov 2026 15:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063787;
	bh=vmyaRtvG8IU3J6XOsWSowUtnVY4ypikZOGPrdlysBVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hWZfoAeieFRd6LHqS8QL/5tNSFm4lSfmXkdUvnttpMVnXOv5icN07oTjx4jZp6oQL
	 tJfK2G1PM4D+lfmFMDy8Ojo4OLAZuiU33aF2FWzVuwh6sIObI6sLH7PZ0Q4zZYF/RH
	 TBHIjE//8aA4FLM4LpDli1Vo8YtxdHwHavfYZ0Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunhai Dai <daikunhai@didiglobal.com>,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 850/869] blk-iocost: abort weight transfer on invalid donation weights
Date: Sat,  7 Nov 2026 08:58:52 -0500
Message-ID: <20261107134921.620083584@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index d0b13580c6b62..5c7cdb493768c 100644
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



