Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032917;
	b=cL7Qfgo+r/Sq+mpIMsaG1ak27uK+i5pgDe2qqs/WpOAGhcjt0DYPTifgQ/chSMuqGhZ1
	 QxO1Eyc8I3Q9qVcRWRKt9EnUcjIjuTArnKRsg1F9EDF3c3ajXZJDzeeIRjWwlPYPyIkvC
	 QWaYpFhNZp12UXFW4Q76+iQrJypYB2+xIc6Ag6N8LgeRJS3ef07Zkff+OuiJw7DELtuk9
	 +B0FeFLHIyatwKFNjkm/CNgA4epCrjT4/LCqGDOWaWn2FiL1yxkI9HrOZnicwpw+wDh5Y
	 bvsu8QtskAXR9UHl4HNcCwsyxAMRrKLErex7jdXvv7GWn9Tu8t69oSv0qZAzXmVPegg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1Gz30CGGE7PHZIea4/NTW3zPQePRuLK28V/3xFRsSB8=;
	b=PYMI7zrfsnxNBRCgr4XB8iPDh232ZtBhoU/fbF8qIskpMPe8FGGzxZIucXfNcz6h0ovY
	 GktBd+PKsXnk7r61yZCNOgnK6Tk3LqYNlUMG7S6D5MqNAajTorOFMu6W7WveW9bt40fNZ
	 xV6PHYeT0A6CII45h9ehqMknWo/o3NiMS8Uef2rZTzr/ZAPHHmJ5zmek4XRzLXwhQASVH
	 T0mAD5DuJ2RP6i+axw+Q/JfoyuPRL6BlJvJZApGIOFUhbEBz6tdUMPxcNdXN1m9Elxnlm
	 zy1dORxPGnwJtRQsLusDXkHGt7EfMcV9af1fX3ZNvoUxzmHF/YDQF8hNGgg6mhl5CHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j0WOIqq5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6EF606A339;
	Wed, 18 Nov 2026 20:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j0WOIqq5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38271F000C4;
	Wed, 18 Nov 2026 20:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032917;
	bh=1Gz30CGGE7PHZIea4/NTW3zPQePRuLK28V/3xFRsSB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j0WOIqq51GTMM/VdJsNNuGpJMkC06FEu4JbkWquUsHT48JD50D43f12g9cGdNhN6j
	 jPNhfk79BMBVSdV6t1X5O+ZkTxQ4S6jLoVHssBPT7FPnX+SkuOK/jq0TJ/+XBkjx+o
	 Tks3k0Dlrxo5t+mNDqB0RaDZ1mluvGuvgSTYi7As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Ravi Hothi <ravi.hothi@oss.qualcomm.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1582/1756] ASoC: codecs: wsa883x: Fix VI sense port channel count
Date: Wed, 18 Nov 2026 16:01:49 +0100
Message-ID: <20261118150112.795475340@linuxfoundation.org>
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
index 491a2131bb598..075c90357776d 100644
--- a/sound/soc/codecs/wsa883x.c
+++ b/sound/soc/codecs/wsa883x.c
@@ -509,7 +509,7 @@ static struct sdw_dpn_prop wsa_sink_dpn_prop[WSA883X_MAX_SWR_PORTS] = {
 		.num = WSA883X_PORT_VISENSE + 1,
 		.type = SDW_DPN_SIMPLE,
 		.min_ch = 1,
-		.max_ch = 1,
+		.max_ch = 2,
 		.simple_ch_prep_sm = true,
 		.read_only_wordlength = true,
 	}
@@ -530,7 +530,7 @@ static const struct sdw_port_config wsa883x_pconfig[WSA883X_MAX_SWR_PORTS] = {
 	},
 	[WSA883X_PORT_VISENSE] = {
 		.num = WSA883X_PORT_VISENSE + 1,
-		.ch_mask = 0x1,
+		.ch_mask = 0x3,
 	},
 };
 
-- 
2.53.0



