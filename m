Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062708;
	b=0rAFp6N2aDuEqAS3L5v7QN2rjPp25CfZOMH9MWbXKkNsEyF2XsXycJ8CmqFcbfCAhQyZ
	 zn60sHtCQ1jGT7pHA11bPtY1Tu2SLBmmp3RWLdeQN17lKieXhNDx467bssQ2sX69ezKF4
	 0zSO9Z7CbgObpVKyozkciP5uqHk3ckyNKMUS9OGmHxjROHeCCv2DKgo9RTOj5VM6JkbpZ
	 YHN1iIm3y3oBFOOUYlGZZjJX27jOX+dl1GkMl4TPB8CX0DB17FxENRZNccIDWEsc+F1FZ
	 2IrNuLYlK2naHYwewwS/9C68fL4IesirlW+n5fF6ovWK9h6R2npTJNb280GEQEF3z9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nggnBON95X9X7HwPYkxrlJm7+A3GcFwHIOaOpvp9lOQ=;
	b=QlVRWYhDwzrck6B4oIAljBomm7d5bzH6YfKeFLCGsb9XKjY9SblyVHtguCweTei7fi+2
	 /YX/z3/88nIushmPXoWq1S/BQ+NAdud93FoJDM7O9Tz9LCVqReA2JvDJ8DZY9n6EvLRvu
	 tZ/dR8QFgT7Jncqc/A8Rfv6YIdGcuQz07+WRD211WEjLJ0CEqPPljvJoUgotLZZDAQq47
	 09IzysvwbmE4RPhWyB3rNPegDgcFbA7AqSfWA1VbcEYG4NB1zOf9L3uWzEs2He3+iUcD+
	 ZA5oX33EFJUClwI1rz4Q8L2ictFAYavC0oD2Nsw8fwAAAp4ZNnPH92CUUCyNhpskzlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tTzyR3U8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC471606A32C;
	Sat,  7 Nov 2026 14:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tTzyR3U8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172B01F0089F;
	Sat,  7 Nov 2026 14:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062707;
	bh=nggnBON95X9X7HwPYkxrlJm7+A3GcFwHIOaOpvp9lOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tTzyR3U8/GM+dxhovNbteGGsS3i6jBGhNUPgw88HpMO8TO7gejzoyp8VHTfkqmq6+
	 nuT6+p5/cqZXc6cWeKR5Mv1W8QOHp8qlB9lCsuXpFlYl9kTYOlDE1DiY2ueoaxFxoM
	 Kp50Y8FtTJemvLlityTQtBUsUvpP7FaDk/K+y7P8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Schwierzeck <daniel.schwierzeck@gmail.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 030/869] cpufreq: airoha: fix probe failure with correct error check
Date: Sat,  7 Nov 2026 08:45:12 -0500
Message-ID: <20261107134853.175111415@linuxfoundation.org>
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

From: Daniel Schwierzeck <daniel.schwierzeck@gmail.com>

[ Upstream commit 801ade22c4fc078ea9b11e1f3fe3aae8b8bef886 ]

dev_pm_domain_attach_list() returns the number of attached PM domains
on success (a positive count), or a negative error code on failure.
The driver checks "if (ret)" which treats a successful attachment of
one or more PM domains as an error, causing the probe to fail with
return code 1.

Fix by checking "if (ret < 0)" like all other users of this API.

Cc: stable@vger.kernel.org
Fixes: 84cf9e541ccc ("cpufreq: airoha: Add EN7581 CPUFreq SMCCC driver")
Signed-off-by: Daniel Schwierzeck <daniel.schwierzeck@gmail.com>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/airoha-cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/airoha-cpufreq.c b/drivers/cpufreq/airoha-cpufreq.c
index b6b1cdc4d11d6..ec9b2fc00f5e0 100644
--- a/drivers/cpufreq/airoha-cpufreq.c
+++ b/drivers/cpufreq/airoha-cpufreq.c
@@ -64,7 +64,7 @@ static int airoha_cpufreq_probe(struct platform_device *pdev)
 	/* Attach PM for OPP */
 	ret = dev_pm_domain_attach_list(cpu_dev, &attach_data,
 					&priv->pd_list);
-	if (ret)
+	if (ret < 0)
 		goto clear_opp_config;
 
 	cpufreq_dt = platform_device_register_simple("cpufreq-dt", -1, NULL, 0);
-- 
2.53.0



