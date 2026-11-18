Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050643;
	b=AAEh3weHWwisLh7ga2seyKlnSu40xGoIHRJZi3kH94L+RlmtGPeVQAtuqEgUqd9b2KeV
	 5uT4xYjnous9AVnY1QvClVquI9lOpt++FuuTZrjbgHL1Op1cUc8vhIUfpS0qIn+g7jdti
	 gfOOFHlc6wLSDn/1z5i+h7anCFGR4P/7+dZIKTAALfWzdE433sBxT55LDPPCAS5sn0Gzv
	 llgqS+G1M4yR3itjekM+aFYQjW3XzOlSC8RZwrGcoeFKg4/PY0DP249z1S0CrzIjbuYF+
	 /p6ywC5eIdYAKaiI4a7cpQvYYhY0vUFkBDILu1T8aF8fNLlwQ4GBC8qkw0rRKY0UrXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rx3UShRVqJwABP8oJOK/2XWcmiTTxh9O5l+37tQ46ms=;
	b=mAuvgEGClmpWnjkylFY1mMq3Emm3spTN6VsXNCKLLOCW/9HvmT29ex3eoLmODU9yHm/N
	 s5uL/G45McAI7obeM1P+WHdw88+jI1S2Mqq49YqwylMZE3ERyEZ6tQO8A2k/jAQalw4Zq
	 V9Y6iqr+nuwnyUPLAFoM94Uu1QYeUi/GcNEygu9bEHnpCtnV3xzLTeuNeYpJERtzIgNkV
	 K42ngyS/wXTHkk9O31BPI1Plksn1OTWsP64l3MQWwFGtgKA6jdVWlQTqp3X4rz6LGFBax
	 v9m4AwHj0TIwfgFuR12qeLyV2Vzaz/eBKdn+yjL7RwDrPRxv+CkvNIBYkQy9k7U9rJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l1z2NPCM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EFB606A325;
	Thu, 19 Nov 2026 01:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l1z2NPCM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DB71F000C4;
	Thu, 19 Nov 2026 01:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050643;
	bh=rx3UShRVqJwABP8oJOK/2XWcmiTTxh9O5l+37tQ46ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l1z2NPCMMttzFvK1LHW8PGLwqSvORTlnuokFQkiKFWRAml3jxYsivzU7Lh4BOGibL
	 0un6TijwVpxnM76rBRVbd5VtRhbsSmVT2RWP+6tQ+66195zhVWMCwUmElUbUM809aq
	 htoGTjeY4ISfCbMw7CXEvWdtk/l7FN5euyhfrYJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2781/2857] blk-throttle: dont truncate the cgroup v1 iops limits
Date: Wed, 18 Nov 2026 16:03:35 +0100
Message-ID: <20261118150341.735651614@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 7d96874ba80ba7a2ab578ea9139c2af79c353b88 ]

tg_set_conf() parses the limit into a u64 and stores the iops ones
through an unsigned int, so anything above UINT_MAX is truncated and a
multiple of 2^32 becomes a limit of 0. The next IO of the group then
divides by it in tg_within_iops_limit().

Clamp to UINT_MAX, which means no limit, like tg_set_limit() does on the
default hierarchy.

Fixes: af133ceb2610 ("blkcg: move blkio_group_conf->iops and ->bps to blk-throttle")
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261028164415.1262013-4-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-throttle.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 7ae61c3f887e9..084ae45efd118 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1414,7 +1414,8 @@ static ssize_t tg_set_conf(struct kernfs_open_file *of,
 	if (is_u64)
 		*(u64 *)((void *)tg + of_cft(of)->private) = v;
 	else
-		*(unsigned int *)((void *)tg + of_cft(of)->private) = v;
+		*(unsigned int *)((void *)tg + of_cft(of)->private) =
+			min_t(u64, v, UINT_MAX);
 
 	tg_conf_updated(tg, false);
 	ret = 0;
-- 
2.53.0



