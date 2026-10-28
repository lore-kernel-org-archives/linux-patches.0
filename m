Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212601;
	b=nl2mulI0gKfFz9DLCtfmwWb3FMStsJlwN9WEMX2J4YsIGPDkEqwp0zsj+vwWR3Ale2fJ
	 tL9wwmN/ODj9XNzKxHuTfhtRbPIV9K/mtHXqR6AJJ2WSmQJr6A1hZuQxHa7DbwXiqDxrR
	 uxOHRtzeO4gKa4uIdOr6m8JkwO1dNAdT83sin0jZVx32g/2ze/g5RAA/C26MSiGslfUGT
	 8+Uk9PHnOwup1NdKfOTnEkTcIwx8d7Q2EKTMcHEdnVDSiNro9iMpS3Zg8c3k6ENmsdF9Y
	 9Pd+twqneW8ODQptch1HLOenloSaYvAlHfOAG9WSvpmflDxVlY4mM1X86uQKkl4Br3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212601;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H32rgRewYsRZrYRCsumgVZKwdDZw7E+UbPYP7xs1Cvk=;
	b=nLgCrqUJMvbWVkO2hSG+AgbRRNbDmNB8WiZvbxT6IZ56xIXGBhHSFu50V844x174QBFN
	 V4fjWm9G0rJcKP6SYc4QBkv00jMOwwj+lEnf//o1HN74vF7Fs3rLXlvpdhWF/BNOdGKYm
	 RhLmMVvtkqn+CrTw2UO5USK3scu8NAHSUZulBQMybhyqa+P0yfZrxqp//zZ5Yqk/QdkgZ
	 t8Sfkn1NCsjYMM7Tm1OX2TSvrykZoDe/wRFV8ttjvUn394KydqnvzSoCuSzrbxlaO/YmN
	 8Y2cBmWD27uDJm9EFU+S/3s0GkPSFUjiL/HWIdPsvYbTQQYYA9N3UyVv8EzhtP8b3fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0TAUewT6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5A5606A31C;
	Wed, 28 Oct 2026 18:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0TAUewT6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4789C1F01825;
	Wed, 28 Oct 2026 18:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212600;
	bh=H32rgRewYsRZrYRCsumgVZKwdDZw7E+UbPYP7xs1Cvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0TAUewT6Qm2B8UONH5oSaKTCLnJPt9KSm2QcsgwQKhOShGzGvRfRaACYoTWH/PT/L
	 8hoWVx37LtAT9C3fTFbjowftAwP6FmbBBtgCeVx8xrfF3JrmFQKaIu3nsp112rGP4Q
	 MHeFwJZyOzlk02+1uW88u2m+L9EyQB/dWSgNn+90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0212/1887] mm/damon/core: dont skip damos_adjust_quota() while esz is not zero
Date: Wed, 28 Oct 2026 17:38:28 +0100
Message-ID: <20261028170504.057174629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

[ Upstream commit 52ae167ce16609c7e6fffef588b3c2c26de2db19 ]

DAMOS could unexpectedly stop working when a user disables quota using the
online parameters commit feature.  Fix it by correcting a wrong quota
unset check in damos_adjust_quota().

DAMON users could disable all quotas by unsetting time and size quotas,
and removing all quota goals.  The intention of disabling quotas would be
making DAMOS run at full speed.  When such quota disabled setup is
detected, damos_adjust_quota() skips all its work.  The skipped works
include effective size quota (damos_quota->esz) updates and charged quota
amount (damos_quota->charged_sz) resets.  The intention is to avoid doing
unnecessary work when quotas are disabled.

However, users could do the setup while effective size quota is non-zero,
by doing the disabling with the online DAMON parameters commit feature.
In this case, because the effective size quota exists, DAMOS will keep
working with the quota until it is fully charged.  After the effective
quota is fully charged, the charged quota amount (damos_quota->charged_sz)
cannot be reset because damos_adjust_quota() skips it.  Then, DAMOS stops
working until the quota is newly set or DAMON is entirely restarted.

The problem happens because damos_adjust_quota() assumes the user setup
for disabling quota immediately disabled it.  In reality, the quota is
still working until the effective size quota is also updated to zero.
Other logic for catching that uses damos_quota_is_set(), which understands
the fact and therefore checks the effective size quota in addition to the
user setup.  Fix the issue by using damos_quota_is_set() in
damos_adjust_quota() to determine if its works should be skipped.

The user impact is a non-deterministic and unexpected DAMOS stop behavior.
That is, users would disable quotas using the online parameters commit
feature, expecting DAMOS will run at full speed.  However, depending on
the timing, the setup can be updated while the effective size quota is
non-zero.  Due to the above mentioned internal mechanism, DAMOS stops
working instead of running at full speed.  It is unexpected behavior.  It
is also non-deterministic because sometimes the setup is done when the
effective size quota is zero, depending on the timing.  It doesn't cause
critical issues like crashes or leaks.  Users can simply set a reasonable
quota again, or restart DAMON.  But definitely it is an unexpected and
non-deterministic behavior that makes it difficult to reliably use.  Also
investigating the root cause of the behavior would be quite difficult.

Link: https://lore.kernel.org/20260916135020.86483-1-sj@kernel.org
Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7afbc20833ea4..568f24da26e6e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -869,7 +869,7 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 		if (!s->wmarks.activated)
 			continue;
 
-		if (!quota->ms && !quota->sz)
+		if (!quota->esz && !quota->ms && !quota->sz)
 			continue;
 
 		/* New charge window starts */
-- 
2.53.0



