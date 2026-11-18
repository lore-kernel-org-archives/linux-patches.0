Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023062;
	b=WLZWLd9sxdTnjj8xNor/nbHY0UyKL9VARDxyRe9Kqz00JTo3nJeeVEgj+XSzZxq6+AOO
	 dimqKgOM6AVObkxzIq/ZH763z4KdJ+jyFGdowymSF2mhKWg0czMAD87f06SkFB9B0ZyLE
	 jiLrrgxqA74T11ZONx88SXQeP66CMid+yrYMyf8NFkipvcg0MWdvhOhlJUogGfVwJKwsU
	 cizUF/nIOMeAgedex4lLKaXrcxSN6Jr2KDaf/ZfZc9EGFRLZhGdByUUsEztgTQCwCO1s5
	 bM/w7TiINT3+aS9f0eMXbgeAl7R6mN/5vh/DrPr0J+WweMG1MlXm3RAdGVyJWnUstmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ZUBm78g4H/+K9Rv1Do5YXpLzZ4Q/VHWkMlZabfZqMeY=;
	b=QXg2oQQNNb2F7x8Ap3UxXjJg4W6yNwOHn92+GY940EyCdYttKqt8ZTibFuCR8N6kA9NQ
	 QqCyomgdm2T2/vxDR2IBII3zGPQAP0okST21QuQddh73UegPpZNOjeUbZLf6CNBFbDVe0
	 w7rC+9y1Orr/fjno6yWLac0mWB4RSdXpyvnKEcAO1d8wBB9qxJNS2Lr9cBk0NYJ4nUWgQ
	 Y9nMapxlBa/Qsv7+i/PfoczBhhrGTi2fNrmkq2EPqbeUe+ZLe/AA5O17Z/N07RHmIxKQn
	 iRw0mYZtQyOLlvF4MfukCqmp1nO53LCv76wpiuiHFKz27relRer+pnZFqK8pkwWoeeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=19GfFwZT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8074606A32A;
	Wed, 18 Nov 2026 17:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=19GfFwZT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8B61F000C4;
	Wed, 18 Nov 2026 17:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023062;
	bh=ZUBm78g4H/+K9Rv1Do5YXpLzZ4Q/VHWkMlZabfZqMeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=19GfFwZToGuGQZpYMTPAxDtNO20ESTI4Z+y0a6EosxhJZhm+8ae9Fd/srmJNejuuh
	 W0JM+GlVVd3g+YLXCYy4dCvi9ckR+Aejtj+q/9KhnNkC31A2EG0B30qyip9IVWp5la
	 qejL34lLLlQT1njhc4kvyxnVa2u6vc3zdQr9jqfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Julius Bairaktaris <julius@bairaktaris.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0233/2151] wifi: mac80211: fix swapped fq_overlimit/fq_overmemory in aqm debugfs
Date: Wed, 18 Nov 2026 15:32:48 +0100
Message-ID: <20261118150130.266390045@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julius Bairaktaris <julius@bairaktaris.de>

[ Upstream commit 25f3f2ff88ae604a3b473b501fc55d58fcb0f5eb ]

The two scnprintf arguments for fq_overlimit and fq_overmemory are in the
wrong order, which results in the aqm debugfs file showing the overmemory
count under the fq_overlimit label and vice versa.

Fixes: 2a4e675d887b ("mac80211: Export fq memory limit information in debugfs")
Reviewed-by: Toke Høiland-Jørgensen <toke@toke.dk>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
Link: https://patch.msgid.link/20260904090626.92727-1-julius@bairaktaris.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 347ae0f63da8c..e0bdef10d53bd 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -96,8 +96,8 @@ static ssize_t aqm_read(struct file *file,
 			"RW fq_quantum %u\n",
 			fq->flows_cnt,
 			fq->backlog,
-			fq->overmemory,
 			fq->overlimit,
+			fq->overmemory,
 			fq->collisions,
 			fq->memory_usage,
 			fq->memory_limit,
-- 
2.53.0



