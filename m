Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059027;
	b=c7bNDZtqzpUJ0cBN0X9BQs3n+UiNNK/Ry6Q2cr7f/mRkTDeq02teLpxJgz/ORTHrCnQ5
	 ACShrChnA3XTP8vTQrK3XXuK17wKK+lRAI7aR5Z7CBg4F7YzozkhM9zIuM239m4w8BBhR
	 UHeT99on01ibteNOieugmjTOtCThzepK5JIiDjMeCDz+7RR3qe6KA5Z2zuc/N1bgzbsha
	 m8vlQIJXXuSIsX3QgyWKbwPZSSb8MhE64fw019DxSdKlCfJC4MCv07NZJdtSlWZMDipwM
	 oi8hXFhH+qpaIV9ddpIJFuuY1OQ8A5zgF5Qqiqpo3z62cPx/JkjKwb43BVPgpshur3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KZsAwdvm5rhnDS0BXOVUI5KZreC/prloO8HJnP1Cfn8=;
	b=Orv56imMswZH5TioGyMpC+S/LKWov4rXlVaQcF1ouwmlpmWlEQVr9Raspr4WEuSSTyrn
	 qsjtrbXwZ3Tg68YdaMyPcAgNi4IaeERiZf2Qb3ZAM3iXxh9vduksB5XaJp2mdrhkYLMA1
	 CewW8NFfGj7yzizA679AWKtHEFe4uqv/NI/iYHWL+KNJe/f7SSwh0dkNnnAejQeOm0NIT
	 NEdz1p2k8Apk9trBJC3S6WBDpEuxckxD8ctn1GN6d3yX00s1Tlt70EQ0HOOG6vgGp60f+
	 GcD1E7/5XEVf7jh2Jl62naZ5O340GmluGyInd2FL+9FqVxyNiQKb2Q55okwqbWHic3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aMFrJT42;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6D3606A31C;
	Thu, 19 Nov 2026 03:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aMFrJT42
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B981F000C4;
	Thu, 19 Nov 2026 03:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059027;
	bh=KZsAwdvm5rhnDS0BXOVUI5KZreC/prloO8HJnP1Cfn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aMFrJT42tzsvfAhUfIS2eiRhI0j4z2QX7i3VTMx6jWnJ3f43tMh8xdEw5VmXgEhsK
	 7UBEuOnGMzh2lILPoLL22274yfVsnDF9tQTt4qzBZWr2rT8qXluQj/tc695l7UI/1U
	 KQEzfIrp4I65yThT78WMuRjc1UZW9yNFEg4HrKps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Yao <yaolu@kylinos.cn>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0694/1848] drm/i915/gem: Reset err for each fence entry
Date: Wed, 18 Nov 2026 15:45:32 +0100
Message-ID: <20261118145944.956422752@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 031c77fec1a08..177e3f734239d 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -2685,7 +2685,6 @@ add_timeline_fence_array(struct i915_execbuffer *eb,
 	u64 __user *user_values;
 	struct eb_fence *f;
 	u64 nfences;
-	int err = 0;
 
 	nfences = timeline_fences->fence_count;
 	if (!nfences)
@@ -2723,6 +2722,7 @@ add_timeline_fence_array(struct i915_execbuffer *eb,
 		struct drm_syncobj *syncobj;
 		struct dma_fence *fence = NULL;
 		u64 point;
+		int err = 0;
 
 		if (__copy_from_user(&user_fence,
 				     user_fences++,
-- 
2.53.0



