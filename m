Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040006;
	b=fEjX9Sg7O+q6/seb8gZ0MqmIZ79+pg3bmd/tk1HOXcDqg2YAmSBja3xpt1ZMaPLLQZbl
	 47vCY13D4fPTirn5H6Uh7ofXNTeOsBGQBfx9T2lgGolNb2yM9i/WqVwUnq9M4DkCDMYUD
	 mH5LqY2UOb2TEpnhZ6YoqgvKBnl8b7NkD9iCxMR+YZATqMx8WBwk7BdCB9WKKm2iJXFqe
	 qo4pVovoUK0mZscOxlXg3qw0hY7I6/93Cc0gifPhycu+AB2pqTPRXCmLfCq1WNPvB+lw3
	 GWglku0YnAQjGBEFP5ImGzENKHxYuQisBDXufSREiRazvkwRrvQ5eOb0DNaISDpAwJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RcNIsV/R+QeaU+sXhxDORq345+JKp6aOpbdhG/sKHNQ=;
	b=0eZtVUNXeVVbbHqd00Vnv9YIoqwjU/EfpWErNfjnsL71iclOgsynCNdZT74EfQhKYKLY
	 wK1lbe3LM7TVbZfasCkc5yClLSkE1k9fm9babZVYMyb9y7sJQOG27MNsfh1iQPPJQFM43
	 rX/gfK813KXM/RkNiH52J1lCOlJ87QTt6FZvCotomdAeQVJMPgHe6XJp3sWRzY5VU4GVc
	 WNsRYMWZcc3jkAYWysWV816EJlCYCKc3/iB/eFt4E0unF7NjJE2p72Urfu3JtpIr+FHFS
	 +TyAdTNMvhoYVFoHOQfUs8h30pcGgwvGLjyzkjd+eJU6sskf1CkDHHAqL7hp0MB6X+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iCSvUbzG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49B6606A31C;
	Wed, 18 Nov 2026 22:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iCSvUbzG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F72B1F000C4;
	Wed, 18 Nov 2026 22:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040006;
	bh=RcNIsV/R+QeaU+sXhxDORq345+JKp6aOpbdhG/sKHNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iCSvUbzGSBLkY4hldxcTk4WFA+PUmc3vIU3/nowM29ZChu90PiZAZT40+nZjt/W2S
	 yabWRBfOx0seb+Qj6mq50U/AnSRQ7M9t8q9spRUIyULqzBL2alLTITkITqyagjbDs0
	 3c2mcov5JvDQ9nbvb/RTGaUqlTE7fGtIQaqjdoWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2302/3318] hwrng: starfive - propagate clock and reset errors
Date: Wed, 18 Nov 2026 15:48:44 +0100
Message-ID: <20261118150430.771177047@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit ace145efdd80cd2eb95e84b1087d0f1fc55bdc0d ]

The StarFive TRNG probe and resume paths ignore failures from their clock
and reset operations. That lets the driver register or resume while its
hardware access prerequisites were not established.

Check each transition, unwind only the previously enabled clock on failure,
and propagate the error to the probe or PM core.

Fixes: c388f458bc34 ("hwrng: starfive - Add TRNG driver for StarFive SoC")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/jh7110-trng.c | 39 +++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/char/hw_random/jh7110-trng.c b/drivers/char/hw_random/jh7110-trng.c
index eb4a28392c370..8228c3607723e 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -321,9 +321,17 @@ static int starfive_trng_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, PTR_ERR(trng->rst),
 				     "Error getting hardware reset line\n");
 
-	clk_prepare_enable(trng->hclk);
-	clk_prepare_enable(trng->ahb);
-	reset_control_deassert(trng->rst);
+	ret = clk_prepare_enable(trng->hclk);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(trng->ahb);
+	if (ret)
+		goto disable_hclk;
+
+	ret = reset_control_deassert(trng->rst);
+	if (ret)
+		goto disable_ahb;
 
 	trng->rng.name = dev_driver_string(&pdev->dev);
 	trng->rng.init = starfive_trng_init;
@@ -343,13 +351,18 @@ static int starfive_trng_probe(struct platform_device *pdev)
 		pm_runtime_disable(&pdev->dev);
 
 		reset_control_assert(trng->rst);
-		clk_disable_unprepare(trng->ahb);
-		clk_disable_unprepare(trng->hclk);
-
-		return dev_err_probe(&pdev->dev, ret, "Failed to register hwrng\n");
+		ret = dev_err_probe(&pdev->dev, ret, "Failed to register hwrng\n");
+		goto disable_ahb;
 	}
 
 	return 0;
+
+disable_ahb:
+	clk_disable_unprepare(trng->ahb);
+disable_hclk:
+	clk_disable_unprepare(trng->hclk);
+
+	return ret;
 }
 
 static int __maybe_unused starfive_trng_suspend(struct device *dev)
@@ -365,11 +378,17 @@ static int __maybe_unused starfive_trng_suspend(struct device *dev)
 static int __maybe_unused starfive_trng_resume(struct device *dev)
 {
 	struct starfive_trng *trng = dev_get_drvdata(dev);
+	int ret;
 
-	clk_prepare_enable(trng->hclk);
-	clk_prepare_enable(trng->ahb);
+	ret = clk_prepare_enable(trng->hclk);
+	if (ret)
+		return ret;
 
-	return 0;
+	ret = clk_prepare_enable(trng->ahb);
+	if (ret)
+		clk_disable_unprepare(trng->hclk);
+
+	return ret;
 }
 
 static DEFINE_SIMPLE_DEV_PM_OPS(starfive_trng_pm_ops, starfive_trng_suspend,
-- 
2.53.0



