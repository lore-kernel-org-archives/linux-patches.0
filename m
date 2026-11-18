Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053271;
	b=NOfPJZar6Fs5x2EGegh3zBBxEasVqUHvGvVHJgGH1+59nmTIhkoSVXhT8tEoN2/fN7E/
	 2RbqP/wxG6IozyeVP9GFRW/V9ipJFmMgye7am9wqpVqmfWCT3RxfQIXKl9fMRRjHpK4TF
	 DptoNSd3Two1YOb+CBXDjMDGLdtyaxsGuxXEMwOTz8ZFJu9LNwmqf/NFGBCM/3yHIcyg0
	 STOTKE6eUlWwP+pBGe1DoUToIICKvXxroWheJxbYtL9Vlke4w+HQb39OI28zeapQtaF1s
	 xXCajrRTZJjtqNLEQ3Ls+7cm2G+QozsVO9ilc15h4XlHj6mUP+OgPKMoDE0EluWvnrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053271;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xHH81A2cK4FrlQck27qVpx8Y/Q6x3miJR1ifA81tVWg=;
	b=VjgtlsSyS35FTIyInue8USPpqGZOteXqsQYi9Mzz+pWSTmZPsDwJBlrhPrWhrBOZsvr5
	 ITK/XSBiBiUAKpCKePo9b0n5IRK/qHdFsRqaolEDMR2c9/nTq8Ez7zBdqzfA5UsAtB2ok
	 g6FgiOpMywbaqTww1R7biSkVDblXBJn9F1pDvpu4EI+CIKtsZ1w1HhSKro88N0Y9Cud/a
	 0aFe19lgQpw0Ci2HLZ9a2g7wqja1ufZ0uYy6Ti+rUXEWl4ZhwSzi3t638zaRJT9HXT2/d
	 H8L5mCq/5niNs+/Ph1NUke5Vf+2U4imzK4RHmL48B9pUfsWfkL3Q9qknHnTK4EaSaJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Jhai1/Wp";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5952C606A325;
	Thu, 19 Nov 2026 01:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jhai1/Wp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB411F000C4;
	Thu, 19 Nov 2026 01:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053271;
	bh=xHH81A2cK4FrlQck27qVpx8Y/Q6x3miJR1ifA81tVWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jhai1/Wp9cTAv+AbL8MDf2WtEBZvQTEUIsz0pwZAWQI4Kyii63sJl6zx7Qx0bI6j0
	 4A1vz7uzdloGPDkRAdKwDQSXvCGLPJ1ryUSnbGDKNP8AgRdq7OfSbYBrINz8Sh1zBb
	 Jh+oRWKqde9Rht0fwfeac5M80TFX1jnqxWxjQO3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Yao <yaolu@kylinos.cn>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0860/2214] drm/i915/gem: Reset err for each fence entry
Date: Wed, 18 Nov 2026 15:42:16 +0100
Message-ID: <20261118150046.562180135@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4811e99964228..00c55184318a6 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -2492,7 +2492,6 @@ add_timeline_fence_array(struct i915_execbuffer *eb,
 	u64 __user *user_values;
 	struct eb_fence *f;
 	u64 nfences;
-	int err = 0;
 
 	nfences = timeline_fences->fence_count;
 	if (!nfences)
@@ -2530,6 +2529,7 @@ add_timeline_fence_array(struct i915_execbuffer *eb,
 		struct drm_syncobj *syncobj;
 		struct dma_fence *fence = NULL;
 		u64 point;
+		int err = 0;
 
 		if (__copy_from_user(&user_fence,
 				     user_fences++,
-- 
2.53.0



