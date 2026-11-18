Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052303;
	b=jZH/hv2LIbE0aghfgtBkWvZaYT6xv28gkrqohhNnZihnVUO9X5uWl0Ky+wANTE/r0JWp
	 sl5NHt3E4cbm5X+cSILGRIBcNbUBngyh9mEUjhf9/ANEXgBXT5wNFl7CNGQE9mIymsOfm
	 +1Kj0PmTAGpKN8FY/yvCZKjRzK8E87hW7GqXCd2+WnjLVO7z8du3IGuaKPBAFH3vObnwP
	 P2M9NgweEJxIDOlGOsybnbh46P6ihz4FatZSnyaKwJAzmAFq5xv3e6Pmftbk0emSeQDWl
	 AYbCP/SgtHwmKES2FmdUn77RDApeFKjf/QAotbLBJ0l7LbY3K3Am/bTYWVTk0urlOQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jHCC1ZH99Hi/Dp2oIEScQKIVdcxP5HgFZ5CSKxfWxQk=;
	b=RQbRywdeHTxku+8QoKY7t2pTMHZMf6U13pyAL3nBEQXCcS08EPBp/qYo+dVLtztkjt8D
	 HiGb1itn9a6zk10A3oSAqwl1W0yzkAVrLsZh6KgtZIBXKWbfoj/4kbDD3Dy15jHPJRiGY
	 UjEbwKpDNyS8zyhlIfvRk6nV3Q25m4lAoZSHl4Jxphgo0E/gEoU8lyZjcuASskJ7hmiJw
	 rbdcZcIv+2pKqIGS4RgVgk1e84hkySP1h+DTgF4oqNcUydmvM+/WN5ZvsCByc2m1QiS4e
	 Hd+1r3HoB1M3O36g9DknWIzhlcFPsP/MZ7srwBBrNowHHcaOjxwOECUkzAK11SNEkgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mDVSm+Ox;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D98606A32F;
	Thu, 19 Nov 2026 01:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mDVSm+Ox
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73FE41F000C4;
	Thu, 19 Nov 2026 01:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052303;
	bh=jHCC1ZH99Hi/Dp2oIEScQKIVdcxP5HgFZ5CSKxfWxQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mDVSm+OxftgO72tpJSvzt253t9PutYhdPm+GW7f80Yos3zesYyFMvuw1IoVZUW23E
	 x94HrqMGGKZYt4guvXk5qXKyidVAHjN4dL+8MfrjXbz+Gdj7Ys+AwtEpizL+8PVpnn
	 dsb1HbBrUH2CUEWak0eEwqOzXbXdNFqLE65gzo3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Sen Wang <sen@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0513/2214] ASoC: ti: davinci-mcasp: Fix runtime PM imbalance in __davinci_mcasp_set_clkdiv()
Date: Wed, 18 Nov 2026 15:36:29 +0100
Message-ID: <20261118150031.631813076@linuxfoundation.org>
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
index dbd30604816e5..9b358be5c8771 100644
--- a/sound/soc/ti/davinci-mcasp.c
+++ b/sound/soc/ti/davinci-mcasp.c
@@ -649,6 +649,7 @@ static int __davinci_mcasp_set_clkdiv(struct davinci_mcasp *mcasp, int div_id,
 		break;
 
 	default:
+		pm_runtime_put(mcasp->dev);
 		return -EINVAL;
 	}
 
-- 
2.53.0



