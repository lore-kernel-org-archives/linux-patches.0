Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215737;
	b=wnzEDa/HdEauk0TV38tAxky7liTZbmx8cDIfdjQ4s50qL44s4k1kQ1+GItsiT3g4yv8O
	 0S7a/5GlMLYwEdyT9sVLwLk8nP9SkoleWzybRl6gv+ZtCbDVVdrSQVwDsLp7xpsFwQRAc
	 bDyM57jI+pjl6dtggh4b7uhiwA6aoteY6QrubiZvVM+BgABrv2h5vOn00PT8z2eowP6Pl
	 J1u6Z74/ODiNJkGm2OUxHOoxzORkEqX1X9LjVwii6UdE0z/hm9RdFzYSZ3zN2euR8cfv8
	 pe88JeON1gQ2kNYadeBWzgq06hAnu+h5H2QESbbTNrPMLgo5V9kckcy/mcS63wVmFlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WstO2VIpCPycgrbpULi2v1XYuqSRTd1LauNW1o9yQ7w=;
	b=JUqCPbUaVVRaDQSQVIpcrYpUGYbQbSKk1I7FJwJeLs+YTPkeYGsKnuxok9Mic4F6SkYV
	 jk+Y/Jwz4FuvCGJdI363p5pUckwwU8HLJsss38Kd2+68gl+jUVeRumdmzQugKEwtqB+ni
	 dFDGRsjs3xyNeLum1tO67NXPB0Kl56tYDRt9LgbqvD4Q/gzoc/zZHK0odb9j4AO9RFX0Q
	 eg9WKS0pCV7/UB/41TcLhLadSbl7k91mUhlGMRqcXIDwWvU/Av2oXEr/a6skm5U/Vw2nm
	 MJ1AEZVRHmr4YyWSW8NZ3dYu1zRkLAakadIA70tX5w17ntXTTqHn8WT5yTBz5xEl2DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=my641H3Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C36606A31A;
	Wed, 28 Oct 2026 19:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=my641H3Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928C71F01825;
	Wed, 28 Oct 2026 19:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215737;
	bh=WstO2VIpCPycgrbpULi2v1XYuqSRTd1LauNW1o9yQ7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=my641H3Y8sdM91eHrt1tq2kv0F9fFPS5AupgjIsCxgLEnhqsGP+MzROgHkU2E5676
	 hWU/4XnLnSgJR0i7D68o9QAV3Wpv6+3q8yS5aIPuNiiEkB/dIjEp8b/4b3BrzBx/c8
	 UA64BywGbKf3V9xXR141mDm29Pc3dQZmTU9myC7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1313/1887] ASoC: tas2562: Validate values for volume writes
Date: Wed, 28 Oct 2026 17:56:49 +0100
Message-ID: <20261028170529.308163824@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 8fb41964f7e4e4207c8999af2056894caa7a252a ]

tas2562_volume_control_put() does not do any validation of the control
value written by userspace, it uses it to look up a value in a fixed
size array which can easily be overflowed and then writes whatever value
it gets back to the device.  Add validation that we are loading a value
we have in the array.

Cc: stable@vger.kernel.org
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260715-asoc-tas2562-put-retval-v1-1-97bf467c924e@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2562.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/tas2562.c b/sound/soc/codecs/tas2562.c
index 07336352272b3..bb9dfd10d2d7a 100644
--- a/sound/soc/codecs/tas2562.c
+++ b/sound/soc/codecs/tas2562.c
@@ -474,10 +474,14 @@ static int tas2562_volume_control_put(struct snd_kcontrol *kcontrol,
 {
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct tas2562_data *tas2562 = snd_soc_component_get_drvdata(component);
-	int ret;
+	int ret, index;
 	u32 reg_val;
 
-	reg_val = float_vol_db_lookup[ucontrol->value.integer.value[0]/2];
+	index = ucontrol->value.integer.value[0] / 2;
+	if (index < 0 || index >= ARRAY_SIZE(float_vol_db_lookup))
+		return -EINVAL;
+
+	reg_val = float_vol_db_lookup[index];
 	/*
 	 * The device applies the 32-bit coefficient to the playback path on
 	 * the write to DVC_CFG4 (the LSB, book 0 page 2 reg 0x0F), so the
-- 
2.53.0



