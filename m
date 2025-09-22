Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A9D1C1ADB;
	Mon, 22 Sep 2025 19:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569971; cv=none; b=EoRigJPnrV/+hu6fkBERFR598nSXESqFRKtnIIWOrRPHXW351KibN/8zFWm6Xb6OK53H2J8K0TLYQhc1y63Dg6+M/jGFFVv2NNs+YdT5DZAN8Dq3j4DLE4S7dW7AwgLFIwnKd9tVc+tGMroMWUGUHU7Za9h6Fy2IS8QUFyMsJgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569971; c=relaxed/simple;
	bh=lhTmVlUG6RW89bZOJRqWJMDbNHDk3xDdIcwJeoDQpoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0DrnvMKRHeHBEfXA8oG0v9om+gVNXNYJ24pdSzQ60NKhZymjmaEoyTt+MCef7e+wnZPq5dZ31buqIGh4ad/xNYxziwz13ZSHyTA0o+B2mv+VNKIgpw+bHspfli/HRVb5QhkE5KdzrsnEAyaMfx1nMX0JOVpmok2CTRQGzOfu9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+qHabQ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+qHabQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF60C4CEF0;
	Mon, 22 Sep 2025 19:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569971;
	bh=lhTmVlUG6RW89bZOJRqWJMDbNHDk3xDdIcwJeoDQpoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+qHabQ/AodNoqOc9HUqk2TrLOQPZY3lJJj+Q72Fl29AEvg6haRJOOEwWlajU22Ll
	 hLjJ5IhjR+7tonkatQA0JxII6epw92x/tz0XIZSwKyFqCsa21TIuBroc3O9nn5vFrQ
	 ctpS3NgxZMNWdjWLfqkoZICR9h9DLlPKJ4ma/kqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankur Tyagi <ankur.tyagi85@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/105] ASoC: wm8940: Correct typo in control name
Date: Mon, 22 Sep 2025 21:29:55 +0200
Message-ID: <20250922192410.786992254@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit b4799520dcd6fe1e14495cecbbe9975d847cd482 ]

Fixes: 0b5e92c5e020 ("ASoC WM8940 Driver")
Reported-by: Ankur Tyagi <ankur.tyagi85@gmail.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Tested-by: Ankur Tyagi <ankur.tyagi85@gmail.com>
Link: https://patch.msgid.link/20250821082639.1301453-3-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8940.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
index 5e8ed8a2c270a..808a4d4b6f80b 100644
--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -220,7 +220,7 @@ static const struct snd_kcontrol_new wm8940_snd_controls[] = {
 	SOC_SINGLE_TLV("Digital Capture Volume", WM8940_ADCVOL,
 		       0, 255, 0, wm8940_adc_tlv),
 	SOC_ENUM("Mic Bias Level", wm8940_mic_bias_level_enum),
-	SOC_SINGLE_TLV("Capture Boost Volue", WM8940_ADCBOOST,
+	SOC_SINGLE_TLV("Capture Boost Volume", WM8940_ADCBOOST,
 		       8, 1, 0, wm8940_capture_boost_vol_tlv),
 	SOC_SINGLE_TLV("Speaker Playback Volume", WM8940_SPKVOL,
 		       0, 63, 0, wm8940_spk_vol_tlv),
-- 
2.51.0



