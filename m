Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064842;
	b=jgn+RBK54Jjq5LuNrD1ahtqGpShvEo/7ssTMcG4m/Gv8AUtzBcT0Q0VcC0jsDCNuODCg
	 aEk5buVrwwxgOzIm6Yk1Zvn7Rgss2/0iCBgoRkxqLkRctNg4HogfJ8yuITVqrxufBTz6E
	 Z+nun3W6am8zRUDG0++cTpYk4cx0hKcFVxW9nZXTqKGGOyM1VuR3Uc9stuyR517LXeA7U
	 dRHwEgd8Y4tPjA5U7gloAQD26zFTXMsRGbcQ7v2qGHfLHcRtcA4Kcbk6CTe/uG7g0x9Xs
	 IkUcAKGhqeDYt+nVEYA1ZTWoov1MzlOfhdxRa0cfo7eN5qEn07DfwcOcC0QecBw2NpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WLSjhZLrLGlMkoU+CnhgzpeXeNoodnTgoXuQjjmAG9I=;
	b=WX1ZA79QjdLkKpYGTM5zNjE2P/DWk8fwOlBLr2F0tJzB2OGfyhr1vVAtfeckd/dTIFnG
	 5hx6eRvn+G/HTKrFLwgnjCWYxESObaoSQh7R1HTixF+VLMS3CozaBBDLkaYtfladiKMqm
	 nLPGCKSl5UvVNKDwDN0C4BVxVfJTewibGaj5glAPYH21/lbLi5QflQuAtLEJRO2V3+Y4q
	 mREuMA+Gu+PUSQCgKH078NOyp6ReJ1wJ2ZwsEi2HYc4fQ+LvjshhiRHHl2WklDpLiWQM+
	 kQiRfOBlVKUGgp6S9cOcvDqSD9JPlLB7mQqiBH7UfH2ZbNiAFSs8MYqa1tXT7yGkrXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1zWkkn0k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A5A606A337;
	Sat,  7 Nov 2026 15:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1zWkkn0k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD1A1F0089F;
	Sat,  7 Nov 2026 15:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064841;
	bh=WLSjhZLrLGlMkoU+CnhgzpeXeNoodnTgoXuQjjmAG9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1zWkkn0kf9yajQgCQE78rtHpFRbIMZz2JzNdP7rt/lOUiFFRET8Vm6J+8lXqR2Tv6
	 ldN+0XqeGZ+HfXhic1QIvwd+uf7WW0xME+549rbMCdqcqY/K8DkiS2lxtr3d45ka9F
	 B/fVUHBZ/42E+5OCwiQTCCZQp2ZkNBofyDYmFhW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0768/1257] ARM: 9522/1: cacheinfo: guard the CLIDR read in populate_cache_leaves()
Date: Sat,  7 Nov 2026 08:51:04 -0500
Message-ID: <20261107135000.505812547@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 2315f2c46e0813d010e7b3ea40f2769621453e27 ]

ARM1176 and ARM11 MPCore can be reported as ARMv7 by
cpu_architecture() even though they lack CLIDR. populate_cache_leaves()
therefore needs the CTR-format check used by detect_cache_level().

DT-based early allocation bypasses init_cache_level(), so its check
no longer protects populate_cache_leaves(). A combined ARMv6/ARMv7
SMP kernel can reach this path on BCM2835, whose DT describes its
caches.

Share the CLIDR capability check between detection and population.
Return -ENOENT from population when CLIDR is unavailable, preserving
the existing absence of cacheinfo and avoiding a new topology warning.

Assisted-by: LLM

Cc: stable@vger.kernel.org
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/r/20260912195552.76673-4-kmehltretter@gmail.com/
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/cacheinfo.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/arm/kernel/cacheinfo.c b/arch/arm/kernel/cacheinfo.c
index 31591c9472548..993c8a1347860 100644
--- a/arch/arm/kernel/cacheinfo.c
+++ b/arch/arm/kernel/cacheinfo.c
@@ -80,19 +80,21 @@ static void ci_leaf_init(struct cacheinfo *this_leaf,
 	this_leaf->type = type;
 }
 
-static int detect_cache_level(unsigned int *level_p, unsigned int *leaves_p)
+static bool clidr_present(void)
 {
-	unsigned int ctype, level, leaves;
-	u32 ctr, format;
-
 	/* CLIDR is not present before ARMv7/v7m */
 	if (cpu_architecture() < CPU_ARCH_ARMv7)
-		return -EOPNOTSUPP;
+		return false;
 
 	/* Don't try reading CLIDR if CTR declares old format */
-	ctr = read_cpuid_cachetype();
-	format = FIELD_GET(CTR_FORMAT_MASK, ctr);
-	if (format != CTR_FORMAT_ARMV7)
+	return FIELD_GET(CTR_FORMAT_MASK, read_cpuid_cachetype()) == CTR_FORMAT_ARMV7;
+}
+
+static int detect_cache_level(unsigned int *level_p, unsigned int *leaves_p)
+{
+	unsigned int ctype, level, leaves;
+
+	if (!clidr_present())
 		return -EOPNOTSUPP;
 
 	for (level = 1, leaves = 0; level <= MAX_CACHE_LEVEL; level++) {
@@ -150,11 +152,10 @@ int populate_cache_leaves(unsigned int cpu)
 	enum cache_type type;
 	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
 	struct cacheinfo *infos = this_cpu_ci->info_list;
-	unsigned int arch = cpu_architecture();
 
-	/* CLIDR is not present before ARMv7/v7m */
-	if (arch < CPU_ARCH_ARMv7)
-		return -EOPNOTSUPP;
+	/* The device tree can describe caches CLIDR cannot fill in. */
+	if (!clidr_present())
+		return -ENOENT;
 
 	for (idx = 0, level = 1; level <= this_cpu_ci->num_levels &&
 	     idx < this_cpu_ci->num_leaves; level++) {
-- 
2.53.0



