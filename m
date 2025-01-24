Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B101D63C9
	for <patches@lists.linux.dev>; Fri, 24 Jan 2025 04:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737691614; cv=none; b=tnaE78aJ+GzN9xdXtUmnYOJoGj6gS39YK71XvojfwIiQEkQrlx39oJqalXjCT4LiM4cjQ8KDomEaYbOaKKBKneSZzxAeR32CnvDL+We5+cd8iYCvRamhF4bjP7C3yjgUYpbcwidzSjxBN/P7IgZc43VQd8J41Xys/UzIh7k53xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737691614; c=relaxed/simple;
	bh=ea0+XODqA4zgxKtAhQAQx7ZqtBm9OFkMPPtrp7Ln3+A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=njpwXvRWc+SYD6B8vl07r6Ps0HBHfti1GDf6HHAfqVndR2Lpja9GipdB0vVYgO1Yra66g3nsz6jUUIl46PIp9NB5SWBPIZiJGJbpmKTBtY5VKEXvYAXLG8367AnoNxoGkMXmB9/f5OVpsCntgtm8ZPBDETWudYD34PjETdiTQKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BaVk5TF/; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BaVk5TF/"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2165cb60719so28566305ad.0
        for <patches@lists.linux.dev>; Thu, 23 Jan 2025 20:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737691612; x=1738296412; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vj1NaMTUsVA57ckq/QD9h243Rs/TkZbkHkyDFlhTqVQ=;
        b=BaVk5TF/5yqTOILraiAk4BznDm4kc/DoyvPI4jrLxah2eRw+Q3P6tinL1JhtARZEtW
         8Q0PSGKi/VXhQUyNxEcvrX+DJEZ/0u14PDv298586WX5osm5gOAcNXxRQ6PrRzekIEyx
         z7s0i5Fzrg3SiOK5RaVquhRBRdzSXlWcrvWCuzO9xopn/eYTolz65XZhpxpucqJtfolc
         nHhnjyJrikm1pPZKbbw4ziIPCd6qbq8TA0iaUW2MhaA0XHjRVD59AYrJOD0FmBx12grE
         xDvIYlBq1N8HmmN8CMru27IE/0gyWr+nMWcMFSAhkxjhleyp56RPvfIzAWuRp4jvs7zn
         1C/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737691612; x=1738296412;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vj1NaMTUsVA57ckq/QD9h243Rs/TkZbkHkyDFlhTqVQ=;
        b=mmQv31kMFFnbgAa/uYh0efcG8O79Uaf5T7fBCqaLYYXxSddaFs+qLQmOjs3sSYGHup
         7LnsCeIXnW/EpMyiSRd30CxQkTqneFOiQr8wo3XhOy/rSXqkdP62NdLBN/W0cLq9fZGQ
         lqwb6PNA6JZxRxV7Px6tgMQapbTU0a2B5GSpLF/lLe/K+T7Xi9AZ7BMJykAsArAJGILs
         ARFuGAWXJBTSfcmSrKqISR1A8dA+gOEyfgmOvGT+QyGU4WQQyl0MjI0JyY5K4d/HDKAm
         xoSqwJ1wMr6NrVMLB601CV/43IeZPemPFI4T6DXXebxvet0pKrd/fRTN3o9Uz2OLdoLE
         QE/Q==
X-Gm-Message-State: AOJu0Yyr/MwHtqBGxEKKJbfx+cTGvHdT9r00vCf/hHXDlAgKL8HMAJhd
	TyAHh3ib/3s1ri22wUudcGmxTEMFpbZ5xIvZI49KC2DS/FD1FZ4W
X-Gm-Gg: ASbGncuUC4smWs5u0fahH3utqIGfHCVSYj0+kYxLHFLOzWhQCg8S24mMichd4AzjMXW
	sSxh3dvn1eD4apzW1nJjbHz0g6Ah9zrsYXLS++bNFnklZ0/jRHv4PV5xmwUeuHlYTLbQLE4J56R
	yDYqdA40xnqVRUSVi95pZWkH+Wh8Ugn8OkXZqINyc3uIWbif28Xc3uP9NKhIcwX8lCyvalqw/gT
	l5qxnpZZ0L6lBT80vEFUxxw4GvAhpNgMXPL3C0szqHhMLwD7GaQ5EglvgJ5/kZTkyW/Km88hKsw
	JOP4rgzz2TIqwWKNAB++Z32HNu96Bg==
X-Google-Smtp-Source: AGHT+IF3SHS7uGw6j2HUHGRc2o6x9hUUGZICmg9DQKSnpjYz1OzyDi2k9jgSfX5GniU24Huia3n0zA==
X-Received: by 2002:a05:6a00:a2a:b0:72d:8af9:bc64 with SMTP id d2e1a72fcca58-72daf9ec17dmr31990363b3a.9.1737691611690;
        Thu, 23 Jan 2025 20:06:51 -0800 (PST)
Received: from jren-d3.localdomain ([221.222.59.195])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a78f145sm795398b3a.167.2025.01.23.20.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 20:06:51 -0800 (PST)
From: Imkanmod Khan <imkanmodkhan@gmail.com>
To: stable@vger.kernel.org
Cc: patches@lists.linux.dev,
	mchehab@kernel.org,
	fullwaywang@outlook.com,
	gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org,
	tiffany.lin@mediatek.com,
	andrew-ct.chen@mediatek.com,
	yunfei.dong@mediatek.com,
	matthias.bgg@gmail.com,
	linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Imkanmod Khan <imkanmodkhan@gmail.com>
Subject: [PATCH 6.1.y] media: mtk-vcodec: potential null pointer deference in SCP
Date: Fri, 24 Jan 2025 12:06:41 +0800
Message-ID: <20250124040641.7431-1-imkanmodkhan@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fullway Wang <fullwaywang@outlook.com>

[ Upstream commit 53dbe08504442dc7ba4865c09b3bbf5fe849681b ]

The return value of devm_kzalloc() needs to be checked to avoid
NULL pointer deference. This is similar to CVE-2022-3113.

Link: https://lore.kernel.org/linux-media/PH7PR20MB5925094DAE3FD750C7E39E01BF712@PH7PR20MB5925.namprd20.prod.outlook.com
Signed-off-by: Fullway Wang <fullwaywang@outlook.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
[ To fix CVE: CVE-2024-40973, modified the file path from drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_scp.c
 to drivers/media/platform/mediatek/vcodec/mtk_vcodec_fw_scp.c and minor conflict resolution ]
Signed-off-by: Imkanmod Khan <imkanmodkhan@gmail.com>
---
 drivers/media/platform/mediatek/vcodec/mtk_vcodec_fw_scp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_fw_scp.c b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_fw_scp.c
index d8e66b645bd8..27f08b1d34d1 100644
--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_fw_scp.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_fw_scp.c
@@ -65,6 +65,8 @@ struct mtk_vcodec_fw *mtk_vcodec_fw_scp_init(struct mtk_vcodec_dev *dev)
 	}
 
 	fw = devm_kzalloc(&dev->plat_dev->dev, sizeof(*fw), GFP_KERNEL);
+	if (!fw)
+		return ERR_PTR(-ENOMEM);
 	fw->type = SCP;
 	fw->ops = &mtk_vcodec_rproc_msg;
 	fw->scp = scp;
-- 
2.25.1

