Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48F9244196;
	Tue, 20 May 2025 13:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749142; cv=none; b=L6kPOug7aYgl+sD0zhKx4NV5O5L8Th/fAo9xTm0g3x8rdm3PeAiBUc1M+j9KKt01oBPH0nTnGK8anzUVvxNDrqRSyM72b5a7EE58U9/b/gUqqXuqqDRT23nF8UuV6shpJGaNW5INy6cItE9PZhw+uiYUz11rxNebiKnru46X11c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749142; c=relaxed/simple;
	bh=/NbC48qfcBX2MoebWKzDncK+byxSSWjOD55MGLxZWXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TS0grWVVbgl6KluxxB1jsFhdnbUgn2UquHf26+d+/EWjLG8SAYNhpR7B8o0YeLIBEN0dKBqM1ygwzsEq/VUw60p4pwLZ3/YYWl6bM3ZvH5Ie6m+1vFpyz8s131fLvt1TO4b/5Hm0sefU5sF+yzStRlL3Eifb9HZclBr9/43t9UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XcZ6A7+/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XcZ6A7+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84348C4CEE9;
	Tue, 20 May 2025 13:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749142;
	bh=/NbC48qfcBX2MoebWKzDncK+byxSSWjOD55MGLxZWXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XcZ6A7+/Dqs1h5kymV/PiyPjk/QpCiD2RnsAJ9v7xeOWGla+XkJRc0CQk1KF3UqyG
	 avm7wVOkn4SqYXiAkA4YkW89z+PXtPj6utNWbHzGYWhPAi1JNnz4ZMeFgyl5GM3gku
	 uTAdgL/o8tB2DxYx0PfdGkGxrEjj7NBzqLGJbWMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 11/59] ALSA: sh: SND_AICA should depend on SH_DMA_API
Date: Tue, 20 May 2025 15:50:02 +0200
Message-ID: <20250520125754.281104692@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



