Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF3C1ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62281C433C8;
	Tue, 25 Jul 2023 11:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285249;
	bh=+yRqOGx+1ShMjJWNWhZw24bxhZTcXzKn+wHD2XmyRW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HFxGBUidqCfWYx+07XKlxMPfJb/NHf2g1NKxqR9OussLsmb85q+BJF/dzL3tVk7kx
	 R5TqfCqZwwYpSabZ3k9k5Rvasr8v9dKb89l5HhnU6DL2bKZnS7DXxG1R+xp3b5f88E
	 uPXynpDtd8Yk1IKEFMVCCVJybv7rf+29Zv6MNFfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 138/313] mfd: intel-lpss: Add missing check for platform_get_resource
Date: Tue, 25 Jul 2023 12:44:51 +0200
Message-ID: <20230725104526.978482605@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
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
index 045cbf0cbe53a..993e305a232c5 100644
--- a/drivers/mfd/intel-lpss-acpi.c
+++ b/drivers/mfd/intel-lpss-acpi.c
@@ -114,6 +114,9 @@ static int intel_lpss_acpi_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	info->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!info->mem)
+		return -ENODEV;
+
 	info->irq = platform_get_irq(pdev, 0);
 
 	ret = intel_lpss_probe(&pdev->dev, info);
-- 
2.39.2



