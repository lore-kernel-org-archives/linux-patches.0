Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774038;
	b=P6h0/Bn6OvFYgzz7xrl7nl6r/vFlrgbGcsSAyD1tuTtXrD6cGjGhDB+OFasTOm2MbW1L
	 kFgMJumMosag9iuSbxL41P53nraKYaWvvX3ZqTL3Tnx63KILKOkgv0Oq4Rv4xJ45SB5WH
	 PluvawGk3ejA0daPW2EOn51YmboPFZtgN8KSqp+0mYRWG3md/6h1KzBNHambiWrdhr14k
	 ykrj4V5wJp2CQ05uBy+jqeawbosYT9/K/iJgIQa5ghTUNNPQqQ0EqqAW+Nahlki5Ludls
	 xGkjbIpzQv0YJlL9kaTT87AZIemrmu42gml7+x95cgCe4I0ajKN/4yAXNlzA1Fob2CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M/e1ZnoY+myVYLfQdR+EX2kBRxIXVlq3MR1fHwJJvKg=;
	b=cZM/rbq+HCEtX/iwJUwzZaUPE0YgSTMzv2UzbnqqKPjRpF9cmUfP5Yugmp9536aahmgk
	 D0Mxce11z8R6D4PiK5doWa1pJLcvzr17d6MIedVtRrtrJ/rVoc3662HKmB+ydYijIGV1F
	 wsDa1oRfQgxKFLZM1PsqiFDYcI3Ay3Xobeh1crRB4kA6lXihKBi+oyDhj5oC/0MezkCqR
	 7iQgnbExDYU791f0pnkVIcWgPpC0Y4KYgbSv4qCe3AKDwODenbH8sfADQiUU/NgVHT7yQ
	 XnxoYw40OahpXs9Tamkwn/DgX1wRfKB4q+hWA7PoHGGuguZNu+CshO+iLBWcy0bD45w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gvY9I8Hs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5A0606A31A;
	Fri, 23 Oct 2026 16:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gvY9I8Hs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935481F01825;
	Fri, 23 Oct 2026 16:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774038;
	bh=M/e1ZnoY+myVYLfQdR+EX2kBRxIXVlq3MR1fHwJJvKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gvY9I8HsimGYPUreD6XNYkJawG7qgks7Ley7CjaG3+T4RPk7JvAdQBwE+9YKq80tv
	 3BnFnUHyADhVhbmKu9RaiSHMESUyfbL/0W87OUu7DOR2G5GLqqQAGxU5OmkFd8j8ka
	 UcgHuurYgnkG2XAV0YmGWrGBjh7LTpLOV4qAUSLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erik Faye-Lund <erik.faye-lund@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 052/193] drm/panthor: fix immortalis condition
Date: Fri, 23 Oct 2026 18:35:29 +0200
Message-ID: <20261023163715.437006551@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Erik Faye-Lund <erik.faye-lund@arm.com>

[ Upstream commit c347fef5f8f8927985bd67835331ce4cf7ff43a4 ]

Exactly 10 cores is also valid for an Immortalis configuration,
according to the public documentation:

https://support.arm.com/compute-ip/immortalis-g715

So let's report this G715 with 10 cores as Immortalis as well, as long
as it supports the ray-intersection feature. This matches what we do for
more recent GPUs as well.

Fixes: 3b1dc21d6d80 ("drm/panthor: Add support for Mali-Gx15 family of GPUs")
Signed-off-by: Erik Faye-Lund <erik.faye-lund@arm.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20261014070902.169273-1-erik.faye-lund@arm.com
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_hw.c b/drivers/gpu/drm/panthor/panthor_hw.c
index 4f2858114e5ea..9a567e4f0956b 100644
--- a/drivers/gpu/drm/panthor/panthor_hw.c
+++ b/drivers/gpu/drm/panthor/panthor_hw.c
@@ -27,7 +27,7 @@ static char *get_gpu_model_name(struct panthor_device *ptdev)
 	case GPU_PROD_ID_MAKE(10, 7):
 		return "Mali-G610";
 	case GPU_PROD_ID_MAKE(11, 2):
-		if (shader_core_count > 10 && ray_intersection)
+		if (shader_core_count >= 10 && ray_intersection)
 			return "Mali-G715-Immortalis";
 		else if (shader_core_count >= 7)
 			return "Mali-G715";
-- 
2.53.0



