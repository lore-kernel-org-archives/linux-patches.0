Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C2A166315;
	Tue, 30 Jul 2024 17:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360821; cv=none; b=VZ6JqBoPD8uHmpJsg7siiq2CuwCIAyiz2YSWDq387TGlXUgnFexyf6cUfNMZ+tM9VZec9H7Xs7WzX+qDznKxZzh1FkBdSD1cMm7eAy/qw4eCPNNIMNzHpUHRvtOqaz5MaheCZjRpeyDPrfDOQ+s4a4Vj5icSpPUzLE0ZjzeqAYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360821; c=relaxed/simple;
	bh=Vasg8TcOHBaZVaw2oCHg2WTgTTtNksQtPzYfp0uCsOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2cCY2DRtLGWH+Eq+OLVmNEyEYAvTma1TlulY+liU5/ISSp3Kd/VrrW6reFcpGglhhk6zEsTStbqkjvn9CHo63flQMz/AvsUIN4UgzTSKYVko8BMjAo7HorfG6tUC7u+FMsfTnrffVI3/1QvLGbCq4t/ypUgdTeZwN6XS5CR1/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y24YsBpQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y24YsBpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903DDC32782;
	Tue, 30 Jul 2024 17:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360821;
	bh=Vasg8TcOHBaZVaw2oCHg2WTgTTtNksQtPzYfp0uCsOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y24YsBpQcygoTh3IryD04DWnrWAjjHxiOcVlnd5yNFYwFLowSUWV8MqS6vkWmTk41
	 cpsWWZi+Q23iJhzFwimi5J7L4K/ZfswWF+CTOtGCtf9jzNC8X9n4EJSOgiK81WkG/C
	 0ABEv1UH+/Qqh888Wp/+0LfG+Uyjgb47vNN3ZZ90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 792/809] ASoC: TAS2781: Fix tasdev_load_calibrated_data()
Date: Tue, 30 Jul 2024 17:51:08 +0200
Message-ID: <20240730151756.251072824@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 92c78222168e9035a9bfb8841c2e56ce23e51f73 ]

This function has a reversed if statement so it's either a no-op or it
leads to a NULL dereference.

Fixes: b195acf5266d ("ASoC: tas2781: Fix wrong loading calibrated data sequence")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/18a29b68-cc85-4139-b7c7-2514e8409a42@stanley.mountain
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2781-fmwlib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2781-fmwlib.c b/sound/soc/codecs/tas2781-fmwlib.c
index 838d29fead961..08082806d5892 100644
--- a/sound/soc/codecs/tas2781-fmwlib.c
+++ b/sound/soc/codecs/tas2781-fmwlib.c
@@ -2163,7 +2163,7 @@ static void tasdev_load_calibrated_data(struct tasdevice_priv *priv, int i)
 		return;
 
 	cal = cal_fmw->calibrations;
-	if (cal)
+	if (!cal)
 		return;
 
 	load_calib_data(priv, &cal->dev_data);
-- 
2.43.0



