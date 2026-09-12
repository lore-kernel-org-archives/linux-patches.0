Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C685F4BEE32;
	Sat, 12 Sep 2026 11:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211935; cv=none; b=BQumPefMW+fEb0Wh0YiH7VeDuZDiNNhxvFjExCBXMvvMKMH1NdFzN0z0juNd9w7nChSzOhkxN84mL1DeVLNA7tZoFTqW0MWWjHvtpxQRFBsR7ecX7LH/bACNnqucsGRbucPXVtMZrwbVINmHmjViDd//x8NBaV2Nt7rDuX7+jyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211935; c=relaxed/simple;
	bh=CCobzFPMkCnkQWmDvaadcH7Zbaspxm1E+8uoJwV9luY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlvQeaG4TvIC0BA3L7ohuH2PcdsJzHiMcAX0RBGgbkSjtWK6iq2FMAcmAAMQ1gyz04OmkOgGtfpvuNuGoxf1JPlSS8A2+g6rSmsxjFJjwLiuQNDs9/CcXheX+FBFLgx2E+jJI4rOwpL7diXdQvn1Ej9poPitp6wIyq1s8bxZ4Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2R5omfYx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2R5omfYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFBD1F000FF;
	Sat, 12 Sep 2026 11:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211933;
	bh=T4xphYyyzDTO3FLfOYf8L+5UZXQpT7kYByfxIN9vQqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2R5omfYx6JgZPHpJCoQctnsUIWVX3pcdcV28vYfmHtBJnlHU2u4cUuU7s76KPOgg3
	 TQTbADBpUR2EnHWmmoWKPgRMdnTRuLDXIFe8mDWpbWaVVnN1sitNw4tH/vwYmP1mXW
	 m2cb/63gfJouXddbMiDS71n5SbWMTyZ0g2gANH7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1290/1518] net: add missing ref_tracker_dir_exit() to alloc_netdev_mqs()
Date: Sat, 12 Sep 2026 08:57:39 +0200
Message-ID: <20260912065652.696128007@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 0b1c2af8a22c35cb099c735c2f63ea3ba757557d ]

sashiko is reporting that trying to read /sys/kernel/debug/ref_tracker/*
causes use-afer-free crash when either alloc_percpu() or dev_addr_init()
in alloc_netdev_mqs() failed, for commit 4d92b95ff2f9 ("net: add net device
refcount tracker infrastructure") added ref_tracker_dir_exit() to only
free_netdev() path.

Closes: https://sashiko.dev/#/patchset/56c707e7-1fb0-43ec-b8fb-cf6f451e513e%40I-love.SAKURA.ne.jp
Fixes: 4d92b95ff2f9 ("net: add net device refcount tracker infrastructure")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/b06ce35d-e7bc-47a5-8e0a-e82be7e4dd08@I-love.SAKURA.ne.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 966617838f403..ae5e8dfd2fc21 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -12082,6 +12082,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	free_percpu(dev->pcpu_refcnt);
 free_dev:
 #endif
+	ref_tracker_dir_exit(&dev->refcnt_tracker);
 	kvfree(dev);
 	return NULL;
 }
-- 
2.53.0



