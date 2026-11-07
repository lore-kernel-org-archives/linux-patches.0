Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064060;
	b=AdOatplG56VVRc0G1FN3m8XWYLNRIJmRN7oiEqj+Bh0enCWVlUtl68i2AuYbuor81pQn
	 Eu1joEt42mFY/5cyKNZ8i8Wq49+y7yJyDmHgmPcBAI2ysmpVxgsSsuAn2h2Ok6r3SMawQ
	 qYX2uV8rXvpnMu9XhxROWaiiXIPrj6DULQh42Wa4tDdGZBY1kWkXqikrBzpuruMjssxsG
	 ACXETbTnAQ+BcumOo3xkIsUl58t/QbpZv061SoOdPAqbJiYsEfKWGOrw7lYjt1SVKZmrW
	 mQh/skwPuYrOXdkAZp+WZZU3zH7/P07bghb4ro1u1ttxUGcr4WytwIZPwE0J2waiOKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jKiXHCa1A+Nopxa8dc1AMTWyly17TGzKy3XnaC5NkEo=;
	b=N+iHocy9nx9sfZOGY/UxURn0FSyvprHDwqVYcz3GY4IFX40z9aC8nRgsYJTPAgrYmzMb
	 /nOntbhBnJdhwtEfzyGPRGKhViqd26eubTsw84eJLncZtp+/gxZJyMbre3g41kAWvhqG9
	 CDegCVSgj5pc0ncifRIJhMQAmFp55HwQygUhnTWtUpb+AklIoorVCsHZRzZ5R6IsD+Rq5
	 ej1b3sPdBqt+2jM0GQuHi2Soq/wFHz2jkvwuRdR/iEC01eZfihbHJvRcAxcfUkP4H+A8q
	 XzZXFYLuOCOduLeOGIudma7hNGDIiORHucVHq7LynnSffQBIPCtQpli2ITDFcM83t6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P2G7TcUX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F159606A9D4;
	Sat,  7 Nov 2026 15:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P2G7TcUX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0EC41F008A2;
	Sat,  7 Nov 2026 15:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064060;
	bh=jKiXHCa1A+Nopxa8dc1AMTWyly17TGzKy3XnaC5NkEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P2G7TcUX7q7DktyPR+ZQkLLyHGmInce4mWUr8Gnt9PZiDci7bXoVWtyUQXtSkaqAG
	 spzvyxv1bsJfp/x0ablmXn7o6aHi5U3SYfUC0NUgZ0xgce71bNVce7nE4HTIa75F0R
	 NhMk1hBzKXbsFYYnhg5dfGbbZenJWkfrVhJKTkHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Sen Wang <sen@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0230/1257] ASoC: ti: davinci-mcasp: Fix runtime PM imbalance in __davinci_mcasp_set_clkdiv()
Date: Sat,  7 Nov 2026 08:42:06 -0500
Message-ID: <20261107134945.879501485@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit ba593d662183de74d2b733b4c6e8cd26f04f0a65 ]

In __davinci_mcasp_set_clkdiv(), pm_runtime_get_sync() is called at the
entry of the function. If an invalid div_id is provided, the function
hits the default switch case and directly returns -EINVAL without calling
pm_runtime_put(), resulting in a runtime PM reference leak.

Add pm_runtime_put() in the default case before returning -EINVAL.

Fixes: 4ed8c9b737b6 ("ASoC: McASP: add support for clock dividers")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Tested-by: Sen Wang <sen@ti.com>
Link: https://patch.msgid.link/20260916073136.1971673-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/davinci-mcasp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/ti/davinci-mcasp.c b/sound/soc/ti/davinci-mcasp.c
index 79239131b6598..d3c9797c03dd8 100644
--- a/sound/soc/ti/davinci-mcasp.c
+++ b/sound/soc/ti/davinci-mcasp.c
@@ -799,6 +799,7 @@ static int __davinci_mcasp_set_clkdiv(struct davinci_mcasp *mcasp, int div_id,
 		break;
 
 	default:
+		pm_runtime_put(mcasp->dev);
 		return -EINVAL;
 	}
 
-- 
2.53.0



