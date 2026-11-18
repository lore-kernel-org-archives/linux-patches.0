Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036857;
	b=h90dvdDN3LDyEXVmqa14Eu+QxxdsddqGUVuY3XUsixjzW2Z7+GhVE84muN828xjXqkyw
	 ExfivjMH+M071FHrhwtTuMvD9stYH13NDZwIDcYvUUvW5m8kDlu07qxuLbhs+UXO48iqV
	 4MxhRWxCxVG/1oLJAQrJEbhiqZGUqegkcXJcA31pXQhquhS0FP2PJkkOtvJ33sd1tgGtG
	 pz0Iw8p8wY9tzzVjFGf+9RSv5gF8pX5qHG2MCarkDqJ34H2qhW3BBLT4ZCr2Wa/Hvhm1N
	 sxaNesSP5U15BfFg8G1WedQSUUfQoMC8T/EHJxMsNjMSJYGJawt44MU+u/wq2inqttg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=XknZYDJGbY2rput88kP0z45SDxeC8qx3Dp3N3fkIe/g=;
	b=gibfmOIqNxI+jCrmWgbX4tIOHlmznZPMxj6XSoiRD/ezyPCha2SmQNZOoJjO8PhElPs7
	 bmV1Sv+SY8izBESL6epjl6oX2ZTZO4JoFF+U+/hj5UjWxECcEOc0evbf4unMfR9G2Fsfh
	 MKSxCO4IdWBMNNYHG0XysFSAAZ9XAd2iy1QAK09Nyrl287ZqGn1N6oId3FgvxVA6Xm2xc
	 lG6enxLF1sVq1puH7TdGmOyPHLZhARmzW47FlD2zVMW2keDU4/cVVn/45WmAIPdcgCQfx
	 6FcZZJJHzrUSZEujM6KG+AzZLyvFUSYr0Cuu8xyvfQh8L/mfKvVtfFK2woXLwTRJbWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X+eDzLfj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20A5606A325;
	Wed, 18 Nov 2026 21:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X+eDzLfj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41B61F000C5;
	Wed, 18 Nov 2026 21:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036857;
	bh=XknZYDJGbY2rput88kP0z45SDxeC8qx3Dp3N3fkIe/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X+eDzLfjsjfCNWPJWGRXe2KBjpa1ABPoEZXgN3EUcnGzGhRH2dVVxwE72dVayHpGM
	 IScyIGQNGUE+E8o887ng41xRkBmfEFyS91AAtt4TL04UtTUSkXONQ67fGmE/mA5VkK
	 NLfsmB054+mG9m2TBkTbsm0G3GoRED1gOZq9PHT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh=20 ?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1209/3318] timekeeping: Update offsets on sequence counter retry in ktime_get_update_offsets_now()
Date: Wed, 18 Nov 2026 15:30:31 +0100
Message-ID: <20261118150356.441178889@linuxfoundation.org>
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
index 344b158bcbd7e..ca9dc1f6efea9 100644
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



