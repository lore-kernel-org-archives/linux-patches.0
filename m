Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829497;
	b=sypT8JwSFZ5+5SP0tKO+N70UVQk8NoTM+/jKO2UCIDN8I06mCPALm/p5F7kvhC55MNM9
	 HfXwKSZKWjh0+6NhdOtAA5Cln0tBEMwy0ns1Tbyvl2M/n0UFi7EUBoiNYeD3K9oNnqXJv
	 HRcjd89DKf8iZr/rHpG5VfvKbixG6sHmSndGuSCE7UCo1JTRetILTeGjngvr//chHUWXz
	 /BJP6/VTdvdPJYxcpz5jnMz+rlUmGWWN5V7IshcjK7xBWPxvgRDHeMvUMhaEyPShb3FKH
	 gK2JjRgwqYZD7hyjrBU/waXJJGHHyh4gpL/f49leORhsyp7qxAyFGqNpMkzRFYuYH6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mPN7h1RgcfIC9+OJlZbyNpxZ0w3e7D+AJfv8QFUh+TQ=;
	b=lEKp1nxAXkkI6GRJhbLl37S1ZCvS8O8zfVl+7kHtA488bYUQeG3Mu0Yapude8Ax2yX9a
	 3+Un7eFT59r/s7oUwkXEU2tthV5pGUTqAXDjKja3zE7c+SHRl6coJkaJ7gMAXd22lR54R
	 5GTAc467FTHUIKTv2bfi3uQcQ6DLPtSrS6BY0v3SvAnh0OFX67qzr39fmkeZ4HmK6J49P
	 DhmqYOA0nBNKr88ZnK0H0gC3H6Jns2YATnFtc7FlSHci07vT85C0oYveBl72fC8yc3cgN
	 bNRsfwh/xTB5AdQUP5sTDyBjnFlhfisN3nNtEz2lKvvgh/cVjJtOZXyv+qSw0sFvWpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vO+O1Eb8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A23606A878;
	Wed,  4 Nov 2026 21:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vO+O1Eb8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C477C1F000C1;
	Wed,  4 Nov 2026 21:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829497;
	bh=mPN7h1RgcfIC9+OJlZbyNpxZ0w3e7D+AJfv8QFUh+TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vO+O1Eb8t63iF3hl4DXgBuqIT9n5OIqrhjkxpwe2mwk9ybiLoyp/mXYddlc9QtiDg
	 fGUkLLGxL1iRG2fA/5ElVpS1sVz/QEhXLcQacOqKGjpSX2ORGoptu4MIb3mieykfcp
	 3xiV9Mt8WiuSsTkPLIE3SP44ZQ7RXD4Z8T7Bex60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0162/1005] ASoC: cs35l56: Add support for CS35L62 for SoundWire
Date: Wed,  4 Nov 2026 15:58:15 -0500
Message-ID: <20261104211048.299612134@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 3330b5f6d8dea66df51c07362f01a39ad9845aad ]

CS35L62 uses the same control and regmap interface as CS35L63 so
support for it can be added into the CS35L56 driver.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260715120135.939280-2-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56-sdw.c    | 2 ++
 sound/soc/codecs/cs35l56-shared.c | 4 ++++
 sound/soc/codecs/cs35l56.c        | 1 +
 3 files changed, 7 insertions(+)

diff --git a/sound/soc/codecs/cs35l56-sdw.c b/sound/soc/codecs/cs35l56-sdw.c
index a513a15d7e5a7..a7b4e2a923205 100644
--- a/sound/soc/codecs/cs35l56-sdw.c
+++ b/sound/soc/codecs/cs35l56-sdw.c
@@ -529,6 +529,7 @@ static int cs35l56_sdw_probe(struct sdw_slave *peripheral, const struct sdw_devi
 		regmap_config = &cs35l56_regmap_sdw;
 		break;
 	case 0x3563:
+	case 0x3562:
 		regmap_config = &cs35l63_regmap_sdw;
 		break;
 	default:
@@ -582,6 +583,7 @@ static const struct sdw_device_id cs35l56_sdw_id[] = {
 	SDW_SLAVE_ENTRY(0x01FA, 0x3556, 0x3556),
 	SDW_SLAVE_ENTRY(0x01FA, 0x3557, 0x3557),
 	SDW_SLAVE_ENTRY(0x01FA, 0x3563, 0x3563),
+	SDW_SLAVE_ENTRY(0x01FA, 0x3562, 0x3562),
 	{},
 };
 MODULE_DEVICE_TABLE(sdw, cs35l56_sdw_id);
diff --git a/sound/soc/codecs/cs35l56-shared.c b/sound/soc/codecs/cs35l56-shared.c
index 646bb4fbca025..3001ec45a72de 100644
--- a/sound/soc/codecs/cs35l56-shared.c
+++ b/sound/soc/codecs/cs35l56-shared.c
@@ -86,6 +86,7 @@ int cs35l56_set_patch(struct cs35l56_base *cs35l56_base)
 					    ARRAY_SIZE(cs35l56_patch_fw));
 		break;
 	case 0x63:
+	case 0x62:
 		ret = regmap_register_patch(cs35l56_base->regmap, cs35l63_patch_fw,
 					    ARRAY_SIZE(cs35l63_patch_fw));
 		break;
@@ -370,6 +371,7 @@ static void cs35l56_set_fw_reg_table(struct cs35l56_base *cs35l56_base)
 		}
 		break;
 	case 0x63:
+	case 0x62:
 		cs35l56_base->fw_reg = &cs35l63_fw_reg;
 		break;
 	}
@@ -576,6 +578,7 @@ void cs35l56_system_reset(struct cs35l56_base *cs35l56_base, bool is_soundwire)
 		}
 		break;
 	case 0x63:
+	case 0x62:
 		regmap_multi_reg_write_bypassed(cs35l56_base->regmap,
 						cs35l63_system_reset_seq,
 						ARRAY_SIZE(cs35l63_system_reset_seq));
@@ -1080,6 +1083,7 @@ int cs35l56_hw_init(struct cs35l56_base *cs35l56_base)
 		cs35l56_base->calibration_controls = &cs35l56_calibration_controls;
 		break;
 	case 0x35A630:
+	case 0x35A620:
 		cs35l56_base->calibration_controls = &cs35l63_calibration_controls;
 		devid = devid >> 4;
 		break;
diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index e3334b2d84532..69976761ffa50 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -968,6 +968,7 @@ static int cs35l56_component_probe(struct snd_soc_component *component)
 						     ARRAY_SIZE(cs35l56_controls));
 		break;
 	case 0x63:
+	case 0x62:
 		ret = snd_soc_add_component_controls(component, cs35l63_controls,
 						     ARRAY_SIZE(cs35l63_controls));
 		break;
-- 
2.53.0



