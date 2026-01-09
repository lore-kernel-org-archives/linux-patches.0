Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F8D35CBC5;
	Fri,  9 Jan 2026 12:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963110; cv=none; b=cLYjtfeb62vp8RTHCBeydP1asgQlkeWhlsfwk9KIK6m8cprGN/0qvMrM0DDkvGMr1GWF+MPVmKOtVhJ3CGvS1rMImPpcoWfzTMNyVPZfoZeY24Oin+PN89a4NqBt3NQhCwS1MBRxxTRkhO7X3gS859x6HvNO9pl/MxZ9dHlcXTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963110; c=relaxed/simple;
	bh=MSNsjMik/MI8ige1E6rS8cj8h025Fohv7gMEKU2fXGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UfTY28GxkbdQz0irRC3yCB1oEfzVHXEh4IYOlIUd1FtlMkEKtSsX3zL1SRjjdmhELLfa9mryJB3f+Au/zcciF12ykigQmaQ9pN6j2+VI1MgGKTvjixZWv+Zh/92K8PQSyyv3ChPBuohaFQRy+mr0ikNnx6/4r3si91M7M8rNe/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DH2X8mA5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DH2X8mA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372CEC19421;
	Fri,  9 Jan 2026 12:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963110;
	bh=MSNsjMik/MI8ige1E6rS8cj8h025Fohv7gMEKU2fXGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DH2X8mA563fAcPEIWB6nY4+gYn6oJCUNxSEOIZkTr/u6YHr8lWkla1r9KvNoOPL6i
	 XQlYpWdTcJ+mPCstuFn1u1AFBPHvSo3UMhn58sCOOVKuRfRpXUODQ7E4CaPRwNSLsd
	 VDq9xNXTMkJfeSjQAsR6zKS9GYNlVRSUyq3Vhha4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 601/634] iommu/arm-smmu: Convert to platform remove callback returning void
Date: Fri,  9 Jan 2026 12:44:39 +0100
Message-ID: <20260109112140.240811165@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 62565a77c2323d32f2be737455729ac7d3efe6ad ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230321084125.337021-5-u.kleine-koenig@pengutronix.de
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 6a3908ce56e6 ("iommu/qcom: fix device leak on of_xlate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu.c   |    6 ++----
 drivers/iommu/arm/arm-smmu/qcom_iommu.c |   12 ++++--------
 2 files changed, 6 insertions(+), 12 deletions(-)

--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -2225,7 +2225,7 @@ static void arm_smmu_device_shutdown(str
 	clk_bulk_unprepare(smmu->num_clks, smmu->clks);
 }
 
-static int arm_smmu_device_remove(struct platform_device *pdev)
+static void arm_smmu_device_remove(struct platform_device *pdev)
 {
 	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
 
@@ -2233,8 +2233,6 @@ static int arm_smmu_device_remove(struct
 	iommu_device_sysfs_remove(&smmu->iommu);
 
 	arm_smmu_device_shutdown(pdev);
-
-	return 0;
 }
 
 static int __maybe_unused arm_smmu_runtime_resume(struct device *dev)
@@ -2310,7 +2308,7 @@ static struct platform_driver arm_smmu_d
 		.suppress_bind_attrs    = true,
 	},
 	.probe	= arm_smmu_device_probe,
-	.remove	= arm_smmu_device_remove,
+	.remove_new = arm_smmu_device_remove,
 	.shutdown = arm_smmu_device_shutdown,
 };
 module_platform_driver(arm_smmu_driver);
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -715,7 +715,7 @@ static int qcom_iommu_ctx_probe(struct p
 	return 0;
 }
 
-static int qcom_iommu_ctx_remove(struct platform_device *pdev)
+static void qcom_iommu_ctx_remove(struct platform_device *pdev)
 {
 	struct qcom_iommu_dev *qcom_iommu = dev_get_drvdata(pdev->dev.parent);
 	struct qcom_iommu_ctx *ctx = platform_get_drvdata(pdev);
@@ -723,8 +723,6 @@ static int qcom_iommu_ctx_remove(struct
 	platform_set_drvdata(pdev, NULL);
 
 	qcom_iommu->ctxs[ctx->asid - 1] = NULL;
-
-	return 0;
 }
 
 static const struct of_device_id ctx_of_match[] = {
@@ -739,7 +737,7 @@ static struct platform_driver qcom_iommu
 		.of_match_table	= ctx_of_match,
 	},
 	.probe	= qcom_iommu_ctx_probe,
-	.remove = qcom_iommu_ctx_remove,
+	.remove_new = qcom_iommu_ctx_remove,
 };
 
 static bool qcom_iommu_has_secure_context(struct qcom_iommu_dev *qcom_iommu)
@@ -857,7 +855,7 @@ err_pm_disable:
 	return ret;
 }
 
-static int qcom_iommu_device_remove(struct platform_device *pdev)
+static void qcom_iommu_device_remove(struct platform_device *pdev)
 {
 	struct qcom_iommu_dev *qcom_iommu = platform_get_drvdata(pdev);
 
@@ -865,8 +863,6 @@ static int qcom_iommu_device_remove(stru
 	platform_set_drvdata(pdev, NULL);
 	iommu_device_sysfs_remove(&qcom_iommu->iommu);
 	iommu_device_unregister(&qcom_iommu->iommu);
-
-	return 0;
 }
 
 static int __maybe_unused qcom_iommu_resume(struct device *dev)
@@ -903,7 +899,7 @@ static struct platform_driver qcom_iommu
 		.pm		= &qcom_iommu_pm_ops,
 	},
 	.probe	= qcom_iommu_device_probe,
-	.remove	= qcom_iommu_device_remove,
+	.remove_new = qcom_iommu_device_remove,
 };
 
 static int __init qcom_iommu_init(void)


