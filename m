Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4C5194A45;
	Tue, 27 May 2025 16:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364500; cv=none; b=Xsfc0w41o+QjI6dSUnBLkoesHv12PVeOQNzTuSjqid1l0+mQq8sHZ724i3K23YOX4MtLs5ADsCJ7s+lAUnJPllQ+sadmdBlvZ/E0agNa96Gzba6ImkP6LcU8vacKA85cntU7jVuCoqKCARKJOO75MnANW4+EV9wtLqDy1wiMG7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364500; c=relaxed/simple;
	bh=+RbCDNxP75dSRYAyVImOZFpRoCd4P3jMoVYA0Bdl8Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIMcR3ySg1UT+bVW91uzcaS+j3iCvtLtdPodkOJdsxJ4EvFbqL0NuL0Fw6Rz3hJ87ZKQGzWrcceNkKE3TG952Guy2WVN8jakQFfxuq33LkXzktRY/zP1OnnLO7zJ1F9IS2sFIMFaXXS7h4G1G2v+HswgTz11v8/dMRTjoicJb+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GjLS+vgl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GjLS+vgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D12C4CEE9;
	Tue, 27 May 2025 16:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364500;
	bh=+RbCDNxP75dSRYAyVImOZFpRoCd4P3jMoVYA0Bdl8Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GjLS+vglgBAb7+wnFco5nHDB5Mc5T8lIoBMroxIttXO0co1+lyZgyX40Wiy8CQAJa
	 aN3Ix0Z/e5vDna1KET59YG8QMqAq4TLppJnCtbrhiKiAchSxG5Qaktepwi4XtgEoaY
	 R9piKbF3ky5YBmA71JLGVqparB8OhU2HxVkoO/yU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/626] ASoC: codecs: wsa884x: Correct VI sense channel mask
Date: Tue, 27 May 2025 18:19:28 +0200
Message-ID: <20250527162448.093281233@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 060fac202eb8e5c83961f0e0bf6dad8ab6e46643 ]

VI sense port on WSA883x speaker takes only one channel, so use 0x1 as
channel mask.  This fixes garbage being recorded by the speaker when
testing the VI sense feedback path.

Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20250312-asoc-wsa88xx-visense-v1-2-9ca705881122@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa884x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wsa884x.c b/sound/soc/codecs/wsa884x.c
index 560a2c04b6955..18b0ee8f15a55 100644
--- a/sound/soc/codecs/wsa884x.c
+++ b/sound/soc/codecs/wsa884x.c
@@ -891,7 +891,7 @@ static const struct sdw_port_config wsa884x_pconfig[WSA884X_MAX_SWR_PORTS] = {
 	},
 	[WSA884X_PORT_VISENSE] = {
 		.num = WSA884X_PORT_VISENSE + 1,
-		.ch_mask = 0x3,
+		.ch_mask = 0x1,
 	},
 	[WSA884X_PORT_CPS] = {
 		.num = WSA884X_PORT_CPS + 1,
-- 
2.39.5



