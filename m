Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064239;
	b=nB5M2wubnHaKi/2DLsyQ9pVcxOl5PiHG7Q3PwdTiPlErDxLOcxDk5ACzocU97qtvbEhU
	 0ZLZHOW3CsSwOoJb2kQqcV0+KQpp+nOWqHPj+5mEXXaAVaheOCVrJ7ww78RCVIgQqGFEn
	 nrN08eMzWcCn1hspQ9HyuwMzFzZgiy04ci0XBKGzqijRArsSGPADOiTjFvJtXx3EtyUA5
	 4b6KOKGnApVpSpx+cvLU3fDpfpfoHWn5IMM6CITxc4/fJ5ckf5OUR4wYvr5qgo3Nzu6Al
	 NzSCh6t2egn0FkvSxgzHp/S5J5OfUX/Va+ZdycT5he6S976411TNdxDcQIcHOh7DG0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tUdRjwlV8hnIuLGHD2odht8ibGXT8e9B5aP6ugRrQoE=;
	b=crwDR+CkRtsIJlgnY2+wlMh/QqozIUfZvhWs+d7GtS1XGmgAwXYy+2LnP8CNKD80591M
	 qjfeei8HXvOul/LKumvVWb820BtKCkrYJS8NpSIoPbtVRzqaLwvi+T/lP54/9vmUflx+j
	 MqbQ2zoBr6WrWbGIx+8OA8lpI95yKrvDwDtx3IBcrWWJbfrJOLvdqcE5ZRPaxiMq3+BgB
	 cgya8vhA0Q7BouKNyMUZ3qMvx7l/x4JRo39t4BgA1fvJbw461DofWR42UZoPkhT2qP2/x
	 9Hi9dM7zkXUIXmvPJeai8vRABjTI6wrPLqg38gJFtq/cjzkvsTu2W8ka3Ra8QEnyvOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lAg12F58;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21D0606A332;
	Sat,  7 Nov 2026 15:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lAg12F58
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F021F0089F;
	Sat,  7 Nov 2026 15:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064238;
	bh=tUdRjwlV8hnIuLGHD2odht8ibGXT8e9B5aP6ugRrQoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lAg12F58cj2gYXzrJ1+VDtJTwXhOhNvJXFjuqXvJXo8PnHMXimIXnUY/Avl4gi/N4
	 zzPfbd+Q4Npq0KVipB3s6zag0BAlNIUtxFzc7bNhjFAZjfpJScu7VBBaDehyS1V3Md
	 XgV4N3b5Dr4uHPSh0SDqaGxW7KhM8RQhMdip/Fb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junjie Cao <junjie.cao@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0292/1257] ASoC: rt712-sdca-dmic: fix drvdata type in the gain controls
Date: Sat,  7 Nov 2026 08:43:08 -0500
Message-ID: <20261107134947.531240938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index a9f3aa4e143ae..882390890738e 100644
--- a/sound/soc/codecs/rt712-sdca-dmic.c
+++ b/sound/soc/codecs/rt712-sdca-dmic.c
@@ -246,7 +246,7 @@ static int rt712_sdca_dmic_set_gain_get(struct snd_kcontrol *kcontrol,
 		struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
-	struct rt712_sdca_priv *rt712 = snd_soc_component_get_drvdata(component);
+	struct rt712_sdca_dmic_priv *rt712 = snd_soc_component_get_drvdata(component);
 	struct rt712_sdca_dmic_kctrl_priv *p =
 		(struct rt712_sdca_dmic_kctrl_priv *)kcontrol->private_value;
 	unsigned int regvalue, ctl, i;
@@ -277,7 +277,7 @@ static int rt712_sdca_dmic_set_gain_put(struct snd_kcontrol *kcontrol,
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



