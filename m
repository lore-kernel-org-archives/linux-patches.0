Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039424;
	b=GJ/Yf5JkGQbr8mzrMzcjTxKOdSGWze3St08lvs3C6SC3uNp3wriv36WbqmvIylQeuJkP
	 hitxuGNwXW211SOWymPtidVSp3apfoQNXRQMxVhFOw534SOO6z+AcjikLQOE3L4J0ZUGZ
	 dMHecxkDtSxOGUFMiKLGOUC6jB8CN2u6HXYpZp4cmcWQwAoFeNvDoZdgqYiVLiWVdykou
	 esn1jtNsGh2xaaGRFDFVk4oUh440nE2uv+IxgfFVJ2FQ1YYUnvQBsHQHWu2nGXaH89dzU
	 eCIjfUsgt0JWawe55NZv/uwBlUMlxhh20GwwSsJFQmlDLIctivcRd8z89hhL+hBJHyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039424;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=oQ9RQrIuC1/HimgNNccYE1ztmJf6WjHkbc/nluhzQ/M=;
	b=pGb5LNYlpuyzrn53qByKPp0/KIBHwmYr3514aa7d7vVq3d9djdjDC/pMsNhG7VQzdAcf
	 AOtgtp0yeN4+gFsA3DfTS/c1h08cv7PQGVDBqa65PEaqCxuxz4bEhFsa6edLCfkhUqPSi
	 Zfq8PcvbqWZ6mRPKa8anFMoFib8fDpLCQI40Rzy+vC8RtuHJ87/vklaVfIGTxptAPmVk4
	 IlBhrqTfCOy8u5vbdgJ6Dxo5004Kw3okrHavQojH6sd6y86o7IWxEFRniiKHFHtnAhKGG
	 cM5D0npudsGwjHvxPRCgzcdzrtyT2u20gw6VINqkVsLpgQm+mvBoZaVWbP3oYgvFu+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jasat9Od;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076D0606A337;
	Wed, 18 Nov 2026 22:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jasat9Od
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF151F000C7;
	Wed, 18 Nov 2026 22:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039423;
	bh=oQ9RQrIuC1/HimgNNccYE1ztmJf6WjHkbc/nluhzQ/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jasat9OddlYo7z6pGoeSFpAKzkrbnFoa72kj2hwctVi8mWTGgPpRYXh/wxgbiNGfI
	 1ZuuWrkr6oJPw3mBhADho5IhLKcHZxNAueXhcJb7LgJsEWvy6cxEwnFW8z5Jx8iLpa
	 L/EyA6/keoZ+gUjdfU2KtlZgua1PaUzD3RGoOI2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Julius Bairaktaris <julius@bairaktaris.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2054/3318] wifi: mac80211: fix swapped fq_overlimit/fq_overmemory in aqm debugfs
Date: Wed, 18 Nov 2026 15:44:36 +0100
Message-ID: <20261118150423.678021032@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0392f3b28263a..2ca3e41ee8987 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -98,8 +98,8 @@ static ssize_t aqm_read(struct file *file,
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



