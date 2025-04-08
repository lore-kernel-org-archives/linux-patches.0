Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A579121ADAE;
	Tue,  8 Apr 2025 11:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110761; cv=none; b=sKxpa60TOzJlUxn7twpoqrRxlQ0pKDGVjYBEYK7ea0DuJ90M1bPeX29MiLl2Y1KixIhcaon/iGl+56z/QBFzSyXZJkkV/qaEJL+0MquuatIxEdnC9NKwk/m43Imus1nF170l3N7/fGK3OWWPjsRRxp+HQvgx0bes+9um4G0p9yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110761; c=relaxed/simple;
	bh=r0lwiJ1Bx3eoakeqZAfE4pQOdyJt5OLavp4IBsAQJVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TR/wN32hLNOgULXUgl2sZy8y/4pyTzqTDEDTu954aBNuuMLZGq4zhuwVWSkEVEALgG+zCyHvN04ZZtiVZ0A6iij/ooZa9kTyzlK1kPzRaXbkMFgoPQQazRlC3OSZOYbUP+9/hPbcgHrwz3QDa+6LGACs/xE1Iv3k8qPGJhoN+og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E56MQBdI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E56MQBdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C23C4CEEA;
	Tue,  8 Apr 2025 11:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110761;
	bh=r0lwiJ1Bx3eoakeqZAfE4pQOdyJt5OLavp4IBsAQJVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E56MQBdImD9c/5+sJO2TQlni+yV7Z1fcnkMiY+kblVyG+rBotKItMevJl/mDbqF1J
	 eo73OxgcYN5MO6NDAlcjeZx4UMyLRx6VW90amvh5y4vB5N4jUq5n+tG9RafkbeWu8l
	 23g3b72CXI9sRFxd+YGhYQsC0jnjlYhQiD8LseFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 185/731] bus: qcom-ssc-block-bus: Remove some duplicated iounmap() calls
Date: Tue,  8 Apr 2025 12:41:22 +0200
Message-ID: <20250408104918.580708215@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit a9ac4ba7dcace2b3b91e7b87bf0ba97c47edd94f ]

reg_mpm_sscaon_config[01] are allocated with devm_ioremap_resource(). So,
they will be unmapped automatically by the manage resource framework.

Remove the incorrect explicit iounmap() calls from the remove function.

Fixes: 97d485edc1d9 ("bus: add driver for initializing the SSC bus on (some) qcom SoCs")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/efd06711b126e761a06eb5ef82daf9ad4e116a10.1740932040.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/qcom-ssc-block-bus.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/bus/qcom-ssc-block-bus.c b/drivers/bus/qcom-ssc-block-bus.c
index 85d781a32df4b..c95a985e34988 100644
--- a/drivers/bus/qcom-ssc-block-bus.c
+++ b/drivers/bus/qcom-ssc-block-bus.c
@@ -356,9 +356,6 @@ static void qcom_ssc_block_bus_remove(struct platform_device *pdev)
 
 	qcom_ssc_block_bus_deinit(&pdev->dev);
 
-	iounmap(data->reg_mpm_sscaon_config0);
-	iounmap(data->reg_mpm_sscaon_config1);
-
 	qcom_ssc_block_bus_pds_disable(data->pds, data->num_pds);
 	qcom_ssc_block_bus_pds_detach(&pdev->dev, data->pds, data->num_pds);
 	pm_runtime_disable(&pdev->dev);
-- 
2.39.5



