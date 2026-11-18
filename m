Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036270;
	b=ACJNTz3aXx4bLlUT3ByS0ybnggdwcyL9eo2eZNA4lQqiaNl7j4+cGrNDVtOHeOd2UgXS
	 oKZFPre2gTMkrApKUlb3QaqmPrk3uWZ/2BXK0+KC5m5mqwQ36QwuIHG5N0KnyGhlQBb9E
	 5aHwALr6oeMAhMWjeh/Qp6Q2tKvdWBpWRERlQQwixroeKpvp7n9rLhkWSIQrXEzvIc+QW
	 Csm5IlEzT2jzLVhTkJEOglV7L/TuuAfjMpL91iosJZEyxKPJR50AUZXBJSQkb2YwD3O+x
	 w0Boyx2IQ+zJo0LzfLfWXQB4yE8fNQrXjUyhyanlWf/nj9TePEn29cKBrE753VSAAVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036270;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qMyGMQp2McEA0YK/aTuCnSS6FJYZlgDm1EPGBNOVkWo=;
	b=ChGbbezMb9DP+D7WOrR9dY3Tp/ONZYNyqTQhh9lSGFGl+t/7/UrtuqiF0PuJnhngt7f9
	 BuwERnxJb/erNLu/CVVGghaD7/V9BgTRSUhtBtWyO5bUR74EKsmVJK1PS9aI/Rsyk0ZTI
	 ws+/MrQsFVZwR+NbqsNm0I8hd6ZpbzS1sZUGmvo61oZJ71Id2uRrPjoBbTGd8jFnucWuW
	 aT6peVR9y+U1Ec/dqzj/tj7RlPjLLE+wjGigY5TwLLI34n2FIC4qohhjjY2lIQZ3Lc+aX
	 EBP5In/wvuUVrZpv2/722MvjlsTU60PZcPgawTGe2GrErbmSZTdM6mGl3+fMD3skc+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A27hFZkg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CABD606A325;
	Wed, 18 Nov 2026 21:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A27hFZkg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BD21F000C4;
	Wed, 18 Nov 2026 21:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036269;
	bh=qMyGMQp2McEA0YK/aTuCnSS6FJYZlgDm1EPGBNOVkWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A27hFZkgFaZSgJdUV2ZkRpDLFkuvWRNeMb8OlzlcJvvLanxs6JHVI2Bg4/P5Df/SH
	 ySYPe/C2KlEo4HUpXzkQ/BrNCBZ+8jAJ4WuX128OX+4G+fPOHjF0xc+8rDvBAQDFy7
	 Md993i9Ijs+C1h+7nUCsJq44r7iHTVvuGV0AAgfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0998/3318] media: platform: mtk-mdp3: Fix device reference leak in mdp_comp_init()
Date: Wed, 18 Nov 2026 15:27:00 +0100
Message-ID: <20261118150349.788368062@linuxfoundation.org>
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
index 667933ea15f44..2f2cc13619473 100644
--- a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-comp.c
+++ b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-comp.c
@@ -927,6 +927,7 @@ static int mdp_comp_init(struct mdp_dev *mdp, struct device_node *node,
 	struct device *dev = &mdp->pdev->dev;
 	struct platform_device *pdev_c;
 	int clk_ofst;
+	int ret;
 	int i;
 	s32 event;
 
@@ -953,8 +954,10 @@ static int mdp_comp_init(struct mdp_dev *mdp, struct device_node *node,
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
 
@@ -979,7 +982,8 @@ static int mdp_comp_init(struct mdp_dev *mdp, struct device_node *node,
 		if (of_property_read_u32_index(node, "mediatek,gce-events",
 					       MDP_GCE_EVENT_EOF, &event)) {
 			dev_err(dev, "Component id %d has no EOF\n", id);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err_put_device;
 		}
 	} else {
 		event = MDP_GCE_NO_EVENT;
@@ -988,6 +992,10 @@ static int mdp_comp_init(struct mdp_dev *mdp, struct device_node *node,
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



