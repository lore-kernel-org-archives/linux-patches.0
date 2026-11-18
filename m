Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045071;
	b=02F/n+T9/T91RITWWA8Y1tKy74Adzv7UacQDC9dqZlLQx1BVTzLquKpZM06SxewFMor/
	 AlIe57nfzHBHV8TQwCqd67gzcP3i+et8Crp2nozeYOiXT+6xtLvgcrthMAEp3R3Vhe7yj
	 8r/sb2h2GLcW+7ZaLqRlB7oFBjfoo81xa/IcoSpLv+N4BgXhstTlnQOfWiTfTE1jMI4iq
	 a+Sb6RAVa0C1OZSlrT1w1LC4I9V5hWbzsjTy4nD1qAIsdwYXcN6lJWkxotW5ktNBgFmbX
	 NfEBB0VhNOMEewMy/SfRPYNksOluaEB0fX7l0lbWQoWzcB1wV/1zXYvXiIYSpiD4Ymw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XvWcZD/Zt7eQdfxis1vUNoP/GZOo+jX3XNt5pHoupoo=;
	b=c8ZMzegi2cVMeAmrJU1wsNYd3/wWyAG6eMO5baXqD/j7EpnmUQV0552/C16evLGkyy3N
	 JVspiyhAxpahn25uNLs6SNNl1frEuGlp0kVlLWksaZ8/7GUsTLrBF9P08ouT97UZPRx3s
	 jq6lfUklKjXH2gpu2IkE9zwDEZxmHkYe6baMjuPRo6eCJN7d7D7s+LNn1OCvgapvvapHo
	 2y1IGzXf9qTab1iK7uC8jQ9l/y9OM9QO4rmc8cXQ1zLs7KjxOvpw6Qxdrd8/s0GUrJuBo
	 6NiqSXaLuKalviPJK50lT6WeLqmamlH8QQpgPePpD0i2W8TrNm5cH/dGVhg3Ia1/G/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q6QNTPFn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3797606A325;
	Wed, 18 Nov 2026 23:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q6QNTPFn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052191F000C4;
	Wed, 18 Nov 2026 23:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045071;
	bh=XvWcZD/Zt7eQdfxis1vUNoP/GZOo+jX3XNt5pHoupoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q6QNTPFnSlxs31gzzWrQlnVOf2zzrG/j6sm2NZz39IjLyXCvi7VJ4QkD/W66Vsy+V
	 0Y0sq8oRETJf6aGZyKVZYTBewcyb8X/KxbRHmiHOq2+cAg5Ucs3L/+cQbPGPdA+oEj
	 nQAOo3eTVOUU4pVGQWrFvmNNxxoscRM4iaejkXkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Sen Wang <sen@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0794/2857] ASoC: ti: davinci-mcasp: Fix runtime PM imbalance in __davinci_mcasp_set_clkdiv()
Date: Wed, 18 Nov 2026 15:30:28 +0100
Message-ID: <20261118150230.155449877@linuxfoundation.org>
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
index c6ef8f92b25f1..eec91c47d451c 100644
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



