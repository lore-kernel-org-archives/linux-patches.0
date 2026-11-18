Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024845;
	b=aUqjWANzOOo5Gz2CV6saHZN4XO5TJBOaUZtYszIohU8YRRuhkZHudiSHWWVT3akmSciU
	 ceUXDH7uXHgOV8ktHifFmCZ17ww5tyfBv1wo+xkpDTZ8QIIYfB5676UYsubv8ZoJpUuW4
	 HNIbptWKceCNvmf1nHkvjTbUq+XeTEKYmaNHoyIjN/iIp5lSqdsMpUDA4TxzOR6vtIEyI
	 OjReMBFp5sDILusOhm8xnKa6mS50YTfNf0+Seqni+9EKaXNZtCI0r5Ifq1pzQxTc5cLgE
	 rv6GL/+dMHv9BzRPLORjXIhGypGpVNdLUn2pxs9n46iEkF/PK8aEnp2DEvtc21oG7Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024845;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+NOWLSxRklq7ST63PrimZ1idVB/5sEulAAQb8PHy+Eg=;
	b=JyYjx79PeGJ3gNOqsW2drbTg/VxVBxSLJXAmFoVsM2q3jXazSmzPm3vTFe6iUsAnFDck
	 R90snbfHDkxOXJblwbM1QEZWosYhurSt4/+Wv+1PHCq9l+71zqMqpRBoWsnusLeKy7H53
	 5dfR75fE550yVcpcHlNdAjuGEoCVX+TzDtRmlLtneXL7hypioKMc6H6hnSY3qVUVFovfq
	 8wHRBLMu8h2bFZkhO84IXiaf9OAhAmBOhVYJGTKlT6kmnUlevVP1g9vqZRuS5RqnSHZ9d
	 kheGL6O/P5QA8lVRr07HZW+UqcHLozM/b9Fos/8goO6dyFAN17b/J4C+M9r4Lj+42vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TxMytxBa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A14C606A325;
	Wed, 18 Nov 2026 18:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TxMytxBa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F56B1F000C4;
	Wed, 18 Nov 2026 18:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024844;
	bh=+NOWLSxRklq7ST63PrimZ1idVB/5sEulAAQb8PHy+Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TxMytxBa80VfkdroJz4otwvm9jxVdNeXlUuBe3MP3kJdUL5eBqG46zrHVuSJwH7fc
	 7tqzhIUg7kWaCPt76TQTNuHXKP66heOYQh28gUd7OfTpABbc4V4dKzmxvH8DDRIoPW
	 MlKcQkhBrRwV3j7r9sxmaTKnRWlZ550SuNgztavU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0827/2151] ASoC: mediatek: mt8192: Handle regcache_sync() failure in runtime resume
Date: Wed, 18 Nov 2026 15:42:42 +0100
Message-ID: <20261118150152.262315825@linuxfoundation.org>
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

[ Upstream commit d9e264741b041fc9dffc555bc1ab68708658cefd ]

Currently, the return value of regcache_sync() in
mt8192_afe_runtime_resume() is ignored. If regcache_sync() fails, the
function continues execution with clocks enabled and regcache out of sync.

Fix this by checking the return value of regcache_sync(). On failure,
restore regcache to cache-only mode and disable the clocks enabled
earlier in the function.

Fixes: 125ab5d588b0 ("ASoC: mediatek: mt8192: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260918133912.133799-11-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-pcm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c b/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
index db0ae44a86afe..5e633e9573a31 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
@@ -2104,7 +2104,11 @@ static int mt8192_afe_runtime_resume(struct device *dev)
 		goto skip_regmap;
 
 	regcache_cache_only(afe->regmap, false);
-	regcache_sync(afe->regmap);
+	ret = regcache_sync(afe->regmap);
+	if (ret) {
+		regcache_cache_only(afe->regmap, true);
+		mt8192_afe_disable_clock(afe);
+	}
 
 	/* enable audio sys DCM for power saving */
 	regmap_update_bits(afe_priv->infracfg,
-- 
2.53.0



