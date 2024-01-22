Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BAE3C24;
	Tue, 23 Jan 2024 00:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969460; cv=none; b=HxFLVlIR/o7KcKVZf1c9iUVgLYZBOoSkzefBWisdVHuSs7fk1r5Rx4f4+yeK+454ZU4sm3flQvWJ/Unh+zbAJoRV+bW9TLZ1q5b7Kbtl2DQ+PusPwruLauScq/WJF4zXILaB7CQazgq0GIawfcqM6DNSiGwk90U+PdjcY61gj3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969460; c=relaxed/simple;
	bh=SVeZgmFjHlPkg+V6/OG2A5K/o/yvwJZ0QOXfbBFTdHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+1ojvYvPltIqPxNplYXMxsh1Z0I4Ano2VPsbkAC8iMDdXMXViwC4BrcQVeaiK6gBGT/lu1dlzRsCEQM0j3M8Xo6uU4K5SXM9A+/XjGSfIWaDqiCPtl1unIr5er1TRR9Fjk1Socu28FquhKK677dONvB5lRSu3cyhk7rAQ7rTrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PwCwBE9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PwCwBE9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE01C43390;
	Tue, 23 Jan 2024 00:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969460;
	bh=SVeZgmFjHlPkg+V6/OG2A5K/o/yvwJZ0QOXfbBFTdHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwCwBE9GbqS+TOY1Fq8H5/e8nP2WI2nkWjT7wVFEnoO3uOp9C0Rq4pQv/hY9orQF2
	 f1pvOm94PbDNnJeYj1UgMoKqkwFWdXLy34qJarAa727tDyqjCswLMnJ5DCuv864JVn
	 3QiVDmW4n8KnH5USJu5q4LugLBaN5STlA9CLLjw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Ming Qian <ming.qian@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 259/641] media: amphion: Fix VPU core alias name
Date: Mon, 22 Jan 2024 15:52:43 -0800
Message-ID: <20240122235826.041029745@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit f033c87fda47e272bb4f75dc7b03677261d91158 ]

Starting with commit f6038de293f2 ("arm64: dts: imx8qm: Fix VPU core
alias name") the alias for VPU cores uses dashes instead of underscores.
Adjust the alias stem accordingly. Fixes the errors:
amphion-vpu-core 2d040000.vpu-core: can't get vpu core id
amphion-vpu-core 2d050000.vpu-core: can't get vpu core id

Fixes: f6038de293f2 ("arm64: dts: imx8qm: Fix VPU core alias name")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/amphion/vpu_core.c b/drivers/media/platform/amphion/vpu_core.c
index 1af6fc9460d4..3a2030d02e45 100644
--- a/drivers/media/platform/amphion/vpu_core.c
+++ b/drivers/media/platform/amphion/vpu_core.c
@@ -642,7 +642,7 @@ static int vpu_core_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	core->type = core->res->type;
-	core->id = of_alias_get_id(dev->of_node, "vpu_core");
+	core->id = of_alias_get_id(dev->of_node, "vpu-core");
 	if (core->id < 0) {
 		dev_err(dev, "can't get vpu core id\n");
 		return core->id;
-- 
2.43.0



