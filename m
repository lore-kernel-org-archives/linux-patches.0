Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831187;
	b=ZBMkBPqn8kbctxtf9r5XnWFNExyDkLmq4BBFLs8sok0snoIZQku4Homu/bNxZ0EfGRxN
	 c+4pVDZaNvXYszl1xnhJsOSS8RB04MJNilgdcSzeYAuih7oyWKPM3hNf88HVMzaKDBmtn
	 whxFEbaZeXBr/2hQFT8oF2RYcPCqDlx2XxHsF21I9pQMyNSLJNgwNhQBw30GZsA/iYuS/
	 ElGT2clSGjD0a/JrzD9XRSvr1gxujMwOxYEz0JoskSNVjv+3IHOV2sTioJ60yK7i355FA
	 dXTNNudxUk63Dc8xIs5VdT5AGBi9Ust/WHA9nZzAVD9hos/MD10P97V5drF8N8twXgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831187;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DV6qOh9OBspQCR8ZxXp8wfvJitAMaJk79XELTJ6Y42U=;
	b=ArCEYAj+n7Yv+8D8BNKgshpB3t9nDCkZp+m5G/Pr9js0j0nrzTAhYkCG3NLUBR26m7Tj
	 XDxEHsGId4yCL4gjvtr2LX+q9quvzMwURv+C/0FIVXDZ0BHMz511XSlFBOE1qgDpEJlvo
	 fyrgyYESF4Al+8iVujSl/8evd/7+q3rdhmFHTC6eYO+xUdWPC+AvcGOZUJLlEQ8rS8TN8
	 Psou0GMkC3pzVjGUTDJercB++kX7Lb+AQi/qSkd+QlWuT7fma4LKkXZBK48FFGbauRK1O
	 sb7l8GvsDDleU0ylrzcbONCtdWN02iopnKmWd+zKnnFMXI4G2OhIbnAEW4QmCPCB9Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ll6YdtyQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F091D606A332;
	Wed,  4 Nov 2026 22:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ll6YdtyQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856C31F000C1;
	Wed,  4 Nov 2026 22:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831186;
	bh=DV6qOh9OBspQCR8ZxXp8wfvJitAMaJk79XELTJ6Y42U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ll6YdtyQSvNTZNJFrg79hzuHamPLOSImDDOAIL7Lgo5nc67MHxqD8SubcnFZw6kKq
	 P+jYwcYR0BwKzvgoNkDEfoOBJL/+WhxFmSxneNsiyWbyRTU4o1yiLMulnp/9EeOHg/
	 INArFdVgPisXpxVdZf6ZE/Z7ebyr2+AWeJjD/upE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Reeves <michael.reeves077@gmail.com>,
	Peng Fan <peng.fan@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0512/1005] regmap: Remove debugfs before cache teardown
Date: Wed,  4 Nov 2026 16:04:05 -0500
Message-ID: <20261104211058.275039024@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Michael Reeves <michael.reeves077@gmail.com>

[ Upstream commit 834035934cef9e60169de682f4dc9feafd49e51a ]

regmap_exit() and regmap_reinit_cache() destroy the register cache before
removing debugfs. A concurrent debugfs cache operation can therefore
access cache state after the backend exit callback starts freeing it.

Remove debugfs before cache teardown, and clear the debugfs pointer after
removal. During cache reinitialization, recreate debugfs only after the
new cache initializes successfully.

Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Link: https://patch.msgid.link/20261006-regcache-lifecycle-submit-v3-1-37bdd82fd47c@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-debugfs.c |  1 +
 drivers/base/regmap/regmap.c         | 15 +++++++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index c9b4c04b1cf60..98debe5020641 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -657,6 +657,7 @@ void regmap_debugfs_exit(struct regmap *map)
 {
 	if (map->debugfs) {
 		debugfs_remove_recursive(map->debugfs);
+		map->debugfs = NULL;
 		mutex_lock(&map->cache_lock);
 		regmap_debugfs_free_dump_cache(map);
 		mutex_unlock(&map->cache_lock);
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index a648218507236..b80bbe9033188 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1424,8 +1424,8 @@ int regmap_reinit_cache(struct regmap *map, const struct regmap_config *config)
 {
 	int ret;
 
-	regcache_exit(map);
 	regmap_debugfs_exit(map);
+	regcache_exit(map);
 
 	map->max_register = config->max_register;
 	map->max_register_is_set = map->max_register ?: config->max_register_is_0;
@@ -1441,12 +1441,16 @@ int regmap_reinit_cache(struct regmap *map, const struct regmap_config *config)
 	if (ret)
 		return ret;
 
-	regmap_debugfs_init(map);
-
 	map->cache_bypass = false;
 	map->cache_only = false;
 
-	return regcache_init(map, config);
+	ret = regcache_init(map, config);
+	if (ret)
+		return ret;
+
+	regmap_debugfs_init(map);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(regmap_reinit_cache);
 
@@ -1460,9 +1464,8 @@ void regmap_exit(struct regmap *map)
 	struct regmap_async *async;
 
 	regmap_detach_dev(map->dev, map);
-	regcache_exit(map);
-
 	regmap_debugfs_exit(map);
+	regcache_exit(map);
 	regmap_range_exit(map);
 	if (map->bus && map->bus->free_context)
 		map->bus->free_context(map->bus_context);
-- 
2.53.0



