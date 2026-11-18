Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031956;
	b=k6sjGz91IskRr9YyUDeJHqr/JryTW9bhQHtqz4/dDNi9seu4q7xXWdily1eiXOradNhU
	 Bd/5P47212n7dua6eg4We4sCG4XuZKlv64a/EwKacgETRQIrsCGsPR8vc0LSqIIZsvax8
	 kP7VWdyn6EjbKnlEF1di9GU+/7S1kOoaKllTT6nG1hx27hgQDJgVrdGmn0Q2F/9SAnDnd
	 CNVR2rkYkZW8O6pHoKh97zUIjTVI/szDVTCbJ5tCqYf1n59zHXGYSyL1oUVEgd0q4Pt24
	 jG62zpk6m7qbaOZqrhFKz/3nuzBPtmxDOZvMF+eF41taZo1jb8Btp5131HQuIfA6EKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+n26e4ppmsC8nMru7EGSNoPLe1dWipRHE8TLh0k7lhM=;
	b=RghtZKZ8YiDU1NtDPR5fYuwDGQyXldZaMBikLqknHIXcPTjWihqTeqjpQGaTWSiFMyMb
	 9Ht80GV61ikneNUf01bkUgWFXtVDVRPCZZ17081dMeuYc0nOUjIPdmNjzXYyS7vXU7olG
	 VEx+yV+kT7Xb+xevbb0D9tp+E2MF/0zvWlkiJSOCXDNFRMAW0IoyS3lbOsPlSlGQ1BFcj
	 nXSUcHcxQfil3YlCXpH8uJdNPQeRjzNMzcN1zaWmUfbshab2jWN+HkQrsfiXwPIpNkos2
	 OdCM73wh8oC7Uh5DA4MNgoZI4Qq9QRu12SuGdEG2c2IZiujyt9/koDAQr8yQzKJ5CJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FGroZuNF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3828606A320;
	Wed, 18 Nov 2026 19:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FGroZuNF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4087E1F000C4;
	Wed, 18 Nov 2026 19:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031955;
	bh=+n26e4ppmsC8nMru7EGSNoPLe1dWipRHE8TLh0k7lhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FGroZuNFM3sJTb/Mc5xLc9Bsk1D3EFs4dkSO5fcPi6tY7rzZHkWw9BKA6+6etpYQU
	 MojX6msjDQDjTS4mLetZcXpTkMVesQIJhVmXrh4UxKmoCqenUiVmfHzbuLADkLHkdS
	 bbcEu36K8IqO22mOcESdpQEzGH2mjj43sCius2Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1199/1756] ASoC: codecs: wm8983: Fix definition of ADC 128x Oversampling control
Date: Wed, 18 Nov 2026 15:55:26 +0100
Message-ID: <20261118150057.580677268@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit c1af9e2272f025ff75be76e03413074d5e7801c9 ]

ADC 128x oversampling (ADCOSR128) is at bit 3 of ADC Control, not at
bit 8, which is the high pass filter enable (HPFEN).

Fixes: 6b3860b0a20a ("ASoC: WM8983: Initial driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/d6a5bbab35e1fd2bec5b13d30951546080d493a8.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8983.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8983.c b/sound/soc/codecs/wm8983.c
index 252b4a6cac04d..86d0161922a61 100644
--- a/sound/soc/codecs/wm8983.c
+++ b/sound/soc/codecs/wm8983.c
@@ -234,7 +234,7 @@ static const struct snd_kcontrol_new wm8983_snd_controls[] = {
 			 8, 1, 0, pga_boost_tlv),
 
 	SOC_DOUBLE("ADC Inversion Switch", WM8983_ADC_CONTROL, 0, 1, 1, 0),
-	SOC_SINGLE("ADC 128x Oversampling Switch", WM8983_ADC_CONTROL, 8, 1, 0),
+	SOC_SINGLE("ADC 128x Oversampling Switch", WM8983_ADC_CONTROL, 3, 1, 0),
 
 	SOC_DOUBLE_R_TLV("Playback Volume", WM8983_LEFT_DAC_DIGITAL_VOL,
 			 WM8983_RIGHT_DAC_DIGITAL_VOL, 0, 255, 0, dac_tlv),
-- 
2.53.0



