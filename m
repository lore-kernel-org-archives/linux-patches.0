Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55058EC4;
	Tue, 20 May 2025 13:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749497; cv=none; b=PTrm5L7BD38tE1a2KjLJd1p8jnaW8eP5WUGoGMCPp4MgpilIA5TzXEj2rrn628Qy5hDHlHuFqUg1I4L+XJ4pzAi5k1r0kLo53ldH7qq+z1TKb2nDrUCu1SI123duYZoM7FqosYeDB0JLxZrd1CJk90TCg0PMziip2FedYE5QTaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749497; c=relaxed/simple;
	bh=wPw0ma1eIHo6NOlsO8tGxXYki/Ue+/IWR2Fo+MReBfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cu+mr5i2fMrKgu5jrpJaN/kSaXSygRifQ752z2d7DExdrVn3i3L9SPytAOVZCpUihAyZ00nMarpkhP8MSztQaA15oCS5yopeQVbO7p8GTqU8BUKQgRm9E04xOSpR/dTdEUX9syYS+/BbdrZ84+LdRuiIhxBw8rQYiAgLY8zt9Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLF2Hs2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLF2Hs2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBB9C4CEE9;
	Tue, 20 May 2025 13:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749497;
	bh=wPw0ma1eIHo6NOlsO8tGxXYki/Ue+/IWR2Fo+MReBfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DLF2Hs2+9FNeGQ8QS+mGXGAOarHyeP1A8W7hcssc9EQKr94duSWJFQr7wZBrLwJOd
	 T6HkqWBJvzd2x4iTZggR1KrIPkmjHPCrFmuAb8nTF7urakurQyVvburs2QOnjL6PeO
	 5kmzYlYMBVD7Z4ozdsUKtYjsSG83tO6PEBCI5s7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 33/97] ALSA: sh: SND_AICA should depend on SH_DMA_API
Date: Tue, 20 May 2025 15:49:58 +0200
Message-ID: <20250520125801.956325996@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 66e48ef6ef506c89ec1b3851c6f9f5f80b5835ff ]

If CONFIG_SH_DMA_API=n:

    WARNING: unmet direct dependencies detected for G2_DMA
      Depends on [n]: SH_DREAMCAST [=y] && SH_DMA_API [=n]
      Selected by [y]:
      - SND_AICA [=y] && SOUND [=y] && SND [=y] && SND_SUPERH [=y] && SH_DREAMCAST [=y]

SND_AICA selects G2_DMA.  As the latter depends on SH_DMA_API, the
former should depend on SH_DMA_API, too.

Fixes: f477a538c14d07f8 ("sh: dma: fix kconfig dependency for G2_DMA")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505131320.PzgTtl9H-lkp@intel.com/
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/b90625f8a9078d0d304bafe862cbe3a3fab40082.1747121335.git.geert+renesas@glider.be
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/sh/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/sh/Kconfig b/sound/sh/Kconfig
index b75fbb3236a7b..f5fa09d740b4c 100644
--- a/sound/sh/Kconfig
+++ b/sound/sh/Kconfig
@@ -14,7 +14,7 @@ if SND_SUPERH
 
 config SND_AICA
 	tristate "Dreamcast Yamaha AICA sound"
-	depends on SH_DREAMCAST
+	depends on SH_DREAMCAST && SH_DMA_API
 	select SND_PCM
 	select G2_DMA
 	help
-- 
2.39.5



