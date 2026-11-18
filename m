Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036081;
	b=cUQu3MoI5XzU9WbVj+9HFCMivheqbWW77ei7TGxF4+cl6KXcfvTnkhz7sQxR5Dutp2gV
	 BMPNbXRbqtGL1J8TgkYeEizpVUt1X2f95F7xDGDo/d+nULGHUkS1dZRqbHdxhCnOtIzR4
	 rgHrsOpWwhDginjKW6n76Agx+6DsKa0y8Hp1pN8BbtpXHRhoY41vwAToTzi6WGx+F+8nq
	 RgzTg5b2XvR5ExhcVv8xfp7Om9NWVTKEpC7BAg9kSXuh1vQ3lhyObulgfylKT7mZKiZ4j
	 NRoz0t/kGwfc3iqvbwqL0soUwDc0X8XihYdov4kNhJQHQo13uFZuNTw4mV+8NKwKjvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HIAuFdnGhj+7uFQp5v+esskIyzjOsp9Z7AsGNGj3Uy4=;
	b=tsR4icuNQPdn4NQx+PmthO3jZoSnMeu/b6fL4IOjLkQICFxEr8BZINjE43+lMwWK/VqW
	 P1V7INh5q82/MpNx4nqSFQiKE3M9X8EkyXb+L/5JiQiM9p4dVr915WSQRtWWGhSFVaPBc
	 I69WQIo+mJ3t+vKRKKwa2EvGfphWABCWE6YhuDE0eoFbgI0u/Cbac4sIeNnfNrPxd9XGn
	 30Ib0AU3MMKj8y6kkaPK9eDFfkPlK20dt+WBSQsp8fL0mOiqOoTgNC5f72WdqFNeBUHL6
	 K8zwTT7CTuEtef9sqNxiu4UhvwiViCO1FNIGb3qZkE83oITKODyKo7SrQfHejFDapqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OBjeJSM1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15135606A31C;
	Wed, 18 Nov 2026 21:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OBjeJSM1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917991F000C4;
	Wed, 18 Nov 2026 21:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036080;
	bh=HIAuFdnGhj+7uFQp5v+esskIyzjOsp9Z7AsGNGj3Uy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OBjeJSM1nSBWRtTYzwHNlBZozgow+XglAkxlZc83swuIyi64Kaw7wNmwRfpY2dRBo
	 mXZ/xq0gDosTRC0/Nc5X1AcIAXyaHCqJ05oibMIYfAx1LByfnAywHw9AiJY2ZlYBfb
	 GldRlAi/dFnE2b4dk6/5kqIAuheVbkZ67cUjqKPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junjie Cao <junjie.cao@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0933/3318] ASoC: rt712-sdca-dmic: fix drvdata type in the gain controls
Date: Wed, 18 Nov 2026 15:25:55 +0100
Message-ID: <20261118150347.547199651@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junjie Cao <junjie.cao@intel.com>

[ Upstream commit 0bc42544a4a06e8d76eb412d2b1414db910a311d ]

rt712_sdca_dmic_set_gain_get() and rt712_sdca_dmic_set_gain_put() take
the component drvdata as struct rt712_sdca_priv, but this driver stores
a struct rt712_sdca_dmic_priv.

regmap and mbq_regmap are at the same offsets in both structs, so the
register accesses work. slave is not: rt712_sdca_priv has dmic_component
in front of it, so its slave overlays rt712_sdca_dmic_priv's params,
which this driver never writes. When regmap_write() fails in the put
handler, dev_err() is called with &NULL->dev (RSI below):

  rt712-sdca-dmic sdw:0:3:025d:1713:01: Defer on undeferrable control: 40800f13
  BUG: kernel NULL pointer dereference, address: 0000000000000058
  RIP: 0010:__dev_printk+0x10/0x70
  RDX: ffffcdac45f83cd0 RSI: 0000000000000008 RDI: ffffffffa09cb5cb
  Call Trace:
   _dev_err+0x7f/0x99
   rt712_sdca_dmic_set_gain_put.cold+0x20/0x25 [snd_soc_rt712_sdca_dmic]
   snd_ctl_elem_write+0x19a/0x1f0 [snd]
   snd_ctl_ioctl+0x658/0x8a0 [snd]

Seen on a Dell Precision 5690 running 7.2.5-200.fc44, with alsactl
writing the control during boot. Compile-tested only.

Fixes: 63a511284c9e ("ASoC: rt712-sdca: Add RT712 SDCA driver for Mic topology")
Closes: https://bugzilla.redhat.com/show_bug.cgi?id=2532834
Cc: stable@vger.kernel.org
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
Link: https://patch.msgid.link/20260920024232.710189-1-junjie.cao@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt712-sdca-dmic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt712-sdca-dmic.c b/sound/soc/codecs/rt712-sdca-dmic.c
index 0b3e1873e5d03..d4718f68a781e 100644
--- a/sound/soc/codecs/rt712-sdca-dmic.c
+++ b/sound/soc/codecs/rt712-sdca-dmic.c
@@ -248,7 +248,7 @@ static int rt712_sdca_dmic_set_gain_get(struct snd_kcontrol *kcontrol,
 		struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
-	struct rt712_sdca_priv *rt712 = snd_soc_component_get_drvdata(component);
+	struct rt712_sdca_dmic_priv *rt712 = snd_soc_component_get_drvdata(component);
 	struct rt712_sdca_dmic_kctrl_priv *p =
 		(struct rt712_sdca_dmic_kctrl_priv *)kcontrol->private_value;
 	unsigned int regvalue, ctl, i;
@@ -283,7 +283,7 @@ static int rt712_sdca_dmic_set_gain_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
 	struct rt712_sdca_dmic_kctrl_priv *p =
 		(struct rt712_sdca_dmic_kctrl_priv *)kcontrol->private_value;
-	struct rt712_sdca_priv *rt712 = snd_soc_component_get_drvdata(component);
+	struct rt712_sdca_dmic_priv *rt712 = snd_soc_component_get_drvdata(component);
 	unsigned int gain_val[4];
 	unsigned int i, adc_vol_flag = 0, changed = 0;
 	unsigned int regvalue[4];
-- 
2.53.0



