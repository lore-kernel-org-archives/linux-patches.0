Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044094;
	b=zYvUnlDRqZ3PEll4KpNVE9ruwaKKlUI4HNZ3P3k4j9ZAQ48ktq915Ym24+d8UQuWD7h7
	 bc5sQMvz11flyuge36jFBFAnO8NzhhBDNenXh40FQpoONgmzf+naCFEz1QM8P7RbE9qZm
	 RLfPNLGXtKVVAKz89Lr52PRZftDZG9vj4220BWL6hTt6SVSvsgGcs9QpbmKeipCz32wM4
	 SmJGHvECXcI+WOIsZjHf5bUj5rgqj0rtBiexkk6dkW9npDwuByJquz425+wnLdMqMYWDA
	 +b3ts/s1gUigfdTOQD49X11AiUOpp8n13lyeYhZfetpA3jEjfP7pcGD6+bwrROUvipw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tIXd9oAHkhcNh+a91DOJ21j+B8xCLp+A6yMWP+lYF9o=;
	b=avfNf82r9TsiyOQBIRBJEGZvBb+uQwacmCP/PyTlqykIQBCtcv1H6ZG74peeloelbiqn
	 W3ozsPuDJQJsjd6voNdN9cUU0ARZZdn2EMqjON/PUFdC+OWFeP5GKRv6R01wkGPXISN1l
	 mHczEd1ajaKGkUPqDhrNQ2QMI8RPJ4dMTN/BmNr5s0e9/jlO2jVbgbjH+LwMJ0L1lqeXk
	 cf9VLD7HZ6coIZNOLHI5/hgDlSGXatwmaPSplpwho54JIrm2shH0H8U+Tr/JgYaFzAyMY
	 hgjGqZUs+/CHEZaUDF8O4Ey0stFNaS4vyhjm68St2rPTCZJNfFegPg86FsWnFwiS7WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KPgSdRj8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E3A606A325;
	Wed, 18 Nov 2026 23:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KPgSdRj8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFC51F000C4;
	Wed, 18 Nov 2026 23:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044094;
	bh=tIXd9oAHkhcNh+a91DOJ21j+B8xCLp+A6yMWP+lYF9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KPgSdRj8wX6GtFnZSFLbcvUj4fqkt8HLQ0VXP1yXdOuCVyyLBx46WDmJClfO9Vw6a
	 LdG1Lw91DLluJYY6vHp0QUrIFaf0wqXJ6CpfYiIIrix6iIfHYeBMILiJRwRMvAcmu8
	 Ei2RvwPgan3FWW+zdvkqyzdVTw3rSxlUL6ySyzvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Richard Acayan <mailingradian@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0444/2857] i2c: qcom-cci: Stop complaining about DT set clock rate
Date: Wed, 18 Nov 2026 15:24:38 +0100
Message-ID: <20261118150217.363776737@linuxfoundation.org>
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

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 8284750a182937bf805f703311501730f02eb40e ]

It is common practice in the downstream and upstream CCI dt to set CCI
clock rates to 19.2 MHz. It appears to be fairly common for initial code to
set the CCI clock rate to 37.5 MHz.

Applying the widely used CCI clock rates from downstream ought not to cause
warning messages in the upstream kernel where our general policy is to
usually copy downstream hardware clock rates across the range of Qualcomm
drivers.

Drop the warning it is pervasive across CAMSS users but doesn't add any
information or warrant any changes to the DT to align the DT clock rate to
the bootloader clock rate.

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Link: https://lore.kernel.org/linux-arm-msm/20240824115900.40702-1-bryan.odonoghue@linaro.org
Signed-off-by: Richard Acayan <mailingradian@gmail.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Stable-dep-of: 7362a1553eb0 ("i2c: qcom-cci: fix device_node refcount leak in cci_probe()/cci_remove()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qcom-cci.c b/drivers/i2c/busses/i2c-qcom-cci.c
index 6c7e4eb95efcc..db2283bfb3321 100644
--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -603,14 +603,6 @@ static int cci_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (cci_clk_rate != cci->data->cci_clk_rate) {
-		/* cci clock set by the bootloader or via assigned clock rate
-		 * in DT.
-		 */
-		dev_warn(dev, "Found %lu cci clk rate while %lu was expected\n",
-			 cci_clk_rate, cci->data->cci_clk_rate);
-	}
-
 	ret = cci_enable_clocks(cci);
 	if (ret < 0)
 		return ret;
-- 
2.53.0



