Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047885;
	b=0f0mbsq9OCAwiiluuldW4RxGzGzzbaEL/BP4V+hApLQ+cyTk27fuM1964uvCWkLkDn1B
	 ZyJcsg24dRZFEK84faTpNeoH7ee/R04KrhAeEkv1NEPcxNlYlFuRmJjs4Dh0SOoTAxkRn
	 NTG7ZFmHo6IMCb/HTFpQJo7t7QPzL4up9SOiuUJuuU1hzcRV98uCR3qFcwfsn3fOYg0kT
	 gtZB5w63ZPGyIgQG+sZnO8/L0/pvnjMmtlrJfiu40r0SZC9RI97oQyc6c43P0/Nf3RJwu
	 pAMMSgl4Wpst/AV5X4xDaAz/Bqma4D/NKN6t1mRlVG6yAQiOwXefoKHAaQ0bgV4Vu1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0y/apcLYCuWdyAbh5gDZu1SWSieUEb3lb+nwCmo5eAA=;
	b=2QdBpszEvq6yo1vjKIhs7XBe1yJa1AQn5PU+ywPXJz2cn51p501lOC35YSEHXXxCIBBu
	 YG8zFqEt4taZcAfkrWAtO/s4V5NXOBaonV5k7v2WDHb+jQ2TZXuKql5/dX0w2A7x+M0T1
	 g5BS28AoSG35CiifWk4oVOxmBndwre3nGLsoE46x4qFouqjK+ksQc6KDqflsYIf6VMo6I
	 ldRQNuOHOf5Rv5Y9hgJtbCLsPw7SHo4AZErmfzb/EWDPEakkCdQ+KhqAqGefYP6dIJaHd
	 3qF8JQSa06f9VA7FLFZSJKhTByU9viZ6JWFD0qBVXkgg9FKqNi+eKhCHCEqKmm1UCBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Cp+/QTha";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF60C606A320;
	Thu, 19 Nov 2026 00:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cp+/QTha
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8881F000C4;
	Thu, 19 Nov 2026 00:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047884;
	bh=0y/apcLYCuWdyAbh5gDZu1SWSieUEb3lb+nwCmo5eAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cp+/QThaYZ13oyEw6D1hJCCtifQNBrHIDrmNV5YpqMtgoUon8sE7L/4wA0PKIXr9w
	 L5k0hjJNAJzNo8kgAPZ0P1UvQi8Pn4IPDrDlLUAWscuXjIGcpbDrlImPBBLHMe3bZw
	 LvjCnOBx61MfWDnrIrflRnl83G5RgMyYU959JA4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Julius Bairaktaris <julius@bairaktaris.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1798/2857] wifi: mac80211: fix swapped fq_overlimit/fq_overmemory in aqm debugfs
Date: Wed, 18 Nov 2026 15:47:12 +0100
Message-ID: <20261118150305.996974106@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f345c61cfd62f..315323c670df8 100644
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



