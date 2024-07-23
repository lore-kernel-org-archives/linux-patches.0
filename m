Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F0C158A06;
	Tue, 23 Jul 2024 18:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759650; cv=none; b=uM73jmj7a5kQ/grifeH9efUjuE4eeuPOW9RyLXMN6fYP5NIbv/e45gvQULUIlggG1Jjwul7/LCMSgTdCG87RyZ8cKeBKRkacuRqdyNzzkravmG37puxp030EykDhlo+tunOAVHwxULr1XVk6QW1sx9QG7tymbLBUmjcn2lOdIw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759650; c=relaxed/simple;
	bh=USAQkLOQiQW6Kd0aQhc5LzJ8EI1MIY4ZJDWBIUjGt18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBN5pzxBUm1N4vXZwCycBviwYr53IG7/sYvtXoW5fvnfN7iAZBJ9QynAboJic7NMNHvYiYC1lP6q9yjM17NSDDUG0Ic92cpldM/NA2Z/c6gLz0y+7TNla12M1VfVo4/OEiyPhFuIfVg+z7XL9LusJ+zji8MyjKMYcoqYYC8B1bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DwTy2xH/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DwTy2xH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4726C4AF0A;
	Tue, 23 Jul 2024 18:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759650;
	bh=USAQkLOQiQW6Kd0aQhc5LzJ8EI1MIY4ZJDWBIUjGt18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DwTy2xH/MiA3OVJhXlWk78hAk2wj5seda08GBfv2FHSB0xvJPrSNv0FlIXk2YHShi
	 5BL+H1dAbV/cjDo/uATDOLAYwWy2FDZRxNQn4hQUDXet4D9wbNjmGgnBSyVAk721z2
	 ELj5Jpxw7olN72zs0Mz2kNhThIfEUWW2PbCt6Kwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/129] platform/mellanox: nvsw-sn2201: Add check for platform_device_add_resources
Date: Tue, 23 Jul 2024 20:23:49 +0200
Message-ID: <20240723180407.914116402@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit d56fbfbaf592a115b2e11c1044829afba34069d2 ]

Add check for the return value of platform_device_add_resources() and
return the error if it fails in order to catch the error.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Link: https://lore.kernel.org/r/20240605032745.2916183-1-nichen@iscas.ac.cn
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/nvsw-sn2201.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/mellanox/nvsw-sn2201.c b/drivers/platform/mellanox/nvsw-sn2201.c
index 75b699676ca6d..1a7c45aa41bbf 100644
--- a/drivers/platform/mellanox/nvsw-sn2201.c
+++ b/drivers/platform/mellanox/nvsw-sn2201.c
@@ -1198,6 +1198,7 @@ static int nvsw_sn2201_config_pre_init(struct nvsw_sn2201 *nvsw_sn2201)
 static int nvsw_sn2201_probe(struct platform_device *pdev)
 {
 	struct nvsw_sn2201 *nvsw_sn2201;
+	int ret;
 
 	nvsw_sn2201 = devm_kzalloc(&pdev->dev, sizeof(*nvsw_sn2201), GFP_KERNEL);
 	if (!nvsw_sn2201)
@@ -1205,8 +1206,10 @@ static int nvsw_sn2201_probe(struct platform_device *pdev)
 
 	nvsw_sn2201->dev = &pdev->dev;
 	platform_set_drvdata(pdev, nvsw_sn2201);
-	platform_device_add_resources(pdev, nvsw_sn2201_lpc_io_resources,
+	ret = platform_device_add_resources(pdev, nvsw_sn2201_lpc_io_resources,
 				      ARRAY_SIZE(nvsw_sn2201_lpc_io_resources));
+	if (ret)
+		return ret;
 
 	nvsw_sn2201->main_mux_deferred_nr = NVSW_SN2201_MAIN_MUX_DEFER_NR;
 	nvsw_sn2201->main_mux_devs = nvsw_sn2201_main_mux_brdinfo;
-- 
2.43.0



