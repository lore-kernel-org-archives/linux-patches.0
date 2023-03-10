Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B3A882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCFDC4339C;
	Fri, 10 Mar 2023 15:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461227;
	bh=aRWZLu9C7644AaKQoLFJo4O2hZk7uDSoFSjZdkGtu5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IVkVdPkH9+wG01Z65Cv0LeUzcQYvtGVpUgE92Yg6XHaYcK9tEdUBm+K6aYNhW8EIU
	 LXAcyrUFcRdJ2VdOsprV4d8IbQsmC9DDRxobqJYzen9IgBuGlb24srpl4oHn/V6KDQ
	 6MolhCDh2DqT0aP2Iglg7yCVkxVH9W0u+BKzMrWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/136] ASoC: zl38060: Remove spurious gpiolib select
Date: Fri, 10 Mar 2023 14:43:10 +0100
Message-Id: <20230310133709.207453811@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 8e70aaae32b72d3088d18a3447b67112b3f5979a ]

The usage of GPIOs is optional in the code so don't force on gpiolib when
building it, avoiding warnings in randconfigs.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220202192333.3655269-6-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0de2cc3707b6 ("ASoC: zl38060 add gpiolib dependency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index d59a7e99ce42a..e9d2408f8480c 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -1830,7 +1830,6 @@ config SND_SOC_WSA881X
 config SND_SOC_ZL38060
 	tristate "Microsemi ZL38060 Connected Home Audio Processor"
 	depends on SPI_MASTER
-	select GPIOLIB
 	select REGMAP
 	help
 	  Support for ZL38060 Connected Home Audio Processor from Microsemi,
-- 
2.39.2



