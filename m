Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045846;
	b=gntMh4yn2jHiQHznw47+CdWzdZuGVwCoMFgyW1c38MF/pgh9RkOpaG5OzasNe8L00Jlp
	 8MxBBx9gRf95p+1eXWRIkX0PL1zF15q4sKyq8DvW46OaJs38IB/cN2HWJgRdIICB0nert
	 iplWpYxhyO5MbXq/iSKWAJKeW6Q2/dF91teUtmHBiQ4DsOGP1uumXxSWP/g6qpKSsLu2L
	 iSImXZzYNceIwEvircL013Y0MZutAH6jffKaUTIPVhKdiHjkryBT935U1JypTYkxX9F+m
	 oeaquRIyL6ckP1B51dCqyio59XshFMu0h10VTUN/lerEBp1839jZbgY0yJspMLmPB5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=bPqkKQzEtz9RpXx9zGt4NKEGERRCE2igqYYB4TmrY1A=;
	b=AgXVQYiq2yVygRXX3d3bo9BilovjuRbPCzTMiYAfSZqP95UfzrUydKEwhXMvc/EzmwVf
	 rA8DuyEvtSSskI1KmdIGYlNhAZ9fr4jP4vKmY26q46h/Y2PZAd3xbpogVFGPTdpZvN09G
	 JRqfOlNPCz/ezgCiBhy33bxhwWBwxz+F86f2UBN8ap8Sjb/4NEgLOiKTOp8o89MxUGoz6
	 tB7rNoEWGpu6MrtSNRRx1dscvQZlY4gZKJ5u7KTRmo7azTyU9LtnHBT5Gac/i993KarG8
	 cnX7m1b0ehhCzcowyPIF/c10LLsgxdKiOogy39DTspYlwpZNsI+s/gp1pjmXhJfwjNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RDC9fg9H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF335606A31C;
	Wed, 18 Nov 2026 23:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RDC9fg9H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCC71F000C5;
	Wed, 18 Nov 2026 23:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045845;
	bh=bPqkKQzEtz9RpXx9zGt4NKEGERRCE2igqYYB4TmrY1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RDC9fg9Hs4qUGdhQ2lMd151V6rgKzr0hbZcfX2UD0b0jenNDZK0WZxm1Fm0R4jBPf
	 zPaqgbJhEOVwxSNRK9nZuqceyqZ/7y+RGNVP91A2Takooe+JilRZYl8XL3066c1Nvd
	 j1jP07Iqyp2YQr2CKF6C6M0/xZgwXmmsI6c/NUL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh=20 ?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1032/2857] timekeeping: Update offsets on sequence counter retry in ktime_get_update_offsets_now()
Date: Wed, 18 Nov 2026 15:34:26 +0100
Message-ID: <20261118150238.754312139@linuxfoundation.org>
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

From: Thomas Weißschuh (Schneider Electric) <thomas.weissschuh@linutronix.de>

[ Upstream commit 6541fbc942f3b63bb8bd44e34eee6223e0abe719 ]

The sequence counter of the cwsseq target is modified during the
sequence counter loop. If the loop retries, cwsseq will now match
but the offsets contain the values from the previous loop iteration.
These are not guaranteed to be consistent in themselves or with the
current loops "now.

Save the target's original sequence counter value so that the update
also happens on loop retries.

Fixes: 868a3e915f7f ("hrtimer: Make offset update smarter")
Signed-off-by: Thomas Weißschuh (Schneider Electric) <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261023-timekeeping-clock_was_set_seq-v1-1-61c4c53d031c@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timekeeping.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 135c8727bb851..1481ada8baab6 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -2315,6 +2315,7 @@ ktime_t ktime_get_update_offsets_now(unsigned int *cwsseq, ktime_t *offs_real,
 				     ktime_t *offs_boot, ktime_t *offs_tai)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
+	u32 cwsseq_orig = *cwsseq;
 	unsigned int seq;
 	ktime_t base;
 	u64 nsecs;
@@ -2326,7 +2327,7 @@ ktime_t ktime_get_update_offsets_now(unsigned int *cwsseq, ktime_t *offs_real,
 		nsecs = timekeeping_get_ns(&tk->tkr_mono);
 		base = ktime_add_ns(base, nsecs);
 
-		if (*cwsseq != tk->clock_was_set_seq) {
+		if (cwsseq_orig != tk->clock_was_set_seq) {
 			*cwsseq = tk->clock_was_set_seq;
 			*offs_real = tk->offs_real;
 			*offs_boot = tk->offs_boot;
-- 
2.53.0



