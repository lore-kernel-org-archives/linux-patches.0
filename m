Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063361;
	b=zSWZudETvaqa7MIhT9aw+SS4BjCXMTK5Z8E+VcqzquVj8u2hN037bEHtY/CYXBGX0KGC
	 umVZkyUwAl6d3PKgYMWPwTPDgjFCXIMNiiW1rtklA8XtUwR13O3HfEJkSc/VliJrmmhQX
	 zxCXksk0xD7X65E70C/BJ2MEjzPCdJWegfGrQLSCsOQAQuS2GDU6smfVbdTuPH0GS58Er
	 UJaRsjCv/m/gCjFz64ew2RfjV6H2/IHHpEq2rbj+yMr27KML3y84qT1KVzPAGRwhERIPI
	 BgITuYoxQ7HxJXqSI+bXVO6LjB5IMEKfVZufi5m8zimbY0eWtqki+7HasRu1dDot7TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2GW2fXoB1j/hBoBqbFVvPalKuytV84wgCupQ6PSI/HI=;
	b=uwRyhrEml5gnagRZDWV5TCiiOLbfZZvteeWi2fgoUITz6r2OwQIFj3gy73T/9llREG2E
	 9hS3vp+DhKf+eLnp6VFjFtkrhYY/UT8EJjInZ3/CmpaEYFnMCreD8YhfHiZsshRIwSxG3
	 lInmtszgD8m+BD36p9kfLG2BS4VAmj0epcox0jKnv7tp3DbIUc4a4VtRKLwtWaz86yEe6
	 pCp889othWi6lONA5n5KxWpbJE1ILIrXQo7UK7ExtZjNywcFw12sqjEa4jie6PlWb/zHI
	 BSkLQ+015nf9irFs7E2LP2dAmuG+HmwPKYpft/mOSb8yJiMqqhzYo3MKbY4cp3cWHVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K6OOSumw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F48606D83B;
	Sat,  7 Nov 2026 14:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K6OOSumw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC8C1F0089F;
	Sat,  7 Nov 2026 14:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063361;
	bh=2GW2fXoB1j/hBoBqbFVvPalKuytV84wgCupQ6PSI/HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K6OOSumw+X2s8WGVr0z3rKapNx1EXWmyS7ZtNzWSi9KZ+aE4X1CMmDRPTcbzCdWhE
	 BzTMqCquJ86RsoqIEn9bxYWGNsA1GeNPK6cDSHQTd49EbhP5VJbGCYdoBAyRW/YnPp
	 4oU4P6V5Md0WHoclwuXAYKAgyzPBfk57fWWR8FFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Wenzel <g.wenzel@gmail.com>,
	Gergo Koteles <soyer@irl.hu>,
	Philipp Oster <philippdev5396@outlook.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 539/869] ALSA: hda/tas2781: Skip invalid TAS2563 UEFI calibration data
Date: Sat,  7 Nov 2026 08:53:41 -0500
Message-ID: <20261107134911.700930466@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Gergo Koteles <soyer@irl.hu>

[ Upstream commit a0f0325e92e505db6a6879d79da5aa88e94a36ab ]

Some Lenovo 14ARB7 laptops do not have proper calibration data.

Skip these zero calibration values and fall back to the calibration data
provided by the DSP firmware.

Tested-by: Georg Wenzel <g.wenzel@gmail.com>
Fixes: c3ca4458cc2f ("ALSA: hda/tas2781: add TAS2563 support for 14ARB7")
Cc: stable@vger.kernel.org # 6.18
Signed-off-by: Gergo Koteles <soyer@irl.hu>
Tested-by: Philipp Oster <philippdev5396@outlook.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/12a1ab265a1dc0e3a062a54287c8ef48682c4efc.1791895478.git.soyer@irl.hu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/side-codecs/tas2781_hda_i2c.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c b/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
index ebfc08b5fb283..6eb9e4b8ba2e8 100644
--- a/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
+++ b/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
@@ -375,6 +375,11 @@ static int tas2563_save_calibration(struct tas2781_hda *h)
 					i, j, status);
 				return -EINVAL;
 			}
+			if (*(uint32_t *)&data[offset] == 0) {
+				dev_warn(p->dev,
+					 "Dev %d: Caldat[%d] is zero\n", i, j);
+				return -EINVAL;
+			}
 			bedata = cpu_to_be32(*(uint32_t *)&data[offset]);
 			memcpy(&data[offset], &bedata, sizeof(bedata));
 			offset += TAS2563_CAL_DATA_SIZE;
-- 
2.53.0



