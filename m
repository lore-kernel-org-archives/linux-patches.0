Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020190;
	b=U/PBS7JQkUDZx+SCn2TqKauufkWTMtO/k+rnIEf4uFC9J/toIB0BFwg1/ErJ+02ulj5i
	 Eql449cUxyHO7Y6Ym31CNewWy8jGQFcc8v2z6fwUqXIZYixxAohJmEAFpbxrCj2c12RVP
	 6PrhuA5jv06pjdIb5HnWSJJMAioeRUaSFECIwpocR1V3o66yWXzHPyq/tEaJv5edl5Gcq
	 aAxGPBDZKTvQh7euWeELB9Wn7hUxUcHwlfGqrUhLCN82B5bUgTioXPu6+nwXgcKPIBfLK
	 Oj3P9cbndT8XHa7pe7TTDQpk/GPidupW2prMRnezX8IwfrUAyi+ADKpJGVRw0L1nXmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020190;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UlW5e/0gaDFP0JVh1lYDqcIsZzBMQAAMVIy7DSw5Fpg=;
	b=cmiWwAumzRhX40r+EQOhawgh+Gy0E8KgqWwMFVzlwafy75zuquGD2pNLk5RmKC4BRoxE
	 RXQJNmLP8FC3KTWIs5+STiJXPKf0CTqq2UkWgKS6d6AbHEZJrOBAKqr92HgYG4y42LMcp
	 e6KquohKsMI+3kZk4YbggBDZxfuxtR+1M2eUU6hATznS94EM9U5qpGv0LTg8XRq3VKSru
	 /WkU5wLGdCWS6zw7WS4mj74jsc9AO6HuUZzojy/c8gaqFIpe9e6Jpd1Sf8dtie2cR/M/8
	 syhPM9jtFYdlvcK6UoeEJtGG7EOEJMuypi8AAqutjlpoi7YyvBKizBv9LWAWsO/YuZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=czkdy+hn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A75606A32C;
	Wed, 18 Nov 2026 16:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=czkdy+hn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0031F000C4;
	Wed, 18 Nov 2026 16:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020190;
	bh=UlW5e/0gaDFP0JVh1lYDqcIsZzBMQAAMVIy7DSw5Fpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=czkdy+hnLrjkxvucM7uV5zz6IBAtPwf0+XLMt54ehwZ/mS9ozACi79FOrphliXsCB
	 iorMU8rJM7spjkhkdc+ndx5WFfC5nd1Qiva47W0x9YFYV/r63l3TFeJax8VNmmsgYF
	 kxuA0cFGzbUH9jOoso8rTqVmiYbvZrrboPHPl+sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1862/2651] rpmsg: mtk: release channel OF node on device teardown
Date: Wed, 18 Nov 2026 15:51:42 +0100
Message-ID: <20261118150354.024830237@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 00e100cfbf7bc159e462df16832cddeaf2cab770 ]

mtk_rpmsg_match_device_subnode() returns a referenced OF child
node, which is stored in rpdev->dev.of_node.

mtk_rpmsg_release_device() later frees the containing allocation
without dropping that ref.

Release the OF node when the RPMsg device is destroyed.

Fixes: 7017996951fd ("rpmsg: add rpmsg support for mt8183 SCP.")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Link: https://lore.kernel.org/r/20261013074744.942560-1-thnkslprpt@gmail.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/mtk_rpmsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rpmsg/mtk_rpmsg.c b/drivers/rpmsg/mtk_rpmsg.c
index 1b670ed54cfa2..430a9b2aa7bb9 100644
--- a/drivers/rpmsg/mtk_rpmsg.c
+++ b/drivers/rpmsg/mtk_rpmsg.c
@@ -168,6 +168,7 @@ static void mtk_rpmsg_release_device(struct device *dev)
 	struct rpmsg_device *rpdev = to_rpmsg_device(dev);
 	struct mtk_rpmsg_device *mdev = to_mtk_rpmsg_device(rpdev);
 
+	of_node_put(dev->of_node);
 	kfree(mdev);
 }
 
-- 
2.53.0



