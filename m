Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058241;
	b=fF6J/VBPBIhbh5inTcLPER5dx6rkQUpq6/OYjzVMxSfXcvW23nWpJP/2uzlAXYevBtkH
	 abaaBJdlUPT2Cw76HiWMO7/aKoT7eG7+d/zk+nuIep9UPrHZDJaXvZB7ucFJzzGCXOsbR
	 h4DYeivncbqBYhWz96DR/FrRbahAxqF3pdpSelQ+8n2Lm52jH+uJqlLAFZDdjeiYe6lxx
	 BDYUW/u0FIOcThk0Ra+Be2urlSjMgRIN5leVm3C+hwdoaMoOXEpqpIhkH1UPa4ltMLfeh
	 h2BcoVXQx9WTFDVMXgnHAMklc5e+fz5KSADzJE17XRFOykOOw1cIwdzg3/5v2mCUNgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5oZUG0Acn8uI9wR1z1foZUb8LyXLquSosTz9glXLxrA=;
	b=l5yxlmIFezcVf3rjys0MEOMkisJV3dTs/fEO1bbr0jalSwIcxLHcYILfkIUrQhzwBexY
	 VNPMBkAbRV3upbA+QjNQNdAP/Dj2FrzDQeIQ0LAuyBcit8Fuz1PkZcH+rFUvN8Y4IYGYD
	 ei0IyGgmFwzZTV6juyYoA/tzS5YI6wh6qS/q2pEBF/Biix4WlG70W4KKPokB6M8fQx6sN
	 OAfMespSKJpFvOsErrEAO/I2ROHkVTjHFkFqQmxWDxAjlzIW0aTV896KpU2NNx7iboWOc
	 S/7ViWiqXe1sYKkP/uCKDMeQ9kHf5uMb9i/MVDW470kBLzszcZ/1anp0xxpcgEJ1fTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q8dKFPEH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2181606A31C;
	Thu, 19 Nov 2026 03:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q8dKFPEH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE26C1F000C4;
	Thu, 19 Nov 2026 03:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058241;
	bh=5oZUG0Acn8uI9wR1z1foZUb8LyXLquSosTz9glXLxrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q8dKFPEHp9WJuAqqNrR89+lkArsZB6IljFKBUGjNKu3IZvv62wDHknzLTpcQSrPsq
	 i5SydNqSXXhFOFZZR7zNotT/fgagi9XArlR2Yzp15YCdDa/Nbk4w3Ueyh+yI/+spRE
	 zuR/Tq3uVPqmqzLigeFi0b1tp7XM9cmcD+dqRyGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Sen Wang <sen@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0416/1848] ASoC: ti: davinci-mcasp: Fix runtime PM imbalance in __davinci_mcasp_set_clkdiv()
Date: Wed, 18 Nov 2026 15:40:54 +0100
Message-ID: <20261118145931.381957204@linuxfoundation.org>
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
index 61ea444f2018d..c4256086253eb 100644
--- a/sound/soc/ti/davinci-mcasp.c
+++ b/sound/soc/ti/davinci-mcasp.c
@@ -644,6 +644,7 @@ static int __davinci_mcasp_set_clkdiv(struct davinci_mcasp *mcasp, int div_id,
 		break;
 
 	default:
+		pm_runtime_put(mcasp->dev);
 		return -EINVAL;
 	}
 
-- 
2.53.0



