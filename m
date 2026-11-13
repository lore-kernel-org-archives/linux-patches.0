Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591058;
	b=ZfLNs2i5Rd7qBpfTe2uqBIIBDVQOsjaOeaY/5T9LLgxXR390SF4dhi8qQ0Ia1VmrZbpD
	 1qiOEGEyjpaZ7HDLS09yDNCQb7ajRGoWyYAaCm8U6guH/qfZMgQxaM7NWwzdvgJKBiRMH
	 DH9fj+8dMX3oJzeCaJlTWgvpS52bByuOsdmcGTi1gOeEM2SZRW54PlopbDj2/V6zv/pra
	 Zvlk4gs1bi0lNziVoXeaEx27rNKI5tCTTdNZ9Z8pOE6aDkE6S/LncinS+Fc6kiX8OciR8
	 Xjv81smNIGlMaZ70wVvLDtPegg7iwsPV1XmV5PmOxv7CkCIjcfc82E1nLQG43RJJrsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a5prqb47sn8vQJw1BKhOIP2bbdvW4VuBlAXfavW31vc=;
	b=eRGtppnSlHsdq8xAGpmzbU5khcr/85+gIwVUKR46zN7oetzgJgS4uztb/MQAOS78i6LZ
	 vy6H3pY8vWbgJpFT063meca50qpEOpKfTrjYY+K/YeT2XCWK9HA+G+3gNvCvbV3q6iGlM
	 V31n4KFPlD0i+qk1tRYOn/+ajswaC3fF9Oiu7jfrG56Z1ksBYFXULSAc1u1jNPIS+5M3J
	 FSdPGGxQxDVGDDEr+Z2LCjPLsEfdBRnrgbhJB/EoHvUOwlzX+HG0bL/HurrsQAEjcrYlH
	 b86h6Z7oU0onw98O+yEaNy68tF+Pv/wo2WL5lFfdt2J8RKhCTzfdZ0LMhRrs1dOJMMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YlRsK80y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A32606B82D;
	Fri, 13 Nov 2026 17:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YlRsK80y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CBC1F000C7;
	Fri, 13 Nov 2026 17:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591057;
	bh=a5prqb47sn8vQJw1BKhOIP2bbdvW4VuBlAXfavW31vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YlRsK80yyEYPCpm1yypBsP0ciOR4dNsi95/5PkMo0HVOd8IcGd1BZVP3sZlUxVS8w
	 6Jft4mrX45OZ/YGtbJbkAT1U29KkIxX2Hp6XWjQ4uYwypdO/HOnkHI1Ey4PsOU4jNT
	 i7rshIGNl1jrSsXmeszbYFYUWGwfU+BoQVBwSzqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Yao <yaolu@kylinos.cn>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 219/670] drm/i915/gem: Reset err for each fence entry
Date: Fri, 13 Nov 2026 10:46:23 -0500
Message-ID: <20261113153819.320385746@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index dbe9fc1e8a108..a89e61dd3940d 100644
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



