Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039357;
	b=Mf3uyUTCIw/VqsoyyB9Tkl+bemfTJfC0wRROQQAhI2bZLYcWuQj7xeKCRWyn1jEEqv0H
	 +3sZ4HGSh+2zUtPdqjZ0pbQO2n5X0ZYkkKeZ4GCxXaDCDjjSfGMDRyra8ysyuySWFvOdO
	 RKYRkDlO9YvUYaZ6CRsV4fWtVyRog4gBEpcOKaIL7QNul8gkzcz6xPbnIeXldQ3RFCz2Z
	 vhVh0BQCmpLa+BMsto1eB5oEf0kWBD5KjsHNvhAe1tORXExm7aWkg9osJoi9ck8XidxXS
	 EZX+EabOrM9MWgHD7zv8c5mZLHsCUGed9HxYccVVap/NEc3pU9LPrvtElz3L0yoW3NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zVmUFNrBACXe1v4FsBnjgUckusWoNnn/4Rmvwh30JAE=;
	b=tRwWYLOFoCDZPYEfYpGYRRS88YYpRKki/RmO+jQ7VfvQBfUUgXSGOQFWa4K9Tt4y7wLX
	 wxVBNmD2jiw/fysMHWUs957aPfykJjTDXEQErSiCv+1NyVP5cDL816haikW/K7IrUSxEX
	 rBSNx75FDyZnQxTGFHodKnnpCCVnVjaPHpJLs+BiNmhpWdeFp0yLnmCZHeHZzPQYiUTVu
	 3LO0dFfh+IVtVfdTNhI4iRwChevr64oKSFbFHroFb/znjdZrTtUh5Qhy/STbYgahmwuNv
	 cj9aaw9zY9POYry3lK+V/QpNPwHXF0xUvR5dThUHQkY/FywJlhkAqTOnW2ZMpqqroRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="cX/Jw3IY";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA98606A31C;
	Wed, 18 Nov 2026 22:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cX/Jw3IY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235431F000C4;
	Wed, 18 Nov 2026 22:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039356;
	bh=zVmUFNrBACXe1v4FsBnjgUckusWoNnn/4Rmvwh30JAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cX/Jw3IY0dzsY5FobR6VigeHiISDnP+cWJdvnrKF2I2oezu0PwnQohC2vSp1AQYaO
	 ROxtPaGFeZuRoP6iZxlp1rV6+ruXQRQvdr6XlujQVPj2cubugtYvSGFAAnfqX4QoA2
	 qcr0PIK2QGlOaWVvjjsrp+xbsoNJ+pyx+bFiNlZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Ning <zhuning0077@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2071/3318] ASoC: codecs: ES8326: Minimize the pop noise on headphone
Date: Wed, 18 Nov 2026 15:44:53 +0100
Message-ID: <20261118150424.213384995@linuxfoundation.org>
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

From: Zhu Ning <zhuning0077@gmail.com>

[ Upstream commit a3aa9255d6ccb1bff13c7c98e5d3bf10ba67f92e ]

We modify the register settings to minimize headphone pop noise
during ES8326 power-up and music start/stop.

Signed-off-by: Zhu Ning <zhuning0077@gmail.com>
Link: https://msgid.link/r/20240120101240.12496-5-zhuning0077@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 349e94679968 ("ASoC: es8326: report resume restore errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8326.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index ca2165f4ad46b..68ff30156bad9 100644
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -404,7 +404,8 @@ static int es8326_mute(struct snd_soc_dai *dai, int mute, int direction)
 		regmap_write(es8326->regmap, ES8326_HP_CAL, ES8326_HP_OFF);
 		regmap_update_bits(es8326->regmap, ES8326_DAC_MUTE,
 				ES8326_MUTE_MASK, ES8326_MUTE);
