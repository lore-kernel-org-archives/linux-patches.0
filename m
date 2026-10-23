Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774479;
	b=u1EEqFqJCTg0iGtkJQdncxe7nqiIN00za6c7jsP+r0GJ/rVFs7sYZTV5XEfwo51hn5wp
	 rGu49XELAVOVQ1BolwID9/Xh9vsJ+LhgYPc8lSDcFayDe4Arz7q8J+1RNkOcIUPQo283Y
	 6+J20xmN4O7W1kl/+2s4OLhkmMOHmXBT9cerf+g/zM69Lt7CergihfsBqrccyXLUxPtYX
	 nA/USbjiKxWxA/cEGCbBn9605WsOcwHQRiQ25RYfoi/4tuLN8YTY+4eyRPbEURkUE8nLE
	 WDU0azv0zmSW+Mb9HDmuQAdwBvlFOT4HWNFa6TeIY2y7oMbBiH/pQodCp2uHqZ7BEcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OZLGWJ+zd2KNLuqa9l1wSmXWJYWqRJYH4Jam1MJvwPQ=;
	b=M4aS7lQnAv4pJtWZOJ714bxDZ2pO5Egn7d46xjZSEKF4GwJjOByMaSZYsBxO+WdV+/KC
	 b4MZd1JcgvNEGw1FJc9OK9eybUMapkXLbW6Wos+PTkUwgYuDvUQcll8+AX5y7SkDkjutN
	 44gYqWoZncLIEaZv30aaW0oYlT8syyBnNQTFVIMc6JAUp/XiyMGP/xA/p4qowSguQrP/S
	 K+rQOI9qXRSAfThQFjE9nk91Yc81GeHfkLdxCf0kmuGwxgKJ0n5oEanLka//FxD53PstR
	 AjxFLvyiNsDVsT1cPHmql/ewa3S8879+jrPXOnFXKQVQOKS2cfdpMetjrzct1LM9xpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YmlZk8Hw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E753606A31A;
	Fri, 23 Oct 2026 16:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YmlZk8Hw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B0A1F01825;
	Fri, 23 Oct 2026 16:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774478;
	bh=OZLGWJ+zd2KNLuqa9l1wSmXWJYWqRJYH4Jam1MJvwPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YmlZk8Hw2tTzNlqRSviW1iBhx2yxNL460BqRg2Tin93nV4rCTK6BPBzsSL1qrrCQJ
	 g9PtpBvPy4kfblY8AhO7PTR5gIu3aMF0OOrQG+VaeCTkJTq4pzGes14SK+CWlxzaVp
	 SZAFt5o3UhBQuETp4SLVgK4AlbimLokRduSLizQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erik Faye-Lund <erik.faye-lund@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 055/242] drm/panthor: fix immortalis condition
Date: Fri, 23 Oct 2026 18:38:17 +0200
Message-ID: <20261023163715.082511609@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 7e315708ca7ca..ea1e222ef1210 100644
--- a/drivers/gpu/drm/panthor/panthor_hw.c
+++ b/drivers/gpu/drm/panthor/panthor_hw.c
@@ -136,7 +136,7 @@ static char *get_gpu_model_name(struct panthor_device *ptdev)
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



