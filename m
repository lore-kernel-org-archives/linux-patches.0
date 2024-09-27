Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBEE1865ED;
	Fri, 27 Sep 2024 12:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440109; cv=none; b=C4LuFFfKUgV4pk83rBptbNjCvhUqapY+/LRYOzO6XnhT6hu2xAEtAoAbqqstE6BxtzEjqIW9NhwqVrIIZi40Aq3PDw/yWtcoXdgNDcwBkI54rS6ePWQMkUF8W4bIFFlH3FZFTnSqO5G1dX4SQG2wlyeh8yEeIym9nJQiJSeTMfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440109; c=relaxed/simple;
	bh=8r2b+jI9L22F2EVfUJIynxgJ1zpb6/bl8ACO+NmkOTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPuflSXYd78hM69h82jr9tc3enI8+rLRqtZZ27XknMLXx+J3exGTplxzlPFS9kBUlEougREwqhnFVkW8O4MAN01sb94UhkLlfbhdWj8++DBenFRp2/jdHb73YQ0k2oYdZBbCwkA3HpuuPSiIUVMsit+BSuji96Swxizw66IZwq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mojTSyWC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mojTSyWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755F8C4CECE;
	Fri, 27 Sep 2024 12:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440108;
	bh=8r2b+jI9L22F2EVfUJIynxgJ1zpb6/bl8ACO+NmkOTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mojTSyWCFmGybbiOj7By+hdgwMAfnhHtCSI90FA+JRpDr8ku9d6rLp/JjLqEmHEMs
	 qFj3pBZnCUi/PpJANiTpt5dzneUX4wPytIZYme3DCgNwQ8LXs4IYd5//X2Tt+JgCGV
	 3aKUhu3IwUZ5SbNmgJW4kwFvFsbUlTNRhsoCydlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 36/58] spi: bcm63xx: Enable module autoloading
Date: Fri, 27 Sep 2024 14:23:38 +0200
Message-ID: <20240927121720.255429061@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
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



