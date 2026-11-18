Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061676;
	b=YON24x1mxmWYmT/Y1oD0qXCXcUFNY8Q4PFpoZV3qyYTcOSnhr/x3f05Fj5ZyCY1zwZ3Y
	 2N1mxdP64Jg82ucTzIaiDFXIAgALw/9HHbp4V38lbOTIQ2LgppjwCZn8zNuEJnvu8ABqH
	 0DaWeti9XmcobaHM2bN0rvXlAPHVz06N5CWfbfZ3wxVMprvolk3mHCGcXgGfqAipQfMDH
	 J4ALeg22Hzyfuv4pZB8fNGezJbK7unz9t7+aZBUWDf80ENwZ8TWYsdlEz7m8bBg7Z0a6N
	 5Z/MmsUXPY6p2Xzy06fCQ4odcq9mHUB8WgPYP4i/k73Y5aQVR5Pbs9YeD8dA8ROlvEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061676;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aNUpTofVxS7DbiognSc/zBIzMd1hr6yW1pmBVTTwukU=;
	b=z4Xhg8bt7LYEerxFoE6Lhw1/fB1WMv8UhPpjzYsVcxGMjibATh42WNTcrEv9ZzWMaQZ8
	 PvCU5a3LJU9oXSZ56Mglh42mkR3MvLmB5Sgv+Z+UDsB73u1CVZnNv4UeAI9jJseo70gug
	 rMvtmSBOuxiwDzMr5gHT1H++tssoryvByWHQOX/z+vS/FH2pVwnJhLwdVPwzrlXS+gaoC
	 qSdrJXvxYrf1ZDcB3F3qZwH6XO+3dZaQX884pn0VL2B0wgA2/3wZi99GqcffArxdh7ChN
	 qRhsHOb7UtshxBjyv/HcVxF3zPfVIOO+5S9/xSutrvzZO+x5diAfDOQ7AjO2JQwpSsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hHeT4OBg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88306606A325;
	Thu, 19 Nov 2026 04:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hHeT4OBg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F4E1F000C4;
	Thu, 19 Nov 2026 04:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061676;
	bh=aNUpTofVxS7DbiognSc/zBIzMd1hr6yW1pmBVTTwukU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hHeT4OBg8Xlp3EGAmbrPuH3qRf2qyUkrvCLTle7tzFkkg/n6eYgBGVF7l5MEa2IWo
	 kU/Tm3BNeZSQRJBD/2jAs+XXmWJa/FDvZgFWtsIangMbk3dvk7WhG62W0JwEGtGIlf
	 4fkXU+ZYYz/EdtHkeXlgNBl2leJbi2jDoMIen66s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1636/1848] ASoC: codecs: wm8983: Fix definition of ADC 128x Oversampling control
Date: Wed, 18 Nov 2026 16:01:14 +0100
Message-ID: <20261118150028.055561352@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d1d2d408ad952..b7fdf96fcb626 100644
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



