Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9395742B738;
	Tue, 16 Jun 2026 15:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622817; cv=none; b=vBij59oIPC0GjnxeCMsos31FExEh9iJzMtguvwuimM1LCvcE3+mp/iDx/lluJGOufEtwjpq1PRhPKeN9iETyGuVf3Ngz8Q4krbgtFCvuSUFySyRI9kAtbsuox/sJ/meCki4QN1hLLh+QBSfaRN8LCTe1D6ngODzgCh2fhWlfJEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622817; c=relaxed/simple;
	bh=6UEBoWkJMzB7rfDFeoouqACJn2dTYUDZ507TnOly3hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzHBSiTfW6TAViKjVESuFY4Kmz5ihGzWSAZUr2ZOl/Yyz0D6jA8Yzg//dXbRQLHPk0Du7LWIoK65aXx3oES9SO1sGNk5MzjVBOvVngkOOhW9fqRE5BNQGPHUc88dtNT5PB034hRX4IZNfk8fSt5sdvHK1UkeX9TdKuct7ZU0T/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tcJl8iun; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tcJl8iun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F4F1F000E9;
	Tue, 16 Jun 2026 15:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622816;
	bh=88NT1A7whBs6lb9xkTXUPBpicbFBFxocfxZimGG0x/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tcJl8iunkpSxSwL5ybHTJKC3TEGBE28QMzhoKEQhljpu3QhxpwQyYLRI2mPcmIEfa
	 IgHjEEYaWO5cjLXPizumanuYnfuVTRlh5H4HhtG/nGbsmnVj/4sA76AS2vtfAbdy5j
	 yx4YgjI5Zwh3eedtykAwpT3eS4iGLvgPIhUWdszE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 011/378] soc: qcom: ice: Return -ENODEV if the ICE platform device is not found
Date: Tue, 16 Jun 2026 20:24:02 +0530
Message-ID: <20260616145110.384483209@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 5a4dc805a80e6fe303d6a4748cd451ea15987ffd ]

By the time the consumer driver calls devm_of_qcom_ice_get(), all the
platform devices for ICE nodes would've been created by
of_platform_default_populate().

So for the absence of any platform device, -ENODEV should not returned, not
-EPROBE_DEFER.

Fixes: 2afbf43a4aec ("soc: qcom: Make the Qualcomm UFS/SDCC ICE a dedicated driver")
Tested-by: Sumit Garg <sumit.garg@oss.qualcomm.com> # OP-TEE as TZ
Acked-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260518-qcom-ice-fix-v7-2-2a595382185b@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/ice.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index bf4ab2d9e5c036..6520e146d2ce06 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -657,7 +657,7 @@ static struct qcom_ice *of_qcom_ice_get(struct device *dev)
 	pdev = of_find_device_by_node(node);
 	if (!pdev) {
 		dev_err(dev, "Cannot find device node %s\n", node->name);
-		return ERR_PTR(-EPROBE_DEFER);
+		return ERR_PTR(-ENODEV);
 	}
 
 	ice = platform_get_drvdata(pdev);
-- 
2.53.0



