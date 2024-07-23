Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43FF13D896;
	Tue, 23 Jul 2024 18:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760210; cv=none; b=P0934E6jPi/HikaCNK0SXimfcRBv9AbR0h3Iko+zfZyNLJxQYCCquOhrWZXpy2YW4KmmKb9ZuzDOwHXss6/1YggfTlQ81YOEXZWAMNDi5+cTCwuVLBNbxpMcbG8Bgr1c+nvzVpdruis42kOXpx63MDtK5sXCeZq6tUqtPsmDfrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760210; c=relaxed/simple;
	bh=72bQl3bUXkbBAUun1GksGmaKq1qVEF6ykMCnOGGIUOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IGhuHYKsz1js1YhQQTv0m6sxNyVnJ6OaQUDOyWHnflsuU1IX7sqai1rjoZW3FgzLEgBLZXVtJvibwU3U6/ZuHZKtdSChu7lezXGCu6tbL4N2/0+37lBvmHHa8Qcn7CGbqkNAEYQBTEFp5+yh4PUaau7yVrfbxIEMITmUAj44QO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZneiGxKU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZneiGxKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE1EC4AF09;
	Tue, 23 Jul 2024 18:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760210;
	bh=72bQl3bUXkbBAUun1GksGmaKq1qVEF6ykMCnOGGIUOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZneiGxKU3GtKRA4zQ0ONOSYzZwnwYd60c8uAQhObnFY5v5aiJMEFTDNzK0iaj1MU0
	 VgSiKHX1iyGwyYvkRmcJwzbO39U6T+SBf2Jh3tL8UZkjBaJT2HGPiO46EY19AoIhiO
	 XRRJPFSpuYTPY/a0QOEOf5dmuPpCLFOaQ6nVz1qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 109/163] platform/mellanox: nvsw-sn2201: Add check for platform_device_add_resources
Date: Tue, 23 Jul 2024 20:23:58 +0200
Message-ID: <20240723180147.686055074@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 3ef655591424c..abe7be602f846 100644
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



