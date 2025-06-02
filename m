Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BAF22578A;
	Mon,  2 Jun 2025 14:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873708; cv=none; b=gfJLPHSlEQuf3cLPL0FGzh56RXBwrjVHs1KiiPtNDbGUSKFtI6g4f7kSltg7aouCCroiAv20/xD7ILBlXbZ9FJOpbmZe0+9nI8+pqElLR7ESmWYLbD8WvyRC5tkxcv63IqJLXUTOhJclsaHwcuWsSKsHDTXZsfLncDrcRV/sIIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873708; c=relaxed/simple;
	bh=/ijmukiV/b7LLfdy2QUDUXWQyNDenYpi0TlldoBaqzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVdulIEYzZpd0RHdzjGrhNOkpm0kG+uEsTzHWpFN0gcgzJj0AeWM7/CLN2lQrXgIyK+gsqzzqCLmhMv/7r2RWU31lJqYUBDe2vhCSDD1ZBB91A1U3vYBbeM8oHsqW1ZOv4waIVdovMCCHZiRJcVNiT6hoeHnlHzLgE++0ESux6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vpPtPGbA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpPtPGbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E7DC4CEEB;
	Mon,  2 Jun 2025 14:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873708;
	bh=/ijmukiV/b7LLfdy2QUDUXWQyNDenYpi0TlldoBaqzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vpPtPGbAFMGEyxTVnKcYmgSFCgWIKgjO9IqWHigid4qHjIg3NTd1PqzdNe0pZwwut
	 hm8JaovrNclUDvMVh047z7FbbG3HsdFPtgDnFif4dUUEKyzv0L1yLFWX27d40KOY0y
	 te1WsLojD9LObLSSD6tcmQMF0+ldWzI6RU+ysN5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 225/444] ASoC: tas2764: Add reg defaults for TAS2764_INT_CLK_CFG
Date: Mon,  2 Jun 2025 15:44:49 +0200
Message-ID: <20250602134350.046425946@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Hector Martin <marcan@marcan.st>

[ Upstream commit d64c4c3d1c578f98d70db1c5e2535b47adce9d07 ]

Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20250208-asoc-tas2764-v1-4-dbab892a69b5@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index e87a07eee9737..4e5381c07f504 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -636,6 +636,7 @@ static const struct reg_default tas2764_reg_defaults[] = {
 	{ TAS2764_TDM_CFG2, 0x0a },
 	{ TAS2764_TDM_CFG3, 0x10 },
 	{ TAS2764_TDM_CFG5, 0x42 },
+	{ TAS2764_INT_CLK_CFG, 0x19 },
 };
 
 static const struct regmap_range_cfg tas2764_regmap_ranges[] = {
-- 
2.39.5



