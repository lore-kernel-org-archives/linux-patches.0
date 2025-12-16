Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F7C376BD7;
	Tue, 16 Dec 2025 12:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888072; cv=none; b=utY0VxUM/oEnTxn7go0Y+OLzVi8Qcc7FId+JaHtrM0YCWlMQLxPgbK2FwHWKnEA96swxK98E/8jSKnuMNOUqwuwecBZ1Jh+aZlZDz6QrnR08XCZl7De9FaSv7AHugze0+8x3JqKnoaS+Y8I4BNLlTnb/Ae/ZHfDHl8q0xGwy5PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888072; c=relaxed/simple;
	bh=fj3Ub7TqAL2NBqURLQnsYtlGdW+2/uwxUihztGEHd+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9kdN93aZMAkbTUOJsfZo8x2CWMjK/tgZVMMKQ7ArTT9qY6TC/IEYkHCbL2LX61dv4KiteJ6DRAP9UX0QCfvm+1k2oPL1cldGmmgL7+H2GaPRW2pBZXp/0PD+B5WOtPy55the5bdF0x+Q5/R3j53VPNqkXFFTcKkP0n0qHXDv4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QSDQ4l+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QSDQ4l+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A859FC4CEF1;
	Tue, 16 Dec 2025 12:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888072;
	bh=fj3Ub7TqAL2NBqURLQnsYtlGdW+2/uwxUihztGEHd+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QSDQ4l+nka5PfI9+HqgaYI4TEETYnu1EmL5MtmRj4XUUpV0469q9hQQ3U5c7jbhcL
	 Q9PusXcmse9u1Bbe7ke6f6bZlZVH7nbSPY8InzP4jjMtSIZmLEfwuEM8dC6h85BvPC
	 HKNb/jOpQJQC/H+BvkxM0yjbQ+DQ7Qqs0LZ7A11k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baojun Xu <baojun.xu@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 381/614] ASoC: tas2781: Correct the wrong chip ID for reset variable check
Date: Tue, 16 Dec 2025 12:12:28 +0100
Message-ID: <20251216111415.165798074@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baojun Xu <baojun.xu@ti.com>

[ Upstream commit 34b78ddd78428e66a7f08f71763258723eae2306 ]

The new variable of reset was added for TAS58XX on TAS5825 first.
And TAS5802/5815... was added later, so this reset variable check
should be changed to lowest chip of TAS58XX.

Fixes: 53a3c6e22283 ("ASoC: tas2781: Support more newly-released amplifiers tas58xx in the driver")
Signed-off-by: Baojun Xu <baojun.xu@ti.com>
Link: https://patch.msgid.link/20251124031542.2793-1-baojun.xu@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2781-comlib-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2781-comlib-i2c.c b/sound/soc/codecs/tas2781-comlib-i2c.c
index b3fd7350143bd..e24d56a14cfda 100644
--- a/sound/soc/codecs/tas2781-comlib-i2c.c
+++ b/sound/soc/codecs/tas2781-comlib-i2c.c
@@ -320,7 +320,7 @@ void tasdevice_reset(struct tasdevice_priv *tas_dev)
 		for (i = 0; i < tas_dev->ndev; i++) {
 			ret = tasdevice_dev_write(tas_dev, i,
 				TASDEVICE_REG_SWRESET,
-				tas_dev->chip_id >= TAS5825 ?
+				tas_dev->chip_id >= TAS5802 ?
 				TAS5825_REG_SWRESET_RESET :
 				TASDEVICE_REG_SWRESET_RESET);
 			if (ret < 0)
-- 
2.51.0



