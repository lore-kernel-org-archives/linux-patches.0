Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061813;
	b=CMSKaozJACRY9Ku7FQbVqW8p59FZjr+jfdQ4QF60cweYFcZdBu4BOjB2kl0xljmXCT5x
	 0wz3pF30qtTDcEJNKHmBsfM9B5k/i4DJXte2JgFrziOUr2PAcualNODDFVJztPv1ylMgn
	 anCvDjLs7DCrpbbBwBNCnh+For3fN//5X7SFE2N7jwdAyCbdEaD5K3saRiQyu3VLdhQYH
	 plauoBQSmWFv1qSWcBs1ZcTPV7VDh3Dmg5cLUo2d0fqaUeyoKZ1nTRM7EQjrtTujcDqLM
	 4mgcI5kiX1RGlbdc7PKY760wUNsyLbjkUJS6emiJ6Y+hgjGPUAyh+l1c0+tiNrtMetw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zFr4f5w1ksB24kzkriYlLD1JKoKogP05IiLwkA7AJe4=;
	b=C1n7GoXxAY0jVhF+iYLFkT/JWfv3TcmqyZd4bqcwN2EKOsUNSculsSULIG/VVCblzQ/A
	 PcyU4Dj9iAujSQPAnavsiZX8kXJfRvTKV1ou9DggFKyAHTDCG/LMPm5MhqHp28GVgPYIA
	 5wvvEe/Ew+mG8zarXivX9Luj+OaMO2IHefzMwwturXqpKTucFDLPzY+XDy0ibtVwomgDk
	 qWoYETGStv7A7MuzM5UtYic7bKSfchmoLeV5fZp4spXmt2jtonBpCAPa7CF2ofLMo5DWr
	 g6JmkrzCsBMCKdFBsRcNI68kqkUsme+33sDiO7FpByTHa0COH+788zg2a554Yfz/yMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qXYrd87M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1D5606A320;
	Thu, 19 Nov 2026 04:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qXYrd87M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2360B1F000C4;
	Thu, 19 Nov 2026 04:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061813;
	bh=zFr4f5w1ksB24kzkriYlLD1JKoKogP05IiLwkA7AJe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qXYrd87MCEP/Ye+MBV4yNq18iY1Fl5YnwWLNCg6UnvRc6V0fNNbdH+tKdC+DbUSUT
	 ZM5gTWdYRnzbhvxkhyqclaHH9VMk9+uYBXqfldBD5+YuBLrt8ZPsLxQFXCzhZXx0rW
	 GIG+QuoOqoq85BrlTHxpHpN8QVmcfLG2b3x6p+5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1645/1848] rpmsg: mtk: release channel OF node on device teardown
Date: Wed, 18 Nov 2026 16:01:23 +0100
Message-ID: <20261118150028.603050244@linuxfoundation.org>
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



