Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1771EB5B
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2FRxqK0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4B4C433C8;
	Mon,  6 Nov 2023 13:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276377;
	bh=L/u4dkvta+j4R9eMfevTIEInDAzP7mnpRclbRKdD4OI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2FRxqK0p5fuHCrCb6z61577BVGlZSLeesg4lPRKqeRTREsFIKUvSk0qQs7uG0ITTD
	 kYoDUVC8S+RG7Xh/Isk/zcaEbnpwEJmCVhZb5guVrfwKXR4t3uY43goTjhe/yZBJYz
	 puL9Y9Mqa5uYczxMeiBHMLxRLVoomog+ZaUskR3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roy Chateau <roy.chateau@mep-info.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 22/62] ASoC: codecs: tas2780: Fix log of failed reset via I2C.
Date: Mon,  6 Nov 2023 14:03:28 +0100
Message-ID: <20231106130302.608202612@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>
References: <20231106130301.807965064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Roy Chateau <roy.chateau@mep-info.com>

[ Upstream commit 4e9a429ae80657bdc502d3f5078e2073656ec5fd ]

Correctly log failures of reset via I2C.

Signed-off-by: Roy Chateau <roy.chateau@mep-info.com>
Link: https://lore.kernel.org/r/20231013110239.473123-1-roy.chateau@mep-info.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2780.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2780.c b/sound/soc/codecs/tas2780.c
index afdf0c863aa10..a2d27410bbefa 100644
--- a/sound/soc/codecs/tas2780.c
+++ b/sound/soc/codecs/tas2780.c
@@ -39,7 +39,7 @@ static void tas2780_reset(struct tas2780_priv *tas2780)
 		usleep_range(2000, 2050);
 	}
 
-	snd_soc_component_write(tas2780->component, TAS2780_SW_RST,
+	ret = snd_soc_component_write(tas2780->component, TAS2780_SW_RST,
 				TAS2780_RST);
 	if (ret)
 		dev_err(tas2780->dev, "%s:errCode:0x%x Reset error!\n",
-- 
2.42.0



