Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4703F11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCCC7C433C9;
	Mon, 11 Sep 2023 15:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444490;
	bh=1UGwEQrFE3rUPrY26es/KUVUgjqF1Vl5uy50RnZ2Gls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1eN+6AU+iD7MqcxR0XhDNhJiA5ghOGlOz81Nh+0qo7BvUpERwWT+eeMH1V1tKOkFO
	 7upGGmBlhBc9vV2c0RyTyoet2OvqW3hZhY7uy6jbONCPEJVI4VmuEV9ANJLtmOhn39
	 bbvugaSFObNyHoDMYj4S7UX+ihFmEqtFh4DI8hbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	ming_qian <ming.qian@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/600] media: amphion: use dev_err_probe
Date: Mon, 11 Sep 2023 15:40:44 +0200
Message-ID: <20230911134633.951087821@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 517f088385e1b8015606143e6212cb30f8714070 ]

This simplifies the code and silences -517 error messages. Also
the reason is listed in /sys/kernel/debug/devices_deferred.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: ming_qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_mbox.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/amphion/vpu_mbox.c b/drivers/media/platform/amphion/vpu_mbox.c
index bf759eb2fd46d..b6d5b4844f672 100644
--- a/drivers/media/platform/amphion/vpu_mbox.c
+++ b/drivers/media/platform/amphion/vpu_mbox.c
@@ -46,11 +46,10 @@ static int vpu_mbox_request_channel(struct device *dev, struct vpu_mbox *mbox)
 	cl->rx_callback = vpu_mbox_rx_callback;
 
 	ch = mbox_request_channel_byname(cl, mbox->name);
-	if (IS_ERR(ch)) {
-		dev_err(dev, "Failed to request mbox chan %s, ret : %ld\n",
-			mbox->name, PTR_ERR(ch));
-		return PTR_ERR(ch);
-	}
+	if (IS_ERR(ch))
+		return dev_err_probe(dev, PTR_ERR(ch),
+				     "Failed to request mbox chan %s\n",
+				     mbox->name);
 
 	mbox->ch = ch;
 	return 0;
-- 
2.40.1



