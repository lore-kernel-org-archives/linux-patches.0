Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061110;
	b=ouYm+tRXFfxFdsNcPlwkGjP8KuiVdPdr3d4bUREsxeqkS0AnV7lMixFp1q086iDL+C4n
	 cfozh6u2o//CkIXRpzAnyzbsl+wV6XDxQPbeXB0/xve3YH2FLl+DxR2Fn7ibBGXYr5gOg
	 S71M1pmUeHrgA3G+5NjW6HvEw8MxatJhLOjKP67/zWQrO3aD0cYCJqzcuYAMtmKEoTTxy
	 3wIZqGFuDfIwbnFDoLvwEJ5fen5KC50qB5O/XspmhIUHjUNxc74ohhn4T1z0d/aJh0rt3
	 BtKjjFxBBWawApPMpvJTprf+IdCQNlGeIW68QX4F1bxckzCFTWU+8bGKPpjhezFkK9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nsh9AfXAwl5J72fJpIcirhQvUiGX+TV6gpya+L/Bk4k=;
	b=HZnOKmCce0h4+yqaKNzp9cQdp5umcq/cRKBCqbQudchiuiJbyM5oh3Pw5RHBHOjCa5cG
	 /+iq2xGxiz7PUyomjCuqvcQsSfXCv+UGkcHthCl/quFeNp5ZVNgHy7W0mtMCpak9lNk1R
	 owfj2rwAro6tB9d8j+Ni0k5L6YRIH1Lp+nhKky8syGUFGB5556ObcHvauMdLX6eKgLX+S
	 HmSz0NfGt7STejLH5sE7WfeqP9BIJhfDotASh9xD60t8i/DkA1Sl7xG6a0Y8Y1kNlrUr0
	 nWS5/4gPsGVETZWntETxzsJr+BOo5nEQtaHbtH1GJLIUw+YL9ZywmpRmQc9f+duU8Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WkrFMReg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6141606A332;
	Sat,  7 Nov 2026 14:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WkrFMReg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537A01F0089F;
	Sat,  7 Nov 2026 14:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061109;
	bh=Nsh9AfXAwl5J72fJpIcirhQvUiGX+TV6gpya+L/Bk4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WkrFMRegTIuJ9aUH97sVJmJY0lDXpmFnNVLLmFMYrYiSPAMGy2lrq01JhclH9GjL6
	 9MqJEdkqCWGj7DC2yUaQyZU40oViMjCUkVse+Oq+dt2rJxcQ404D7rrfQIqmWzhD7u
	 XvLOrQ9+p5Br7HAMfBPW1MXB1R2KovPXhHb7pp5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Reeves <michael.reeves077@gmail.com>,
	Peng Fan <peng.fan@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0427/1536] regmap: Remove debugfs before cache teardown
Date: Sat,  7 Nov 2026 08:40:43 -0500
Message-ID: <20261107135009.560189257@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fb84cda92a753..d65f6dd8c1215 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -667,6 +667,7 @@ void regmap_debugfs_exit(struct regmap *map)
 {
 	if (map->debugfs) {
 		debugfs_remove_recursive(map->debugfs);
+		map->debugfs = NULL;
 		mutex_lock(&map->cache_lock);
 		regmap_debugfs_free_dump_cache(map);
 		mutex_unlock(&map->cache_lock);
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 3b2e27af91fe6..75460428f6300 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1425,8 +1425,8 @@ int regmap_reinit_cache(struct regmap *map, const struct regmap_config *config)
 {
 	int ret;
 
-	regcache_exit(map);
 	regmap_debugfs_exit(map);
+	regcache_exit(map);
 
 	map->max_register = config->max_register;
 	map->max_register_is_set = map->max_register ?: config->max_register_is_0;
@@ -1442,12 +1442,16 @@ int regmap_reinit_cache(struct regmap *map, const struct regmap_config *config)
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
 
@@ -1461,9 +1465,8 @@ void regmap_exit(struct regmap *map)
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



