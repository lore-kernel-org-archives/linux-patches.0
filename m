Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049796;
	b=4qS61SEP9zHSkoGZn2dlMhSF/vSLqQ+v7yiZ1N66i5RJ1cqnklyWaU6elL8G2wudA4fo
	 ZmixhnLartcrXz1b7qkIc6uoIwyZ0xNsaMvT/NtmJilDkrxz6m5gNnyGzpUsyZdxUit1p
	 GYjS1xF1ugi5hkj9P12F6pyBYzZKapHevSlYR7o88MZ6M0k7Y4tYbNQ6untd9qSiWt/2/
	 nzpB3fhwKSAQJnrQ90TunSmlTcuUnrvibAGaeq+jiA9f5W9Rz/h0iTQUrsws3aQGySoTn
	 ih1HirjB/nGdjwWRWa4JiinPqiwV3Fxn58RJW3BMF6r5lLShXdOjA8Nc45td0ecesVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049796;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vNXYGZvn43j1yX1kvuJHZvju2hJ7CiPq+i39HF0W+VY=;
	b=UE8DsO3xMMKbhU1/HekowvIaDuYPCApcRWEojaJJRhn0wfM2GNXGfRt9oM+pn5D7J4nB
	 JDGZsinpBQ490NoHDeqRrUpbDEjQ09jVCO91mZLZAelf4cp0xsGVnzjFv0P0g4cyeVJX+
	 d2J5p8UANAj8RK8aC6GEZ+tW8c7HwAW8Qei3Ft5gUFq8l6oB/M/H/cyTpAtPAki/ffiB8
	 opPmmiiEnX7iinhn9xaED6xWYIJ+4zBsMmuLjeoqfLqxxbwMd8b8ZeKaGQOCKupG3+okd
	 xafI2DpKWblyld30Z4lGhGplumQl3cvah/NHkms2opTrt5MPtzMVY5ygnDFZWX6H/0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mInE0l4H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AC7606A320;
	Thu, 19 Nov 2026 00:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mInE0l4H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FD21F000C4;
	Thu, 19 Nov 2026 00:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049795;
	bh=vNXYGZvn43j1yX1kvuJHZvju2hJ7CiPq+i39HF0W+VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mInE0l4HMJ3Nj8HkOlfJWWcjjuy/zsycU8R2gtDVI81t1JQ17Ut5UZMszafEthpER
	 qAvkVhEieoLyUdrBZpOUyZ07fRa2re6NBtZutWzdH5l7fqBXTDXi8322PJ23Ow8aGB
	 bOXrT21gjA17J+B3D56aHD74EYmKmJYh8uVgd55k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2478/2857] ASoC: codecs: wm8750: Fix definition of ALC Capture NG Type control
Date: Wed, 18 Nov 2026 15:58:32 +0100
Message-ID: <20261118150330.783159769@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 8c299077c787c151c5c88928467d8e8d85cebdb7 ]

The noise gate type is wm8750_enum[7], bit 1 of WM8750_NGATE, not
wm8750_enum[4], which is the 3D upper cut-off.

Fixes: abadfc928a27 ("[ALSA] ASoC codecs: WM8750 support")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/ce530dfb932d9e8def75059ab9d669360adc76e8.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8750.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8750.c b/sound/soc/codecs/wm8750.c
index 2f6ee8d6639f8..839850463e6fa 100644
--- a/sound/soc/codecs/wm8750.c
+++ b/sound/soc/codecs/wm8750.c
@@ -171,7 +171,7 @@ SOC_SINGLE("ALC Capture Hold Time", WM8750_ALC2, 0, 15, 0),
 SOC_SINGLE("ALC Capture Decay Time", WM8750_ALC3, 4, 15, 0),
 SOC_SINGLE("ALC Capture Attack Time", WM8750_ALC3, 0, 15, 0),
 SOC_SINGLE("ALC Capture NG Threshold", WM8750_NGATE, 3, 31, 0),
-SOC_ENUM("ALC Capture NG Type", wm8750_enum[4]),
+SOC_ENUM("ALC Capture NG Type", wm8750_enum[7]),
 SOC_SINGLE("ALC Capture NG Switch", WM8750_NGATE, 0, 1, 0),
 
 SOC_SINGLE("Left ADC Capture Volume", WM8750_LADC, 0, 255, 0),
-- 
2.53.0



