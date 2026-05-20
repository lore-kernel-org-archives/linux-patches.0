Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53D93546E6;
	Wed, 20 May 2026 17:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297815; cv=none; b=mwblF3SNy4UvfYjYEckco1OXBMKPyMa+0hXBn4tpPoHJOcyfXuxajs4jh/uCrg7L5WpGs7UT6GoZ6D74pxuHY8ynxj+eOeHIgX8KJiyDI3v9rm9vgrvhlhQpKoIGpY1Wakr/8H+m32165TyGzEEQO4R6oo4YCl47xYP7h0P+PX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297815; c=relaxed/simple;
	bh=sWovFjeFgKxADfx/WKPSsZ0yyu01xTdoXKJR8iRwwi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmosAUPZCfizNrHtio0hv5KhPTDT0Uj8vuwxHDvBch/CuLMyd1MimqLJolDTQ4XnPX1e/pTTfYH0iGn9mQi2eyx1TB1zR2B4WBm5C/RLI/11kMPxUD0xq4cUVnGCKIYF2xUdcaQRwEzcLlv00kMjCjrOA2G6oQjpy7R2wV6awy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHPydi3m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHPydi3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468DD1F000E9;
	Wed, 20 May 2026 17:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297814;
	bh=QEZaBYVZLKiulq5FKGdU8rBikIuS9aMg4zEjUuYn9sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wHPydi3m7Ec1mMbK6IaQiIEWdGLkCJ0o5dCkkXG/KAvr1TFrUh2wV85c+T/CH9r8P
	 PKwKdPKBcRAFd7kax3XJC5XWGbIZm+Ru9T7Frt87MMtygJWgP0vfoMGwHVyUZ/g73c
	 FDhamA9UybPuaG2iHgPRitUs5abHo0KPQ/ws8BNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Haoyu Lu <hechushiguitu666@gmail.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 133/957] ACPI: AGDI: fix missing newline in error message
Date: Wed, 20 May 2026 18:10:16 +0200
Message-ID: <20260520162137.440277352@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e0df3daa4abf0..abe29705744e5 100644
--- a/drivers/acpi/arm64/agdi.c
+++ b/drivers/acpi/arm64/agdi.c
@@ -32,7 +32,7 @@ static int agdi_sdei_probe(struct platform_device *pdev,
 
 	err = sdei_event_register(adata->sdei_event, agdi_sdei_handler, pdev);
 	if (err) {
-		dev_err(&pdev->dev, "Failed to register for SDEI event %d",
+		dev_err(&pdev->dev, "Failed to register for SDEI event %d\n",
 			adata->sdei_event);
 		return err;
 	}
-- 
2.53.0



