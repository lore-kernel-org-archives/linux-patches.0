Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554BF280314;
	Tue, 27 May 2025 17:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367604; cv=none; b=D1c5Bqj1g38sXXnlK0faFaICarr5H2QkC1kL4PAiU77hCgSLlvsDcxzu7dDmPGCtV/RYkdz6VO6sMro4BWPHmsQzVSrvw+iUyZvZKfIaHtsBRCy7TcGL8q0N1Ix8mYjmCf8u5iSR3sbOVh42scTGkXTr1p+bbx7sRo+u9PX0S2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367604; c=relaxed/simple;
	bh=Z02/qLBzkLgOJYa0uYXUdUjPxOTZ+PLDMB35jNkCAwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDBg1euX3dDW6G3czEyFvtIVAXrqCh/jA99mXaAx/7aYcrJHKH0N5PtAZ3OpvYThSohI70cKWLXdaVFYUdFiM2pYEC9GZQJRO88+0HgpQPim9ls+ADuxIPfuhDhqc2Mb2nBq/2K6uC7a+4vexEPxxfMRH78eqHY9F4VLsFai5Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eEsK9Uka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eEsK9Uka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5D0C4CEEA;
	Tue, 27 May 2025 17:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367604;
	bh=Z02/qLBzkLgOJYa0uYXUdUjPxOTZ+PLDMB35jNkCAwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eEsK9Uka/LLCuk/jlSmtivYo2wfBCne5GHet3q/utffzLUcMkcVxeoNKpyMuEbKGI
	 t4/QG4ATNp2HELeKbbTCTGt+VjEKxIkXG0EwSBqCGXx4dzdFNHS54sVwT/D7V5egPc
	 ZVWKI7S4JJJcyhNVEg6ilSg+R5ZnCalHaarSfqJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 440/783] ASoC: tas2764: Add reg defaults for TAS2764_INT_CLK_CFG
Date: Tue, 27 May 2025 18:23:57 +0200
Message-ID: <20250527162531.053865111@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 58315eab492a1..bc0a73fc7ab41 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -634,6 +634,7 @@ static const struct reg_default tas2764_reg_defaults[] = {
 	{ TAS2764_TDM_CFG2, 0x0a },
 	{ TAS2764_TDM_CFG3, 0x10 },
 	{ TAS2764_TDM_CFG5, 0x42 },
+	{ TAS2764_INT_CLK_CFG, 0x19 },
 };
 
 static const struct regmap_range_cfg tas2764_regmap_ranges[] = {
-- 
2.39.5



