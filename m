Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056266;
	b=KbYSSpuoneMk2MMOIJB+JRSBDduOZk43LUjL1KznzoGOJHyYJLLmLw7y+5sg9WNff/cC
	 K+XnOIX87p4mLMcYho+jAw8zs9enug3qYqP/b5WJ6DxBtA3RiVMzUtQng0EhvYnM1Itwy
	 C6vUc7ZAqQaHpLHFnJLyb+b1WTdJrTTG1qsCmJNeBdVlaK2tVSiqWwzLcVvKSZ+bkfdIT
	 F3FHmTNuYTnQ6/S/VwdxAkMrEJJ2qQRzog6W2geGpGEBEmYUdfP0LcSlGtRi8TXLu2YNq
	 WAZ9p+Acoy5qWwTgFr2vRT+ZlHX+rZGF3do0jEZbHEizT7VnFDPs2FuD1mawY0+PaEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pbEymsYCSvLuFW/smS52vOK+AH+bXsOAl0VYBtLvP1Q=;
	b=KWYJaOVKHk0BJdSNGpSbDsHvhwoiB6v72Q6TEdVoEfL6n0+M/bPScAQWqaGeSiIwgeC4
	 kN9i/rhhcSmr6P2nThCe3qnSf6uRbsbe7clSnQeEeN5LWtgarWkiz/B65+NU5HUIK2ek8
	 RK1V95ExyOrXCd/HjdvO8iwICYmjBmkZwI8GsKjKShRf7UmzWE41sznRIFB6J9xGb6xue
	 4UvSlnOYg6DcyUI//GAX/Odm+ADnwokI1J1MNbrWFFOoVeM3/f3mGAknnJOHSb25X9a5Z
	 X0/AVfSgR+vrJZa7nYgYIBCJlzlaXI1PJ+K3NYyuXQZ/ZmOhf7ZuWFxzdxlXxbsy7aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q4vmpCUD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4334D606A320;
	Thu, 19 Nov 2026 02:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q4vmpCUD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7131F000C4;
	Thu, 19 Nov 2026 02:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056266;
	bh=pbEymsYCSvLuFW/smS52vOK+AH+bXsOAl0VYBtLvP1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q4vmpCUDGrcioUw9LZzHq0vf51WmNekCrgQmzY+naqpQwKsz5jvbhHY/gnIsxhnGI
	 j2RoltlOFuFmJMoNAzjudJINGTRUHQawFaaISGzBCnOoQ7sOVIgFGhLa65sel6ZUFd
	 BYDwsgjIR6ATmWkFdzQX6bFH7ir3Y16yKRtjCyZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1926/2214] ASoC: codecs: wm8510: Fix definition of ADC Inversion Switch control
Date: Wed, 18 Nov 2026 16:00:02 +0100
Message-ID: <20261118150128.079756278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 22d50113078dfbeff0d005d64fd9cc680249831c ]

ADC polarity is bit 0 of WM8510_ADC, not bit 0 of WM8510_COMP, which
is the loopback enable. wm8974, which has the same register layout,
already uses WM8974_ADC for this control.

Fixes: 5d421516670e ("[ALSA] ASoC: Add WM8510 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/6ada61df8c8fc97ffb1623e74f6742ca498032fa.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8510.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8510.c b/sound/soc/codecs/wm8510.c
index a18e2290b8c88..68c694b233a4e 100644
--- a/sound/soc/codecs/wm8510.c
+++ b/sound/soc/codecs/wm8510.c
@@ -135,7 +135,7 @@ SOC_SINGLE("Master Playback Volume", WM8510_DACVOL, 0, 127, 0),
 
 SOC_SINGLE("High Pass Filter Switch", WM8510_ADC, 8, 1, 0),
 SOC_SINGLE("High Pass Cut Off", WM8510_ADC, 4, 7, 0),
-SOC_SINGLE("ADC Inversion Switch", WM8510_COMP, 0, 1, 0),
+SOC_SINGLE("ADC Inversion Switch", WM8510_ADC, 0, 1, 0),
 
 SOC_SINGLE("Capture Volume", WM8510_ADCVOL,  0, 127, 0),
 
-- 
2.53.0



