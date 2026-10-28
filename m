Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207574;
	b=ttfwQSRDIfw1Iy6RvSt4QCokGASSHUGGLSNp+JgqemLObvELavv/50xOdLC4Sf4aZuxS
	 z51UjyJdLFS0k37WwHcRvuYQxB1GCbnt27aUEkhpfcg3CdysytvNEQHxfbchWpYSwl8vf
	 g++uaeHN58sv1zrXQFUxYkZGLO6xQ4ayNwCPxqnkOGcfsKfNXDM4j9Y6kxXyvB6eYH1Mw
	 b6mpOeTYldLeA/8xbIIKLZqP3+fxr1kNlW/M+k9NL7Kjizm2CednijYT7by5scmI2IOns
	 9qu2sQCTLUP2RQAb0XKFWedBYu7/2LaDT5r0z2BTZz9uNORI4aZq8baE1SjvFBQeTbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6ANc7rjlQP5xaCMUGcKZ39e0wAZYcODqk+4Agyf6wGA=;
	b=htq6h4tJ+ExYF0WGBN+kq0+yYM6LQpnVMN8zbkFuOvT5r/nzApNH7ZdTbVe4fHSTQJlF
	 i/YZQ8lxHEAhUNDsuTqPTDJW0s30K3OEs+ShMLVwKNJqBbK79dl8CH9HV8KCQ9qwZn8DD
	 99JfBhg6sAdpLaHztszIho6rR0w4SgdYQrV+nNIVIXf3J901tVqGBvutHNNxV00Sl+o5d
	 NZhg4lpw2TmU2A0olH+cMJal4wJHj/zTj+jN53R4krSSC0Vpl/Ud1dtDTXupibkm3Idw3
	 rSl18LhN7ZrzHF4GPrAvyNaXok8R1AJm7XfsOWjJnNoObNKb0ID9gW9DsmmJGnpA6lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s4IuYn3x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF6A606A321;
	Wed, 28 Oct 2026 17:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s4IuYn3x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D23F1F01825;
	Wed, 28 Oct 2026 17:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207573;
	bh=6ANc7rjlQP5xaCMUGcKZ39e0wAZYcODqk+4Agyf6wGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s4IuYn3xFUTmmYEsmR0GcRQj9HqVbOsUiZs+3y6D2mp47a/7wXrR60vQqqYOL/nE4
	 gQ2DEAnnoYy7wv1GiAOrtu661K4cyDX7cLx+bikHOS84Qu+tL2TzpyB1mNnI7qc+Gf
	 Pms2szGyVJxz/RztFpvKNnA/krGUZivd/KxO8Hqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/247] regcache: Add ->populate() callback to separate from ->init()
Date: Wed, 28 Oct 2026 17:57:20 +0100
Message-ID: <20261028165948.245740819@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 94a3a95f03154d8d4c6206950a7f6ef9a30baec6 ]

In the future changes we would like to change the flow of the cache handling.
Add ->populate() callback in order to prepare for that.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20251031080540.3970776-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: abff0a48b110 ("regmap: Drop map lock during cache init and exit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/internal.h |  1 +
 drivers/base/regmap/regcache.c | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index bdb450436cbc5..e3ce87ffdd8c2 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -186,6 +186,7 @@ struct regcache_ops {
 	enum regcache_type type;
 	int (*init)(struct regmap *map);
 	int (*exit)(struct regmap *map);
+	int (*populate)(struct regmap *map);
 #ifdef CONFIG_DEBUG_FS
 	void (*debugfs_init)(struct regmap *map);
 #endif
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index d3659ba3cc112..d2630a55bb50b 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -201,8 +201,24 @@ int regcache_init(struct regmap *map, const struct regmap_config *config)
 		if (ret)
 			goto err_free;
 	}
+
+	if (map->num_reg_defaults && map->cache_ops->populate) {
+		dev_dbg(map->dev, "Populating %s cache\n", map->cache_ops->name);
+		map->lock(map->lock_arg);
+		ret = map->cache_ops->populate(map);
+		map->unlock(map->lock_arg);
+		if (ret)
+			goto err_exit;
+	}
 	return 0;
 
+err_exit:
+	if (map->cache_ops->exit) {
+		dev_dbg(map->dev, "Destroying %s cache\n", map->cache_ops->name);
+		map->lock(map->lock_arg);
+		ret = map->cache_ops->exit(map);
+		map->unlock(map->lock_arg);
+	}
 err_free:
 	kfree(map->reg_defaults);
 	if (map->cache_free)
-- 
2.53.0