-		regmap_write(es8326->regmap, ES8326_HP_DRIVER, 0xf0);
+		regmap_update_bits(es8326->regmap, ES8326_HP_DRIVER_REF,
+				0x30, 0x00);
 	} else {
 		if (!es8326->calibrated) {
 			regmap_write(es8326->regmap, ES8326_HP_CAL, ES8326_HP_FORCE_CAL);
@@ -417,8 +418,13 @@ static int es8326_mute(struct snd_soc_dai *dai, int mute, int direction)
 			regmap_write(es8326->regmap, ES8326_HPR_OFFSET_INI, offset_r);
 			es8326->calibrated = true;
 		}
+		regmap_update_bits(es8326->regmap, ES8326_DAC_DSM, 0x01, 0x01);
+		usleep_range(1000, 5000);
+		regmap_update_bits(es8326->regmap, ES8326_DAC_DSM, 0x01, 0x00);
+		usleep_range(1000, 5000);
+		regmap_update_bits(es8326->regmap, ES8326_HP_DRIVER_REF, 0x30, 0x20);
+		regmap_update_bits(es8326->regmap, ES8326_HP_DRIVER_REF, 0x30, 0x30);
 		regmap_write(es8326->regmap, ES8326_HP_DRIVER, 0xa1);
-		regmap_write(es8326->regmap, ES8326_HP_VOL, 0x91);
 		regmap_write(es8326->regmap, ES8326_HP_CAL, ES8326_HP_ON);
 		regmap_update_bits(es8326->regmap, ES8326_DAC_MUTE,
 				ES8326_MUTE_MASK, ~(ES8326_MUTE));
@@ -438,23 +444,20 @@ static int es8326_set_bias_level(struct snd_soc_component *codec,
 		if (ret)
 			return ret;
 
-		regmap_update_bits(es8326->regmap, ES8326_DAC_DSM, 0x01, 0x00);
+		regmap_update_bits(es8326->regmap, ES8326_RESET, 0x02, 0x02);
+		usleep_range(5000, 10000);
 		regmap_write(es8326->regmap, ES8326_INTOUT_IO, es8326->interrupt_clk);
 		regmap_write(es8326->regmap, ES8326_SDINOUT1_IO,
 			    (ES8326_IO_DMIC_CLK << ES8326_SDINOUT1_SHIFT));
-		regmap_write(es8326->regmap, ES8326_VMIDSEL, 0x0E);
 		regmap_write(es8326->regmap, ES8326_PGA_PDN, 0x40);
 		regmap_write(es8326->regmap, ES8326_ANA_PDN, 0x00);
 		regmap_update_bits(es8326->regmap,  ES8326_CLK_CTL, 0x20, 0x20);
-
-		regmap_update_bits(es8326->regmap, ES8326_RESET,
-				ES8326_CSM_ON, ES8326_CSM_ON);
+		regmap_update_bits(es8326->regmap, ES8326_RESET, 0x02, 0x00);
 		break;
 	case SND_SOC_BIAS_PREPARE:
 		break;
 	case SND_SOC_BIAS_STANDBY:
 		regmap_write(es8326->regmap, ES8326_ANA_PDN, 0x3b);
-		regmap_write(es8326->regmap, ES8326_VMIDSEL, 0x00);
 		regmap_update_bits(es8326->regmap, ES8326_CLK_CTL, 0x20, 0x00);
 		regmap_write(es8326->regmap, ES8326_SDINOUT1_IO, ES8326_IO_INPUT);
 		break;
@@ -660,6 +663,7 @@ static void es8326_jack_detect_handler(struct work_struct *work)
 			 * Don't report jack status.
 			 */
 			regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x01);
+			es8326_enable_micbias(es8326->component);
 			usleep_range(50000, 70000);
 			regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x00);
 			regmap_write(es8326->regmap, ES8326_SYS_BIAS, 0x1f);
@@ -703,13 +707,10 @@ static void es8326_jack_detect_handler(struct work_struct *work)
 static irqreturn_t es8326_irq(int irq, void *dev_id)
 {
 	struct es8326_priv *es8326 = dev_id;
-	struct snd_soc_component *comp = es8326->component;
 
 	if (!es8326->jack)
 		goto out;
 
-	es8326_enable_micbias(comp);
-
 	if (es8326->jack->status & SND_JACK_HEADSET)
 		queue_delayed_work(system_wq, &es8326->jack_detect_work,
 				   msecs_to_jiffies(10));
@@ -824,6 +825,14 @@ static int es8326_resume(struct snd_soc_component *component)
 	regmap_write(es8326->regmap, ES8326_DAC_DSM, 0x08);
 	regmap_write(es8326->regmap, ES8326_DAC_VPPSCALE, 0x15);
 
+	regmap_write(es8326->regmap, ES8326_HPDET_TYPE, 0x80 |
+			((es8326->version == ES8326_VERSION_B) ?
+			(ES8326_HP_DET_SRC_PIN9 | es8326->jack_pol) :
+			(ES8326_HP_DET_SRC_PIN9 | es8326->jack_pol | 0x04)));
+	usleep_range(5000, 10000);
+	es8326_enable_micbias(es8326->component);
+	usleep_range(50000, 70000);
+	regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x00);
 	regmap_write(es8326->regmap, ES8326_INT_SOURCE,
 		    (ES8326_INT_SRC_PIN9 | ES8326_INT_SRC_BUTTON));
 	regmap_write(es8326->regmap, ES8326_INTOUT_IO,
@@ -840,11 +849,6 @@ static int es8326_resume(struct snd_soc_component *component)
 	regmap_update_bits(es8326->regmap, ES8326_DAC_MUTE, ES8326_MUTE_MASK,
 			   ES8326_MUTE);
 
-	regmap_write(es8326->regmap, ES8326_HPDET_TYPE, 0x80 |
-			((es8326->version == ES8326_VERSION_B) ?
-			(ES8326_HP_DET_SRC_PIN9 | es8326->jack_pol) :
-			(ES8326_HP_DET_SRC_PIN9 | es8326->jack_pol | 0x04)));
-	regmap_write(es8326->regmap, ES8326_HP_VOL, 0x11);
 
 	es8326->jack_remove_retry = 0;
 	es8326->hp = 0;
-- 
2.53.0



