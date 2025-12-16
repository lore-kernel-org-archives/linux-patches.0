Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6383563C6;
	Tue, 16 Dec 2025 12:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888124; cv=none; b=W+GKXJ8spWn3FO2OSAy1R4p8ULaJNoICiWCJkzggFmhMxUrGjBIzp/5G/dHuGWTydFbaOYt750lC6pyw2+JzBcKm9a//TJRA0Y1D8ic/BMPV0JZ12CpzXwESaCpcaS7tQKxTWAVLIfJOVj35heSukBYJgFgsB7il4uD4+zZn4/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888124; c=relaxed/simple;
	bh=9za3bZAHoBybkSkd78LnqprJTiu41Pss3VTPDMlpcwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACqBxPjcBXUNj7hdKlSWmPhqKTCGxuHganzkbfVRbO2f+P69xM2g8PkO/kDuCNbRussg0d6SKOUMZd/rMzjN0HCx+uA104K5J/j1ffUOXd02EPkGBcvsUydFCC4f5U+nPezb3yRTK7dZDhxeUwFSAsK5Z7MdTPEerZCdq5uJ4bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PGY2eD5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PGY2eD5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F37C4CEF1;
	Tue, 16 Dec 2025 12:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888124;
	bh=9za3bZAHoBybkSkd78LnqprJTiu41Pss3VTPDMlpcwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PGY2eD5EEreKA/VDjxJYLG8Q/bagujInKI78TsyjVaoaGawpv0+iQXY97JU/lrO9E
	 LfybA20T6+rYb+eIOtJjn9xoEZk7FepKg6wAHbfCPyekV8+Xjb2Ax9LWRWdV4zcdXD
	 T5Ks2qAnkblcw2f+RA1JUJ+ZC5/Trrp8ooOICh8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seven Lee <wtli@nuvoton.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 439/614] ASoC: nau8325: add missing build config
Date: Tue, 16 Dec 2025 12:13:26 +0100
Message-ID: <20251216111417.278888039@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaroslav Kysela <perex@perex.cz>

[ Upstream commit cd41d3420ef658b2ca902d7677536ec8e25b610a ]

This configuration was missing from the initial commit.

Found by Jiri Benc <jbenc@redhat.com>

Fixes: c0a3873b9938 ("ASoC: nau8325: new driver")
Cc: Seven Lee <wtli@nuvoton.com>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://patch.msgid.link/20251126091759.2490019-3-perex@perex.cz
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Kconfig  | 5 +++++
 sound/soc/codecs/Makefile | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 160c07699a8b7..91ac99bc3edb2 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -170,6 +170,7 @@ config SND_SOC_ALL_CODECS
 	imply SND_SOC_MT6359
 	imply SND_SOC_MT6660
 	imply SND_SOC_NAU8315
+	imply SND_SOC_NAU8325
 	imply SND_SOC_NAU8540
 	imply SND_SOC_NAU8810
 	imply SND_SOC_NAU8821
@@ -2715,6 +2716,10 @@ config SND_SOC_MT6660
 config SND_SOC_NAU8315
 	tristate "Nuvoton Technology Corporation NAU8315 CODEC"
 
+config SND_SOC_NAU8325
+	tristate "Nuvoton Technology Corporation NAU8325 CODEC"
+	depends on I2C
+
 config SND_SOC_NAU8540
 	tristate "Nuvoton Technology Corporation NAU85L40 CODEC"
 	depends on I2C
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index bd95a7c911d5c..da4077463278e 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -192,6 +192,7 @@ snd-soc-mt6359-y := mt6359.o
 snd-soc-mt6359-accdet-y := mt6359-accdet.o
 snd-soc-mt6660-y := mt6660.o
 snd-soc-nau8315-y := nau8315.o
+snd-soc-nau8325-y := nau8325.o
 snd-soc-nau8540-y := nau8540.o
 snd-soc-nau8810-y := nau8810.o
 snd-soc-nau8821-y := nau8821.o
@@ -618,6 +619,7 @@ obj-$(CONFIG_SND_SOC_MT6359)	+= snd-soc-mt6359.o
 obj-$(CONFIG_SND_SOC_MT6359_ACCDET) += mt6359-accdet.o
 obj-$(CONFIG_SND_SOC_MT6660)	+= snd-soc-mt6660.o
 obj-$(CONFIG_SND_SOC_NAU8315)   += snd-soc-nau8315.o
+obj-$(CONFIG_SND_SOC_NAU8325)   += snd-soc-nau8325.o
 obj-$(CONFIG_SND_SOC_NAU8540)   += snd-soc-nau8540.o
 obj-$(CONFIG_SND_SOC_NAU8810)   += snd-soc-nau8810.o
 obj-$(CONFIG_SND_SOC_NAU8821)   += snd-soc-nau8821.o
-- 
2.51.0



