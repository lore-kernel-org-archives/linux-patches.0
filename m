Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056269;
	b=c/Ob7oetTM9KM6VOxqqdH7lnX+R5+TauT4RTq9hSPJXImjQS5eHc7Pw0dogNVmgAvhlA
	 TR+4sIAxL8vkbPXu/eTUlDse5hg0lEx+XKi1h1/gjDM105KWJ/t6wPSVHbL32EfERdVQG
	 +G3OxE3Q2LQU6OeUgC43peX4D2qNT021bxjcD/LpvUKfjJ3Xqp44aCP63P9gdOgqx1L+X
	 zDfrkOShrt1ZjqMAXdQIdpteSsIQ4BRtKFL9hKOAnN/xIVdH8kt9U+ZgYiY1rDBYzqS1O
	 CMPx1sGEiTeTuAF2UGdUC13CK00//mUzwZD7Jl1O8JPE0xPgYOzXzGQw6f7d8pKu7Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K8eFuBkPCoU+S1H4DN2P6CoJBMqxZU5/TzWjnPFXE/Y=;
	b=SZJ7GY3ixU9t01dFqxEEkSplM34DFPjVM9nLsN2ys3HbbTKvnlGftoXSbA6QwXC3VFXz
	 RzruUOryzOGV7gqZPKGUY9gYKgVAPVMZBc/ENwYJ33RJHn6zlr2V+fJm/BCbebZd8Sidh
	 9ois9/vqc25Di+9qgIuGjspGcXg5PuNZJ7gHaSyKGna26z8wwPtN0v6v6eImoNtAh5sVz
	 XfpDCsXXZKhTvPoNZEyULKHpTSw6KxRGFDU6hP+/j0tb9xUVdkO0fJ3gi8UwPCKt1Z6+Q
	 k8VRv8vz83BRr7qAhNUIhLkJyMoDiMfXFsvlPlGicm5M2n7zTv8UM7xRQ+DujN4zZmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pb0WOVLX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D130606A31C;
	Thu, 19 Nov 2026 02:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pb0WOVLX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739BA1F000C4;
	Thu, 19 Nov 2026 02:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056269;
	bh=K8eFuBkPCoU+S1H4DN2P6CoJBMqxZU5/TzWjnPFXE/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pb0WOVLXIzbHej4DX8QeaGe5ewUAlnR3Ar6fQdD+d8GVzDxpCD+xzMKscDAMxRQRG
	 l7bbmMnb1gQuUZh4s/C0mNIAeM0LP+RdUDmTKlirj/8Zc0mhd5JPP3oa2DUVBZypZA
	 P+QMi7FpO5kA7cE3SRWdCUQstblQeRdF8HZi5Bmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1927/2214] rpmsg: mtk: release channel OF node on device teardown
Date: Wed, 18 Nov 2026 16:00:03 +0100
Message-ID: <20261118150128.116497114@linuxfoundation.org>
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
index 2d8cb596ad691..94dbe78fbaa90 100644
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



