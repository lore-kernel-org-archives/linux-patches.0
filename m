Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EF31E32D7;
	Wed, 19 Feb 2025 08:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954240; cv=none; b=rYqlspEDcC7SdHk8gGK1vm9AcVqvRXaX5HTUGjJAfYl1M40DD7ODs7BaLoZOIcVpByuIoxGR0ShW9gK6rck83ejuHRqXOuGHurHAhMI3w3MHfUlPWKqb69w9hFXIKg29kYF2nxiDK669K6CUTL7gU2EjvaF/rjXiLFX1iMN8A/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954240; c=relaxed/simple;
	bh=rzmBRuWXb3v6WnDkC605zE7Fq5SULc3Z2CbR2RtNzGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuvmX4kWrTBcq/iXV2YmYRdl0kz4P8eJhW6tkHWUP0j7LgEtQQ/5uEl1O1e3hYqwUyfpktmTp07YgOFM1B1HU39k9bdttmxPRek4rYN0aYg9paosz9WNloBn7uEeKWL7KMl5MWHdIFqod9SEmobvbATLVyADRwkMLKbKtdjPIwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FfWIJE8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FfWIJE8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C02C4CED1;
	Wed, 19 Feb 2025 08:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954240;
	bh=rzmBRuWXb3v6WnDkC605zE7Fq5SULc3Z2CbR2RtNzGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FfWIJE8P09M7g1tyTf/gRq1oDiSztRVEFJKzCioKSndJs2Vc0c4DB7wT5gUWP5YC5
	 6LrXyAQCDs4KHW59c6qe3ttd5QiQKYeJ/kEoAjqQfAr79ruxHxpJkq9zUSLuYhncuq
	 4XOQm/AxpFUv4LjMfgxUF/GFImehtdGn6MInxKMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 109/274] ASoC: renesas: SND_SIU_MIGOR should depend on DMADEVICES
Date: Wed, 19 Feb 2025 09:26:03 +0100
Message-ID: <20250219082613.884006617@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 2e3c688ddaf2bb8e3696a773b5278711a90ea080 ]

If CONFIG_DMADEVICES=n:

    WARNING: unmet direct dependencies detected for SND_SOC_SH4_SIU
      Depends on [n]: SOUND [=y] && SND [=y] && SND_SOC [=y] && (SUPERH [=y] || ARCH_RENESAS || COMPILE_TEST [=n]) && ARCH_SHMOBILE [=y] && HAVE_CLK [=y] && DMADEVICES [=n]
      Selected by [y]:
      - SND_SIU_MIGOR [=y] && SOUND [=y] && SND [=y] && SND_SOC [=y] && (SUPERH [=y] || ARCH_RENESAS || COMPILE_TEST [=n]) && SH_MIGOR [=y] && I2C [=y]

SND_SIU_MIGOR selects SND_SOC_SH4_SIU.  As the latter depends on
DMADEVICES, the former should depend on DMADEVICES, too.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501241032.oOmsmzvk-lkp@intel.com/
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/8c17ff52584ce824b8b42d08ea1b942ebeb7f4d9.1737708688.git.geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/renesas/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/renesas/Kconfig b/sound/soc/renesas/Kconfig
index 426632996a0a3..cb01fb36355f0 100644
--- a/sound/soc/renesas/Kconfig
+++ b/sound/soc/renesas/Kconfig
@@ -67,7 +67,7 @@ config SND_SH7760_AC97
 
 config SND_SIU_MIGOR
 	tristate "SIU sound support on Migo-R"
-	depends on SH_MIGOR && I2C
+	depends on SH_MIGOR && I2C && DMADEVICES
 	select SND_SOC_SH4_SIU
 	select SND_SOC_WM8978
 	help
-- 
2.39.5



