Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064799;
	b=D0eOKnrIazdBs0ruz0TaIaaSCWrRM/CAh8C2CyrXjDQ64LHZPRW/S9IP6YDeMquM9R15
	 T0qhb5wp+FwqkySRlc9l8NrmWg7q9JQ/H5oZq6NEaUtKzhYQWCk0ZiDp53m/vlMsqvbuK
	 JzA9iLAGFAMMScQr1RerLTaxKZ8Ty4PQYulNgNjqFg4C0xHXn9vcPoxp4WRbfjpA+rqHU
	 Go+DtBKrHtQmsCKX7iBUfcMSZ5dJ7eXIHJCnap7TnkME/QHu40mPJR4+BYhznrUefTm9G
	 PlZd+jFud9mT+wL6xcF/4gREZgalE+0BTHzO6XHbl8nSD0gk6aVV1MPzYgN+TVwrgjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jKLODsr7XEJL1NzJhlX02XXWx5xmSdqePUpQGPet5Sc=;
	b=XfbvlZM7uVJ6TDfcElPO5WaWMw4SOfVBzQN6A59IDpyWLAr16AR1yWjbHYH1lcwnN110
	 VUE9JeM8qLBC2ODYY9BgXaUdWqsQk698nvgUIJdKSAplnUE0gbVQort4bx349UCrohmFa
	 jOnATDI4yYJyUbA+JNltU+v1fJolh00b6cnCNgFXOuoq1GctSaGLyULCY28WATbfXAv8e
	 RtQkJykBqkWwn+Of2k2V10h8xTaFkTGyNBGnztMxBBNv2S9lMbYfSwT65T8FbkPylekUr
	 EypgeBgti00Yvom+09QJ49/OmVAOdXQjv1H+TY+qarJpnlPqd0A/kMI9I+rYj8h7USQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iN1CCZPK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E991A606A33E;
	Sat,  7 Nov 2026 15:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iN1CCZPK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6579F1F008A2;
	Sat,  7 Nov 2026 15:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064798;
	bh=jKLODsr7XEJL1NzJhlX02XXWx5xmSdqePUpQGPet5Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iN1CCZPKek7V5KeUsIIsOiFQtVYW2pz/84P5N3Ej3MjpUky0b/wyqHEADYd3WB9ys
	 vjHZZjb2ONQo01uc6e4T1vKYktnvbKn/LTI//gFCNoRjrp3lQmYv24HXC/3MG7NFmZ
	 yARKSKOvcjhpluLMiQDL0AN5eXO100ndlDpAugvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Philipp Oster <philippdev5396@outlook.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0741/1257] ALSA: hda/tas2781: Assign total_sz at the end of the function
Date: Sat,  7 Nov 2026 08:50:37 -0500
Message-ID: <20261107134959.753790708@linuxfoundation.org>
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

From: Gergo Koteles <soyer@irl.hu>

[ Upstream commit 35911ab70c41957b4a8ac972af137a8e5ccbe259 ]

In the tas2563_save_calibration() function, cd->total_sz is assigned in
several error paths.

Move the assignment to the end of the function.

Fixes: b6016332b889 ("ALSA: hda/tas2781: clear cali_data.total_sz when calibration read fails")
Cc: stable@vger.kernel.org # 6.18
Signed-off-by: Gergo Koteles <soyer@irl.hu>
Tested-by: Philipp Oster <philippdev5396@outlook.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/4b357778dce1b70a647e7e47b5ab3f0a6b2fc0cc.1791895478.git.soyer@irl.hu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/side-codecs/tas2781_hda_i2c.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c b/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
index 5e5f46c9fb6b7..cff8fab8133a8 100644
--- a/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
+++ b/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
@@ -335,10 +335,11 @@ static int tas2563_save_calibration(struct tas2781_hda *h)
 	}
 
 	cd->cali_dat_sz_per_dev = TAS2563_CAL_DATA_SIZE * TASDEV_CALIB_N;
+	cd->total_sz = 0;
 
 	/* extra byte for each device is the device number */
-	cd->total_sz = (cd->cali_dat_sz_per_dev + 1) * p->ndev;
-	data = cd->data = devm_kzalloc(p->dev, cd->total_sz,
+	data = cd->data = devm_kzalloc(p->dev,
+		(cd->cali_dat_sz_per_dev + 1) * p->ndev,
 		GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
@@ -352,7 +353,6 @@ static int tas2563_save_calibration(struct tas2781_hda *h)
 			if (ret < 0 || ret >= sizeof(var8) - 1) {
 				dev_err(p->dev, "%s: Read %s failed\n",
 					__func__, var8);
-				cd->total_sz = 0;
 				return -EINVAL;
 			}
 			/*
@@ -370,7 +370,6 @@ static int tas2563_save_calibration(struct tas2781_hda *h)
 				dev_warn(p->dev,
 					"Dev %d: Caldat[%d] read failed %ld\n",
 					i, j, status);
-				cd->total_sz = 0;
 				return -EINVAL;
 			}
 			bedata = cpu_to_be32(*(uint32_t *)&data[offset]);
@@ -379,12 +378,7 @@ static int tas2563_save_calibration(struct tas2781_hda *h)
 		}
 	}
 
-	if (cd->total_sz != offset) {
-		dev_err(p->dev, "%s: tot_size(%lu) and offset(%u) mismatch\n",
-			__func__, cd->total_sz, offset);
-		cd->total_sz = 0;
-		return -EINVAL;
-	}
+	cd->total_sz = offset;
 
 	r->r0_reg = TAS2563_CAL_R0;
 	r->invr0_reg = TAS2563_CAL_INVR0;
-- 
2.53.0



