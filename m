Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E6536C9E5
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302294; cv=none; b=KT4nspqqNErQkxLdy3/63MBC1DyOtn1RT63zo8ACRWCernJYTN8+ey2Q+xD24Lv1hyQv76TIZd9Jp9eGPgXCBYJiGfCYWEitoDcVyE12ZTJ/NLdSdzVLageYWqCeJpswkGtFRwH2FoSioDrhbnlf4zU5b4ZLVLqIdD+qKLyjp+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302294; c=relaxed/simple;
	bh=Pv+fL6GVef+FgVdZCVhjT/6LB5qQlPpjA6XnwVVSTS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPztcBsyD0PTPCYVdMl5ajescVmRlsrISrJ3Jl6w5oV/vZrEkNNqYRg3jxGHNz5HFlyyB4qCqULDap/DQ1OorakMi/flPU9XClgPDGhSqbQM+ACFCZEtekm3al1GBqInYT1busIj/F+HhBeqR5ZAKx4LLiMBLwyrVzCG3V+qYFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WcCpeTzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WcCpeTzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08E0C116D0;
	Sat, 28 Feb 2026 18:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302294;
	bh=Pv+fL6GVef+FgVdZCVhjT/6LB5qQlPpjA6XnwVVSTS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WcCpeTzAQr7YEYUaffIc8DS1Qvb1hRCL3HQaeXx8pa/WvrXU5WZcQ1hoBmHr3iAFN
	 9N2r5RMj52kzIdaAVVa/lBIOwSggMDN/pXE/sR9wDWrrdphDFXZDXCJo/oS48fq1MQ
	 zSjfHtP9Na+SWi4YLsq5JIlF7kqYZdjVoA6QO3VYnaBtVceKKTPyPGWwU+BCNryvST
	 mbHKcWasFtNKBQNBgt4IH13UL8C0ypxBY0A9PgbIYbdwj5rlbNA9L5/DIlTlFm6NVc
	 QW7eyFmbSede1mVE9u+R8F2M4Gu2lAN5d+jRa833gvT1VQbMvBx9S9EBpExytUlTBt
	 DxTIn3G7aDzEA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Billy Tsai <billy_tsai@aspeedtech.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/232] i3c: Move device name assignment after i3c_bus_init
Date: Sat, 28 Feb 2026 13:07:40 -0500
Message-ID: <20260228181127.1592657-7-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Billy Tsai <billy_tsai@aspeedtech.com>

[ Upstream commit 3502cea99c7ceb331458cbd34ef6792c83144687 ]

Move device name initialization to occur after i3c_bus_init()
so that i3cbus->id is guaranteed to be assigned before it is used.

Fixes: 9d4f219807d5 ("i3c: fix refcount inconsistency in i3c_master_register")
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260112-upstream_i3c_fix-v1-1-cbbf2cb71809@aspeedtech.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 44574474bda35..fea1f852358c2 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2764,7 +2764,6 @@ int i3c_master_register(struct i3c_master_controller *master,
 	INIT_LIST_HEAD(&master->boardinfo.i3c);
 
 	device_initialize(&master->dev);
-	dev_set_name(&master->dev, "i3c-%d", i3cbus->id);
 
 	master->dev.dma_mask = parent->dma_mask;
 	master->dev.coherent_dma_mask = parent->coherent_dma_mask;
@@ -2774,6 +2773,8 @@ int i3c_master_register(struct i3c_master_controller *master,
 	if (ret)
 		goto err_put_dev;
 
+	dev_set_name(&master->dev, "i3c-%d", i3cbus->id);
+
 	ret = of_populate_i3c_bus(master);
 	if (ret)
 		goto err_put_dev;
-- 
2.51.0

