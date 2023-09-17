Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A07746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C27C433C7;
	Sun, 17 Sep 2023 20:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982527;
	bh=LVjsaNlDxYQFNpdiV3U1zFKaRYzwnDubz6i5Jrb9HRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y0m95bciancUIN4at3hxUIfsB8w16mDST4/xlvaFGXiamd6lddPzhfw97QAhOM3bD
	 y24CUTDg/rEI5mzTUHFjDUH4d8Ns0LMZlGJUf29vPalNXfXV0FU7hN4fPE336meqB4
	 scvI7FplPgfi2HU2akQgaMKqP9ukuRuDgeU3FwUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Irui Wang <irui.wang@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 249/511] media: mediatek: vcodec: Return NULL if no vdec_fb is found
Date: Sun, 17 Sep 2023 21:11:16 +0200
Message-ID: <20230917191119.832631539@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Irui Wang <irui.wang@mediatek.com>

[ Upstream commit dfa2d6e07432270330ae191f50a0e70636a4cd2b ]

"fb_use_list" is used to store used or referenced frame buffers for
vp9 stateful decoder. "NULL" should be returned when getting target
frame buffer failed from "fb_use_list", not a random unexpected one.

Fixes: f77e89854b3e ("[media] vcodec: mediatek: Add Mediatek VP9 Video Decoder Driver")
Signed-off-by: Irui Wang <irui.wang@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c b/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
index 71cdc3ddafcbb..0b2cde3b3439a 100644
--- a/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
+++ b/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
@@ -226,10 +226,11 @@ static struct vdec_fb *vp9_rm_from_fb_use_list(struct vdec_vp9_inst
 		if (fb->base_y.va == addr) {
 			list_move_tail(&node->list,
 				       &inst->available_fb_node_list);
-			break;
+			return fb;
 		}
 	}
-	return fb;
+
+	return NULL;
 }
 
 static void vp9_add_to_fb_free_list(struct vdec_vp9_inst *inst,
-- 
2.40.1



