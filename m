Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F73218ACC;
	Tue,  6 May 2025 21:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567413; cv=none; b=anKlUymTEB6PEH0f6kcFNmQ02SGWF+TyWas3hBDY1lGoicxtQHl2O5Vvo39hp1e2xp0KoHgx0ZF5XWRiYRkkQkkaCLLYBk8UWSWz3Aw23+fRu1l+UHn3jsa9WuJRELZ5dPY0foxvG0RKPlndcKllF9CtNOrmYBo1FgZZFlrO9Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567413; c=relaxed/simple;
	bh=+fNJE1yTF2PALBlbEE+UifwLAvbWwqAE5ZTkWve7cD4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZBNeVIw8DYiTcOR6WmYCm/je1btMdRBkly+DCDO6NgsTVyY+0A3rcEj3h1A+U1OV8YJS5DRSznoRn3Ff8uhiNIjGAB1/Bmrlwk6rnsH36Yzze+sKqE7PSQ+R8G1oXVJkC+XNA+qpwxYiGLs5Pev4ACEbxFYJ6JIMqzTa3yjZjaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V95Btymw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V95Btymw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC145C4CEE4;
	Tue,  6 May 2025 21:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567413;
	bh=+fNJE1yTF2PALBlbEE+UifwLAvbWwqAE5ZTkWve7cD4=;
	h=From:To:Cc:Subject:Date:From;
	b=V95BtymwV/E5DqMEVgxfcFw1cm+UfaeVTE4Ot+mz1hWuy5jquRBNrGqRbMcxK60gm
	 kGgBDOHhzzVxIxKncgDuCr2T+PSlv9hDzWDuk9tpjo3a6/wKiHKvSZzqntNZohn9b/
	 QfigwMXfLSE9koBDnxL1KxkO7bZMDv7XguJ3PNC9pPpF6k+TrKV93CaHY+NIgjFd0/
	 snS4zfT2WYuuwQvRXNfGoCwgLuZatdeUpnuDrnzlrn7xcJ9tJ/zkrMH5vMdZs0slgG
	 FfYLVyOlHNQsuvnsvytTfhx0CvCskXCzITY4/HG9Co3r94bAB5MmLdHbVsoJnz/FI6
	 05om8T1x1HVIA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chenyuan Yang <chenyuan0y@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	shengjiu.wang@gmail.com,
	Xiubo.Lee@gmail.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	shawnguo@kernel.org,
	linux-sound@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 01/12] ASoC: imx-card: Adjust over allocation of memory in imx_card_parse_of()
Date: Tue,  6 May 2025 17:36:36 -0400
Message-Id: <20250506213647.2983356-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.89
Content-Transfer-Encoding: 8bit

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit a9a69c3b38c89d7992fb53db4abb19104b531d32 ]

Incorrect types are used as sizeof() arguments in devm_kcalloc().
It should be sizeof(dai_link_data) for link_data instead of
sizeof(snd_soc_dai_link).

This is found by our static analysis tool.

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Link: https://patch.msgid.link/20250406210854.149316-1-chenyuan0y@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-card.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/imx-card.c b/sound/soc/fsl/imx-card.c
index 7128bcf3a743e..bb304de5cc38a 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -517,7 +517,7 @@ static int imx_card_parse_of(struct imx_card_data *data)
 	if (!card->dai_link)
 		return -ENOMEM;
 
-	data->link_data = devm_kcalloc(dev, num_links, sizeof(*link), GFP_KERNEL);
+	data->link_data = devm_kcalloc(dev, num_links, sizeof(*link_data), GFP_KERNEL);
 	if (!data->link_data)
 		return -ENOMEM;
 
-- 
2.39.5

