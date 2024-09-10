Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2084D193067;
	Tue, 10 Sep 2024 10:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962843; cv=none; b=XIUGBVUEvm+y7n402FDHK3iRZdkCenXhplKYiaBxui6JxNbQnR6C9xktOspkufLI/HQBteISU3v3WI39eOAqmPv2MGl85azG/xd4qdRASJTseUhvhgAAqx/RcxyPyjGmYj5HOI0Y7oQXmRjuV1j8x1+jK8xMPdpi/hLrLK584OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962843; c=relaxed/simple;
	bh=NTmw6OyjjVm/aNPOxtDF+fl7n/D+BPSZKyuVddo8YpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2GvDbgQb0Uas0rnjwhj4K2CtAW5ragXAndvEWUV3QfJFeHJRqJnyeGkfsHi/6u/GzdVtEvpZ1HA4FQJEZme4rbM9hsWkMbzZ8BryYcdsQEuXMh8FDDYlR4NV7F7ooZUTI1WYBaF/RlQX2aedxGtDE6Ybn6BmulYgi9C7ISFhag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYDSR64I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYDSR64I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B85AC4CEC3;
	Tue, 10 Sep 2024 10:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962843;
	bh=NTmw6OyjjVm/aNPOxtDF+fl7n/D+BPSZKyuVddo8YpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YYDSR64Ism8lwW9h2zFsFzQyuk4TFsnOB2f1VSZp/VBleaYldQXwPqRyrFf250Uqu
	 yQWywaaBnZZfmRa0su4F9JOO2c+RTKEEr8EhFfqVRpwZ191dyjE3kch38FoA7dVMgE
	 xvvbQJelLIvmFjMCo+lgfYwJsUKvnmZrY+a1T6ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 022/192] mmc: sdhci-of-aspeed: fix module autoloading
Date: Tue, 10 Sep 2024 11:30:46 +0200
Message-ID: <20240910092558.867880031@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

From: Liao Chen <liaochen4@huawei.com>

commit 6e540da4c1db7b840e347c4dfe48359b18b7e376 upstream.

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded
based on the alias from of_device_id table.

Signed-off-by: Liao Chen <liaochen4@huawei.com>
Acked-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Fixes: bb7b8ec62dfb ("mmc: sdhci-of-aspeed: Add support for the ASPEED SD controller")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240826124851.379759-1-liaochen4@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-aspeed.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/sdhci-of-aspeed.c
+++ b/drivers/mmc/host/sdhci-of-aspeed.c
@@ -513,6 +513,7 @@ static const struct of_device_id aspeed_
 	{ .compatible = "aspeed,ast2600-sdhci", .data = &ast2600_sdhci_pdata, },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, aspeed_sdhci_of_match);
 
 static struct platform_driver aspeed_sdhci_driver = {
 	.driver		= {


