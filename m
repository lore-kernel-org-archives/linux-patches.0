Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BC73C3C16;
	Wed, 30 Sep 2026 19:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794884; cv=none; b=Dpb+zhtJbXG/jG4XN9SMA4+fUKwG3JE7/j6PEZ5ifSNe8ZgVGvo+z5+tWguJRnCbHgxQHS4hAQW6DBdXrx/LVVyusd43shmJmo7OWTXrHQ3WIQ7nT5aOGVsrh+po7mXqLfMCwr1YciZaLpgB3vmo4mPI1iSYFEsNmcKf+Yhs7wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794884; c=relaxed/simple;
	bh=ffDO1QZmM+lNwKBSL2B4y++hcp7TLgGdB7cyo+PKR0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFTug1GAIiEnGzqztNnTxTIpIoEQUw029dYbnkkhQKRJUbB/FduxZ1891Y7+LoUQjYUO/7SUKFQKYk3f955Xl+jd55tR1vV0hPylFnj9YM1KFa5+1/pdRYEj+4t2GH/++MuIzUL2LpOIn8lW2iHK4Dc4ahUrfTCdiOAwN8yUoDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPk4JQwm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPk4JQwm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7041F000FF;
	Wed, 30 Sep 2026 19:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794881;
	bh=9dwBggxmaU6gUXwTjebHrxw74KQ8ag6nyXghgdMTEUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZPk4JQwmxoXnss5YaQI1oV/8turxKCvgkPkRGRH65iIOsijPXcGEEiV5Zizk0SMUw
	 8SOrdLdSOqz5LeldVMSoZ0v6/XZBc98qVvNv/iIiLta3XVK7WozuG2cbqiGzQdG3J7
	 +naIhJMyKr2hJTumE5a3faxRL04P5icpgXTiVE7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0364/1193] ASoC: meson: aiu: Validate written enum values
Date: Wed, 30 Sep 2026 17:17:28 +0200
Message-ID: <20260930152442.263439161@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit d65adf85477247be04ac86886f8edfaa047b5d4a ]

The AIU HDMI and internal codec mux put callbacks use the written enum
value with snd_soc_enum_item_to_val() before checking whether the value is
valid for the enumeration.

Reject out-of-range values before converting the enum item, matching the
validation already done by the G12A HDMI and internal codec mux controls.

Fixes: b82b734c0e9a ("ASoC: meson: aiu: add hdmi codec control support")
Fixes: 65816025d461 ("ASoC: meson: aiu: add internal dac codec control support")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260609124317.38046-3-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/aiu-acodec-ctrl.c | 3 +++
 sound/soc/meson/aiu-codec-ctrl.c  | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/sound/soc/meson/aiu-acodec-ctrl.c b/sound/soc/meson/aiu-acodec-ctrl.c
index 7b04b97f7b41c..c4cf97d2c82f5 100644
--- a/sound/soc/meson/aiu-acodec-ctrl.c
+++ b/sound/soc/meson/aiu-acodec-ctrl.c
@@ -38,6 +38,9 @@ static int aiu_acodec_ctrl_mux_put_enum(struct snd_kcontrol *kcontrol,
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	unsigned int mux, changed;
 
+	if (ucontrol->value.enumerated.item[0] >= e->items)
+		return -EINVAL;
+
 	mux = snd_soc_enum_item_to_val(e, ucontrol->value.enumerated.item[0]);
 	changed = snd_soc_component_test_bits(component, e->reg,
 					      CTRL_DIN_LRCLK_SRC,
diff --git a/sound/soc/meson/aiu-codec-ctrl.c b/sound/soc/meson/aiu-codec-ctrl.c
index ee0ef6301010c..fe776de739881 100644
--- a/sound/soc/meson/aiu-codec-ctrl.c
+++ b/sound/soc/meson/aiu-codec-ctrl.c
@@ -30,6 +30,9 @@ static int aiu_codec_ctrl_mux_put_enum(struct snd_kcontrol *kcontrol,
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	unsigned int mux, changed;
 
+	if (ucontrol->value.enumerated.item[0] >= e->items)
+		return -EINVAL;
+
 	mux = snd_soc_enum_item_to_val(e, ucontrol->value.enumerated.item[0]);
 	changed = snd_soc_component_test_bits(component, e->reg,
 					      CTRL_DATA_SEL,
-- 
2.53.0



