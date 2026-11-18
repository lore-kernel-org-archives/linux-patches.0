Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041591;
	b=JTH7j/tH5ghjg6cWLiQL6z98TIPzYi83T53W9XgHHHot1zoQOiDpOI+ZATVDODGafSqq
	 U1ZZL8Dc4sTR7crM11kp/zfXAI4CREoP8FJt4bOjf/uAK21OqweLZt5UtPZy3CiP5zTRz
	 oNKJ1O+9C+PsIM/tFnG7MhIFm0FBRzUyclWq3CDRIBzkbbmVoxbIZyROB2y0UexYgQX/4
	 IpkbTp2dBgZNbniMDbv5/cjQr9XTF3S9HSNCgZ/JXaV+xXHCPENwpU3kmtiBZFwYtI079
	 Wrt9Y/6KJqpIdAOd6HG/+STxKMUPJ3M9tsRH3BA7BWwiY9icBMNhGfxKb+gGW1vIooA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OZvmpVlVYAEQDCvjPo+vnZ5k8HgchmFKGcBFx91rX2E=;
	b=ExlurDdOFoDhcos8SRD2g+FJJQ9qurowxOql/g+S7v4Xv/CLB1aEwdvu+wOOsE+wdRvr
	 EYBgVfbhttF0TzG0mMEIFvYFW3je1p7Ok85BCUxnjld3KkiWkj6L+LTCsj1UNDB1qs6Pg
	 l1QfT6F9O/ykgsLUQc5zWxK58iEeqzwVz3OeAtLmpV6a+Qlqu7hGG2mn7fzb6CTpCFUAS
	 TlbL/k8QyNmGJMjGNY3yam6TP3QwgJ8qMqbUnE4W6g1a09V69SJvxh1BJ1gxztW9ZdUXm
	 6J/l510ZNQmdC38piHJJCYguD6AUFa9fpCHmQeHD2WKwxULQg4XvYgD/23LbSfRoOOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WxwWp33V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0B2606A6CC;
	Wed, 18 Nov 2026 22:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WxwWp33V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D471F000C4;
	Wed, 18 Nov 2026 22:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041591;
	bh=OZvmpVlVYAEQDCvjPo+vnZ5k8HgchmFKGcBFx91rX2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WxwWp33VbMET311iH2x4dAbRfZDw3i8uHqqO8wUncqGzKOmaiXHTO3kFx6n7qZ9uN
	 pamGeu8/Aai9XcZzAfau8fxBFOUbH96cTorO/bFB50FFf/6wrAdxBB/gzGYaVduJ2G
	 qEKJOdOoliBE2rPEUilZyqLmHcKCg2jETgtK/ZNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2868/3318] rpmsg: mtk: release channel OF node on device teardown
Date: Wed, 18 Nov 2026 15:58:10 +0100
Message-ID: <20261118150446.605845770@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d1213c33da204..d4eb1968cefd7 100644
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



