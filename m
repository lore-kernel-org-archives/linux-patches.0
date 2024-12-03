Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0773C1F7071;
	Tue,  3 Dec 2024 14:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237600; cv=none; b=CAGxA22W48UkgZQvNTlFz1V8CJUt5OQzBoo/3mV/kPvSuDoCTDCNuRlXZFde8tmDcfjtFpNxJVjPLXrivK0EufbMVx1NbIccWB4IHGgv42TG0VfmSr1w1QufCK3Hf4zeh2i3dR0MvPzFS11Jtyd+fIT3c4ntWSP8ZQUN8GRopLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237600; c=relaxed/simple;
	bh=wkSVx997DncxdcOmCIXbOuKedzmvs6VYavNJjKeYMbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oecnJZSb3aYbCn0yp4bCxBogkQAS6dne/du4qh4AVWvmTSaeeLX38xwIXKcxcyKNWXudpzuYNDTJhHB2aAsCkBPrOhcMbHDMdt10CwdNKzWvHL2Yf6sNWjUR38cSn1q2W5W/YEO74TOQqsWbnNNM30HszF9MSruAwnTI/xkkCVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hc9bV4mB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hc9bV4mB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFC6C4CECF;
	Tue,  3 Dec 2024 14:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237599;
	bh=wkSVx997DncxdcOmCIXbOuKedzmvs6VYavNJjKeYMbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hc9bV4mBfydQW7MDUY1lokfISk8gZUl4Pj54LrGO/G3gNbyDwHL8PwiEF6p/7wqBu
	 7KLyYslr7utqcCCRZhol8y/5/LDINjLnX2ffNjiZW90rFRBT5hJTS3uzBLQ2WxKYpq
	 21Fqt3DdK34xYQkQCd7hqc2a+t84SS+ag+BBuQS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Skladowski <a39.skl@gmail.com>,
	Prasad Kumpatla <quic_pkumpatl@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Mohammad Rafi Shaik <quic_mohs@quicinc.com>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 017/817] ASoC: codecs: wcd937x: add missing LO Switch control
Date: Tue,  3 Dec 2024 15:33:09 +0100
Message-ID: <20241203143956.314832444@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Klimov <alexey.klimov@linaro.org>

[ Upstream commit 041db4bbe04e8e0b48350b3bbbd9a799794d5c1e ]

The wcd937x supports also AUX input but the control that sets correct
soundwire port for this is missing. This control is required for audio
playback, for instance, on qrb4210 RB2 board as well as on other
SoCs.

Reported-by: Adam Skladowski <a39.skl@gmail.com>
Reported-by: Prasad Kumpatla <quic_pkumpatl@quicinc.com>
Suggested-by: Adam Skladowski <a39.skl@gmail.com>
Suggested-by: Prasad Kumpatla <quic_pkumpatl@quicinc.com>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Mohammad Rafi Shaik <quic_mohs@quicinc.com>
Signed-off-by: Alexey Klimov <alexey.klimov@linaro.org>
Link: https://patch.msgid.link/20241022033132.787416-2-alexey.klimov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd937x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/wcd937x.c b/sound/soc/codecs/wcd937x.c
index af296b77a723a..63b25c321a03d 100644
--- a/sound/soc/codecs/wcd937x.c
+++ b/sound/soc/codecs/wcd937x.c
@@ -2049,6 +2049,8 @@ static const struct snd_kcontrol_new wcd937x_snd_controls[] = {
 		       wcd937x_get_swr_port, wcd937x_set_swr_port),
 	SOC_SINGLE_EXT("HPHR Switch", WCD937X_HPH_R, 0, 1, 0,
 		       wcd937x_get_swr_port, wcd937x_set_swr_port),
+	SOC_SINGLE_EXT("LO Switch", WCD937X_LO, 0, 1, 0,
+		       wcd937x_get_swr_port, wcd937x_set_swr_port),
 
 	SOC_SINGLE_EXT("ADC1 Switch", WCD937X_ADC1, 1, 1, 0,
 		       wcd937x_get_swr_port, wcd937x_set_swr_port),
-- 
2.43.0



