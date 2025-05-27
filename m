Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051161D432D;
	Tue, 27 May 2025 17:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365387; cv=none; b=JtXF50ymW0+pZQ83DeYXjodjnECttT4Dz5vi67aLYMUU+Ztny7TiSk9vdKbgZt+bz6SE8HJDyd31BhhDcColbU5P8vd/feRiwev0Idw7p76+zM/ufaHeRaqKZs2aKi+gXppVixBwnZ6UULNWrTQ0DKjwBVoGkgU7/+nnYEivYoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365387; c=relaxed/simple;
	bh=+blBK4+wE40+hQKiyAp1nTtLPE2h5bAD1P7hNPYFRUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fflBty8pC5d8NYdXmLIoglSMSADLrhSzGvmlwmgWw0qTZC92BK/uTQkuva1XIdPq5OBQg/SyZfwWOcCwPnzrkhKtbGM5oEEJ4AG04r94TCSL5zvzOCZICrNR8MGuXDvSoCGgdzZ/MSMr7tKBZyUPIQOccQj4WjsCzkUeXsZLCIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrI4mTwO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrI4mTwO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5655DC4CEE9;
	Tue, 27 May 2025 17:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365386;
	bh=+blBK4+wE40+hQKiyAp1nTtLPE2h5bAD1P7hNPYFRUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LrI4mTwOfyT/IXsBhbx3f109ZxBTJCii2O+co50uQqeYVzBn6koLXbFEMvYEI/9Cu
	 SLj2wKbSBVe5sZO+AkEo08RTN2s9WTUHulIQB+TMRG7rdIKr0oqyQ1CLghYeu+QU27
	 UQFFVQW99H0R7UgzQwYF7DoaiFVRj+KnoCrwQAmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 360/626] ASoC: tas2764: Mark SW_RESET as volatile
Date: Tue, 27 May 2025 18:24:13 +0200
Message-ID: <20250527162459.641926203@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bc0a73fc7ab41..31f94c8cf2844 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -652,6 +652,7 @@ static const struct regmap_range_cfg tas2764_regmap_ranges[] = {
 static bool tas2764_volatile_register(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
+	case TAS2764_SW_RST:
 	case TAS2764_INT_LTCH0 ... TAS2764_INT_LTCH4:
 	case TAS2764_INT_CLK_CFG:
 		return true;
-- 
2.39.5



