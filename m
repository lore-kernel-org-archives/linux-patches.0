Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9803625E831;
	Tue, 11 Mar 2025 15:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706543; cv=none; b=LxMl4EnBU/ifKqZgu7kH98mPA3NsFleoaCZEpVyeHO84AZax20tNH7Oct4Flqbp2RGcT1BMU5Fi13INtrARd6h71KMlZJqEU3iYo0u6MhO/5InEbulS/PjC7fyjr0qIDi1GmIkiUZe1F44y7Sy3O2DLXsRTMgu7PeXytp0PaCI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706543; c=relaxed/simple;
	bh=ew7bH6fp7ponO6fDcSS5iVhgNw39eT5RPJbVSqeyRuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHWfuZTaX3BPjyYLcXk/Ymtg6ixDA5x5Omdb/GWNTORMA7ImS0p9IN5UIhc0+jAcNHCNHY+TAlg5GZGUsKcwBlbWnamEv0zI6aJlweiYyEmdgQD1AM0Ef0uZWcTvPYARWz0zmDxmMhezfGlf781H9SitUoKQ8NQBSfwU1xF9kOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z63gy5wz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z63gy5wz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10B8C4CEE9;
	Tue, 11 Mar 2025 15:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706543;
	bh=ew7bH6fp7ponO6fDcSS5iVhgNw39eT5RPJbVSqeyRuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z63gy5wzoRNkNw6YNPgRuDddl2dBcjSnSyCRU1CSJm2li6RrIzbIRQ1lZ+TAw/P6m
	 EiRKUCyW8r+PqqaVY6Ojvf9XR+xPpfbgy/i8P/zfGEd6UY7bfAdNt6JYN/8zjc3owl
	 i5ucS687lV6bjLNgMpSbUfx5pL3fXJw0hVUoi5Js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/462] media: camif-core: Add check for clk_enable()
Date: Tue, 11 Mar 2025 15:55:51 +0100
Message-ID: <20250311145801.710229358@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit 77ed2470ac09c2b0a33cf3f98cc51d18ba9ed976 ]

Add check for the return value of clk_enable() to gurantee the success.

Fixes: babde1c243b2 ("[media] V4L: Add driver for S3C24XX/S3C64XX SoC series camera interface")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s3c-camif/camif-core.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
index 422fd549e9c87..aa2427cb2e63b 100644
--- a/drivers/media/platform/s3c-camif/camif-core.c
+++ b/drivers/media/platform/s3c-camif/camif-core.c
@@ -529,10 +529,19 @@ static int s3c_camif_remove(struct platform_device *pdev)
 static int s3c_camif_runtime_resume(struct device *dev)
 {
 	struct camif_dev *camif = dev_get_drvdata(dev);
+	int ret;
+
+	ret = clk_enable(camif->clock[CLK_GATE]);
+	if (ret)
+		return ret;
 
-	clk_enable(camif->clock[CLK_GATE]);
 	/* null op on s3c244x */
-	clk_enable(camif->clock[CLK_CAM]);
+	ret = clk_enable(camif->clock[CLK_CAM]);
+	if (ret) {
+		clk_disable(camif->clock[CLK_GATE]);
+		return ret;
+	}
+
 	return 0;
 }
 
-- 
2.39.5



