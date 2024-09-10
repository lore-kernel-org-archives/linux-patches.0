Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D97C191F9F;
	Tue, 10 Sep 2024 10:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963494; cv=none; b=dA0HTlxTkk47QBGBfX/HOtoVj++hHxYIkYvKneyS+dIAYhm52ENdm+9iEq6QpDkrHnOPFoyGjzSAQfPYKwTz+gyheOpvgZaOKXC9FPsT+qLTKyE6tXSS/NW0VEcXUsxELDr6ebqMl6qBAjmx6/6iLYxADIXnlmllTyK0t4C7rm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963494; c=relaxed/simple;
	bh=ymqyeHvisP9+665PFSgt85MCKlCzyzMDWZnAztU/O50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jc0AjNlx7M24Nw4Jsdl0yiVXVc6CIUWlGwx2ANtS6OD9Ppi8+TYKW92/kvr9FSTyvYhqsLvtiDhvzNGN0e09BrNrUPh0cboWTmykp+haLizV2P89j1pBnLCDA/yhNqrYszup0AT+4PB2uu0F2PVWwydyJOl+3qAenn4SYnSsP5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZIpOyj0z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZIpOyj0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4ABC4CEC3;
	Tue, 10 Sep 2024 10:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963494;
	bh=ymqyeHvisP9+665PFSgt85MCKlCzyzMDWZnAztU/O50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIpOyj0zMNLE4qvQFWmhdYYbK4PiHEMFA8duTL6J+rCiskkKTmIyiBc7IiNlSxe2I
	 dTO2zzMmVXzgDxFCtLJ4/HHG1/blhbWwJp0OEfObibiGB/xvb8q3byjV8MIqtIrGA8
	 mRtseJNUtzvM1XuLjmdCGfQljVWR62bn/qeuOTio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 076/214] mmc: sdhci-of-aspeed: fix module autoloading
Date: Tue, 10 Sep 2024 11:31:38 +0200
Message-ID: <20240910092601.848187286@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


