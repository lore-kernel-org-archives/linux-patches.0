Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49701DF252;
	Wed,  6 Nov 2024 12:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894851; cv=none; b=PfuyA3bi4dkUwa9OGhJZPoZcLHmahoneRHSDGhP9lQmYZDCOk92C4EiyCn0T20XyFo1K+ziwzXT69m1Hu8rH0+tSEDjHqbXolftaMhZP6KdpAivtm5MZ+nnuZD/XiLNRYblERlZ3AYT7nLLFQfgUe7b9qOf93I+LRur0KO5RJ0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894851; c=relaxed/simple;
	bh=FBY4uuGxlIGJqpovcIHwkeHGUqX/5+42toAqhtCtOa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1WErGP1sJ7fRTHXGUUjhGEQ1QQIu3tHxRuZCWPyYTSiFmAfQmXbaryxg8/enTiAxGFB7gbOkGYEzubqVW7vTyV1+5ChrDnCa3hG8CTqQYIF0/pz50hVjz9pdV4ZA7TZtv+ICXVqX8MPMURPlLtOCiz9OXXQ6RWCjsKtv+udlPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q94SLqln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q94SLqln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495F0C4CECD;
	Wed,  6 Nov 2024 12:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894851;
	bh=FBY4uuGxlIGJqpovcIHwkeHGUqX/5+42toAqhtCtOa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q94SLqlnPyOdT8CIQu6va6rN1s0wUrgSiRAGOjoLewIlpReDRuDGweYJuMwYao4Vd
	 3cMOOvSX1UqHTynmPreT3ktH7Xga03EcIxpbtZwiS2KUTsXxKp49ZxEkk8MAVa0cVt
	 5nwOnp27i7zlOAM4jbpLH+dwDN6yvQ+0yJqupXcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 022/350] spi: bcm63xx: Enable module autoloading
Date: Wed,  6 Nov 2024 12:59:10 +0100
Message-ID: <20241106120321.423670615@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index cc6ec3fb5bfdf..d57a75a5ab372 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -490,6 +490,7 @@ static const struct of_device_id bcm63xx_spi_of_match[] = {
 	{ .compatible = "brcm,bcm6358-spi", .data = &bcm6358_spi_reg_offsets },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, bcm63xx_spi_of_match);
 
 static int bcm63xx_spi_probe(struct platform_device *pdev)
 {
-- 
2.43.0



