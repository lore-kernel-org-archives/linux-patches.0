Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56034BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4D9C433EF;
	Tue,  7 Mar 2023 18:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213041;
	bh=Ed/Gnb6Dioor4lM/pwGnTJjJuZQFFzidX40torlALKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OHBFc6JgrQRWnGe7ER8qCxoNF4q7M5uc8GRd182cVs6ia/wkHGMdMPV95P66yj0Vw
	 Y/ia3La0y49x1QVIBhbSIbtNcayhONo3KSNfWUAoYBOm8Et+wls4aoYU181nq9iY3R
	 Io+uAwp41gL8TETOt9Nr52iuR2DdsnxAvmGiMLVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 339/885] ASoC: rsnd: fixup #endif position
Date: Tue,  7 Mar 2023 17:54:33 +0100
Message-Id: <20230307170016.954122552@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 49123b51cd896e00b256a27c2ce9e6bfe1bbc22f ]

commit 1f9c82b5ab83ff2 ("ASoC: rsnd: add debugfs support") added
CONFIG_DEBUG_FS related definitions on rsnd.h, but it should be
added inside of RSND_H. This patch fixup it.

Fixes: 1f9c82b5ab83 ("ASoC: rsnd: add debugfs support")
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/877cx26t7r.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rcar/rsnd.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sh/rcar/rsnd.h b/sound/soc/sh/rcar/rsnd.h
index d9cd190d7e198..f8ef6836ef84e 100644
--- a/sound/soc/sh/rcar/rsnd.h
+++ b/sound/soc/sh/rcar/rsnd.h
@@ -901,8 +901,6 @@ void rsnd_mod_make_sure(struct rsnd_mod *mod, enum rsnd_mod_type type);
 	if (!IS_BUILTIN(RSND_DEBUG_NO_DAI_CALL))	\
 		dev_dbg(dev, param)
 
-#endif
-
 #ifdef CONFIG_DEBUG_FS
 int rsnd_debugfs_probe(struct snd_soc_component *component);
 void rsnd_debugfs_reg_show(struct seq_file *m, phys_addr_t _addr,
@@ -913,3 +911,5 @@ void rsnd_debugfs_mod_reg_show(struct seq_file *m, struct rsnd_mod *mod,
 #else
 #define rsnd_debugfs_probe  NULL
 #endif
+
+#endif /* RSND_H */
-- 
2.39.2



