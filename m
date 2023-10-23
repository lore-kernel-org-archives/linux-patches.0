Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4B415E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pgx+031O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBABC433C7;
	Mon, 23 Oct 2023 11:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060960;
	bh=FU2cxxSRIXVZQETIWFQBseYfPGR6wJOjkljcvuFEcbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pgx+031OhZUiyE5Ac4YrzrSRLSY4PomTJ+xMkfh+x4DsoAfVeZGu5qh84aGooRFVH
	 O4pfxAgS5epgYrdaL2vb5KPlW8/0WT0rcLoNqyEJAyCVBYUFYRceZ8Sub3SD4UFilH
	 1SuGQZ99ua0SMhF6IaBUE1I4DplkbxAAr70A1h44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 027/137] ASoC: codecs: wcd938x: drop bogus bind error handling
Date: Mon, 23 Oct 2023 12:56:24 +0200
Message-ID: <20231023104821.911918261@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit bfbc79de60c53e5fed505390440b87ef59ee268c upstream.

Drop the bogus error handling for a soundwire device backcast during
bind() that cannot fail.

Fixes: 16572522aece ("ASoC: codecs: wcd938x-sdw: add SoundWire driver")
Cc: stable@vger.kernel.org      # 5.14
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231003155558.27079-2-johan+linaro@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd938x.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/sound/soc/codecs/wcd938x.c
+++ b/sound/soc/codecs/wcd938x.c
@@ -4424,10 +4424,6 @@ static int wcd938x_bind(struct device *d
 	wcd938x->sdw_priv[AIF1_CAP] = dev_get_drvdata(wcd938x->txdev);
 	wcd938x->sdw_priv[AIF1_CAP]->wcd938x = wcd938x;
 	wcd938x->tx_sdw_dev = dev_to_sdw_dev(wcd938x->txdev);
-	if (!wcd938x->tx_sdw_dev) {
-		dev_err(dev, "could not get txslave with matching of dev\n");
-		return -EINVAL;
-	}
 
 	/* As TX is main CSR reg interface, which should not be suspended first.
 	 * expicilty add the dependency link */


