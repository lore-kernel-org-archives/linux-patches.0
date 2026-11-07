Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064478;
	b=DtKYjeQBzTsHc+oAPtou1yTcIdOhQEiuYPobb91SYtFaOj8o9V7F5jYpNzDbgzVmohrL
	 xllvwpj/huzn3IJGrjG3EMsPXXAr34Z/NBC8r+BSsupGcjpo8Ezu7Uwfz9QADd1dgNrvv
	 w40wa98WfZmBXg7rXYGJCk9IC2BXMLKJLcOU/FZRkXZqjmBe3DylTTTIQpQfS+YFCc42R
	 i+w2v5eI+5qrpJ5itTNpkpdZIXH1/RBBuWdSwIFXMgkI6oywWXyrumNBL5X0nTUyu5Jki
	 etzO4tXkbUgQcKeEhhtiohFG1Pt0YkV4R58cP9TUifw7zeAcCrHHjfgUHmMcz/63f8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064478;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JfykpwuaA2ApO1g1iy3q2xDheUeIf7O6m1nx96Rr7O4=;
	b=QLp6sqNqkKOxKeg0SvOVFR+HDFAsM2HggkHXx0YjNUdbSNrYVnDfp8JMd1Vu153Ib1aI
	 btMLjBW4ftP6WKSOR3NDyAOMlOtaByz+qAKN4puKc3OMN2PWjRwJIRXZpzrirlTsoTwjT
	 7b3FI1qlmIG5ydLrHkCCvOKBp1308KcOgVPXx41mWifdK2WqdT5ugI8PI/kO2rOB8I4VJ
	 LX+fRDwY+01KGLHxBfPOl4hd+SPNBEPOOVYrp3nqvpoTPLmz/84RIPldVUSjaH28+8VeP
	 eGtjb7vNYAvoVsdnIsDXeScAsN8RvoMG8dKN+W4ht6gCWRQTjDdKWWlWYQmhq0Mdhfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IdmD0ZM3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FE5606A9F2;
	Sat,  7 Nov 2026 15:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IdmD0ZM3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176D91F008A5;
	Sat,  7 Nov 2026 15:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064478;
	bh=JfykpwuaA2ApO1g1iy3q2xDheUeIf7O6m1nx96Rr7O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IdmD0ZM3MpW7WoQx9nxHOy0AA+Sc9WrBCH+ng+PcHhDm8Q5eOWGafNMmI7Ns8odym
	 yZXrpLuA+V89KVkJuiu8oZybjmUhzF4jRS1japEXcNIzACndEmi/o+SOdM7zgBTHiD
	 JjVTr/Sh7FXDv014AKSXiSFdjL9u0RfjjbxbW7iE=
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
Subject: [PATCH 7.3 0517/1257] mm/damon/sysfs: set next refresh jiffies per sysfs context
Date: Sat,  7 Nov 2026 08:46:53 -0500
Message-ID: <20261107134953.711012921@linuxfoundation.org>
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
index e3858ffab4b22..f05b256c90ee7 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1789,6 +1789,7 @@ struct damon_sysfs_kdamond {
 	struct damon_sysfs_contexts *contexts;
 	struct damon_ctx *damon_ctx;
 	unsigned int refresh_ms;
+	unsigned long next_refresh_jiffies;
 };
 
 static struct damon_sysfs_kdamond *damon_sysfs_kdamond_alloc(void)
@@ -2215,17 +2216,15 @@ static struct damon_ctx *damon_sysfs_build_ctx(
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
@@ -2273,8 +2272,8 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
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



