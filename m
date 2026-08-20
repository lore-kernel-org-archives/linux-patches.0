Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E2E442B2E;
	Thu, 20 Aug 2026 16:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243221; cv=none; b=DjT//Mblw9FS3R6EcqBOHrBwunFL8uIeCwCV80UOJt4lWYB9RNgCEWDd298Y0iNXqxRvICnLTtq9ec0qEzMXctHlVEA+U9Y3V09EeP052rGwETj4kesMC1AlWv4xKv5QSMFA0ncxZliOdyc6fOu3WYe38UzzoP9yZYm8XzVQcwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243221; c=relaxed/simple;
	bh=uVy1sYCPcHy+bOI+zy23e1hfkyme0mLItfI3WfPZi8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6tZx6TRR9fYs1Zj1ys+udI/Gf0i4ZIZSJXJvtXSUc43t9YPJkb+mq4JPt896xh6uEPuPopT4d4Gas66lvvXLvJlmQcqVEW1XVrvausi9RsmZMg7CYv/AWvcnmfV/0c+Lb8BvZEPg62Nnhai84uFxdYUQoD/AnSkRx+ouRne7qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WL6edsCt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WL6edsCt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FE11F000E9;
	Thu, 20 Aug 2026 16:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243220;
	bh=kd6N8TZ4fxXJ0j2meanG6k7naA/3vNpo7tJEpeGmeHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WL6edsCtWdnRzjQ7+JUMRc6nJnuazOaitXjbbs0wsyBByIX74y1xNRdWbUORHrtuT
	 81vS9oeOT2ikmfGJ+4LGlwubaoaDQgb1t3cFpP2rpn2Z52Uv8k0AtLIoG2YhhJ2wSH
	 IiK8btQd74hcUtG9/IO7CGBmJnCbzo1BTfmSzVac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fullway Wang <fullwaywang@outlook.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Andrey Troshin <drtrosh@yandex-team.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/272] media: mtk-vcodec: potential null pointer deference in SCP
Date: Thu, 20 Aug 2026 16:53:06 +0200
Message-ID: <20260820145231.309929878@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Fullway Wang <fullwaywang@outlook.com>

[ Upstream commit 53dbe08504442dc7ba4865c09b3bbf5fe849681b ]

The return value of devm_kzalloc() needs to be checked to avoid
NULL pointer deference. This is similar to CVE-2022-3113.

Link: https://lore.kernel.org/linux-media/PH7PR20MB5925094DAE3FD750C7E39E01BF712@PH7PR20MB5925.namprd20.prod.outlook.com
Signed-off-by: Fullway Wang <fullwaywang@outlook.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
[Andrey Troshin: backport fixs from
 drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_scp.c
 to drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_scp.c]
Signed-off-by: Andrey Troshin <drtrosh@yandex-team.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_scp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_scp.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_scp.c
index d8e66b645bd8..27f08b1d34d1 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_scp.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_scp.c
@@ -65,6 +65,8 @@ struct mtk_vcodec_fw *mtk_vcodec_fw_scp_init(struct mtk_vcodec_dev *dev)
 	}
 
 	fw = devm_kzalloc(&dev->plat_dev->dev, sizeof(*fw), GFP_KERNEL);
+	if (!fw)
+		return ERR_PTR(-ENOMEM);
 	fw->type = SCP;
 	fw->ops = &mtk_vcodec_rproc_msg;
 	fw->scp = scp;
-- 
2.53.0



