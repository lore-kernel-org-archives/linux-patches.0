Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025947;
	b=ng9MXnVpxr1el8Eqk1cTsLJY24AvLaT6Q/duwLBYgzPBbCitQTen99THHiz4ODl9B9Z+
	 Yv8VVqjEaVo8DHYvGTSq0mnGg/iHsu/syNPk8R8YO75I+zRGloq7iHn7boCRWXc/MSPU6
	 qJRB62hk+XwpM2QKmqb51KkmMPIbpSw6lRtnkpihx19l4Izb+GKAafrWvoUe8sqBFnSUh
	 bD4fpXPVvEBQNSKZRU9kUPJnDeBCtqdss8RpSJe4B99CXNG0n888lqgewcgSwMTYY4tkb
	 E97uzdn8QnlEjOtXS9Gus/2a8uWpE7BnGqXtBySPBFGvLsmpyHbQIh1qZU/JHdq+9yA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025947;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m2I1dTPmsqk5qA54jVjZlFmYzUQc4+JclLVsg+9/nqs=;
	b=emG813dea34C4aqFRTeas5OQkLYolcjvbZrzdXQbmZlh1YvBRee/VwcEaFBO93zihuxO
	 2PL6qJX+Q+DIomOSsHja3QdSI0rxcVX2bAKqrDrlLlQO/TlJK3HuvHjljFIu0L7Z6R3hW
	 rAcVCOmLpt79tTN87/uk39qG0cggET/FMzS76bW8t58X96Bp8n0JKtpTj756GqgLZGUH5
	 +vFv6zalM8Zg3A3JR2lrMJZAUpU72Zb9U6yKUh7XnP4N3y7qphn/jOIB/hGHWtYoyKfeL
	 BdJ+JZSp5oO53ECPrKUkk5nmrYS7YhUtDcxSgWToVDE+NULSCV+EuPjHQHkwLi7frzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SJxRQB8+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437ED606A32F;
	Wed, 18 Nov 2026 18:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SJxRQB8+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9501C1F000C5;
	Wed, 18 Nov 2026 18:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025947;
	bh=m2I1dTPmsqk5qA54jVjZlFmYzUQc4+JclLVsg+9/nqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SJxRQB8+gwoWY6oU373l3thSXzXAB60bzYWUmP1xnq3UnAzFgs2iZF41gSpH5z/vj
	 dMfMOjS2ZmTOoAwof4GySt8w0XWGXpnHUhVLxo8XqaiSNX6OtGHnF9R2bjxpLKI06A
	 SJpWyPasbyS6rKNORvloeo7Gj+M6hE6C2leIdwGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1243/2151] ASoC: tas2781: Fix TAS2781/TAS5825 PPC version logic conflict
Date: Wed, 18 Nov 2026 15:49:38 +0100
Message-ID: <20261118150207.449232150@linuxfoundation.org>
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

From: Shenghao Ding <shenghao-ding@ti.com>

[ Upstream commit 3a05cc2d739486fa3c63aa32e6653ce55dae4819 ]

Fix cross-team code conflict in shared PPC version check path, ensure
TAS2781 and TAS5825 apply their respective correct firmware parsing
routines, eliminate version matching misbehavior between the two models.

Fixes: f4ee43ae6ea8 ("ALSA: hda: Add TAS5825 support")

Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Link: https://patch.msgid.link/20261002025230.1959-1-shenghao-ding@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2781-fmwlib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/tas2781-fmwlib.c b/sound/soc/codecs/tas2781-fmwlib.c
index 2f6522f76df9b..8ffe2450d1352 100644
--- a/sound/soc/codecs/tas2781-fmwlib.c
+++ b/sound/soc/codecs/tas2781-fmwlib.c
@@ -1934,7 +1934,8 @@ static void dspbin_type_check(struct tasdevice_priv *tas_priv,
 			tas_priv->dspbin_typ = TASDEV_ALPHA;
 	}
 	if ((tas_priv->dspbin_typ != TASDEV_BASIC) &&
-		(ppcver < PPC3_VERSION_TAS5825_BASE))
+		(ppcver < PPC3_VERSION_TAS5825_BASE ||
+		tas_priv->chip_id == TAS2781))
 		tas_priv->fw_parse_fct_param_address =
 			fw_parse_fct_param_address;
 }
@@ -1945,7 +1946,8 @@ static int dspfw_default_callback(struct tasdevice_priv *tas_priv,
 	int rc = 0;
 
 	if (drv_ver == 0x100) {
-		if (ppcver >= PPC3_VERSION_TAS5825_BASE) {
+		if (ppcver >= PPC3_VERSION_TAS5825_BASE &&
+			tas_priv->chip_id == TAS5825) {
 			tas_priv->fw_parse_variable_header =
 				fw_parse_variable_header_kernel;
 			tas_priv->fw_parse_program_data =
-- 
2.53.0



