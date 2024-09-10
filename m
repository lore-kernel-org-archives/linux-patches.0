Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4225170A01;
	Tue, 10 Sep 2024 10:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962511; cv=none; b=FcqpwNMXahLfRZMnkxDEUqRvjfv7qS8apFMdZHL5cjMd554V9V44T81aFVY7m9A8sNfQE/i3THml7zDdguZmgTlMOq/+BP9E3jFF9TmOMbKqLFTsVCEPMOZcJO2fSF7EUysYMMjHgwreHduYt3dSRHa0sitG9/zP082DRENDmuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962511; c=relaxed/simple;
	bh=+BcMrBDMBeaQN63nvaT9mh5ju/FG+ZEO4QnePL4yDAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jl4JDINhx5DgrnPuo+H5Cw8OS1iFlSoC1R6QTfjCTgGDInsHkZ9ZU4iHjhlDQL2a3+5tkLmovdkqNrXaolzKJOKtIviDZgKZS+vxpG5+8MpC1JvDKOwua/7bsFd/W1W3SGF0iIPZtf0Lqh1djDbSZX4u3ju2UhKo6JXlT4fTwaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Ow24pNT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Ow24pNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73212C4CEC3;
	Tue, 10 Sep 2024 10:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962510;
	bh=+BcMrBDMBeaQN63nvaT9mh5ju/FG+ZEO4QnePL4yDAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Ow24pNTqdDNTpgJG2Dips69UHoziv+0XRhgRZzSJmGvAuIpwLCOdT2x6qSi1JQz8
	 tiCyZfMJSUtMVuAej3m17HL8RtpHAsKWb/HECWiRpxkc54fRTzqKEHrYvwk/o/JZuF
	 wewPrtH6prkX7AAc/Fas1buoEesBadnP3coVZeqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 032/121] mmc: sdhci-of-aspeed: fix module autoloading
Date: Tue, 10 Sep 2024 11:31:47 +0200
Message-ID: <20240910092547.253298862@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -224,6 +224,7 @@ static const struct of_device_id aspeed_
 	{ .compatible = "aspeed,ast2600-sdhci", },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, aspeed_sdhci_of_match);
 
 static struct platform_driver aspeed_sdhci_driver = {
 	.driver		= {


