Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F57915AC5
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5770C433C7;
	Tue, 25 Jul 2023 10:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282255;
	bh=GGOQBBdRek3AH3MuzMCabXyqd63cH6fXVbP3+8/WVrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NSO12PejUTqjIYb+gmig6VbiqTQSBPkt8eFDcdHi4DvGodB00d3Z32whCPxF5c5G4
	 ibOPMXSxZODKQtC6VeghQl6SxjFeIwXHqAkWH2WLkR0s8p4fnkBdPUhNvzfLj1bDm5
	 oDxKCbvTf0f99JHZSN22Zam6CPJ1EMWeyDdJZcx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Seyfarth <m.seyfarth@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.4 062/227] ASoC: cs35l45: Select REGMAP_IRQ
Date: Tue, 25 Jul 2023 12:43:49 +0200
Message-ID: <20230725104517.317766590@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

commit d9ba2975e98a4bec0a9f8d4be4c1de8883fccb71 upstream.

After commit 6085f9e6dc19 ("ASoC: cs35l45: IRQ support"), without any
other configuration that selects CONFIG_REGMAP_IRQ, modpost errors out
with:

  ERROR: modpost: "regmap_irq_get_virq" [sound/soc/codecs/snd-soc-cs35l45.ko] undefined!
  ERROR: modpost: "devm_regmap_add_irq_chip" [sound/soc/codecs/snd-soc-cs35l45.ko] undefined!

Add the Kconfig selection to ensure these functions get built and
included, which resolves the build failure.

Cc: stable@vger.kernel.org
Fixes: 6085f9e6dc19 ("ASoC: cs35l45: IRQ support")
Reported-by: Marcus Seyfarth <m.seyfarth@gmail.com>
Closes: https://github.com/ClangBuiltLinux/linux/issues/1882
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20230703-cs35l45-select-regmap_irq-v1-1-37d7e838b614@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -701,6 +701,7 @@ config SND_SOC_CS35L41_I2C
 
 config SND_SOC_CS35L45
 	tristate
+	select REGMAP_IRQ
 
 config SND_SOC_CS35L45_SPI
 	tristate "Cirrus Logic CS35L45 CODEC (SPI)"


