Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FAF242D65;
	Sat, 12 Sep 2026 11:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212475; cv=none; b=jUD8Urhtdh3stY73S1plFwFx4kA6TbaKr+AAcyOHHBBF8r8eApCKzQi8OypKEXRKwKiFkwjz8sEU+3D8bPa3uhQgCtdP6kP2Tf6ThyYeU3qoImIrgh8Wvi6wEi1OgRC0g9rDyKTLJ2KBiumKljqPIqKxo/v4YOkE5/Q0bcyx1oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212475; c=relaxed/simple;
	bh=sAvTOw4GAqgZpsRpdj44uQ8eMnpOV3bDy721GbrUdhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEyCPOJinLrpRw4YUdJ8kuc1cOS8DyoLDnJc3gLE4w6lkN2oQBCFAcSqAq3smvYiVFppxrgcz3Nwc2oqWab9GC6dFQSXTXkzZac2PuIxNcmvFxgHHWiIweU5v52Jr6RyVdYnI+y5sdP+h3y0PGkzpKti9gTW2VIz/umkj7iYgT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DIgWAOH2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DIgWAOH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB741F000FF;
	Sat, 12 Sep 2026 11:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212473;
	bh=wIHGd/Xfdmhgst09j093n7r+j+X3nk7ewC8ibjLqZ/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DIgWAOH2gk8YlhyRP7+zyBAwI5BC/8WhDGMCjaqj2FJ2ZlOI85QFTs7sEXOR4UKMO
	 NFym0p07Bm3/kCMClgm5C6Z1kXwZJSInDs7CWeyJfbvfil/8e1RJsE8Qi2NAYyBPFO
	 Z4L3bgX3Jzrj66tI/7g3t0NAdSGbKF3yGfRb37k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1444/1518] netfilter: x_tables: replace pr_{info,err}() by pr_info_ratelimited()
Date: Sat, 12 Sep 2026 09:00:13 +0200
Message-ID: <20260912065656.221316551@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 793d9eda4821f75b5f7cc9e6a870b72a58b44c2b ]

Several xtables extension still use pr_err() or pr_info() without
ratelimit.

For xt_cgroup, while at this, remove redundant "xt_cgroup:" prefix
since pr_fmt is already set on.

Fixes: c38c4597e4bf ("netfilter: implement xt_cgroup cgroup2 path match")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_cgroup.c | 12 ++++++------
 net/netfilter/xt_hl.c     |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/xt_cgroup.c b/net/netfilter/xt_cgroup.c
index 43d2ae2be628d..28e6cd51b2fb0 100644
--- a/net/netfilter/xt_cgroup.c
+++ b/net/netfilter/xt_cgroup.c
@@ -23,7 +23,7 @@ MODULE_DESCRIPTION("Xtables: process control group matching");
 MODULE_ALIAS("ipt_cgroup");
 MODULE_ALIAS("ip6t_cgroup");
 
-#define NET_CLS_CLASSID_INVALID_MSG "xt_cgroup: classid invalid without net_cls cgroups\n"
+#define NET_CLS_CLASSID_INVALID_MSG "classid invalid without net_cls cgroups\n"
 
 static int cgroup_mt_check_v0(const struct xt_mtchk_param *par)
 {
@@ -33,7 +33,7 @@ static int cgroup_mt_check_v0(const struct xt_mtchk_param *par)
 		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)) {
-		pr_info(NET_CLS_CLASSID_INVALID_MSG);
+		pr_info_ratelimited(NET_CLS_CLASSID_INVALID_MSG);
 		return -EINVAL;
 	}
 
@@ -49,7 +49,7 @@ static int cgroup_mt_check_v1(const struct xt_mtchk_param *par)
 		return -EINVAL;
 
 	if (!info->has_path && !info->has_classid) {
-		pr_info("xt_cgroup: no path or classid specified\n");
+		pr_info_ratelimited("no path or classid specified\n");
 		return -EINVAL;
 	}
 
@@ -59,7 +59,7 @@ static int cgroup_mt_check_v1(const struct xt_mtchk_param *par)
 	}
 
 	if (info->has_classid && !IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)) {
-		pr_info(NET_CLS_CLASSID_INVALID_MSG);
+		pr_info_ratelimited(NET_CLS_CLASSID_INVALID_MSG);
 		return -EINVAL;
 	}
 
@@ -89,7 +89,7 @@ static int cgroup_mt_check_v2(const struct xt_mtchk_param *par)
 		return -EINVAL;
 
 	if (!info->has_path && !info->has_classid) {
-		pr_info("xt_cgroup: no path or classid specified\n");
+		pr_info_ratelimited("no path or classid specified\n");
 		return -EINVAL;
 	}
 
@@ -99,7 +99,7 @@ static int cgroup_mt_check_v2(const struct xt_mtchk_param *par)
 	}
 
 	if (info->has_classid && !IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)) {
-		pr_info(NET_CLS_CLASSID_INVALID_MSG);
+		pr_info_ratelimited(NET_CLS_CLASSID_INVALID_MSG);
 		return -EINVAL;
 	}
 
diff --git a/net/netfilter/xt_hl.c b/net/netfilter/xt_hl.c
index 4a12a757ecbf8..59e93d97b5072 100644
--- a/net/netfilter/xt_hl.c
+++ b/net/netfilter/xt_hl.c
@@ -28,7 +28,7 @@ static int ttl_mt_check(const struct xt_mtchk_param *par)
 	const struct ipt_ttl_info *info = par->matchinfo;
 
 	if (info->mode > IPT_TTL_GT) {
-		pr_err("Unknown TTL match mode: %d\n", info->mode);
+		pr_info_ratelimited("Unknown TTL match mode: %d\n", info->mode);
 		return -EINVAL;
 	}
 
@@ -59,7 +59,7 @@ static int hl_mt6_check(const struct xt_mtchk_param *par)
 	const struct ip6t_hl_info *info = par->matchinfo;
 
 	if (info->mode > IP6T_HL_GT) {
-		pr_err("Unknown Hop Limit match mode: %d\n", info->mode);
+		pr_info_ratelimited("Unknown Hop Limit match mode: %d\n", info->mode);
 		return -EINVAL;
 	}
 
-- 
2.53.0



