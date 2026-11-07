Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062537;
	b=oqfTY3XgAtZzQexQ8F5lSJsyNWH5fdKXYEOFqnlYsmCFL6JDDAglqsPV6yvOe4C/iQYA
	 sMuNXgF8atQB34KBsjtThlnX5lqTjGV9nWKfZU2CKlMpJdbGLU/azZaCsDywRdVE6Izr/
	 AC/qY8cVQc9oo7HU6g2Vpuz51Mr34wgnIitDKDkuUDvBl2E5b4bbvqtNAk2A52GczVbvN
	 q7ma27gq9sD4vLXFO++K9LwkUPMBtpNDwBej8M9RDGF+PVaYhhl9uYC3VmY9ovlhNbK1l
	 OlHB+wfGYJ+T/JvNgqRha7cSzXxfhkfg7uUrEgN+CmvfXa+e6i8JL0RWE/hJu71cfxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062537;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=N/XVI2LOZHUdpKMvCUjvGL+7MhGjY7wTEOqOejel29w=;
	b=Dpb5ICadMUGE06HtUthx/AXtPNaoGa1jIozCft5hCiejoUtvIXgWxvbkbpoYh9i2pss+
	 3cfbYaZNau3vsmMuXhRVLoCKG5h1EnF3o83mubTs2oN3VPJE4Z1TtuE08BEWt9VO4Z7R5
	 iOi36tOjXNyst3e/YuLVNri6Y7Tn/zexfy7qRNKBvBdjyk2nqmIsjzR4kExAWjSRLdstv
	 Va3LtJgGGVNZGe1efuSA7mC93KvqqpNGezeK2+LKkmjnVk+GbmJfqzf6JDpGcTjIG33kS
	 x2wLOwjY3HrKdH61pqKegbVzGcd7AmjC2SDElA3/JcEusc14ainYk5iHxfyYv3Csmxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Yb5k/ujd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97B4606EE96;
	Sat,  7 Nov 2026 14:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yb5k/ujd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366D51F008A1;
	Sat,  7 Nov 2026 14:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062536;
	bh=N/XVI2LOZHUdpKMvCUjvGL+7MhGjY7wTEOqOejel29w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yb5k/ujdlzP/S4S2LrrJWJsb2KK9nlT/0Z4mlPW4fhCIjA3rKh3kl948SQmS6HMik
	 sVLnffsEkgdey4nLajck/SVKUDkajqqBcroetsWunk5DhfFqW+uQc5a/EbCQG0HLJg
	 yV/qYLc5guFN8Q1zr4bmSpGe1XKysltTqioJ0jvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh=20 ?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1427/1536] timekeeping: Update offsets on sequence counter retry in ktime_get_update_offsets_now()
Date: Sat,  7 Nov 2026 08:57:23 -0500
Message-ID: <20261107135037.913015338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 626fbb2a1a8cf..cac3a0df3a780 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -2359,6 +2359,7 @@ ktime_t ktime_get_update_offsets_now(unsigned int *cwsseq, ktime_t *offs_real,
 				     ktime_t *offs_boot, ktime_t *offs_tai)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
+	u32 cwsseq_orig = *cwsseq;
 	unsigned int seq;
 	ktime_t base;
 	u64 nsecs;
@@ -2370,7 +2371,7 @@ ktime_t ktime_get_update_offsets_now(unsigned int *cwsseq, ktime_t *offs_real,
 		nsecs = timekeeping_get_ns(&tk->tkr_mono);
 		base = ktime_add_ns(base, nsecs);
 
-		if (*cwsseq != tk->clock_was_set_seq) {
+		if (cwsseq_orig != tk->clock_was_set_seq) {
 			*cwsseq = tk->clock_was_set_seq;
 			*offs_real = tk->offs_real;
 			*offs_boot = tk->offs_boot;
-- 
2.53.0



