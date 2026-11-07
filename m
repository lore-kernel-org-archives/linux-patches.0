Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063164;
	b=g3/XCdh6YGQBsKhuAVOi14qc34d27I5gStiHJOtU4X5f6rdUVmwlXIfLZGEg8VWend09
	 O2fOz0CvmGxGVVe3EVjiOF26g0SpTT2V9qxHtcOkTTSMdusBYCi0vM31yraZEFTcDT1bF
	 n8weCKd67lsZKrQjg+p4+gJelsksvGjSZ59ZSw9JkcO2zMqwvUpzyvYhRrz8Nprhmot4V
	 Wl6aCM8bTsddhObMysFzR19ZZapBECNoXVV3Uiec0yHG981oab3Dn/TZypwyloqKl7K8I
	 1ICKKR84a9ZpPKUAoYpg3MEPeFTlgnhNYuXO04YeE2NKDoWZR81wYvZeXpfA9/QKBdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063164;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PE0p5/OeYudstkbIlTRct/yJPqPb6Cj2QRmdxkHCV8E=;
	b=I2yYj9GlAbLfkyOTL1FXvfQOm7otvKTxWOMcssendKv6SaLHGbjES1w82SVrP1YfeBUL
	 CfaT+DQAwHPGJqyVopxoZ4hK/B5qeHqTsLv2rvdlSnm+8mT/skCtI7MpMqdvteCtj7mo6
	 7ysb3pK27P+dLzHlGuhOdcuYi7NpbguJSjhEidbkPjFtO2B6ZRKYTdScE+u1C1KMXdaQd
	 yn8ZKxRTYAB9F+Cox4TRGY1U60X+3OjXHEHZvIB+bhK8WyBv0hm2QSGDgCwl9+nCsxwjv
	 AJZcwBKrxNz+WLAWaD7ozRzh9SbxU2GaJJpRSqhhn57l9bmdEDgESHT51SPZZ8t2eLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yp5bgE8Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1DD606D833;
	Sat,  7 Nov 2026 14:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yp5bgE8Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534CC1F0089F;
	Sat,  7 Nov 2026 14:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063163;
	bh=PE0p5/OeYudstkbIlTRct/yJPqPb6Cj2QRmdxkHCV8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yp5bgE8Zb60/48XHtvKfcdl/mE1gDxLVcddYBTb3b2fYO9GDoCYxVEY2Rw0KGhSM7
	 QJJ7RxQ/gCA4CGRB2rTJVVUE+18wYag4voRWT9n3HXEEs+eHa6saxOkv2hQ64d62Ee
	 xhYmEKCOuAYr2DeQIpotVYvBvZX0REnbtDu6BhtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 385/869] mm/damon/sysfs: set next refresh jiffies per sysfs context
Date: Sat,  7 Nov 2026 08:51:07 -0500
Message-ID: <20261107134906.437857068@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

[ Upstream commit b9100ecb5411d2de79175ed534df72ec41e94998 ]

When 'refresh_ms' is set, DAMON sysfs interface periodically updates
auto-tuned parameters and DAMOS stats.  The timestamp for the next refresh
is initialized when a DAMON context starts, and updated in its
damon_call() callback function.  That is, each DAMON context updates it.
However, the timestamp is a global variable that is shared with all the
contexts.  When there are multiple DAMON contexts having different
refresh_ms, the update frequency will be changed, depending on the order
of the contexts.  When there are multiple kdamonds, it will be even more
chaotic.  Fix the problem by having the timestamp per each context.

The user impact is not very critical.  It does not leak, corrupt or crash.
The update will not be faster or slower than the lowest and largest
refresh_ms values of the contexts, respectively.  The user can also
manually ask the updates on demand using kdamond state commands.  That
said, clearly this is a bug and can easily be reproduced.

Link: https://lore.kernel.org/20260902002725.108635-5-sj@kernel.org
Fixes: 9fd7bb5083d1 ("mm/damon/sysfs: change next_update_jiffies to a global variable")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Tested-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Quanmin Yan <yanquanmin1@huawei.com>
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/sysfs.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 3a79d8c89b5bb..1ae026d099a2e 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1199,6 +1199,7 @@ struct damon_sysfs_kdamond {
 	struct damon_sysfs_contexts *contexts;
 	struct damon_ctx *damon_ctx;
 	unsigned int refresh_ms;
+	unsigned long next_refresh_jiffies;
 };
 
 static struct damon_sysfs_kdamond *damon_sysfs_kdamond_alloc(void)
@@ -1567,17 +1568,15 @@ static struct damon_ctx *damon_sysfs_build_ctx(
 	return ctx;
 }
 
-static unsigned long damon_sysfs_next_update_jiffies;
-
 static int damon_sysfs_repeat_call_fn(void *data)
 {
 	struct damon_sysfs_kdamond *sysfs_kdamond = data;
 
 	if (!sysfs_kdamond->refresh_ms)
 		return 0;
-	if (time_before(jiffies, damon_sysfs_next_update_jiffies))
+	if (time_before(jiffies, sysfs_kdamond->next_refresh_jiffies))
 		return 0;
-	damon_sysfs_next_update_jiffies = jiffies +
+	sysfs_kdamond->next_refresh_jiffies = jiffies +
 		msecs_to_jiffies(sysfs_kdamond->refresh_ms);
 
 	if (!mutex_trylock(&damon_sysfs_lock))
@@ -1645,8 +1644,8 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 	}
 	kdamond->damon_ctx = ctx;
 
-	damon_sysfs_next_update_jiffies =
-		jiffies + msecs_to_jiffies(kdamond->refresh_ms);
+	kdamond->next_refresh_jiffies = jiffies +
+		msecs_to_jiffies(kdamond->refresh_ms);
 
 	repeat_call_control->fn = damon_sysfs_repeat_call_fn;
 	repeat_call_control->data = kdamond;
-- 
2.53.0



