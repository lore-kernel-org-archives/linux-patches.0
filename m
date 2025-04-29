Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D342A24337C;
	Tue, 29 Apr 2025 17:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947233; cv=none; b=FKiZiVNNZxwL7HPWkO64LRwyn2HfzeeROc8sreZd2v4F7IcTSJEIpQwwpC9ggdY7qrXsQYcmqLot90WVsMLYyx0GzTWXD60im51s621txopFwKfu6nOh7D0o8PQ0XtwyRTsOyE2v1zJ+h982a3okTOGSnayhu2sJKLv9QD5Ye8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947233; c=relaxed/simple;
	bh=lw7xV+1YW+IHIQ8gLWwlRjGE/nTqNPQfvifou7q5ZVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRO1lKpIOn+oKwCifti0TWlWAW9tWRFwoJ1UdV7v8dD7EoL3bM2jn0ZslhUbWySDPbQcziibFeZisgKV58hwrOpSfv8XsqE9t152PUgOpkNfPuuB7+DmWl+F+R0u6qNAqvp9eLNbM57gYFw2YaQExMSLVmqf/niG7Rv5mN94eHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrYb90mJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrYb90mJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DCAC4CEE3;
	Tue, 29 Apr 2025 17:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947233;
	bh=lw7xV+1YW+IHIQ8gLWwlRjGE/nTqNPQfvifou7q5ZVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrYb90mJ5r9NOTgjT/rQDwmtL1RFAUWPql1ETAHz0F7DS4c1BO4DyrI7raFVvvs/K
	 50FcP8PmuEcgFBuG5wmx+u9DBCjpeBFMuUX2tfoRvmfUsmx9r3Oi5zr53MjSVGEGko
	 EOsr5uBiJX7CdACNOQpe47G+HIOdbtyPuhSpxqZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
	Sylwester Nawrocki <snawrocki@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 214/286] soc: samsung: exynos-chipid: avoid soc_device_to_device()
Date: Tue, 29 Apr 2025 18:41:58 +0200
Message-ID: <20250429161116.751035172@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit d1141886c8d72ad77920e6e4b617d366e6e3ee8a ]

soc_device_to_device() seems to be discouraged [1] so remove it in favor
of printing info message with platform device.  This will only change
the prefix in the info message from "soc soc0: " to "exynos-chipid
10000000.chipid:".

[1] https://lore.kernel.org/lkml/20191111052741.GB3176397@kroah.com/

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Sylwester Nawrocki <snawrocki@kernel.org>
Tested-by: Sylwester Nawrocki <snawrocki@kernel.org>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Tested-by: Alim Akhtar <alim.akhtar@samsung.com>
Link: https://lore.kernel.org/r/20210919093114.35987-2-krzysztof.kozlowski@canonical.com
Stable-dep-of: c8222ef6cf29 ("soc: samsung: exynos-chipid: Add NULL pointer check in exynos_chipid_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/samsung/exynos-chipid.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/soc/samsung/exynos-chipid.c b/drivers/soc/samsung/exynos-chipid.c
index 2ab6ce71e9be5..2b02af5d2faff 100644
--- a/drivers/soc/samsung/exynos-chipid.c
+++ b/drivers/soc/samsung/exynos-chipid.c
@@ -103,8 +103,7 @@ static int exynos_chipid_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, soc_dev);
 
-	dev_info(soc_device_to_device(soc_dev),
-		 "Exynos: CPU[%s] PRO_ID[0x%x] REV[0x%x] Detected\n",
+	dev_info(&pdev->dev, "Exynos: CPU[%s] PRO_ID[0x%x] REV[0x%x] Detected\n",
 		 soc_dev_attr->soc_id, product_id, revision);
 
 	return 0;
-- 
2.39.5



