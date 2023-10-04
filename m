Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09561D6B0
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IkGgKclB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B34C433C7;
	Wed,  4 Oct 2023 18:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444049;
	bh=o81k4fFC9dDukNJ8dDss4ApzzeTQfxtBnaZB83RGPvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IkGgKclBFDmTSkqymTZil86Mvxoy/SiYp9LU22OV2OVyVmGJbrlNCbulFc+nbaAwI
	 AgqUxBJsIbwtSe6EBc7dkfmRxG0hnbSNzPeHOU8EMAQ8sH4o2iJYTmsTVwq7eAOl+5
	 oalVMdDU/lq4EcwB2VDBdOCkkAQeMwSlg41VTKXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 112/321] ASoC: cs35l56: Disable low-power hibernation mode
Date: Wed,  4 Oct 2023 19:54:17 +0200
Message-ID: <20231004175234.416910321@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

commit 18789be8e0d9fbb78b2290dcf93f500726ed19f0 upstream.

Do not allow the CS35L56 to be put into its lowest power
"hibernation" mode. This only affects I2C because "hibernation"
is already disabled on SPI and SoundWire.

Recent firmwares need a different wake-up sequence. Until
that sequence has been specified, the chip "hibernation" mode
must be disabled otherwise it can intermittently fail to wake.

Backport note: This is the same change as upstream commit, to delete
one line, but the upstream commit would not apply cleanly on older
branches because of minor differences to the surrounding code.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20230912133841.3480466-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56-i2c.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/codecs/cs35l56-i2c.c b/sound/soc/codecs/cs35l56-i2c.c
index 40666e6698ba9..b69441ec8d99f 100644
--- a/sound/soc/codecs/cs35l56-i2c.c
+++ b/sound/soc/codecs/cs35l56-i2c.c
@@ -27,7 +27,6 @@ static int cs35l56_i2c_probe(struct i2c_client *client)
 		return -ENOMEM;
 
 	cs35l56->dev = dev;
-	cs35l56->can_hibernate = true;
 
 	i2c_set_clientdata(client, cs35l56);
 	cs35l56->regmap = devm_regmap_init_i2c(client, regmap_config);
-- 
2.40.1



