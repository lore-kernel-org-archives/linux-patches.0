Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062967;
	b=0bV/ERC3XHWLD43SiJXagwANLCQn7/lbnL7KJSYIUkO+jtTWXDc3EFNQ1+5IoTvngV7c
	 euXWqf8Gtm0QPYgKZtu05KuOKaoWJpkrMj4wAUZOkwRKuAx+mPorKEdHNLhFrOnlwhz/m
	 TS11yFXCdirzQ2L58U9plK+KQ9VK1XankQiA6ielQeV2MZF9Swj2sbhOFd18DkDSvIETx
	 tiMCNn6wn3m/OWZ2yvp5ALGiOQLbuEEJtvHfGp1HJetzh2HausPIMIhsmRZy0U6WryIW4
	 F8sbW3ChNVYY40/WR6dkyp+W0kIRvDMB6Rh6CG/c2dua5w0v3s7Ad/S0QI7fzPE3/3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jmsfuq9tod6Ay3+c7NXRsUaJY6gD1SvpdAjny+xdCEk=;
	b=wo+ZpmZRqJnj9RB1FxJvk1BgdOJTPkKIkIw3Tvi69QSddqlVMM/OssltXFVq/GlroNYk
	 PB7E05QbyVu99NNmec6Uqn0CAx8uFoOXoOY0/VfBTxXWohG0kDt8HTIVfc3yJrw2vKRAN
	 +zvbGpe+gtYuA9yCC4tSUvJ3/BwYkFRXoTktu0/4Yw2ENjfWki8TcgFxEDaVG9n7ka+59
	 pnfpCug3G3rn/9bVjHyoZIvqlFP+MWvW9Bh2pZl0DhU0Gvqli4HJ/lr2GpbKaKNXGr/+2
	 u9c45cSMrbN/1PIZZP/q2MuAPe3cnjvy3DAJ/jnzv/6L9DBcSPfL/Skne/bOC8vY0BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kz2Khw06;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D94E606A32C;
	Sat,  7 Nov 2026 14:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kz2Khw06
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0FD1F0089F;
	Sat,  7 Nov 2026 14:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062967;
	bh=Jmsfuq9tod6Ay3+c7NXRsUaJY6gD1SvpdAjny+xdCEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kz2Khw06cRWCcVCnt9y1Ri9T4Hje7AgTjZlqtmVynMYkxU2mmQolWlb2k7TalWl39
	 joEeEQ++OxElbsEyBAvfjG6kq/3HWL6IytFQxT4Gzd2zBuIZ9lYx3hAfnwiSzKfHhg
	 dKuJ1mQJuBIVOQGU7dFDCdB3HJ1ayttTLvvDvAx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Sen Wang <sen@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 184/869] ASoC: ti: davinci-mcasp: Fix runtime PM imbalance in __davinci_mcasp_set_clkdiv()
Date: Sat,  7 Nov 2026 08:47:46 -0500
Message-ID: <20261107134858.363201145@linuxfoundation.org>
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
index 621a9d5f9377a..23a68ac3a3e3f 100644
--- a/sound/soc/ti/davinci-mcasp.c
+++ b/sound/soc/ti/davinci-mcasp.c
@@ -647,6 +647,7 @@ static int __davinci_mcasp_set_clkdiv(struct davinci_mcasp *mcasp, int div_id,
 		break;
 
 	default:
+		pm_runtime_put(mcasp->dev);
 		return -EINVAL;
 	}
 
-- 
2.53.0



