Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027939;
	b=WtWErKooxl7QpjEZVLwiY7WBLe0kd588lgaDtNcD+pW5N4K2Oy8s8xHdzUUq1GWhXUmC
	 j6tj9ER6jcXRS/YcyRWsH6RKFx0JHVBB9d3rp8Efhd33qtGvQrej5dNMDFE9pCy12k3ok
	 Blrbu2ralLbHDQ6Xfv4E9EF+gv2mQVQIr3HMHT47mYD9+RarkVrAhYegmGdi3n0/emrk+
	 LtWwapcIqu6vuxfp5BfguM4em7rkhw/Z8D5WSSp3BF54NFaydqKYXK2ZygzklfmpRNJp/
	 oaR6/Jq/8CnrqOXdeyOxxsKi16wPNYEDw08n/C+bUDrkL7EUQGoCijjJ30/YB//mZtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027939;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ItydmvG/iVyxHCMHR1pEx+0bCgA009hbAKmgFRoKI2k=;
	b=osv+WiCX+weiwO/Dpp0ttan3fN7syMe7BcGPqDVlcyjSYDjliUw1iRStTJn7Hl5fClpa
	 TGUxq8WNZuGKRwsDqGmxNKFUznkt0OUk6g4qvpgClSSH7Z+9LSckQZk1oT7lJ1+YFW8fu
	 KPvV/LKnt34pgWd8foplfuQ2ggg05nDryBhrd/iAxgSYTPx29ruEteJV0212lwCq2fXWs
	 NniqeXDaKgtGZiUcac1LPqevM2SqjQ4OBSELifjVl+KxSKEpRd8LQQELIzkVd5jfPunir
	 YkBqZEgK77jQv/SBWqc2UBf+Q2o4rDnIi8N+rDkbOmUNO8CQUUlPhbGYDUP4nQWiJOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0LorRiUD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C121606A31C;
	Wed, 18 Nov 2026 18:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0LorRiUD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D275D1F000C4;
	Wed, 18 Nov 2026 18:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027939;
	bh=ItydmvG/iVyxHCMHR1pEx+0bCgA009hbAKmgFRoKI2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0LorRiUDSsIDR22xygbuuNxmE/QJlW+3fnWOPa9JX7P5VqLcJzqBILxbmGAI2blGC
	 HpXtV75As/TraRG5FSSKOJzH4TZTQlj2CkF6D9Xx9cF5mNRtCk/Pf3I7ucw/cha+TL
	 zX1/C/TjeQ1Ub3cZ8LpuavUZyYUUPgVDzlycafII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Ravi Hothi <ravi.hothi@oss.qualcomm.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1968/2151] ASoC: codecs: wsa884x: Fix VI sense port channel count
Date: Wed, 18 Nov 2026 16:01:43 +0100
Message-ID: <20261118150233.438981807@linuxfoundation.org>
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
index 7b8c47a6da1bd..49b8d997cdfb8 100644
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



