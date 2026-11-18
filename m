Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031861;
	b=HkZ1+1DRQ18MRtGIrP1cYuTKadCYq7tSmdS5FdDp77wHpVml8sUkQDsqG70Oi+aaBIiz
	 6tLaz9/svc9pO/6gWdqptHICfdSzEfwzDtswwfvqfsHRyYsNDHWMTODKGaU01mCYlZYgt
	 4cOytcvWnpCVWqkmhsKbwa4JoDwUnV1/qDwhogotoq6fuOzMrWdw6zqHD57VAar//4MvW
	 memqm8VKB6bVCMO0nreTLkcvplJ9LtO45tesidGxOvt/q2+9Y4b+RpEICeu1Fpuijq56E
	 WrxvAw/QX7dTw2YqJCPLxWhxgv5NpFAfnGBV2wow9R8Y6V6hdMuOhgWTGJO7exzp3dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G4pmPslfsphYNDdgu95Crvkw877uGvcyLXL5I1V+wRg=;
	b=b7vqxdp81vDbSG44pfYKl1H2uZonlGKOTyoKs58DViCgG8ugBmcvd9pN/xqOeyJoQCB+
	 BLsen/nBU2PJnUm8rHs8NssLNS3DDMqFC9cv5vSlNW7SMAkC0Bqto2leU/tgTIWv71p6a
	 R4yLEK/EwqeygvQSH4M8rdCp0NaLkx8egaM/YugU1uI+QdQls+QRNkEbu4dLrWEBOkWk0
	 EiNng7ymO5GD0YEAeZwIyCOa/KQZbRPi6AXCl1RzdyLlUQEIDh0exXgCHzNkd+fz+5dyR
	 1mfQ7jcldW04uGGZ1mym4a3SmhEFEe+CGMPRswBFmRR5L2rwqVUrTKZHkDobfNODssw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xcRaWoHX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A6A606A31C;
	Wed, 18 Nov 2026 19:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xcRaWoHX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4041F000C4;
	Wed, 18 Nov 2026 19:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031860;
	bh=G4pmPslfsphYNDdgu95Crvkw877uGvcyLXL5I1V+wRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xcRaWoHXGwf8XYfY3tHEbWRBVyFhtnrP4NRRst4r9uyuanDrtN/0YG5kR7dRGYP0Y
	 w3hNxcykKKCrD3enVykacMqZk8A7GwbFwhrUhhC/mZ0QwzByFcgdSPJveubLMuok2e
	 QCSRIu/pi0jc7X2vXIpg6QGfEt9+eLPtHZM4Hh9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1208/1756] rpmsg: mtk: release channel OF node on device teardown
Date: Wed, 18 Nov 2026 15:55:35 +0100
Message-ID: <20261118150057.905517390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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



