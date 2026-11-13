Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590244;
	b=Y/yghkX0OXGXTzlxIxWRrjOowYcaZnevcRvz5fsjeYqWTxaLgwTMkTgyJOLvcqguNtje
	 YacpVARhhMAByqTg9/r7LyqXcAtNK/HSpHGgyv7bvKdeF6J2mq0aCEyyo3AD9gCP0mhQY
	 RIA9dEtoAt/KyAgJuzgARAQt0v8cZKNFt1W0XgLqmk9OTITtjJIqw3RQ/jrQ8cjcB73wF
	 rOJ3auZHtovbsXtkv9BIdsIadTTcXTjntIgB4z2DhX9eJ35x71ddAfpxK4ZHtNBcrahEI
	 cNpffklbLNRsPyEZiVO+8VVBe9+BQtsjnsPZPEFzMfIfzkp3sxBJ1HfCQmLjAN/8few==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wJ/o/8TIi1qnmOZcaEh37ZvUlGNkDj8qmeKtgx/YmTE=;
	b=I+ea4peSfPPCtTyirDaIhxHrjX5yAGxdlIs/wrj11j5EHud7kivABSXo4NRJiesHEN2b
	 7sQb2y/AoSzv+9tjjJDqEXPjNvNA+dxRM9JQKKgPObZ+rANxs+L4qrA04Vn+Rfod6Fh6H
	 3Y2lRhiE34+k+2mvmWDNqEw02FjhLjiwnaxLgtJibslF1mOY4u4Rv9v4spDRtu/BMj92W
	 lu/ocQmEVpu/VngNAKte5AGsIY9wtfHcrZ4eXld4Mn8s+2LfrRnHPQJN6wRLeyfw/bF/7
	 JUSw3fc2IJF2ENrkOUeF8V5cRj3GGNJCdiwpHih60On0Viyi2zGw3eJOqvRFB6ja51A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yn2ocQMc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EB7606C0BD;
	Fri, 13 Nov 2026 17:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yn2ocQMc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C911F000C4;
	Fri, 13 Nov 2026 17:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590244;
	bh=wJ/o/8TIi1qnmOZcaEh37ZvUlGNkDj8qmeKtgx/YmTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yn2ocQMcx2VTgW1PjmpePNC6sPJgduMWnIpmxOc5x7PY9hsk7H0E2NXo8RJs+sjwY
	 KfW9920G4UihrFqNUUmG5q5cLGUDFwO/B2odyMAatEHiyB3JHlzXhGwzuAiN4Rv0qQ
	 MDFP19U/n+btHNjvAWnKEm4o++eMNOM/qZkhSbKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Yao <yaolu@kylinos.cn>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 242/686] drm/i915/gem: Reset err for each fence entry
Date: Fri, 13 Nov 2026 10:46:15 -0500
Message-ID: <20261113153829.260723572@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Lu Yao <yaolu@kylinos.cn>

[ Upstream commit 31643dc89818d9b65bf42ecb1c67c99b64146fba ]

If dma_fence_chain_find_seqno() failed once, 'err' will store val in
the following loop. May causing returns '-EINVAL' even though that
entry never called dma_fence_chain_find_seqno() at all.

Fixes: 13149e8bafc4 ("drm/i915: add syncobj timeline support")
Signed-off-by: Lu Yao <yaolu@kylinos.cn>
Cc: <stable@vger.kernel.org> # v5.10+
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patch.msgid.link/20261027072832.726435-1-yaolu@kylinos.cn
(cherry picked from commit 4e9db08db75f55c920986ac929cfd82a4ee99f41)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index 61f1b8f172a76..e05b1e98c9b2b 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -2789,7 +2789,6 @@ add_timeline_fence_array(struct i915_execbuffer *eb,
 	u64 __user *user_values;
 	struct eb_fence *f;
 	u64 nfences;
-	int err = 0;
 
 	nfences = timeline_fences->fence_count;
 	if (!nfences)
@@ -2827,6 +2826,7 @@ add_timeline_fence_array(struct i915_execbuffer *eb,
 		struct drm_syncobj *syncobj;
 		struct dma_fence *fence = NULL;
 		u64 point;
+		int err = 0;
 
 		if (__copy_from_user(&user_fence,
 				     user_fences++,
-- 
2.53.0



