Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3543A34F24E;
	Tue, 16 Dec 2025 11:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886176; cv=none; b=c5Y0JUVHi9bf/m3+6pBsddjWS4aPc0LU6HeQEPpaj9rtPm4Jvecbp8gfohcBSZDW8eRJAJNpKB5N5i9GYhYjtnRt5OHZ96cPXJI7imRkh/4EZJwaMwdPbTEKAdpnxxbFqUYdL2cTrjZXmLHxu/uIPpzxWm8yl8psP0vkpAU0v3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886176; c=relaxed/simple;
	bh=QRv/Awahz/j048jyv1GpI1wxGyjyHfb4j6lgQ/g+xnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6LFcSVi380VEpMoOlLq7ior1gjYn8a74Ss8x7BdPm0lVw+E1fECKZCMy6PaRftr90PO+gwvbkwbd9TopcHbSglwsTY4M3jsvKQLkvZEIKweE8dCJBY06Ns33GtXyIG6XdnvURToTHB7jPxeoEvmD7IFpV0NXNCRLClZPq0/60k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1hCjVY6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1hCjVY6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D59C16AAE;
	Tue, 16 Dec 2025 11:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886176;
	bh=QRv/Awahz/j048jyv1GpI1wxGyjyHfb4j6lgQ/g+xnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1hCjVY6HJEXVtWEw4e/HxpUEYp1E63Slu/FgEIN3W8frAJM+AOtiHA6oeismuYSGD
	 nN8eYsywu2C66E3Tv8dwCa/+sMEC6SHxuQVnqEuqJR3ARw5p08VevCJW5pRVCtajus
	 z/qeV0eYtZTc13GyWZEyMCLoyNSv/hOFR1M9N30w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seven Lee <wtli@nuvoton.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 361/507] ASoC: nau8325: add missing build config
Date: Tue, 16 Dec 2025 12:13:22 +0100
Message-ID: <20251216111358.535826597@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 6d7e4725d89cd..412f8710049d0 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -169,6 +169,7 @@ config SND_SOC_ALL_CODECS
 	imply SND_SOC_MT6359
 	imply SND_SOC_MT6660
 	imply SND_SOC_NAU8315
+	imply SND_SOC_NAU8325
 	imply SND_SOC_NAU8540
 	imply SND_SOC_NAU8810
 	imply SND_SOC_NAU8821
@@ -2655,6 +2656,10 @@ config SND_SOC_MT6660
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
index a68c3d192a1b6..53976868e6a79 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -190,6 +190,7 @@ snd-soc-mt6359-y := mt6359.o
 snd-soc-mt6359-accdet-y := mt6359-accdet.o
 snd-soc-mt6660-y := mt6660.o
 snd-soc-nau8315-y := nau8315.o
+snd-soc-nau8325-y := nau8325.o
 snd-soc-nau8540-y := nau8540.o
 snd-soc-nau8810-y := nau8810.o
 snd-soc-nau8821-y := nau8821.o
@@ -610,6 +611,7 @@ obj-$(CONFIG_SND_SOC_MT6359)	+= snd-soc-mt6359.o
 obj-$(CONFIG_SND_SOC_MT6359_ACCDET) += mt6359-accdet.o
 obj-$(CONFIG_SND_SOC_MT6660)	+= snd-soc-mt6660.o
 obj-$(CONFIG_SND_SOC_NAU8315)   += snd-soc-nau8315.o
+obj-$(CONFIG_SND_SOC_NAU8325)   += snd-soc-nau8325.o
 obj-$(CONFIG_SND_SOC_NAU8540)   += snd-soc-nau8540.o
 obj-$(CONFIG_SND_SOC_NAU8810)   += snd-soc-nau8810.o
 obj-$(CONFIG_SND_SOC_NAU8821)   += snd-soc-nau8821.o
-- 
2.51.0



