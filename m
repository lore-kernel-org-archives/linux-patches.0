Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5B139BFFE;
	Tue, 21 Jul 2026 18:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659709; cv=none; b=fYKFBtEoSqva1Y1ylCXPdMC3s4AjqGBUraXZc635/Pbwah/BJp99/ObAdczE8CcFrfL29zId+IHZuKxYZhKDeSmSAZGOTAzsR2YYSkAiUOAoaRCzGVFyKeGGBKOfeaGPtHK5rmzHrlAil2yIY1PFOshnn83U8chgd6S0zsicp7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659709; c=relaxed/simple;
	bh=LYrWOVSeIdBNVOp2yZDPbAYYEdrk6X6rXXS4C5ekqO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqaI2rKhyOO8c/ddX+Gq4J57EL3ESA9la6SySgEBFgmYKtMGU4OlrZHrUA/WAOTLBa/rX4kXoCDfCFHejrCY+mvv0Fd41ukGdyJ739/RC4rvqwJn0tW1yw6R2C5Ce9NpVXAqUX+EXDnvMJYQ4YRdhdq5Qu76lgq9amM3Q3RFWaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPEk1GcC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPEk1GcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3EE1F00A3A;
	Tue, 21 Jul 2026 18:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659706;
	bh=/KOrY9565gcc9oDE1pQw4zS3O2tWjlYmrosr4ja1YDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xPEk1GcCpezSYj2uk19bwFyuLcrYPgLuH77x+UOXVfgQzYbqoPXF0p5lMEErn3n/4
	 1JnN3JYQUS3qE35zf5V5+0wQ+gDyAKe4pz+9kBZyIwbJYo7bSNMYj07b9SVQ2RPpAd
	 ZANViHTg0ZC84KAKklIForYl0KuI3m6fEWALoY2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0704/2077] ASoC: meson: aiu: Validate written enum values
Date: Tue, 21 Jul 2026 17:06:17 +0200
Message-ID: <20260721152609.399177745@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 483772ba69cd7c..94c5d65335233f 100644
--- a/sound/soc/meson/aiu-acodec-ctrl.c
+++ b/sound/soc/meson/aiu-acodec-ctrl.c
@@ -36,6 +36,9 @@ static int aiu_acodec_ctrl_mux_put_enum(struct snd_kcontrol *kcontrol,
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	unsigned int mux, changed;
 
+	if (ucontrol->value.enumerated.item[0] >= e->items)
+		return -EINVAL;
+
 	mux = snd_soc_enum_item_to_val(e, ucontrol->value.enumerated.item[0]);
 	changed = snd_soc_component_test_bits(component, e->reg,
 					      CTRL_DIN_LRCLK_SRC,
diff --git a/sound/soc/meson/aiu-codec-ctrl.c b/sound/soc/meson/aiu-codec-ctrl.c
index 396f815077e291..60bb4cdfee5201 100644
--- a/sound/soc/meson/aiu-codec-ctrl.c
+++ b/sound/soc/meson/aiu-codec-ctrl.c
@@ -28,6 +28,9 @@ static int aiu_codec_ctrl_mux_put_enum(struct snd_kcontrol *kcontrol,
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



