Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2C31C84A9;
	Wed, 19 Mar 2025 14:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395136; cv=none; b=dHI1Tvj3jYEhSble+JdP5qBUSy79no6JG/Z61kbxHNxeJZMJa20oSu+4SOmtY4Cmc1GKpm/DBXnXJ/+OFtKuFaHc1IQS4Wrw/bv8dM7ZXOmOOVZXrEVEqkO7VVbmNHV6RfUV+mGGrdoJ/+OxX/CvWRi73YH0EUjTJ97l0+uOzQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395136; c=relaxed/simple;
	bh=+YQC/8lQcc3e2Jl+4FrMCoXw4mW+qORrhVuwiTo0t2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNavoi2N8g5R66YK4uDLqfG7zA40wjzypVRIi59aqQHakL6XS2uiO8G+RWvqgHxYrEyuFFgPnY5nuWHxgZ4yeOuxN3x6VbeUPRVQTrqpbRtfL08ALQMc7cTiAUZyV/TWdyIU4bnMXsa3xQoHLnza1fwf/wX2RcANF8RxqA0K8HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yhJxtYS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yhJxtYS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B5DC4CEE4;
	Wed, 19 Mar 2025 14:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395135;
	bh=+YQC/8lQcc3e2Jl+4FrMCoXw4mW+qORrhVuwiTo0t2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yhJxtYS8l4L40vWFoBvfD8J4RGKy68to22CikNEpmgg/nHxoTuvS00Tc9N/K9JLyp
	 ks2rqrVnS0jV5ppPzD+7DeCnBNJacEyHS935/EwvYlUwT0qtUDoKQxvJ2WXJwYE4W6
	 lWknyit55fbOKwYnlYlpCAU+3YB3Mvn3+lbprknQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 201/231] ASoC: cs42l43: Fix maximum ADC Volume
Date: Wed, 19 Mar 2025 07:31:34 -0700
Message-ID: <20250319143031.810177188@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit e26f1cfeac6712516bfeed80890da664f4f2e88a ]

The range of ADC volume is -1 -> 3 (-6 to 18dB) so the number of levels
should actually be 4.

Fixes: fc918cbe874e ("ASoC: cs42l43: Add support for the cs42l43")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20250306133254.1861046-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l43.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l43.c b/sound/soc/codecs/cs42l43.c
index 8ec4083cd3b80..2c43e4a6751b1 100644
--- a/sound/soc/codecs/cs42l43.c
+++ b/sound/soc/codecs/cs42l43.c
@@ -1146,7 +1146,7 @@ static const struct snd_kcontrol_new cs42l43_controls[] = {
 
 	SOC_DOUBLE_R_SX_TLV("ADC Volume", CS42L43_ADC_B_CTRL1, CS42L43_ADC_B_CTRL2,
 			    CS42L43_ADC_PGA_GAIN_SHIFT,
-			    0xF, 5, cs42l43_adc_tlv),
+			    0xF, 4, cs42l43_adc_tlv),
 
 	SOC_DOUBLE("PDM1 Invert Switch", CS42L43_DMIC_PDM_CTRL,
 		   CS42L43_PDM1L_INV_SHIFT, CS42L43_PDM1R_INV_SHIFT, 1, 0),
-- 
2.39.5



