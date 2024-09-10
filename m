Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9DC18C340;
	Tue, 10 Sep 2024 10:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964963; cv=none; b=eT6YeUeYZ9Ga7GF+8nbGfmzQXFVvK1MgVGbI+zfUwil2C/k5QGhAGf8VBNVOpFOE9r4xuiiLnGrO4NIabEG887OUxPdPjbIQBnuVcxWtrX8JCxQAK0cuOXn/PoZnzakxAOeg+Up45DvZNngzXJeYZTywYeS9FfakCEB46wWGKI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964963; c=relaxed/simple;
	bh=tCD+FH6cHAbcNvpyNDjhwJAESbTEkunSqKk4YvVwxGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ig3PdnJMSq7X34inUsx5xXqRvRkJGVXgswuZscKebLfbc9coDLykxyndof64rNNHFlOxmYwXsALs0YR+ev5CyjxK/+IHYlVZA3grxf3VQ/sY5ihl37chCpTKLaA10/fp0OrSr3pex/kDSUY4+NL31VcSLBvgQUf2Ti1Kz3jhLio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNc0z0K5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNc0z0K5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FD6C4CEC3;
	Tue, 10 Sep 2024 10:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964963;
	bh=tCD+FH6cHAbcNvpyNDjhwJAESbTEkunSqKk4YvVwxGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNc0z0K5W1x8HNXU96oYoviwmKl+Vt4/TlTuRkNvJAn4pvvnOzMRpz73BqtGSqdJd
	 w8YI+KEvgSNCPS4a+XJQfmpdQ69+BY3GNxv2yD14NqzdLsJ7WlaYf53P8FoTs2VTMI
	 RQOZ+K844/xSTprsl2v+npz3nEe5Vs2H3Mok2te8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 064/186] mmc: sdhci-of-aspeed: fix module autoloading
Date: Tue, 10 Sep 2024 11:32:39 +0200
Message-ID: <20240910092557.128220894@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -236,6 +236,7 @@ static const struct of_device_id aspeed_
 	{ .compatible = "aspeed,ast2600-sdhci", },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, aspeed_sdhci_of_match);
 
 static struct platform_driver aspeed_sdhci_driver = {
 	.driver		= {


