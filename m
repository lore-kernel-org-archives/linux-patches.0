Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025919;
	b=aBM9Arm75ZtIbiGjRXwSy5k7x8Q+H+wA8ivjxEDXTNLa0n4IdaAfY3OaEEQsFVuq19vr
	 nxwPboWiQjtX3D8LtuDFhvbUufJIEeKdj6WBxMNn1WtV63QjnWOmBsgt+Yw3lD2iqvSF5
	 U6fdm3hhPA55EwrFVjObIg+OQ5t8QJnir+1ruwZy1gYcA7sRYIXWva+u59N01rKOjtSPA
	 NFWLqO5/ULyTm5hs03KJxz9ba0kmyU5QrvTBr6Zp/t/tXEukAdLltwUqPBxp+QAun61Ht
	 nl21rByxNRbv35uaT7mB3jaLsEIj2ykHHdlIfPIr8SFu3g4iZlNHP+ejYGpz3vaybuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=43smH14GZR14YkpyxvQYawoBbfKjmP1T4VTGSxAsYnY=;
	b=H1YSP17OEm/YZlLzjNUErUD+ucW7AiAFMT4PaWnraMmKQPwW3xRMdpZyVoDroWeDX7Tw
	 jq052yB0mxSf3NXVgbk45LACTZ4WRzDaPCGaNbSNyX6iRU3c2kaBBXvwlN8E1k06cFXEh
	 SHcS5l87XqFkWbWVKkUfC2cH8BnyIvDlZalxHTTjFCge5p9aOy4y4M3ezpQlmRASgDrJC
	 AiiCfpHi12LizC8Q8iDxRZFJDiHahfycXVo1yGRvcfgQ6AX4BbSUlcuVe3385ZnkI4UMW
	 yfLt3HeEbtLBvyDOpXcbwrXHW+UkE1doIysqSlOpFycaiIy0SJpwynXAY3BjfuUFceA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2q7htz2O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABAB606A320;
	Wed, 18 Nov 2026 18:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2q7htz2O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF241F000C4;
	Wed, 18 Nov 2026 18:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025919;
	bh=43smH14GZR14YkpyxvQYawoBbfKjmP1T4VTGSxAsYnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2q7htz2O+gAvwlWHiW3aU1M6Lc5A0x1GEbWeR5mHoojydPqSFn5sEQNn4c8rMHiJ2
	 UhRQ6DQ4zHZ5jDBbOt/vYjk0cmqToNZjY9jUiuOQiJ2TcuPNxOKAMsqgBRUistECEs
	 4jSGSlgpQVD1Q2JePplX5BIn7A/ltgfst9226rIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1251/2151] ASoC: mediatek: mt8188: Handle constraint return value in FE startup
Date: Wed, 18 Nov 2026 15:49:46 +0100
Message-ID: <20261118150207.736720460@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 71253751586b8ce37570b8e15cfbc74f0dd06c3d ]

snd_pcm_hw_constraint_minmax() may return 1, which is then returned
from mt8188_afe_fe_startup(). ASoC only treats 0 as success when marking
the DAI as started, so .shutdown() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: bf106bf09376 ("ASoC: mediatek: mt8188: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20261007110858.509341-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8188/mt8188-afe-pcm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c b/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
index 4a7baa53f709a..682f5cd9b92e9 100644
--- a/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
+++ b/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
@@ -320,6 +320,9 @@ static int mt8188_afe_fe_startup(struct snd_pcm_substream *substream,
 					   MT8188_MEMIF_DL7_MAX_PERIOD_SIZE);
 	if (ret < 0)
 		dev_dbg(afe->dev, "hw_constraint_minmax failed\n");
+	else
+		ret = 0;
+
 out:
 	return ret;
 }
-- 
2.53.0



