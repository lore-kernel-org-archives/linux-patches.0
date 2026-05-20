Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF1F36A357;
	Wed, 20 May 2026 16:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295065; cv=none; b=PbjbquGJAUqma3NeE5EJZx2b+K8Xq9F+TNiSGhJohWKmSij2QSpG76G73SXhrig7opc0w/v162r4omlF+5u3KAO7e9ENvYgYXsHeNjD2OAG50hGyBjxPC/V+cAoErC2ozPt9hitD8RhmCfyi7zRMe5JMTHQ9bF6DlWwpZIXW3N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295065; c=relaxed/simple;
	bh=ouw84jTx1lF0CmI8Nh15P1sbPjgAP1LtZkxxziR2T7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=faaEPJyTGOyOBoE7wpdwRIJoUJ+JU1nUg8LVv7oi8WclSWrwIvKf5yU7HhYC0x7AT+NDAc7u7eP8abKNjB3tnosNa1OUkv+tV09Zf2sMPckjpKXY5Oi39qZsDiZWDSdSBPhu8HZAdIMeGjF29Ww3YqmEG3pswNNqH2ZZcPRxFKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0YhKCGd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0YhKCGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439F31F000E9;
	Wed, 20 May 2026 16:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295063;
	bh=DetRn9n4Len2mou6CXsPVfgqPq3TZ4aafB0tY7F0hwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E0YhKCGd16t2xpcDsCTmeocUO8MtPHPd1NUt0eX77uv+BiKpbpKAnVSS4nnu2Xlc1
	 UB7bVyfpBFPlFylrphGop0Si2WqE7MSwDR2WXLHT5SJzw92ELbCYPXL+za9PbNMqbJ
	 5AyaYst3021nAa3tf935dvPMZPgHe2gBv+O54Td4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0277/1146] spi: axiado: Remove redundant pm_runtime_mark_last_busy() call
Date: Wed, 20 May 2026 18:08:47 +0200
Message-ID: <20260520162154.486703820@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit ec6c2e15a42fc8fb63baadee0e8a3257e37fa90c ]

The pm_runtime_mark_last_busy() call is redundant in the probe function
as pm_runtime_put_autosuspend() already calls pm_runtime_mark_last_busy()
internally to update the last access time of the device before queuing
autosuspend.

Fixes: e75a6b00ad79 ("spi: axiado: Add driver for Axiado SPI DB controller")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20260307-axiado-1-v1-1-e90aa1b6dd9b@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-axiado.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/spi/spi-axiado.c b/drivers/spi/spi-axiado.c
index 8ddcd27def22b..dc55c55ae63c8 100644
--- a/drivers/spi/spi-axiado.c
+++ b/drivers/spi/spi-axiado.c
@@ -842,7 +842,6 @@ static int ax_spi_probe(struct platform_device *pdev)
 
 	ctlr->bits_per_word_mask = SPI_BPW_MASK(8);
 
-	pm_runtime_mark_last_busy(&pdev->dev);
 	pm_runtime_put_autosuspend(&pdev->dev);
 
 	ctlr->mem_ops = &ax_spi_mem_ops;
-- 
2.53.0



