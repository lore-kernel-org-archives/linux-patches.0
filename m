Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4B32ECD1A;
	Tue,  2 Sep 2025 13:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820139; cv=none; b=fxDQotiz8tGP6ut3f+qtpcKa26oKIuKCeo8gJaVBFg4HT/jOBP1GncTNxZyZc6IWrImQYLgKOkqL3e6gN12nIGGIwn1SkYJSiMwee/ywL6tXrBo3nxqBZSuixG7eCmL7EBACQUYqSq9DGjWkH8lSB0T5vzIA5L/p42V15Kf2+1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820139; c=relaxed/simple;
	bh=c01Bt79rOQ0AX/RfuG4RMAN6xFN0vC5kittDoJetQYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDJNgQB36yJiwIV+Rk9GpLUp3WHV68xm8nwRpLcwzaZkVJQria23+S8hUD/jRZeXjDU/lDtm0XNxNXyD5KoneMquWwQTij1oV77EzP/QW0GtTQksApHwI0HeFtjv3CHjiHGDX0BJ5LntOQWSmP3JW2Gnmwoe/g+oz01SzYzwc1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xawPWm/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xawPWm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16DAC4CEF5;
	Tue,  2 Sep 2025 13:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820139;
	bh=c01Bt79rOQ0AX/RfuG4RMAN6xFN0vC5kittDoJetQYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1xawPWm/QJUYWFK3OhNzlVHYUU6aFcJwdV9ckI6AsGfBU44IHnZ856aJqS9gKAfV0
	 gdLa0CAh5g3EgCOon1hAvac1vMC4WN95bPXhcKbAdQuxRtRK6n8K6v3ysefAos05Oj
	 5L6909SBtiujbeZX4RGcPNxqe/GQH7aVWIbsoem4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srini@kernel.org>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 11/75] ASoC: codecs: tx-macro: correct tx_macro_component_drv name
Date: Tue,  2 Sep 2025 15:20:23 +0200
Message-ID: <20250902131935.561134696@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ebddfa74ce0a0..150ed10c8377a 100644
--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -1940,7 +1940,7 @@ static int tx_macro_register_mclk_output(struct tx_macro *tx)
 }
 
 static const struct snd_soc_component_driver tx_macro_component_drv = {
-	.name = "RX-MACRO",
+	.name = "TX-MACRO",
 	.probe = tx_macro_component_probe,
 	.controls = tx_macro_snd_controls,
 	.num_controls = ARRAY_SIZE(tx_macro_snd_controls),
-- 
2.50.1



