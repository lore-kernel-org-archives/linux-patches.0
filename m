Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6144C2820B6;
	Tue,  2 Sep 2025 13:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819848; cv=none; b=Zyr72dRVOerCw7afWmNrPivBLHnI5kSToP0peS+1p4t/f137vlxGydvqWM+3Q96mqkY6sd3rK4pk7MAc86b7DM0ItA2a3GrwW5I2jh3vqDWPR0ohTdW2TUeRYsRbR254xp3qXl5VcONXTxqek3RxL6fQ+BHtNH7W+EdZr1e8AIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819848; c=relaxed/simple;
	bh=qKl6OgBVWmhYRx13oOQEL/DXf4aE6CBklzA/hqC/SMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VpV7p7BRL9+QcOTbof/0xI6QG91Wp/M9hqUGA83RlQlXyIqqaB/Wr9PLHC71nJYv0D5PainIaifsaO/qz8ZyEkELE4xcCkY5S2ChgvuWawGPKJRd1IZLBu+ridRsN21mEnGFmWMP5PsCt5ma+/MjtJUY/te8qqQspOaOqFMJehg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vhtLjRvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vhtLjRvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C77C4CEED;
	Tue,  2 Sep 2025 13:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819848;
	bh=qKl6OgBVWmhYRx13oOQEL/DXf4aE6CBklzA/hqC/SMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vhtLjRvUHQT7hS4XHW4IOVMLafCDzEnW5pL5ajWAFVA6A0OffOIIRCVd/MJ5etO61
	 50hhogeJu/wd8+r9b3UD4noKDn8gW5h2fjkfspgomCko+kli7LMNay/9nw1kDQzFFn
	 qxNHn+uxXF1sb8eZ9639ZygaJ5a1cN1OXJIAjgJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srini@kernel.org>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 15/95] ASoC: codecs: tx-macro: correct tx_macro_component_drv name
Date: Tue,  2 Sep 2025 15:19:51 +0200
Message-ID: <20250902131940.199543051@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Klimov <alexey.klimov@linaro.org>

[ Upstream commit 43e0da37d5cfb23eec6aeee9422f84d86621ce2b ]

We already have a component driver named "RX-MACRO", which is
lpass-rx-macro.c. The tx macro component driver's name should
be "TX-MACRO" accordingly. Fix it.

Cc: Srinivas Kandagatla <srini@kernel.org>
Signed-off-by: Alexey Klimov <alexey.klimov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20250806140030.691477-1-alexey.klimov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-tx-macro.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/lpass-tx-macro.c b/sound/soc/codecs/lpass-tx-macro.c
index a134584acf909..74e69572796b5 100644
--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -2230,7 +2230,7 @@ static int tx_macro_register_mclk_output(struct tx_macro *tx)
 }
 
 static const struct snd_soc_component_driver tx_macro_component_drv = {
-	.name = "RX-MACRO",
+	.name = "TX-MACRO",
 	.probe = tx_macro_component_probe,
 	.controls = tx_macro_snd_controls,
 	.num_controls = ARRAY_SIZE(tx_macro_snd_controls),
-- 
2.50.1



