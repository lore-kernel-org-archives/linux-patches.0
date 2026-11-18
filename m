Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032915;
	b=4wwIn2/HEXfAZLL5nFn2xsYz7cvBANhG1+KEvorTsog0bUTJfDbGiS8+FU7wB6sSm6xH
	 GsfivadsKZRPxjCclsP8FIStxvtFMFLjPwtJsue0jnOTHjgIGZpE+m7S+qFWx50/+OG0J
	 EaGWtpxkiVLpMnHp0Kjd1+hHSSS6W6WpE1iNL1gQwRc15BKtTniiO2OcNCo2KM6kizCQy
	 5K4mi+MEReltHXiC/3dV8vQBWnzbDxuv8w3pVZFvjzx+Jy5qH0og/by7eD2r4V8XZMXRb
	 +D5LPcMPwquPnU8Vst1RxVLPjJicm1KXvcraL2EN+7VnC36K4ngCSsts1OGBJ8mXD/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l9nMcM9XSNeQPGqoB0yDRmBBm7p/J/BUR67Ci8J2V5I=;
	b=rkOFR4WsXVns69kudSIjg6/MIBOrNJj6wkc0H1exrXPBRFnmtIzGc2LQ9wikYoL7Y3wA
	 /VQ3bacAp821s3QKBz/7koeQ095N4qYX97mihcPIeJVKGKcOXPakD+iX6HlH4RuiGTXiL
	 LLUr21OdioHTCEa4x+vJ4n7uG8b57uFRy0HWRB+iXdRiDC6FZ6nooHPPvsb8cEilC8eEk
	 5GJp99fDaTGxVVMrMTGTdm9QoPky9X2tbo34yC+i6rXUPkuCqfZSI69JiDE7+rg8BGfdg
	 oy38YHYC9MMl18gtGZJ36wgLhdWitQUK0SiERqMsFzosSo3lxqHqlpxX06aPzCpTFQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A0jbQhlc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7C2606A32F;
	Wed, 18 Nov 2026 20:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A0jbQhlc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527081F000C4;
	Wed, 18 Nov 2026 20:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032914;
	bh=l9nMcM9XSNeQPGqoB0yDRmBBm7p/J/BUR67Ci8J2V5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A0jbQhlc7v1TiaeRAWF12gWcEZXNcAwWetuPCjjGA984qQqsurxq/yd9MxHe1IN/x
	 aik/LsqEhC19uiljfOwYSpRqY4EOOugSZ1eZsz4HhHwgkOkK7P/mmH/gqmYVhe/1ZP
	 Aszjaa9EUXDRl55bkMoHAioi2GJtw/W51K7oE0uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Ravi Hothi <ravi.hothi@oss.qualcomm.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1581/1756] ASoC: codecs: wsa884x: Fix VI sense port channel count
Date: Wed, 18 Nov 2026 16:01:48 +0100
Message-ID: <20261118150112.743243921@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ravi Hothi <ravi.hothi@oss.qualcomm.com>

[ Upstream commit a6093f98cbfc4a717ef3d1048b0e38fb2035be98 ]

The VI sense port carries both the voltage and the current sense data
of the speaker, but it is described with max_ch = 1 and, since commit
060fac202eb8 ("ASoC: codecs: wsa884x: Correct VI sense channel mask"),
a channel mask of 0x1, so only half of the V/I pair is transferred.

Describe the port as two channels and set the channel mask back to 0x3.

Fixes: 060fac202eb8 ("ASoC: codecs: wsa884x: Correct VI sense channel mask")
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Ravi Hothi <ravi.hothi@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20261023171316.819857-7-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa884x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wsa884x.c b/sound/soc/codecs/wsa884x.c
index 1fb9f11ba2a9c..78e40d9569cff 100644
--- a/sound/soc/codecs/wsa884x.c
+++ b/sound/soc/codecs/wsa884x.c
@@ -859,7 +859,7 @@ static struct sdw_dpn_prop wsa884x_sink_dpn_prop[WSA884X_MAX_SWR_PORTS] = {
 		.num = WSA884X_PORT_VISENSE + 1,
 		.type = SDW_DPN_SIMPLE,
 		.min_ch = 1,
-		.max_ch = 1,
+		.max_ch = 2,
 		.simple_ch_prep_sm = true,
 		.read_only_wordlength = true,
 	},
@@ -892,7 +892,7 @@ static const struct sdw_port_config wsa884x_pconfig[WSA884X_MAX_SWR_PORTS] = {
 	},
 	[WSA884X_PORT_VISENSE] = {
 		.num = WSA884X_PORT_VISENSE + 1,
-		.ch_mask = 0x1,
+		.ch_mask = 0x3,
 	},
 	[WSA884X_PORT_CPS] = {
 		.num = WSA884X_PORT_CPS + 1,
-- 
2.53.0



