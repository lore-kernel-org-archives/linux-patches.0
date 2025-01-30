Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1117B1E493C;
	Thu, 30 Jan 2025 14:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246882; cv=none; b=M5M04otyxwZGTWCCGZEHseM+QzrKTASqsCgKPjVoy9l+GjKbJkyb5fCHLgOQislwsqVg2X/rDM3U0T1PMW4+BthJxaiUOCW6xXpbd486mD3M1J1h8N/aFSQbNgXUhVAqCr/I/IfxM8g9JU1MF/dVXWfmYopqxTlRjJy89Iwxh9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246882; c=relaxed/simple;
	bh=eL0GORssWdJaRYosDqumLH7z1CK/GAaFvn8U1zT+iOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZHTiAtOClI802J22hdNsLmpeIc7nGnU49YhImbB8ysksVoe/tLp+gsEFI1QbHmZQLAnPM0vXmuRU5T0I4G/FG9EvTk1T8WqQDOmOYb/ky8wI9Iq/cBBhNBv9ZPfKjZ4BoS05AdYjE8/GPwV77lPxAsUH6mOSD3JN2Wt7uwSbiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aScg6JCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aScg6JCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA28C4CED2;
	Thu, 30 Jan 2025 14:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246881;
	bh=eL0GORssWdJaRYosDqumLH7z1CK/GAaFvn8U1zT+iOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aScg6JCGXoaCBhh8/+TxnHWo5gCcNETCzWbbxit35c9NP75rRFGX9g6w/blfZRjDA
	 UY/GbV8bbupuWvz1vQZUMQrvoQQxXqt7NDqFMKpbw6tW35C5LyoFOAUhqm5ARMfazx
	 TnbmO75zN5avNrWxNfmFlS4kh+t+7dUKan3IUxzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 75/91] ASoC: wm8994: Add depends on MFD core
Date: Thu, 30 Jan 2025 15:01:34 +0100
Message-ID: <20250130140136.690128306@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 5ed01155cea69801f1f0c908954a56a5a3474bed ]

The ASoC driver should not be used without the MFD component. This was
causing randconfig issues with regmap IRQ which is selected by the MFD
part of the wm8994 driver.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501061337.R0DlBUoD-lkp@intel.com/
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20250106154639.3999553-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index dfc536cd9d2fc..7b03ff158d782 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -1400,6 +1400,7 @@ config SND_SOC_WM8993
 
 config SND_SOC_WM8994
 	tristate
+	depends on MFD_WM8994
 
 config SND_SOC_WM8995
 	tristate
-- 
2.39.5



