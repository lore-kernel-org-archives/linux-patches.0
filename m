Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212304;
	b=gVTTxW7H2otJgc4g1ceC/3WPwNKp/cSVp4kidD1UgdQlD/xwHDZqs2b5Sqoa/dPFtiaz
	 yt3qR5xdgxNonXWGVk06N5vW6QMmzRkYmxE5WZXBP0uPuL4JrVhyTlx65LPZd1YGjfEAL
	 xPiwUVNdnVGmmHeFEib0kFdUtw2NR2R99DIUVbNgStCC6/e+JgY+LGw3ghYXvDlHiyoY3
	 y1/Npk9yqXBBWaOx/ZFd/UGh42hlJnD4GQyAsr9RrIMSq/tRrl1uxaulHgup90Nu6Stov
	 LksOjrx7pOGbzxcv5jTDeLptxmkGvL9IJlB55R5iLOpLrzDLLYc6nkazcwPSjKm+aYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5tnyiGQX1tAlCWvXEePqS9BeBdwQFmaxw7xQ9QF6ANs=;
	b=fAOLJUShBjB/p/ylOYKRUwiy/io5MU9+H1W3cV6BKAnM5w5rCdUT3qXtQr8ADeAAARn/
	 ERpI9vf5J6ye77Mrz27fQp/BvovXrjG7L8mVYeEyrKnQ9nBp6gBjXE1VEkpVrycN6YRCq
	 AWeRy4UOm+IggiQu7LkGoqlovPdSO0pRCGWPG2G3U81FOwa0MIEMbUcnc9MV8Uo+LX+yG
	 vTJxoumy/xWP3tCHa0E8U6J9xhuOlD5GClxaGr/WHg6S7CXZbMa8GYjIXMyaI3GF21CAp
	 V4mQ8zIoUZunqfH1HOTPG9OVDYC9DKQe3Lr2GMxuYONN5f6H5ui5sGefM2SeFf4pC/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LsyNj+7l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEFF606A32A;
	Wed, 28 Oct 2026 18:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LsyNj+7l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D784C1F031E1;
	Wed, 28 Oct 2026 18:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212304;
	bh=5tnyiGQX1tAlCWvXEePqS9BeBdwQFmaxw7xQ9QF6ANs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LsyNj+7lPuwK6TxCd1WI9W0Mnb6MJUEI07RCAxi/N7Ly0WysXhJp9Fk8sjFah8Cry
	 h9d1Y5d48h/3TCPBy+xAS2K6S5r2/mv1Lr0TvZDJ9hrqQrjeRTHzPIj2cv90kxo75E
	 3wmuWrzl7iuvYKLQLRaG1GZ5zf9BEDDFk5gXi9Zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moudy Ho <moudy.ho@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0106/1887] media: platform: mtk-mdp3: fix NULL deref on failed SCP lookup
Date: Wed, 28 Oct 2026 17:36:42 +0100
Message-ID: <20261028170501.646284752@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 90368323fb244da0504e3da37a182f8e89bcc3b9 ]

Add the missing sanity check after looking up the SCP to avoid
dereferencing a NULL-pointer in case its driver has not yet been bound.

Fixes: 61890ccaefaf ("media: platform: mtk-mdp3: add MediaTek MDP3 driver")
Cc: stable@vger.kernel.org	# 6.1
Cc: Moudy Ho <moudy.ho@mediatek.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ Adapted NULL-check placement to the older direct platform_get_drvdata() lookup. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c
index 97edcd9d1c817..9a11064ecfa95 100644
--- a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c
+++ b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c
@@ -241,6 +241,11 @@ static int mdp_probe(struct platform_device *pdev)
 		goto err_destroy_clock_wq;
 	}
 	mdp->scp = platform_get_drvdata(mm_pdev);
+	if (!mdp->scp) {
+		ret = -EPROBE_DEFER;
+		goto err_destroy_clock_wq;
+	}
+
 	mdp->rproc_handle = scp_get_rproc(mdp->scp);
 	dev_dbg(&pdev->dev, "MDP rproc_handle: %pK", mdp->rproc_handle);
 
-- 
2.53.0



