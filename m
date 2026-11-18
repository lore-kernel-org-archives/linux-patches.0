Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027942;
	b=JqEA8shvHtvXsmWnKRLnKd5TCdYBqimt8uUaK7tIxQOmJi07lwl2ArDZwGv0pS1232xB
	 NbYRRCwP+vvil2WROqTe/B0nqGTXyyfD1iIZU5iv6iE3QF1jR7ocMUiAbuWSTY4/qCT4q
	 7z9OKIQwqw0VgrD92Ekc1tC1Bv4pfLn4rtUEJRBJWPn/em9y6bg0xcJx7egPnTy66QLLn
	 Eu6kgMq3BQJextx/3Esm/S3aDFvAdXCQudhPzTFVKJWDMXUF0Pqr3z+khcZE1JfQQSpg+
	 ZyORDdUCoscMf6iizt7DRi/zsWLp2tZLaT8zQG2fbydYOTAElOIo1mF8YtIyIgijsXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027942;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6QvU/5B7aLuoM63lt2cLLpo1CA06Z0nsQMxbOHOBivM=;
	b=GDGv7Uq7m3mcJ6/8VlReP3JFDxbZjlWH/zjbgL4SAbbPktcUz/8PsiQF4woNeaM1Ljf8
	 6ZEUHEZFCcnRA5w5AgGz04Dw0rpcIkoOpT7gdLel8V/WZAF8EruHMv+Et1X/0r4xUBC1P
	 teSyocLI0qvmlKsZlKWBl88Dvy0bCDn7Z8q0EXmJera97mj0U5wIrKxx8immoIPoO+ukD
	 ulkOMlDelQbGxLYqMF3eiPYRfIC03xylRkHhqc3w512fSMpLn1iKpL2qJNGiPV7WtAFrD
	 j7HIq4fSi3Z1W7tHk4yrXvvvIs8UiVlMYYvdXrLqrbdvgkeWrr9zDD6XhlrC/Wj0Q9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BAZ4/oA7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0A5606A31C;
	Wed, 18 Nov 2026 18:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BAZ4/oA7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916F21F000C4;
	Wed, 18 Nov 2026 18:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027942;
	bh=6QvU/5B7aLuoM63lt2cLLpo1CA06Z0nsQMxbOHOBivM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BAZ4/oA7joYTM36KNTlyRm6WqFRXS6OZu8Id71dCqQCT5hM9oxOowRDs8nnC11KC0
	 fCb3pMDkTQ7UWALPvdz+8OVkGu6m7gt9rDF7JcxUcV/1K3fF41uTsAmmXraBll8+5g
	 8t7YG0gc51AJpyhrEYQqeS6iWrEI7TN7zwk9Uh2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Ravi Hothi <ravi.hothi@oss.qualcomm.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1969/2151] ASoC: codecs: wsa883x: Fix VI sense port channel count
Date: Wed, 18 Nov 2026 16:01:44 +0100
Message-ID: <20261118150233.473663500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ravi Hothi <ravi.hothi@oss.qualcomm.com>

[ Upstream commit 9728b328d7adf228d5f691d0ec43bb7a6d07e44b ]

The VI sense port carries both the voltage and the current sense data
of the speaker, but it is described with max_ch = 1 and, since commit
ed3b274abc40 ("ASoC: codecs: wsa883x: Correct VI sense channel mask"),
a channel mask of 0x1, so only half of the V/I pair is transferred.

Describe the port as two channels and set the channel mask back to 0x3.

Fixes: ed3b274abc40 ("ASoC: codecs: wsa883x: Correct VI sense channel mask")
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Ravi Hothi <ravi.hothi@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20261023171316.819857-8-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa883x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wsa883x.c b/sound/soc/codecs/wsa883x.c
index 479085658bde2..bcddcdc33862a 100644
--- a/sound/soc/codecs/wsa883x.c
+++ b/sound/soc/codecs/wsa883x.c
@@ -551,7 +551,7 @@ static struct sdw_dpn_prop wsa_sink_dpn_prop[WSA883X_MAX_SWR_PORTS] = {
 		.num = WSA883X_PORT_VISENSE + 1,
 		.type = SDW_DPN_SIMPLE,
 		.min_ch = 1,
-		.max_ch = 1,
+		.max_ch = 2,
 		.simple_ch_prep_sm = true,
 		.read_only_wordlength = true,
 	}
@@ -572,7 +572,7 @@ static const struct sdw_port_config wsa883x_pconfig[WSA883X_MAX_SWR_PORTS] = {
 	},
 	[WSA883X_PORT_VISENSE] = {
 		.num = WSA883X_PORT_VISENSE + 1,
-		.ch_mask = 0x1,
+		.ch_mask = 0x3,
 	},
 };
 
-- 
2.53.0



