Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604C33BD63C;
	Wed, 20 May 2026 16:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294905; cv=none; b=J3/DEqy+ET3uw9ceb/VOBukYgLJk0uXI0oxMpN/DQzkYK397a7tmv4ECgiAkdDTHJKkxp3qiveJljwmEteTkbwiLqQeMjxut/EY7B+GW6dW+JryFduPqq9E60mBr5+xtZy1hH5LM+K/5/QtkMacSDajtuwjBwV3vwgTdhn811Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294905; c=relaxed/simple;
	bh=VQKi9IxRDb/ULUQnL9cFNXY2pMucMoXT7wB6Jtew/vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPDOosi9CSLzUeR1g7bvBnmnJbDi7pntjfJCvIaklDaBPrLXs5Gks9mOjLAyF1rHrm0T9BUvVGN8Lz1mCk//cJ5He/3NdItToW8q4c65IWe4E6FJvd16QeHSvLVee2eEo23KryRGi9/rSmc34iNiOuwViocy3J2B/Bu2dJoP0Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/p1EjjO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/p1EjjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9420F1F000E9;
	Wed, 20 May 2026 16:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294903;
	bh=2pj7VcDUxjD68h7Fl2vNva2SxByewJ3ffTRRICRcaFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z/p1EjjOTOZq2BzHGX7Y0A2vgeRJ6HIsEhhff7Drs92b5AMHmGS70moeA8FEWfWMC
	 r6PpAh5zeSDtfQg4dpaRin5UMD6ALa+aMdQOr2MfGqR0arDl18SMWXRq8RKFNY3X7Q
	 VHYrwM5ZSbvPrJPznNMaTuBGJ42uJMmlYRRZeklY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Haoyu Lu <hechushiguitu666@gmail.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0165/1146] ACPI: AGDI: fix missing newline in error message
Date: Wed, 20 May 2026 18:06:55 +0200
Message-ID: <20260520162152.025706034@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoyu Lu <hechushiguitu666@gmail.com>

[ Upstream commit b178330b67abb7293b6de28b2a49d49c83962db5 ]

Add the missing trailing newline to the dev_err() message
printed when SDEI event registration fails.

This keeps the error output as a properly terminated log line.

Fixes: a2a591fb76e6 ("ACPI: AGDI: Add driver for Arm Generic Diagnostic Dump and Reset device")
Reviewed-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Signed-off-by: Haoyu Lu <hechushiguitu666@gmail.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/arm64/agdi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/arm64/agdi.c b/drivers/acpi/arm64/agdi.c
index feb4b2cb4618e..0c2d9d6c160be 100644
--- a/drivers/acpi/arm64/agdi.c
+++ b/drivers/acpi/arm64/agdi.c
@@ -36,7 +36,7 @@ static int agdi_sdei_probe(struct platform_device *pdev,
 
 	err = sdei_event_register(adata->sdei_event, agdi_sdei_handler, pdev);
 	if (err) {
-		dev_err(&pdev->dev, "Failed to register for SDEI event %d",
+		dev_err(&pdev->dev, "Failed to register for SDEI event %d\n",
 			adata->sdei_event);
 		return err;
 	}
-- 
2.53.0



