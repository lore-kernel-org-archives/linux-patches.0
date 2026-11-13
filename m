Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585470;
	b=qW3M74VQ2/liy8XG5uYE6Hyjyiz8mLtXglAyWXIvGQdi6tfMrCtUYF6iRoJr0uwzVScx
	 L8h70/9/tBRf3jgpkiGKFWMIFwwpvihejzvq4RCaY0EXlgBUBU6L2Cv7chYs91VsgUBHt
	 dEwOoDO/oQVRwVIc39f04b/b1C/Zut17JqqGjZ2iQjwnXMgd3nnt6iWbwhR1BSkztulb0
	 q26/emp/BSRnYaxy8VeWIC8jjXa23f9luJsS9bNlsXVc+kjxhpW0Kr6c8iEaaArDDWZXd
	 t1Sor6pqF1FTFco03lrmH2aGMyCgGMcW+UX8itqLn7psMEFdovUb+t+pgFOrxM/wYFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wrKgxzQXtV/1TGc8Wm1Y4sCwVP4SA3R3DmG708jBCE8=;
	b=gaucw9GZoGlvHoEvRP9DNuv7t7OAWWLDUCzumXpzaEXry+lnam0rhrI0sqFnFP4XXTl5
	 qfAGzALTywOJWhhCnuiRR6pwjDbyd3h/GCWElh8enAWI902y9JMBeWgcLIf8QVj2M7awO
	 1MfU0B52UitdsTmdO6fWnNv7y4UPL4bBU8gMPuVaKOcHg4LaN51Phu+adoBGgj56NCNuB
	 UGAeFZPx6OYj29qbi8pp1x4pC7vBR7K5Yv6juCN8hsR1swySLLTUKzqWKHjy2CANw2nZs
	 3zuqzzb+cWkJLk11odQDFXhxN9GVruCcugP6VZszE/OHA37o4CFnbC98jHvtUnhrLGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VskYHS5F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8504606EB8A;
	Fri, 13 Nov 2026 15:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VskYHS5F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E4C1F000C6;
	Fri, 13 Nov 2026 15:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585470;
	bh=wrKgxzQXtV/1TGc8Wm1Y4sCwVP4SA3R3DmG708jBCE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VskYHS5Fm4jGmx54UQe9GlcgxJ6db7DI2YffD2WKgjwhzPCP8vHjoQ9yRjupzTnaO
	 xFsr9EbL626D7HBP3cR1GLXRUWKFIdSI5ce0MDzsEOzZNDP1qeRKd4wrBA1HkgDNkc
	 36naX7UtALej2Wz1k4RVO4ueZZi7e24R3CvDC+1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Yao <yaolu@kylinos.cn>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 125/507] drm/i915/gem: Reset err for each fence entry
Date: Fri, 13 Nov 2026 10:47:09 -0500
Message-ID: <20261113153758.675318292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index d5aadced7da0c..7fdd41a190b42 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -2790,7 +2790,6 @@ add_timeline_fence_array(struct i915_execbuffer *eb,
 	u64 __user *user_values;
 	struct eb_fence *f;
 	u64 nfences;
-	int err = 0;
 
 	nfences = timeline_fences->fence_count;
 	if (!nfences)
@@ -2828,6 +2827,7 @@ add_timeline_fence_array(struct i915_execbuffer *eb,
 		struct drm_syncobj *syncobj;
 		struct dma_fence *fence = NULL;
 		u64 point;
+		int err = 0;
 
 		if (__copy_from_user(&user_fence,
 				     user_fences++,
-- 
2.53.0



