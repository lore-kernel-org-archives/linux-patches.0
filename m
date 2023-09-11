Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1355F1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC86C433C7;
	Mon, 11 Sep 2023 14:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442198;
	bh=Lv1NKOg82lki41tgK0SHqljC2HbKVyyCERc2RsVr6kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3pU75jms3vy4wkA1QOr8NyK9Kka4RcmA3WRM9WRnGKgTo8NI1dPOuvmUi+As6QCC
	 hbdNVh2qaFo3W43zT1Mad7e+AIRQAguMnIrgmB0M8dl0V5pxyFLSuHeke877RkuZ00
	 I/UGfRDNHbxhnrGI0QQKni6ocB71ss1/PELmz3Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Fabio Estevam <festevam@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.5 681/739] media: nxp: Fix wrong return pointer check in mxc_isi_crossbar_init()
Date: Mon, 11 Sep 2023 15:48:00 +0200
Message-ID: <20230911134710.120144229@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

commit 4b60db99babad0254129ddc58e0927ffa9e93e35 upstream.

It should check 'xbar->inputs', when allocate memory for it.

Cc: stable@vger.kernel.org
Fixes: cf21f328fcaf ("media: nxp: Add i.MX8 ISI driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-crossbar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-crossbar.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-crossbar.c
@@ -483,7 +483,7 @@ int mxc_isi_crossbar_init(struct mxc_isi
 
 	xbar->inputs = kcalloc(xbar->num_sinks, sizeof(*xbar->inputs),
 			       GFP_KERNEL);
-	if (!xbar->pads) {
+	if (!xbar->inputs) {
 		ret = -ENOMEM;
 		goto err_free;
 	}


