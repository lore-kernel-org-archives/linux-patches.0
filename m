Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064651;
	b=THpyCJZbJUv3lr/Cwtn7nH5hHJoBk0yD+KHT0vQL0E2SXA0FATgZ0N9NyAAPwJIV33A6
	 dJArttp+i1DBjN4IyzVHLaYM2QvvvXv7C8/UcGTUp572cjMYfqlm5NA2hB7/E1B8Hxzpj
	 Ko6gssJyBcMLWVhmLLBKQqJ44lLuS7qqxFf9mx7DHc3nZ7p5eDBJsphp6Q6r7X7Rrljfb
	 JM016lT1laJpPwMbtS5YWn3JAQ6MGfLSyDHWK/3XEXGqGKAOab4mLXN8UAz2RG9bBZKSP
	 ++WafC8RaYzPJOLmSaGQDoBXV930puNuNhHdD8cOsPI2xoJ94af/KN8gvkP8czH0VLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tPHXrv46ImCIvFHIaFaIMmZdkDEHOLvNF7CFSW+USkM=;
	b=aBylARHAcTmpo0vfYLwZ+wbqdzkig8T/QDXhzK2jNSDmX/QLvCMWcTKhBneKuSj3zNPk
	 P0xcATo84VWt7tuOU1p79H/IiXNHKkXV95ylMIZdP8Iw0SzVmJf72ASS2K2D3PODIklMq
	 d4h0W527diRxDtZ6E0I34g9wSsqJryUxYnHe9JMZUWJCwXtKvZdGSmn7z8KbSa2zhVKct
	 BH3FZTtG/noR/NIgEeckkAcNgkNzB9U89Ch3e9NqtGtUvGc8z7xNpgRTg9DicQ+hFBYZT
	 8p5+XS0LpfiuTYbAv6/wIuo6lXGASwnsTWQ5ui9Rw0dnycWBE2E4hvdzFB0uKF/NqoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vIoSCXEX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4739606B880;
	Sat,  7 Nov 2026 15:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vIoSCXEX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6362A1F008A1;
	Sat,  7 Nov 2026 15:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064650;
	bh=tPHXrv46ImCIvFHIaFaIMmZdkDEHOLvNF7CFSW+USkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vIoSCXEX2TzamphJbUC3ZvCy504Uw0Qg0I0uR+gokNKAbOJNYNhHG52/OkEjmF4ch
	 PFD+ijGJOpBBsRA1wkBTHzI7WYmk4YUsiOrppPcC6IMorNB3S93dgRvAGAAiEcZPqr
	 Xl0bgIcHWyTqRfaqo+9QmvrLhUOfsQIFTs0o3hZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0653/1257] mm/damon/core: return an error from damos_commit_filter_arg()
Date: Sat,  7 Nov 2026 08:49:09 -0500
Message-ID: <20261107134957.299397066@linuxfoundation.org>
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

[ Upstream commit 6f276422aded370174edea69549ebe6b1683ffcc ]

damos_commit_filter_arg() is supposed to always succeed.  It may not in
future, for example, if the given filter is invalid.  Prepare the case by
modifying its signature to return an error when it failed.  Also pipe the
return value to its callers and let them handle the error.

Link: https://lore.kernel.org/20260914142327.92510-4-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0a0fdff279d86..a4542a49ff80a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1244,7 +1244,7 @@ static struct damos_filter *damos_nth_ops_filter(int n, struct damos *s)
 	return NULL;
 }
 
-static void damos_commit_filter_arg(
+static int damos_commit_filter_arg(
 		struct damos_filter *dst, struct damos_filter *src)
 {
 	switch (dst->type) {
@@ -1263,28 +1263,32 @@ static void damos_commit_filter_arg(
 	default:
 		break;
 	}
+	return 0;
 }
 
-static void damos_commit_filter(
+static int damos_commit_filter(
 		struct damos_filter *dst, struct damos_filter *src)
 {
 	dst->type = src->type;
 	dst->matching = src->matching;
 	dst->allow = src->allow;
-	damos_commit_filter_arg(dst, src);
+	return damos_commit_filter_arg(dst, src);
 }
 
 static int damos_commit_core_filters(struct damos *dst, struct damos *src)
 {
 	struct damos_filter *dst_filter, *next, *src_filter, *new_filter;
-	int i = 0, j = 0;
+	int i = 0, j = 0, err;
 
 	damos_for_each_core_filter_safe(dst_filter, next, dst) {
 		src_filter = damos_nth_core_filter(i++, src);
-		if (src_filter)
-			damos_commit_filter(dst_filter, src_filter);
-		else
+		if (src_filter) {
+			err = damos_commit_filter(dst_filter, src_filter);
+			if (err)
+				return err;
+		} else {
 			damos_destroy_filter(dst_filter);
+		}
 	}
 
 	damos_for_each_core_filter_safe(src_filter, next, src) {
@@ -1296,7 +1300,11 @@ static int damos_commit_core_filters(struct damos *dst, struct damos *src)
 				src_filter->allow);
 		if (!new_filter)
 			return -ENOMEM;
-		damos_commit_filter_arg(new_filter, src_filter);
+		err = damos_commit_filter_arg(new_filter, src_filter);
+		if (err) {
+			damos_destroy_filter(new_filter);
+			return err;
+		}
 		damos_add_filter(dst, new_filter);
 	}
 	return 0;
@@ -1305,14 +1313,17 @@ static int damos_commit_core_filters(struct damos *dst, struct damos *src)
 static int damos_commit_ops_filters(struct damos *dst, struct damos *src)
 {
 	struct damos_filter *dst_filter, *next, *src_filter, *new_filter;
-	int i = 0, j = 0;
+	int i = 0, j = 0, err;
 
 	damos_for_each_ops_filter_safe(dst_filter, next, dst) {
 		src_filter = damos_nth_ops_filter(i++, src);
-		if (src_filter)
-			damos_commit_filter(dst_filter, src_filter);
-		else
+		if (src_filter) {
+			err = damos_commit_filter(dst_filter, src_filter);
+			if (err)
+				return err;
+		} else {
 			damos_destroy_filter(dst_filter);
+		}
 	}
 
 	damos_for_each_ops_filter_safe(src_filter, next, src) {
@@ -1324,7 +1335,11 @@ static int damos_commit_ops_filters(struct damos *dst, struct damos *src)
 				src_filter->allow);
 		if (!new_filter)
 			return -ENOMEM;
-		damos_commit_filter_arg(new_filter, src_filter);
+		err = damos_commit_filter_arg(new_filter, src_filter);
+		if (err) {
+			damos_destroy_filter(new_filter);
+			return err;
+		}
 		damos_add_filter(dst, new_filter);
 	}
 	return 0;
-- 
2.53.0



