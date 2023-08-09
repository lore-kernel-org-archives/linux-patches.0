Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253E71773D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACA2C433C8;
	Wed,  9 Aug 2023 11:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579736;
	bh=3c7ap01Zl4Uhy4WQkYjigLEqaNEEdIkr+TE3d7D20RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1F/lUN9vqLbXbQv35067q3jTyGpW8AX/r+GuGOgZYlri1tJ56R9vmQB52d80b+Qt/
	 k1W4ujNZYvpFcCpGNprIj1uJHW1IhVSUkK5yBzj61gIMgCUR8QuQA/BXVyWPB7oJw/
	 yPCeDX/0jgnZadBUjX5PckSdkvaUatagG89TiffM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 097/323] mfd: intel-lpss: Add missing check for platform_get_resource
Date: Wed,  9 Aug 2023 12:38:55 +0200
Message-ID: <20230809103702.497513298@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit d918e0d5824495a75d00b879118b098fcab36fdb ]

Add the missing check for platform_get_resource and return error
if it fails.

Fixes: 4b45efe85263 ("mfd: Add support for Intel Sunrisepoint LPSS devices")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20230609014818.28475-1-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel-lpss-acpi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/intel-lpss-acpi.c b/drivers/mfd/intel-lpss-acpi.c
index fc44fb7c595bc..281ef5f52eb55 100644
--- a/drivers/mfd/intel-lpss-acpi.c
+++ b/drivers/mfd/intel-lpss-acpi.c
@@ -92,6 +92,9 @@ static int intel_lpss_acpi_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	info->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!info->mem)
+		return -ENODEV;
+
 	info->irq = platform_get_irq(pdev, 0);
 
 	ret = intel_lpss_probe(&pdev->dev, info);
-- 
2.39.2



