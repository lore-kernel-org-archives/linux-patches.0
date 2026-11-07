Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062659;
	b=5UXihh22GhV280AXJ61T1ni692xzp7e7TrjkCSDwXcYBSA6kGDcyQ678nJ59nv7sDWg8
	 5goJnU505U9UNPl2vX6ViVaKtCW1Z8D00h4+Wv3NGzLUJsPng7PMQs8zxcf7neoxLtmyt
	 CFXV+3esT5X0D0usUqN2cHgsmvUtVzBpw4qZVeSz1LEeqiGOipyDvud57hd6W2oOK1PFN
	 uyZfC0ID2htB0KNkTSQHXt5lXIRij0n19jKumxvvWEedkoSUZPBWye9COPdYh4HCaCzTD
	 5VKDt8MbG2DARm3P2clVbWJJoY5rOnZUG2986tZylT5CcR+O/Mnp4J3g2+1YBvihmPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062659;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2wPBwVgiEvodq3x0z0IGSdpMrhTaEFtYMtymAxQcXHA=;
	b=upqhjInkK2v7qqPCAbPdGde/iYh6a3NJEfOWVLgzey/hwzrTCDTit2IDHN/0kN2IFPTl
	 4vArWPAaxBtksZ1xvI81/HwC2U1DGMkCcwJvTDIVG1XZdeLboVjoHuPxVvvZTCgsYI+Jh
	 iCgZlS3YH0mSpPNWvLoQA5wiwc6zcCUrNyRWe7BSXPbnResZ5wPTAHjPV4PHOXhVj3PYd
	 1nziUR4uHOynAEPYcM8/D4hvKawUTAws/Qn/QJ63sEbax8UkaUevcnXyiS/o9FdT6n4CF
	 BdB19PQIau0EtuhQVhDidg3BVj7oVz5sK+winTf6EZ28pLRgfacNkC1b1Rz05gFi5vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jG3MXpiM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B18D606A333;
	Sat,  7 Nov 2026 14:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jG3MXpiM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8771F0089F;
	Sat,  7 Nov 2026 14:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062659;
	bh=2wPBwVgiEvodq3x0z0IGSdpMrhTaEFtYMtymAxQcXHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jG3MXpiMTb3iL6szqrjLamYq6miKaPudJGa5EpjeEqGgiLWuUmCf4C9ZPVZadcNXd
	 9K0XSy0+dANb//mp4DM9sbIDBfuAXFdc3y8N+AEozBdtewh+33ceTq5OauGBPP0dhs
	 jA3i2+ICkUd0jgOaewy3XJ0RO+T8P0cuDvzxuAg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunhai Dai <daikunhai@didiglobal.com>,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1522/1536] blk-iocost: abort weight transfer on invalid donation weights
Date: Sat,  7 Nov 2026 08:58:58 -0500
Message-ID: <20261107135040.625765885@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8b775dd95ba57..4707b93493055 100644
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



