Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590480;
	b=ocH64GBHz68C2xORoV6NzRRBJGuQi5A31yGFC06h+QbcA/jPmCMa1BkULJuNWpBpyWN2
	 80G140L5BejRJidQWtzlLSLMsd49zsFO5j0l6HUxEhzxpbOqUY2NrWxAAIIJfh1pWTYA4
	 LtCzZFcaT8HCyleZ0rLDbqzdmocf5IAoq3lXLCg3pT5cKDVfgxgiurMngC0njN4M1+P0q
	 58rPchsC/Vqmm2yG52rI4xW5+521B3EN5c4kVVd6rG7U1++BLJGC3TkJNomz2N1p79FGM
	 5eM1hNYeXH7OILUt528V5ecNj/QV2bOIIgVb0VbN2PTZOx3DL0E3RvQTWtTfFT9Eo8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Am24W/tq28b886GbNuqqNGsu7fw8WHMZsTJ2k8iyVDM=;
	b=mfy/kAmYay3H2LZJFQBKU/cnA28BoMVQkLFsWMXO9d1eNUaymWKPs02uqjjmWCbM5E8O
	 tvuDkTJVduvPc0968kZO9kU3tU6YBNjbtsCIrCjkI88ht+gASKKkYPdasQxC+R7PiDIud
	 Hj7aJL6CER8iLyEtLY3oeAeILkfKuJfFKXeM10WuJxSkaZlsCti+GARJTUPaP4eIfv0pH
	 cd0siDosEc/E9kZKPgnE74wGuO3OI2sHfAAGfPML2tTGEN5lTXakHEwZd8vyLrYZle6Nr
	 b154efaQ1DzRevUzKHbSVSDLcGTbiqC7FW29ppOSwH36KdXtbJsA63vvQcoIVch2yEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WHLvIF0X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B58606B826;
	Fri, 13 Nov 2026 17:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WHLvIF0X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146B11F000C7;
	Fri, 13 Nov 2026 17:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590480;
	bh=Am24W/tq28b886GbNuqqNGsu7fw8WHMZsTJ2k8iyVDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WHLvIF0XPdQPv2R24uUZn752BdfPu3bgyha9Xv7kA6HtWVOPY4mTYcoFIGPpocg9W
	 KKhLl1k36Qt7zrgkgZwjQeu7SaovHza7ZhBLCVNvCA09OCMreaX6BvaEk08+heyPNg
	 t+gWF2Mll6Vcqbn3/xTeT5j114mCF4kWJP+rrE8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Castellano <cristian.castellano@icloud.com>,
	Mohamed Yassine Jebabli <med.jebabli@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 432/686] ALSA: hda/tas2781: Only accept CRC-less V1 data if all entries are valid
Date: Fri, 13 Nov 2026 10:49:25 -0500
Message-ID: <20261113153835.556149474@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Mohamed Yassine Jebabli <med.jebabli@gmail.com>

[ Upstream commit 8dbab764f1e0a92c3fac0ce070ce30c0c33c2692 ]

Commit 408249089c48 ("ALSA: hda/tas2781: Accept V1 calibration data
without CRC") only checked the first device entry. On machines where
the BIOS populates fewer entries than p->ndev, the remaining all-zero
entries are applied and tas2781_cali_preproc() divides by zero on
playback open.

Accept CRC-less V1 data only if every expected entry is non-zero and
self-consistent (R0 * 1/R0 close to 1.0), otherwise reject it as
before.

Fixes: 408249089c48 ("ALSA: hda/tas2781: Accept V1 calibration data without CRC")
Reported-by: Cristian Castellano <cristian.castellano@icloud.com>
Closes: https://lore.kernel.org/all/4e500063-d985-46b6-a0a1-3feaa77c4b2f@leemhuis.info/
Cc: stable@vger.kernel.org
Signed-off-by: Mohamed Yassine Jebabli <med.jebabli@gmail.com>
Link: https://patch.msgid.link/20261103-tas2781-v1-nocrc-fix-v1-1-a769c27f21ce@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/side-codecs/tas2781_hda.c | 27 +++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/side-codecs/tas2781_hda.c b/sound/hda/codecs/side-codecs/tas2781_hda.c
index 00628e0b5c3e4..dc4e42fd88484 100644
--- a/sound/hda/codecs/side-codecs/tas2781_hda.c
+++ b/sound/hda/codecs/side-codecs/tas2781_hda.c
@@ -50,6 +50,31 @@ static void cali_cnv(unsigned char *data, unsigned int base, int offset)
 		(u32 *)&reg_data, TASDEV_CALIB_N);
 }
 
+/*
+ * V1 data without CRC is only trusted if every expected device has a
+ * populated, self-consistent entry: R0 (Q27) * 1/R0 (Q31) must be
+ * close to 1.0 in Q58.
+ */
+static bool tas2781_v1_nocrc_valid(const unsigned int *v, int ndev)
+{
+	const u64 one = 1ULL << 58;
+	int i;
+
+	if (ndev <= 0 || ndev > 4)
+		return false;
+
+	for (i = 0; i < ndev; i++) {
+		const unsigned int *e = &v[i * 5];
+		u64 prod = (u64)e[0] * e[1];
+
+		if (!e[0] || !e[1] ||
+		    prod < one - one / 10 || prod > one + one / 10)
+			return false;
+	}
+
+	return true;
+}
+
 static void tas2781_apply_calib(struct tasdevice_priv *p)
 {
 	struct calidata *cali_data = &p->cali_data;
@@ -145,7 +170,7 @@ static void tas2781_apply_calib(struct tasdevice_priv *p)
 			 * but leave TimeStamp and CRC zeroed.
 			 */
 			if (!tmp_val[20] && !tmp_val[21] &&
-			    tmp_val[0] && tmp_val[1]) {
+			    tas2781_v1_nocrc_valid(tmp_val, p->ndev)) {
 				dev_warn(p->dev,
 					 "%s: V1 data without CRC, accepting\n",
 					 __func__);
-- 
2.53.0



