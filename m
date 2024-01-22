Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D68F65BC9;
	Tue, 23 Jan 2024 01:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975101; cv=none; b=YYehOW1gtFtBNvKm6HObXhIR3nJiSetdN728a/U9eWLrufc4mFZHWZdJsqpexNdY5xJTg1tSvSvNFXMSnsmxvJX2W2unnQF27OCvVsoS/83CZagJ+sNlaz6+o11NbyYJbp5FLt3DcYZTGZCwhryEZUN68CCtmpNdvINhmWuLphk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975101; c=relaxed/simple;
	bh=uQZ7wRJwgmxRfJv+Nsc2cxDahr5YxIPhnsegepZqBsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApWi1kcEkV5+3wlOzNQ20W162goKGZgFRvfV0Zfb8Y0A816Y2Cp71px3zoAL/C8xEExOGO0Y0TgJ5Aat+R9FfVk12fNWzEX10wosBBrzML4MKjiw/fGO1Zj8u4+XONJh673JSTsxgu/ACPIweJ7MCzE4FfjetPMVMQ7INkMxdVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xm8GHxv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xm8GHxv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5715CC433C7;
	Tue, 23 Jan 2024 01:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975101;
	bh=uQZ7wRJwgmxRfJv+Nsc2cxDahr5YxIPhnsegepZqBsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xm8GHxv80TB/gspFgHzdEIyyNkN8j32sg2iTEhykBzZOJkHl80tW6y2L2+dwbzlb0
	 ZNCBUH4QD14KoJmh/+f2vcsRZkC8f+26EM+mG5iwCa+kg9RFzFipNOJEhXzw1yqmdf
	 CCt6qguiH811lFAogUnYbmFli8ARFUI/+nnBXTNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Ming Qian <ming.qian@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 238/583] media: amphion: Fix VPU core alias name
Date: Mon, 22 Jan 2024 15:54:49 -0800
Message-ID: <20240122235819.274888013@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



