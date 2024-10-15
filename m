Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4881EF95B;
	Tue, 15 Oct 2024 11:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992437; cv=none; b=Jfo4EjKk0ie4mO6mU7PIw7LLP0SPmfzDUGvSoaUvzGLvgodE9QAITnUntxDvvH8VyB1IGY6t7VOj9B/8E6JcXod7avhT7Np2xtVOOnu4LjIlaIuWgvj7jY4kHoDRWFzth46wVdTrZC+VbFEph3kuq7PsW8E8H/9ZT39Hg0DYydc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992437; c=relaxed/simple;
	bh=OSa0gwsklTMkY3XG0D0/nlQ7pFAZn9ltCeBAuQR++l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIaRXgGteFSGkI+zG2j4v+Vm0wKEer1mDAryUpK7NQk/6HgYbIGmWrdOvm0Tj/eUCcfDWVYDqJKeihdyyGuaI7Kx5csTjVTvaHGdohuB7LTyzLHkOlbwLbrCqeI7Vi4Tt2UtpUPKkib01HNetnTokMb1N7HfF31AvKnL2PWOtFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/r0rjdq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/r0rjdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FE4C4CEC6;
	Tue, 15 Oct 2024 11:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992437;
	bh=OSa0gwsklTMkY3XG0D0/nlQ7pFAZn9ltCeBAuQR++l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/r0rjdqFSw38ElKzbNzubBxa6aVlOTaHHcJCeJ7xgCffYQARcK14jSTGAfLASIWI
	 8XCJ2R0jXmj7Yjw0lQ3YB24d9Li3L9c9mnP38qkkxjnkGkUL+kB8qruXGXEL8a3alC
	 SorTZqxA7zCphRMRt8Ef1DwWZdadeC64ecivgpTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/691] spi: bcm63xx: Enable module autoloading
Date: Tue, 15 Oct 2024 13:20:23 +0200
Message-ID: <20241015112443.335204467@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
index 147199002df1e..a9921dcd6b797 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -482,6 +482,7 @@ static const struct of_device_id bcm63xx_spi_of_match[] = {
 	{ .compatible = "brcm,bcm6358-spi", .data = &bcm6358_spi_reg_offsets },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, bcm63xx_spi_of_match);
 
 static int bcm63xx_spi_probe(struct platform_device *pdev)
 {
-- 
2.43.0



