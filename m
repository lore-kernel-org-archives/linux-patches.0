Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4321E18BB91;
	Fri, 27 Sep 2024 12:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440031; cv=none; b=RrvL72bknA4zkTAIhYt9JH0oWNLDneGV5NfTxz9ZosHL7t/xLkR5VeUBQg/4hi/6qOusJFgBCxZcUd8A2AJt6Nft+UJdZKMHr0HVe6Pp4gES0+TsrT3pQnqV8ZflrZkwxCMCVbARpTNxBuZMN/9bfDm7eFqSxivuCdzPVTUiCCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440031; c=relaxed/simple;
	bh=egkVnnTArlRcwAhEBW1H3i+eoDV5ymbT+2IGTF0JhEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+ZNuwumv5akpsmwrcmOfS3b/tSTgxwRLeMBz3eHcr4jZUFj75yKk9mlcya+JtR1wF6V1/zQU52tFvuGEQEeiXyEhJPB0JQiIaB2w6s6cfUKAcOhtX4ssLR1hQjYfQ1E5MwCtP51NdrzDedBJP1q+ZdOsZmmJOKq096ohljkMW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fHXJ4oHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fHXJ4oHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3AFAC4CEC4;
	Fri, 27 Sep 2024 12:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440031;
	bh=egkVnnTArlRcwAhEBW1H3i+eoDV5ymbT+2IGTF0JhEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHXJ4oHBfKid9FlxWmBVSTcAwMRiGjKga3isnaugUIc6zNtaR9B9D8r11IcjrLSGZ
	 fpKX8wZL8I8GrLXmxd3Ur74mSl6X3h0dxmvFMQz+HyYsb4YCD2jGZXAd/bxNjfUvqW
	 h3w5A0TTdNZ77E+Kg7g7hDVk4X6IZTYR+lkb6qfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 31/54] spi: bcm63xx: Enable module autoloading
Date: Fri, 27 Sep 2024 14:23:23 +0200
Message-ID: <20240927121720.990157136@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liao Chen <liaochen4@huawei.com>

[ Upstream commit 709df70a20e990d262c473ad9899314039e8ec82 ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded based
on the alias from of_device_id table.

Signed-off-by: Liao Chen <liaochen4@huawei.com>
Link: https://patch.msgid.link/20240831094231.795024-1-liaochen4@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index aac41bd05f98f..2fb8d4e55c777 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -472,6 +472,7 @@ static const struct of_device_id bcm63xx_spi_of_match[] = {
 	{ .compatible = "brcm,bcm6358-spi", .data = &bcm6358_spi_reg_offsets },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, bcm63xx_spi_of_match);
 
 static int bcm63xx_spi_probe(struct platform_device *pdev)
 {
-- 
2.43.0



