Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021811;
	b=JbEoxt3xyyfYrD3kp8gc/cXl32ar0kufWAX1HdHNw4jLB94c6oscvsMubOiSlL88BdIx
	 uAvAgB4mKlhTqete8jYhuj0MWrwuleeb2aePCi/K2KX8b9iiPXkp2pkxkril7vzXQoZDx
	 lGxULPY/OhsBmsTmqsTERlrnHQLZYplM+1GTK7CxQ7aQpwYuEDcHE1f19ThfkzIJcClo0
	 Y9zS+fIBRs0vhXPcESuvsEr553fUTiN1dST3S4WB+Y09pgdsfQixHkGmnmBvr668M1h4U
	 VjtLH8x3h0VCMwJjuLoVuq1Kbik4/9fFEU2o/6DtpcajyLdr9ylIVbR3ih77kGmkD6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Op6IoOVW9wFa+hO706ZPcKmnImX/o1MD+vIViTSS+w4=;
	b=KpkQC6rtlrjdkBwt1vqd7bfnCbPJKmbJ0TBpucJPvey+i9ja7bglwoEt5vS+GLx0vGL9
	 PCNCCm8l5YP8nu3J0RtJGwZx27wl2XaEukvytCctczE2k4F458IJapIEHn+YJ2cjxYATj
	 1WDV+VsN0HhSLzztSXrO29dbaVegiw9/4jVIWKtGfQ9ew0ysJf8kBxyMMfDHcQz1a6SJ6
	 8MCrFjThGLLr67fcJrWQ0EMzNB2Se1JQY0RD31qdpc0kZ4B6jGJXoEb49yUC3CBNLFfNI
	 eSgMfrY4ysghew4j4fUzMdajCRfHh/OmCFOGxDfqOziTxIpNye/PsA8zn/mayy7nKNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="I/yOL5Jo";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C2B60A2603;
	Wed, 18 Nov 2026 17:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I/yOL5Jo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E9A1F000CC;
	Wed, 18 Nov 2026 17:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021810;
	bh=Op6IoOVW9wFa+hO706ZPcKmnImX/o1MD+vIViTSS+w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I/yOL5JoxlVbdwcRa4IBYeUlLoS9xOL0+H9mUSFgLNeVMm/87B2h0kOp7aLC6S71t
	 dq2PFvgw6+ae1xR2trEgfKmbr4rtl6dCx7owRUzriDvzPAgjXltoyY+nPThh0LXsxJ
	 XxIC7i35oqyl4tZdIhaG37FeIXOQxFCxizvmV2ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Ravi Hothi <ravi.hothi@oss.qualcomm.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2438/2651] ASoC: codecs: wsa884x: Fix VI sense port channel count
Date: Wed, 18 Nov 2026 16:01:18 +0100
Message-ID: <20261118150412.952318905@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 3c008224d32e8..acf32af5aae3e 100644
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



