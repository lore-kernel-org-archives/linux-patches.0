Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016154;
	b=14iIhdR+6jbloi22s4vr9aTfM8XXUkDs0RI8ZTommAo5vylbhvAikjugvT5jvVtswz20
	 ESFQ9tRQ5JBIcLpi/q7pnDCXShKRWA0YPyA8SPCh7L6y6E44loZoAopCYk+DuRXFC0fD9
	 iLPZz/cJ1erK5mlHy/X0DDqnC1VyFc4KPyoMeWypDSEH9f5a8ar0/lBUDzkavledXRjTq
	 qu7NYW2rXET+uxJaSgndL0hl97oLlWTRh4h78v+39Dt+DJxpUJw720wDENri5attwmxcj
	 SenTZWHZJqJe7kmeiAc+R1xTwnHQqXSzQBzH6o/oPtGx4dv6ChrtDkAYza+xTgoDNIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=62u8s5qu5bzO54uwlNJu9ihuOqrMLPcafHjykXA1cks=;
	b=HN9hu76Z1+WliwGy+ZNoeZA5aJyQjPcGnQACVz62DyodKjHwsDi9Pr9Z4zZafyuNqv0h
	 sSgpYX5HYxfogZnBFWVRRgKkffjvuNeZOekHAhQU2r1JYw38T2Gp+z6b+rCAAsz7opf2J
	 qxweRwX2V9CG0q73srYHRVPB6E64jVwghWMQghYxi+YztgRLZoUqJKP1zL5nVUdNW9mW0
	 LLUbgvJhkwBbkd5BZ0tJi0fbldB8eOn1J2VP6SDxc9COEcTO5qkk9Hc+q8N0faPLN+D/b
	 UAZ1Ct0l71uCIS5fg0p6s6z/zFVr+rXjjDxog1FmV/mzNmQgxKv0bbGiX1KeB0NrLEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FIvYbtNZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C684606A330;
	Wed, 18 Nov 2026 15:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FIvYbtNZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506F51F000CB;
	Wed, 18 Nov 2026 15:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016153;
	bh=62u8s5qu5bzO54uwlNJu9ihuOqrMLPcafHjykXA1cks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FIvYbtNZKMOqw6iicX+vJZQNlBAovY6i0HhgwIZoPaVBAYllKMd+3YlOV5qw2A3Py
	 Q+p3HXav3bBfI2NFNEzPOf9mZeLreGUwZobzcGW7FfJTv0UAlzVQt21iiTWnCKBEpR
	 Iel09QY33lW57zSpDPKrUIGrm4oMSKYhlttz6rww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0386/2651] wifi: ath9k: use rcu_dereference_bh() for sta->rates in ath_merge_ratetbl()
Date: Wed, 18 Nov 2026 15:27:06 +0100
Message-ID: <20261118150301.728466314@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

[ Upstream commit 93de43318ecdf0ff5f0e6125fe33a8b30fd10c66 ]

Commit c4f518736472 ("wifi: ath9k: Remove redundant rcu_read_lock/unlock()
in spin_lock") removed the explicit rcu_read_lock()/rcu_read_unlock() pair
from ath_txq_schedule(), relying on spin_lock_bh() to provide an implicit
RCU read-side critical section.

That is correct on kernels without CONFIG_DEBUG_LOCK_ALLOC, where
rcu_read_lock_any_held() falls back to !preemptible() as a proxy, and
spin_lock_bh() disables preemption.

However, rcu_dereference() in ath_merge_ratetbl() checks
rcu_read_lock_held(), which under CONFIG_DEBUG_LOCK_ALLOC only returns
true when lock_is_held(&rcu_lock_map) — set exclusively by an explicit
rcu_read_lock().  A spin_lock_bh() does not set rcu_lock_map, so on a
CONFIG_DEBUG_LOCK_ALLOC + CONFIG_PROVE_RCU kernel, any call path that
reaches ath_merge_ratetbl() with a non-NULL sta will produce a lockdep
splat.

The correct fix is to use rcu_dereference_bh(), whose validity check
calls rcu_read_lock_bh_held(), which returns true whenever BH is disabled
(in_softirq() || irqs_disabled()).  This matches the actual protection
at all callers of ath_set_rates() that pass a non-NULL sta: they all hold
a spin_lock_bh() (either sc->chan_lock or txq->axq_lock).

Fixes: c4f518736472 ("wifi: ath9k: Remove redundant rcu_read_lock/unlock() in spin_lock")
Assisted-by: LLM
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20260813-ath9k-rcu-fix-v1-1-424665a1ce60@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 89d8b31787846..3413bb4906d4d 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -168,7 +168,7 @@ static bool ath_merge_ratetbl(struct ieee80211_sta *sta, struct ath_buf *bf,
 	if (!sta)
 		return false;
 
-	ratetbl = rcu_dereference(sta->rates);
+	ratetbl = rcu_dereference_bh(sta->rates);
 	if (!ratetbl)
 		return false;
 
-- 
2.53.0



