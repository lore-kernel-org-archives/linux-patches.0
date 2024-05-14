Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8D12B9AD;
	Tue, 14 May 2024 11:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687702; cv=none; b=toKAnsD0C+EfQJd6LIyKJSMl4GNpXHlGVfoBu6Szy1lqCfhNVulhJgI5CMPtseXqLSnv8HTFTS4o+a3P4nP4cV02SQhc4VjYzfGwf+N4Elc/GzZFFXmXfzYv666SsAu7d9IBc37Bz7gUGvNc/B6OPSPpO7SNz7a84djddfWp8OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687702; c=relaxed/simple;
	bh=5k+XTXSxCDXONzseZJOa0vPf7vT9UMaWJEIPHewjdsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnUqtSFxy19exAgYTgOZaj6RNW0TvWDhu26mFltCazzaTPALYcz0dyYzU2+17gt8oqTdCX256loG+6oWgLOunnTnIpGz/t2DwXbTNKwaPLgvi+kEz/73/nGLPlhiuCjmw/P8RBJUF3Os3VsKoN157aXhgEVkKwe5LgT9Cn3JpeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BczT8j8p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BczT8j8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54A9C32781;
	Tue, 14 May 2024 11:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687702;
	bh=5k+XTXSxCDXONzseZJOa0vPf7vT9UMaWJEIPHewjdsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BczT8j8prEVNm7BS3I4LXEB/9sIGFp5UjayaSUn6YEHzJcbzXZcoXtAfSydLPqyi5
	 9VeFcrc4vBIHAJO7jBLsnScOuqOaG3k6cfOniYAXaYOp/mnPJ3qzFdy3PElXMAsRVu
	 G2ijd7bRd9pkVu6nqkv7aFPy4HS1pzYdfZPx+HHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/168] ASoC: meson: axg-card: make links nonatomic
Date: Tue, 14 May 2024 12:19:02 +0200
Message-ID: <20240514101008.356882791@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit e138233e56e9829e65b6293887063a1a3ccb2d68 ]

Non atomic operations need to be performed in the trigger callback
of the TDM interfaces. Those are BEs but what matters is the nonatomic
flag of the FE in the DPCM context. Just set nonatomic for everything so,
at least, it is clear.

Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20211020114217.133153-2-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/axg-card.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/meson/axg-card.c b/sound/soc/meson/axg-card.c
index 2b77010c2c5ce..cbbaa55d92a66 100644
--- a/sound/soc/meson/axg-card.c
+++ b/sound/soc/meson/axg-card.c
@@ -320,6 +320,7 @@ static int axg_card_add_link(struct snd_soc_card *card, struct device_node *np,
 
 	dai_link->cpus = cpu;
 	dai_link->num_cpus = 1;
+	dai_link->nonatomic = true;
 
 	ret = meson_card_parse_dai(card, np, &dai_link->cpus->of_node,
 				   &dai_link->cpus->dai_name);
-- 
2.43.0



