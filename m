Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCEA1DF73C;
	Mon,  2 Jun 2025 15:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877095; cv=none; b=Sfm1kwrHjQXQIEayx5ghRPvxXCL1kAsJp2EyMLTl//G1vVnMSHf1d+czemaoLSieUDi9KrB0fKO2/oCI+QMTcEXEQmOFyyk4noVQaziveae798xD3HXoQV91OUDIsqowrebWoyXbMtrX8ecOWk+ZOwvqGCVdWxyUciVIWDxPQAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877095; c=relaxed/simple;
	bh=oK4FJfA6Is0SOg0p9n19tnptSE/9vwwt0etLWDcgOaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDfvTx+Ru9Q6XhBcj0AcmpkPTBSFDn8WBKcPz6xx+0TSd9PA4iCC+4V3REgDsgSmWt+mXK4UEHSA6OYumsJVYGWoQ4pwJz/Mwm2xzIU/QjhYGYuCxJpxiNLHbk3V8bnak31Pjm8BISYSa3JKDIOLqvanw9+tbZyXCRmnZZThFRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IN0Fglyl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IN0Fglyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F987C4CEEB;
	Mon,  2 Jun 2025 15:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877095;
	bh=oK4FJfA6Is0SOg0p9n19tnptSE/9vwwt0etLWDcgOaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IN0Fglyl30OUfX/PCaFa+GWRpLJWoTK374UCbzz9jVdLm/1p7kKQhXjWpOmK0Bpua
	 wI5kNS4nZu8wGa+2ADFFlSPuVKcVxMy5DoTtX1rhGX6uzYfqD3tQVN5zm6pSK+EdYM
	 BFJQZlQLxht1mTfs9Exs6RB/hKpgWxbVvxq06oAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 169/325] ASoC: tas2764: Mark SW_RESET as volatile
Date: Mon,  2 Jun 2025 15:47:25 +0200
Message-ID: <20250602134326.684468894@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hector Martin <marcan@marcan.st>

[ Upstream commit f37f1748564ac51d32f7588bd7bfc99913ccab8e ]

Since the bit is self-clearing.

Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20250208-asoc-tas2764-v1-3-dbab892a69b5@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index 72db361ac3611..94428487a8855 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -654,6 +654,7 @@ static const struct regmap_range_cfg tas2764_regmap_ranges[] = {
 static bool tas2764_volatile_register(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
+	case TAS2764_SW_RST:
 	case TAS2764_INT_LTCH0 ... TAS2764_INT_LTCH4:
 	case TAS2764_INT_CLK_CFG:
 		return true;
-- 
2.39.5



