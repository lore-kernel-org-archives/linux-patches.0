Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB51158A2E;
	Tue, 23 Jul 2024 18:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759383; cv=none; b=QJQ3fVCzkwEr+77Q6WcH+eCl255RRtITu8T46MTkG1RXJT4AoNwbBIpSTCGBN7y5XhKpHCx3uuTQsYDivNsNXSGY/+N4E+FupLAcIW2BfKKwbplMAnlCszwvNTjitYGYK/31wlJ+jK1SyaOV75VDveetOGd+QA5J9xz5+7m6hSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759383; c=relaxed/simple;
	bh=sV2M6vGbsm8/vLX/MSJYReZBHnsC2qc1fhKzpqk9GIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4Ovo7gPyBM83nbO4LZcpOxTJCOu4+4q6H6vLBq9IWp3/aLbpcCHgPjBofKRrddNEOC1x1OhGOGwJXGTvBECdrJErkteARvJ38ft9hNDF/bZt0PP98JHUy25N9uxCSqP/XzD0QNrvhyW7nQhrcaeml6x9uKwM0uPqvH4KfQ4dxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DO28cDse; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DO28cDse"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D183C4AF09;
	Tue, 23 Jul 2024 18:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759382;
	bh=sV2M6vGbsm8/vLX/MSJYReZBHnsC2qc1fhKzpqk9GIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DO28cDseFm6WjVAWKz8pMVJdAbwWEWXix7e/LN2UlLrBvNgez6nuy3BJiR3G4GFy2
	 n7moEyvNiE4TgNiN5iL1x+lXc5J4RRgMWOZyR8HKJJOeoRYrygW2Nc5xk8TxmPDT5v
	 lg3LtvE8eEOk6KjhReKME4uo8NNWwYqj8cHwtlmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/105] platform/mellanox: nvsw-sn2201: Add check for platform_device_add_resources
Date: Tue, 23 Jul 2024 20:23:43 +0200
Message-ID: <20240723180405.789390107@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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
index 7b9c107c17ce6..f53baf7e78e74 100644
--- a/drivers/platform/mellanox/nvsw-sn2201.c
+++ b/drivers/platform/mellanox/nvsw-sn2201.c
@@ -1194,6 +1194,7 @@ static int nvsw_sn2201_config_pre_init(struct nvsw_sn2201 *nvsw_sn2201)
 static int nvsw_sn2201_probe(struct platform_device *pdev)
 {
 	struct nvsw_sn2201 *nvsw_sn2201;
+	int ret;
 
 	nvsw_sn2201 = devm_kzalloc(&pdev->dev, sizeof(*nvsw_sn2201), GFP_KERNEL);
 	if (!nvsw_sn2201)
@@ -1201,8 +1202,10 @@ static int nvsw_sn2201_probe(struct platform_device *pdev)
 
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



