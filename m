Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C08369999;
	Wed, 20 May 2026 17:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298129; cv=none; b=cO2E7xNEcwphHYhR2tXBzqpytwlEzO8Hqdg6p7Hx21ncquzUoDUMcwjtdfbXQz/ZYnGwOWmNRUsrUp+iJlV6hoPL9S18x/xvXs6UPrlE3ltZkiCvz1wS7VobwdqiD19O07oLaE7RF5wiA+yDjhYuXQXDDGkoXosN+RZERLadbik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298129; c=relaxed/simple;
	bh=RpuTOqsCMjfzcu8mU8FktyTbZfZB5tfDC1ZUAPFLR50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7ydtVP47QnR2qNyrAvIyMn7DFtykmX4obAMeNwtugzwZWeMNJ5lOHIhkfVJ9p+6mEhOitaKTPUDoK4x1CLfoPddpe+BQgOXmoSfPA4qlIXpzSFUR+ieTpZdkIuEeM29pBTnC+RPBXIAZGMn5thxgi+PUzVBvKMjQ20nDiHh6Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4am2aYB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4am2aYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2901F000E9;
	Wed, 20 May 2026 17:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298128;
	bh=N5mtEgwjO5PGfvfOm4PRI/PvSFbLqFL8Qpp4wktNeH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h4am2aYBCy5UpBXQx0v8/EeMRGkjE6z+TvnUhbH9DCSMlFMwtKv5QufUhJekJw8AX
	 fctXJUKgOO4szganndwZDDM6PQxOyCdJtJGQG4UldlXyfOIc9CNK2cXXx++VJF+drS
	 m9DftuU+imCnaVflhSTgaLWYtAkfjvUVfyA35YR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 292/957] ASoC: fsl_easrc: Fix value type in fsl_easrc_iec958_get_bits()
Date: Wed, 20 May 2026 18:12:55 +0200
Message-ID: <20260520162140.868888578@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit aa21fe4a81458cf469c2615b08cbde5997dde25a ]

The value type of controls "Context 0 IEC958 Bits Per Sample" should be
integer, not enumerated, the issue is found by the mixer-test.

Fixes: 955ac624058f ("ASoC: fsl_easrc: Add EASRC ASoC CPU DAI drivers")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260401094226.2900532-11-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_easrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_easrc.c b/sound/soc/fsl/fsl_easrc.c
index 8647df027c3fd..725c7b65fe6b8 100644
--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -73,7 +73,7 @@ static int fsl_easrc_iec958_get_bits(struct snd_kcontrol *kcontrol,
 	struct soc_mreg_control *mc =
 		(struct soc_mreg_control *)kcontrol->private_value;
 
-	ucontrol->value.enumerated.item[0] = easrc_priv->bps_iec958[mc->regbase];
+	ucontrol->value.integer.value[0] = easrc_priv->bps_iec958[mc->regbase];
 
 	return 0;
 }
-- 
2.53.0



