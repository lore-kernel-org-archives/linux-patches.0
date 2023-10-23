Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E3214A99
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iloQV43o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF9CC433C8;
	Mon, 23 Oct 2023 11:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059555;
	bh=WJ6bRM+hB52EvqDbs7VfNPE/LYIpBFVLrWOA8eqQxBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iloQV43oT99QcxOfubJWlRvM0DlBPje0tcnnOBvzftDqYkf80yfMu6rTuDDX8tx8o
	 08EPREqBXoUF1caiAVKzi1BSIa15ah5gdgm8dPiLMh+W+xLi7UkDDAP1Mx1LeYqL1q
	 mFYBbcWNDOvWn/JlG+zAPHH1UKRNkF5+pgU9L08g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 217/241] ASoC: cs42l42: Fix missing include of gpio/consumer.h
Date: Mon, 23 Oct 2023 12:56:43 +0200
Message-ID: <20231023104839.141749554@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit d6cbc6a3a856a7d8047316d81e2e039e44432acb ]

The call to gpiod_set_value_cansleep() in cs42l42_sdw_update_status()
needs the header file gpio/consumer.h to be included.

This was introduced by commit 2d066c6a7865 ("ASoC: cs42l42: Avoid stale
SoundWire ATTACH after hard reset")

and caused error:
    sound/soc/codecs/cs42l42-sdw.c:374:4: error: implicit declaration of
    function ‘gpiod_set_value_cansleep’;
    did you mean gpio_set_value_cansleep’?

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 2d066c6a7865 ("ASoC: cs42l42: Avoid stale SoundWire ATTACH after hard reset")
Link: https://lore.kernel.org/r/20231011134853.20059-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42-sdw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/cs42l42-sdw.c b/sound/soc/codecs/cs42l42-sdw.c
index 974bae4abfad1..94a66a325303b 100644
--- a/sound/soc/codecs/cs42l42-sdw.c
+++ b/sound/soc/codecs/cs42l42-sdw.c
@@ -6,6 +6,7 @@
 
 #include <linux/acpi.h>
 #include <linux/device.h>
+#include <linux/gpio/consumer.h>
 #include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
-- 
2.42.0



