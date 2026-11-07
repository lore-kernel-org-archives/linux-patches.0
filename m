Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064836;
	b=HAH/VaE1OMRa0iciV+tX7IW29+yuIxOmT5xyqH7kxwgH/p+VxShlv5/xwD38wwIORfNF
	 QwzcZfvTNC+QGsweNOGMGKX2Src5J4W79pnhbsv1w5qgj4KEmFH51xQ5GGsLmy2UmYZ/c
	 Uq1BhxduQ5ePF/Z+JBaVL/RzcnHx2ZeE+J0AxeG1XfHhGo2Jm38z9iK+23tTpNhGfTOmw
	 /eJXPubwZHRilYTvjISn9DFliabHHaMOuUZKGk1TZilb4aBUhnMhPM4+xjfBeFOaGN8Zp
	 kfKCMNgiPOvbcbYvxhIK9Ov/GOMEfo8Sdok4GD0dM5SDeLrIc1mahKbNwieJiE105rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064836;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yRBO2BtfucflKUUOVtMp/Ija/xX2SkA7tygjS34Z1lU=;
	b=I0WsRu8/PewsNmaSbHXz1rHLJ3snpNYPmL8okzv8NIOe8Y8Wy4BCkFAP+o3BRGtWdNiR
	 v2ZpM3DcdycpS2bar3nmaQ2y25ZXf3ADG6GY+Q59HptKy51mlbuV8RkpSfNGsJ/3+b1+e
	 UoxTkPyhISiGC2R1ocxTuVXOCFY7Nb+NNwN12UvOnNI9ddFDRX/zEtEMS8vd5v8tJYmkA
	 RK4/GWV02/Q1HaEreH6EJ78FwEdwHVm63SognoHhTDVBUe91NiRtHU9zB7AG1/A7qQexJ
	 CKe5UUJsVge2NgMs0Nm74wKGw2HrmYu3M/aP5JWeCpDAEIFBeMVfBAmICFZj/mOHIMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ib403NLL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A68606A32C;
	Sat,  7 Nov 2026 15:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ib403NLL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27391F008A4;
	Sat,  7 Nov 2026 15:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064835;
	bh=yRBO2BtfucflKUUOVtMp/Ija/xX2SkA7tygjS34Z1lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ib403NLLB1V2prhYl+tUQqoEueM3bSmhOgeAJcbxODPDxK64Q3A9By9IIebpmYQuk
	 IDC3rlZELqILgB6NmudTvdKSG6CxFG8QvA8rnlvcJ36jmfJiUZJHXxevpmZ5w4aTwb
	 rubK9bai3NwpA6rR4E3AIwotHBOz4ZptchuCpFKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0766/1257] ARM: 9520/1: cacheinfo: avoid out-of-bounds write in populate_cache_leaves()
Date: Sat,  7 Nov 2026 08:51:02 -0500
Message-ID: <20261107135000.449860626@linuxfoundation.org>
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



