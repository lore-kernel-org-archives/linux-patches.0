Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058670;
	b=4FFJrzfWNThxr8CtqVR4o8Zw7sLZ9YEzOqDVuDBIrQstB3EOhsIhZs7a9XSM98x9Mlok
	 QAMEa7D4GiF7krSE33JcM+nO7xWYApPmkjLIhBUyMTThGFQTxDxF33rQC+BSOF6oeKPYP
	 JFkivW01rjU6Vlsr2cApFFNeCTd2O4ybFyzm043NzrDEvAKnws9gxGnaSjR3ZEouugwco
	 BuYJq54idHJNZLoPE0uBUdQ2UcgPDeStAhfjblXXxRDAMLw4vVdfHLEfneMfLQLgw2Uf+
	 0/6KlieJKXa5P5TWd1fy2vgZIDbtFmD3xEZndyp5QstmcwlhppNRTyJDl4JT/MFfwSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058670;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NkH58yZ8TFQ2OlgPgasPovZQBVnwmngtAnJynge4fgk=;
	b=dxN/6C9wIhvh0dmxI1ZbJtH6+KDYGp69g5Cl6dBcI9fBENWjnLvCcKdIs0aYc0r5dX57
	 X9r4eFAjdZoiLz2GzTOMCuZ1XNQ21NpdChCpZ0GGZ3ZgCi3vqn9NrFR/P7GiQCWzsDJXx
	 sgYehCkL5AdD/aqaW6A+MRxQ46hOu76osdoctZWeoSe7+QZlgQz2vVyZHZcUJyxjCIdVb
	 xRKPoPVup+OqNGwbIn/hcUpklvAAEPnK3C6XRN6MPI2/tVXd3BIlhkWk+6k5cSbvWS75A
	 v76dfT8qTVxAazybfMdIQ8cRVEyfOuQpi5ICmVjQ0v/qyZtTbx5qsKcvl/O+gArTmmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eN8BwQrD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D78606A31C;
	Thu, 19 Nov 2026 03:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eN8BwQrD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE52E1F000C5;
	Thu, 19 Nov 2026 03:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058670;
	bh=NkH58yZ8TFQ2OlgPgasPovZQBVnwmngtAnJynge4fgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eN8BwQrDtIZC8o5CnrnPj/x4h3W5Q0AYq5Xn1eV5ALoX7qq80x2ZxAqjGr5xfBXKy
	 UB1lTgD/F5hdHev1MhP5hwRxEAQj40yEL7dst8ADA3+LU7h4ycB0b67HfBvAIVb+Ri
	 3CPJ90NNII0fkQ8/PG1wGFZTlyyVi7TltL1tkTjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh=20 ?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0567/1848] timekeeping: Update offsets on sequence counter retry in ktime_get_update_offsets_now()
Date: Wed, 18 Nov 2026 15:43:25 +0100
Message-ID: <20261118145938.755633856@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d45718d327c89..98b7f7aced090 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -2296,6 +2296,7 @@ ktime_t ktime_get_update_offsets_now(unsigned int *cwsseq, ktime_t *offs_real,
 				     ktime_t *offs_boot, ktime_t *offs_tai)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
+	u32 cwsseq_orig = *cwsseq;
 	unsigned int seq;
 	ktime_t base;
 	u64 nsecs;
@@ -2307,7 +2308,7 @@ ktime_t ktime_get_update_offsets_now(unsigned int *cwsseq, ktime_t *offs_real,
 		nsecs = timekeeping_get_ns(&tk->tkr_mono);
 		base = ktime_add_ns(base, nsecs);
 
-		if (*cwsseq != tk->clock_was_set_seq) {
+		if (cwsseq_orig != tk->clock_was_set_seq) {
 			*cwsseq = tk->clock_was_set_seq;
 			*offs_real = tk->offs_real;
 			*offs_boot = tk->offs_boot;
-- 
2.53.0



