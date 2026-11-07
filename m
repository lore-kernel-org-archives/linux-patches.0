Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063393;
	b=mVCb2IHpBBmHmw3d4WY3CuznmSRTv0UXs50bGXMv3yVN5luBDSvfImDokUdfWf7rhIhy
	 u9zIKmgR7cXJCKhoveaFIa+ltNDMq/bpvQbgvk+wSGcKxK+qqRcaghD7aj3CZLbTGTY7Q
	 mdRD4+Nr85Vm+dLNpj1RDR8DacTryxOjhkh6iU5yLatrSi77nz1TCPgtt/YjrIjl5LkPn
	 y5Ax+8juL61qw1kHgD9QVfWPBaIyp1ZXWUgL2JFxxFD1qRH8yKZa9tSfO8H3kuNx9Pyl8
	 sM3/T6h/a2Hx0D/ZTejKw2uvkbbRasknoKpp0wxdADCdAvG3K3CH3LKhhfzM9l8jHpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063393;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pxq7ZubBvZRvonRtAMko4FQw27ec4G0hqxc6sMbdpd4=;
	b=iQzqwgqAXcKBWN2COGV2rc7btv6DTjZlDBUjnyWm1sy4bSmtWkzoReJ96jMw/T1/r1r6
	 wch0aDJ2n1WwDO0OM1QWRAKISElcoCOovopEccBRjZAiAOBGd5EX8JD7sm4J0/+zWOr73
	 8Pqtqr7DO0zIM/iRYabp3JTUw9N5t/NCwZqSK3FIc2cO4V2Oi74Vqz0zrISmZaISFrBq+
	 Kvh7u1jxGGtH/QUx40vLkb/HF46mg64a8HEgpDZmRBpa5Sii3zYJQ2SDzBCS8X1ytjRjE
	 pfkmc0bCYAJlJd45T6BK9MnZQV6ljfr+MGVdtqc/y0BxFaCfT4Aflmha1axoJQn0Kag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hAFxRQs1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB1F606A333;
	Sat,  7 Nov 2026 14:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hAFxRQs1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B213E1F0089F;
	Sat,  7 Nov 2026 14:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063392;
	bh=pxq7ZubBvZRvonRtAMko4FQw27ec4G0hqxc6sMbdpd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hAFxRQs1GDXT1JlUbMvwsq1qACa8vD/QMnU1UhgEtzWVwueCAoprfDLuNKrrIWWJo
	 1oUz/fwBOEqeUTitIqlJ+SvhBJor171PhuWouj5MfopbfqhIi4/RcLRJm6Hn27Lvz1
	 5kNYma3MkKopXwU4F7WF0w6oN4KnOsyvSBOVGQoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 558/869] ARM: 9520/1: cacheinfo: avoid out-of-bounds write in populate_cache_leaves()
Date: Sat,  7 Nov 2026 08:54:00 -0500
Message-ID: <20261107134912.244418019@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 41a3f4bc3e4ae4722fd24743bf3f286cea14e3dc ]

populate_cache_leaves() advances its bounds-checking index once per
cache level, but split instruction/data caches consume two entries.
CLIDR-based allocation supplies enough entries. Early allocation from
the device tree can supply fewer and expose an out-of-bounds write.

Count each written leaf and stop before a split level that does not
fit. This prepares ARM for DT-based early allocation and matches
commit 875d742cf532 ("arm64: cacheinfo: Avoid out-of-bounds write to
cacheinfo array").

Assisted-by: LLM

Fixes: a9ff94477836 ("ARM: 9433/2: implement cacheinfo support")
Cc: stable@vger.kernel.org
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/r/20260912195552.76673-2-kmehltretter@gmail.com/
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/cacheinfo.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/cacheinfo.c b/arch/arm/kernel/cacheinfo.c
index e1469b6417804..860eeb03cfe5d 100644
--- a/arch/arm/kernel/cacheinfo.c
+++ b/arch/arm/kernel/cacheinfo.c
@@ -151,7 +151,7 @@ int populate_cache_leaves(unsigned int cpu)
 	unsigned int level, idx;
 	enum cache_type type;
 	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
-	struct cacheinfo *this_leaf = this_cpu_ci->info_list;
+	struct cacheinfo *infos = this_cpu_ci->info_list;
 	unsigned int arch = cpu_architecture();
 
 	/* CLIDR is not present before ARMv7/v7m */
@@ -159,13 +159,15 @@ int populate_cache_leaves(unsigned int cpu)
 		return -EOPNOTSUPP;
 
 	for (idx = 0, level = 1; level <= this_cpu_ci->num_levels &&
-	     idx < this_cpu_ci->num_leaves; idx++, level++) {
+	     idx < this_cpu_ci->num_leaves; level++) {
 		type = get_cache_type(level);
 		if (type == CACHE_TYPE_SEPARATE) {
-			ci_leaf_init(this_leaf++, CACHE_TYPE_DATA, level);
-			ci_leaf_init(this_leaf++, CACHE_TYPE_INST, level);
+			if (idx + 1 >= this_cpu_ci->num_leaves)
+				break;
+			ci_leaf_init(&infos[idx++], CACHE_TYPE_DATA, level);
+			ci_leaf_init(&infos[idx++], CACHE_TYPE_INST, level);
 		} else {
-			ci_leaf_init(this_leaf++, type, level);
+			ci_leaf_init(&infos[idx++], type, level);
 		}
 	}
 
-- 
2.53.0



