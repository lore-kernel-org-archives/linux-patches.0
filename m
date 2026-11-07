Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064378;
	b=VJC+BWuOKqK0DeD77SuNMCXvkmvy1iWrjkfDrlnspKGHgYTYMBWNCBGHhzNBnNUm2mAT
	 B+Q5OEc3gWkeAq91+5m72Bw4mOz2HgUqbKFGfz1oRLmHxc+0i6bjibQF3ZA4O3g1/x6hH
	 FB1X9jJC6P2EUqr8ns/8aZn3yuzR8jZ2pBMWOKSWs2WC6tGXFhqqpgBHxVRcIfjHo8A0w
	 1bPN7CmE9gMNLYd42Cbcd8CWHsZEz0rPDrsBI07UHXk9u7AzcfeoEwlbyAt/FMr6IcRmz
	 8Xh0zO1Rre1aniI/ZR1TXvLuvQGhI7Gm2UDw+sYt5/oNnxBGAHRpju7hXm05F97AM8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4KRng7nsvxvF/lsVBd8zFVY5imSrMf6EuP/y1T0su2Y=;
	b=VFAlXyYUznNj1hnjr1KUGXhfZt+KSDozcqRsPI6abemuFhO9FdqjM9rEr+SI3Tmn9GCv
	 ZqvSl0BxkyCqoVv83tqPnb0QKBD5QXG7a0j7N4Y6dK4nV8o3IHrMpr1Aa8r/1R36OYjil
	 ZALCCpOBL6Aa3657ext5q1zJiOxv6m8e2npsXef2RBkGpUm//dhS+fPeWzGhObEpUi2Kl
	 BA78ITZt4GG5PPL1AfeLAWqR1W/AWkjq1h5DssxBu2RJ2s/Nz6IapjB1lgFuGQjnp7JpE
	 CUY/dSdvRFALikVvcpJai3pkfyGf6tBTDIDLR0FsmPGSqikubeHbVfFYZRY2MWF6FsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TihQIFGC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD85606CE7C;
	Sat,  7 Nov 2026 15:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TihQIFGC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3880A1F008A1;
	Sat,  7 Nov 2026 15:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064378;
	bh=4KRng7nsvxvF/lsVBd8zFVY5imSrMf6EuP/y1T0su2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TihQIFGC9YpTH0DkC3DULiZqmT6X+Cg+fDUuyAd3/rxUq39hUxjXzqrzhgMzA3v5H
	 lXfsSVVTjj4HmJWA04eRIF+6f1Hjmwh4LIeHucXKxrLScAEpgF7f5M7B6jAtHJV4qF
	 XZ1vCU4vbQoZI9wmcGYQliMsJk+5SY6oVab4pDnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0456/1257] media: platform: mtk-mdp3: Fix device reference leak in mdp_comp_init()
Date: Sat,  7 Nov 2026 08:45:52 -0500
Message-ID: <20261107134952.066766110@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit ff3308afa9c9da0ef9113cb80803588adabef902 ]

mdp_comp_init() takes a reference to the component platform device
with of_find_device_by_node(), but the error path taken when the
clock array cannot be allocated and the one taken for a component
without a GCE EOF event return without dropping it.  The caller
frees the mdp_comp in those cases, so the reference is leaked.

Release the reference on both error paths.

Fixes: c4320f9721fd ("media: platform: mtk-mdp3: dynamically allocate component clocks")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/mediatek/mdp3/mtk-mdp3-comp.c   | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-comp.c b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-comp.c
index 7fcb2fbdd64ee..acb2758a7b42d 100644
--- a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-comp.c
+++ b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-comp.c
@@ -1730,6 +1730,7 @@ static int mdp_comp_init(struct mdp_dev *mdp, struct device_node *node,
 	struct device *dev = &mdp->pdev->dev;
 	struct platform_device *pdev_c;
 	int clk_ofst;
+	int ret;
 	int i;
 	s32 event;
 
@@ -1756,8 +1757,10 @@ static int mdp_comp_init(struct mdp_dev *mdp, struct device_node *node,
 	comp->clk_num = mdp->mdp_data->comp_data[id].info.clk_num;
 	comp->clks = devm_kzalloc(dev, sizeof(struct clk *) * comp->clk_num,
 				  GFP_KERNEL);
-	if (!comp->clks)
-		return -ENOMEM;
+	if (!comp->clks) {
+		ret = -ENOMEM;
+		goto err_put_device;
+	}
 
 	clk_ofst = mdp->mdp_data->comp_data[id].info.clk_ofst;
 
@@ -1782,7 +1785,8 @@ static int mdp_comp_init(struct mdp_dev *mdp, struct device_node *node,
 		if (of_property_read_u32_index(node, "mediatek,gce-events",
 					       MDP_GCE_EVENT_EOF, &event)) {
 			dev_err(dev, "Component id %d has no EOF\n", id);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err_put_device;
 		}
 	} else {
 		event = MDP_GCE_NO_EVENT;
@@ -1791,6 +1795,10 @@ static int mdp_comp_init(struct mdp_dev *mdp, struct device_node *node,
 	comp->gce_event[MDP_GCE_EVENT_EOF] = event;
 
 	return 0;
+
+err_put_device:
+	put_device(&pdev_c->dev);
+	return ret;
 }
 
 static void mdp_comp_deinit(struct mdp_comp *comp)
-- 
2.53.0



