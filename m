Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060385;
	b=a8u/2bZf4UUjKaz+mc23H35OxiBUrA5HLda05HdwuW5xclmkLSd8f1Fl5FZLAHWYL/+1
	 0cXVdKKkJrFH9rJdK7sMWtz3/piDW0hmEfSsxDFseASXjI+pKMjoStsY/06EVmUJUvFuX
	 VjrHwXJ4AdPacnkNKcVULsyWhOOrGm3fgAzQ9TADZfVjVEz4SBuLF5NtBgDUjgcD5pgdE
	 tHwae1sANBtVL+FVfSwHQiAIVQJHcm0npoBNPEGS1o9ND3SK5TevqZZfIA46DytAk8Kyq
	 s7z4Bq8fRK6Nldw4ek9FPZQyQv1jZ2hAg11RkPpE5+NCC9R5egk1rc8oWLLrWrZxRTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060385;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sbhFXmIYM2dMyT+1wWfzCgPaGzvdzn3nJiYp1MzItk4=;
	b=G0qc9goAH76xrKatk0ApXm2usRc4MtEGkYErVxJanKuimU5snf59EcOK75eoPFXCsfqc
	 5Zh8ZnWuqrefhIbMsOjzVuefQJwUy7azBtsFGKG25AcxscZJ6rGYL2eAQBgxHUQ2j+t0K
	 CMQ+dOIjIvfQNw4Oyw9AOWe1XatNxNgQh/YFfx7oEUB6bbfTAUn6x/1Rax+lXbZ7hKja9
	 iPmMRP8TB2ooq4AzVI07atr6rTles2y9sR1OXiWov9Cl1eIy472wfczZSJUuEwTdmRSlO
	 iflVKPNRE+HUI6NuwLFsb0kR458bMMpU5RedSbumdKXz5K8j+L4CHjOYBb44BQXXmVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=so+Kacou;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D47606A326;
	Thu, 19 Nov 2026 03:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=so+Kacou
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6C51F000C4;
	Thu, 19 Nov 2026 03:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060385;
	bh=sbhFXmIYM2dMyT+1wWfzCgPaGzvdzn3nJiYp1MzItk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=so+KacoujEvWIRNgVNmutxw2gXULAQ9EC9Jj1tExGkmm9EYUaMegY3Y3Oo2HUOVcH
	 9TZDJkOkKpjCxrg3UB1cNrxtD8iB1tE6jd2JPQuCm2l+G3tNb4r/Wxxt+ZMLuXzfFc
	 qEDUOTbb3ShRUy9Fb2+mKbLDhJNvi9Bg2MinxiLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1153/1848] spi: omap2-mcspi: Remove unbalanced pm_runtime_put_sync() calls
Date: Wed, 18 Nov 2026 15:53:11 +0100
Message-ID: <20261118150008.003250139@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 5f01cb141169fe422c42279f7d502479b1ff9fd2 ]

pm_runtime_put_sync() is called in the probe error path and in remove
when nothing holds a runtime PM reference anymore, so it underflows
the usage count.

Fixes: 0e6f357a5deb ("spi: omap2-mcspi: Fix PM regression with deferred probe for pm_runtime_reinit")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260826-mcspi-v1-1-0a8dd7f6dd56@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-omap2-mcspi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 3596bbe4b7760..3943ba934e198 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1523,7 +1523,6 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 
 disable_pm:
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 free_master:
 	omap2_mcspi_release_dma(master);
@@ -1539,7 +1538,6 @@ static int omap2_mcspi_remove(struct platform_device *pdev)
 	omap2_mcspi_release_dma(master);
 
 	pm_runtime_dont_use_autosuspend(mcspi->dev);
-	pm_runtime_put_sync(mcspi->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	return 0;
-- 
2.53.0



