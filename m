Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065282;
	b=M+0a5htXODPUthjCnH1MYguR7DdadA/9Tfl4iOOlmtIWCdDgV2GjXvn+ofgXJoPP4CvS
	 ZR7scE2u9jZsN0mFYi9R92y9H1uLvsXXz+kEpP39WmdRDhzZJ5FuHUI0BgVWtuYaIwR3J
	 FPrDQyQYUayWWE8USJ+aVSIVxw1VqTGtKGGcGDjktrGulmQLps2qG6PCYmuLFEZ7zrWFq
	 7njov1+9qlBjUYDs+sSUuXDux7p9nbLtHQYxGtXbt9WpnfccGbERwvOTQhV9djFRAZxSf
	 FwfUZ4ovNEjgQ2BO590fJOucQtjh7xJRhPgxkUikkyzVpwfG5DofFR2IkzLOwda0nZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065282;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=aMadSTcBHVNPsGl3c2k8+vEAvZPUw1sYzm/XvqEbX0Q=;
	b=M5gUoEQPb1fOzDVCnWBlsC8Oi+HmCdcYS3dDtJWvdGOv8ZlAVL+Y/jbR8RHBdqmH/gAQ
	 yS4+dESk0JRH+ffBlktc8OW2bjp/2fV1Hm34lqPBF5cw0faLh3au3lY3kVHVlRwyo+BUr
	 c8vwEoakGvl+ss3e+iKjKO81H/lwMgkyGjeQoFtIb75rvJkyRPLRUKH04CIr0V+cGvfBD
	 pzTAl22+VONgWeFg6SRFnAfxLorJWH2B+knboBa/j6FBKLhIr+vNaUl+ru4XCD8N8lWja
	 Iilq66oZ9TB4VLIluJwdSI6wa9HQsidIe1OaNx3W7MgJ8dxeAMhHgwOKa4x+k2DKu2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rYE3bd39;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D935606D80C;
	Sat,  7 Nov 2026 15:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rYE3bd39
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07A61F008A7;
	Sat,  7 Nov 2026 15:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065282;
	bh=aMadSTcBHVNPsGl3c2k8+vEAvZPUw1sYzm/XvqEbX0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rYE3bd39V5o2kaUBSIGT6jIGNX1JNREMLU4wfdg6pV/67PkMdDvhu3RAJcFLpmMo/
	 QMJCqyLjkhlFPwOMo4W6CvWUnAwwQso13CFaHPdvQSNF+LsuB2up2qATCSCYcXkmQK
	 +QMsZ8ypG8w7Igk4vMmn3Wikc9MgDmzC9B5ElS9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh=20 ?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1043/1257] timekeeping: Update offsets on sequence counter retry in ktime_get_update_offsets_now()
Date: Sat,  7 Nov 2026 08:55:39 -0500
Message-ID: <20261107135008.116607108@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 1b342825bd8f1..cae3e51eaf55c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -2849,6 +2849,7 @@ ktime_t ktime_get_update_offsets_now(u32 *cwsseq, ktime_t *offs_real,
 				     ktime_t *offs_boot, ktime_t *offs_tai)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
+	u32 cwsseq_orig = *cwsseq;
 	unsigned int seq;
 	ktime_t base;
 	u64 nsecs;
@@ -2860,7 +2861,7 @@ ktime_t ktime_get_update_offsets_now(u32 *cwsseq, ktime_t *offs_real,
 		nsecs = timekeeping_get_ns(&tk->tkr_mono);
 		base = ktime_add_ns(base, nsecs);
 
-		if (*cwsseq != tk->clock_was_set_seq) {
+		if (cwsseq_orig != tk->clock_was_set_seq) {
 			*cwsseq = tk->clock_was_set_seq;
 			*offs_real = tk->offs_real;
 			*offs_boot = tk->offs_boot;
-- 
2.53.0



