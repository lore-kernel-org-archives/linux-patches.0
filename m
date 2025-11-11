Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2F42D8DC3;
	Tue, 11 Nov 2025 01:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823532; cv=none; b=Yuc/dwynmA4cXAOSeS9mhWRIh1DEnzq7V8kkmhE9PgDHJShzTKXqLnlILRpEXYnb7xzv7tNK0I4y28LDsjkPWAZ2wbGejT6/MT7HMvU+Y8CRsSiprQi6pr2nDytItnLjIIOzXQBW3enQm+AH7aY7c8I937m6Ub18hyrtvx+P15I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823532; c=relaxed/simple;
	bh=DW/pUdrLncu5NiOTQzRIP/pCRinMkTh1kj2zR9iORDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciD90vE45IiWmGchFUdnbfO+m+3y9vOFIuuJy2BqX7d/c2o8iQFUnUks6qYS86R0Mbw3dy1RJtMpDb41XLSL1IsH4SK5VegL7nd6njXqYaASEsCwfBo/0GcWyLw9NfLrs9oz/OSnmzHik2zlJnniqrf6ClE2B7NPZiUvjiq6vX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gL/2ogx1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gL/2ogx1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D918BC19424;
	Tue, 11 Nov 2025 01:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823532;
	bh=DW/pUdrLncu5NiOTQzRIP/pCRinMkTh1kj2zR9iORDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gL/2ogx1BGDsV3gBACLGs5ULPywZ2qO2AbX27pFeZLkoVWuZSqoDwzmpplDYYozpm
	 NuJ3/r3Ylq/s01cWcw1z8RXihv83WfEm7nemJ4/HxEV6WVbfAuYdwT0hEJFpJsEjFw
	 IWI4IBbI2Y/rbLvmvweORWICFHl1SUpcyBauLwUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xichao Zhao <zhao.xichao@vivo.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 318/849] hwrng: timeriomem - Use us_to_ktime() where appropriate
Date: Tue, 11 Nov 2025 09:38:08 +0900
Message-ID: <20251111004544.102559890@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xichao Zhao <zhao.xichao@vivo.com>

[ Upstream commit 817fcdbd4ca29834014a5dadbe8e11efeb12800c ]

It is better to replace ns_to_ktime() with us_to_ktime(),
which can make the code clearer.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/timeriomem-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index b95f6d0f17ede..e61f063932090 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -150,7 +150,7 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 		priv->rng_ops.quality = pdata->quality;
 	}
 
-	priv->period = ns_to_ktime(period * NSEC_PER_USEC);
+	priv->period = us_to_ktime(period);
 	init_completion(&priv->completion);
 	hrtimer_setup(&priv->timer, timeriomem_rng_trigger, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 
-- 
2.51.0



