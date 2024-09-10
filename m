Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F0A19148D;
	Tue, 10 Sep 2024 09:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961336; cv=none; b=CxVgY634Ry1mJNc1+bc7Nrg+WT3QW96RaDHZrGgOaautEdZQ3Ob4HeTl8re9n8OlNj4MhArRyUdYX+duVoWl1ZaCCjCTzsKsbv0nt0owmD9BuqliqkdqzEWzYZQQ7dAInEmzSyLPXq/Rt38NElDd6FiKe3UDMFp8s29kKyJMAAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961336; c=relaxed/simple;
	bh=O5/iilqZ8m5aT8CJgPrc09chtShzzdGJ71W7yVvzN+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhmgCWV21kAnpQOzo1HqO5BbXiHB/Lr5OkBVo4prIvR2PElU116dJjWyzZvA8WTRZIduc/3gC4xIXbbb+jMFWtf4pnSxxjh0dNK62m1kuXcjAmwbv6nU/nPNCnO01jQnWI6Mlk3LggGBTmvO3NwVbz9HtCgKs6y7hvN04+AvP2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4lcr6v8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4lcr6v8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FD7C4CECE;
	Tue, 10 Sep 2024 09:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961335;
	bh=O5/iilqZ8m5aT8CJgPrc09chtShzzdGJ71W7yVvzN+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4lcr6v8J72iFaKiDCyWRPnIfrkEJrPRfrasUa1tMxat7LNQmlS6MPphjGb1tnlNN
	 zFHrsZy5zrGPTE6qgNlUJY2Vr3OOiTPr3/3N0LRo/LAJFcv5LNNOzwZjYflpRuJ0Zj
	 cHrij8581jZin3W0YDmjJcbWVgoDE5akUTxW8Wwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.10 035/375] mmc: sdhci-of-aspeed: fix module autoloading
Date: Tue, 10 Sep 2024 11:27:12 +0200
Message-ID: <20240910092623.409921727@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -510,6 +510,7 @@ static const struct of_device_id aspeed_
 	{ .compatible = "aspeed,ast2600-sdhci", .data = &ast2600_sdhci_pdata, },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, aspeed_sdhci_of_match);
 
 static struct platform_driver aspeed_sdhci_driver = {
 	.driver		= {


