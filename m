Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209503;
	b=wPQXbXkoIV3umqYEqc50xhhzmfYR4uZFQewqgYOVh/XxbNbrHQOtxyy6sD6zeWVveLRH
	 XUETb93UBBAQReC/ED+UW7Yja2GlU1MB3Fa4AWdyFXqwr8yxYoviPKsAWJrgu98CL0hLR
	 LFOQTKWjkAlUHXQM3lgSY4IfOXP1LknIFm3bWNs3BqQpDM223NrxaWQpDDi6HcNoAqf6b
	 vYdJYLNfBKkQAYTaXLBH7sq3w7JJDQaaClqE8KGsaK6kFm+q2pCTh0ZApM+/WcTOi1vPL
	 AsNLxUVxwkHgmFAZc69MEGcw1F0Tuf13K2y/bHIe39Oznmqbn7/YkzWKJchix2hmu3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iP+T4nfvpyB1vLsOvZmcv4R3VHezCJGrGqhIHWY+OhE=;
	b=UM/imaA5oEhFXSoTURKPqz77ZROmeTInE7fzTYj1NDU8Xz6BuewxqqOfU09SLCC89p9x
	 SVDbXsCJYK5zIgOxeV31SGoVhYoOFlnhPQMRjzK8Mp/rQu8wwIKuE28zHkEWYLo9NQLvc
	 de8c/T+n//GUqCx5BDHe7c1d/QHX8SSIOhsAbTaBbg/C0fBO2XJxjOaBYaKzTrZFfryRX
	 p0kZQLucZsKjIT3qXtpnN24M7ENXiJX2Au2iunQTTrPW4BYBDJdPeLolmQzxtFdKr8bft
	 smt/DmhGz4WPZS8uDntCVmtYpuW2KZDzqhV0OHFgX50ml4xMW9f4r/76Obhr3vOVfWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LnAtOXB8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E834606A31E;
	Wed, 28 Oct 2026 17:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LnAtOXB8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5291F01825;
	Wed, 28 Oct 2026 17:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209503;
	bh=iP+T4nfvpyB1vLsOvZmcv4R3VHezCJGrGqhIHWY+OhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LnAtOXB8gZwdAzaslXa4i5Q1N4XPlW0Cp5GB2iyG2oReFYoNCbAqHp3vA+fZauEka
	 8Ix9vRbLf6rl6/XBV32cd7iiiZLTVfWk+ZGbFejYS/7AYRWVnqKdSt6BR1AZVJuA74
	 l3UfsSmVqf0IZOMZiCPsoGgh0MeF3+Wy+JHvp5/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 494/516] i2c: viai2c-wmt: Fix clock leak in wmt_i2c_probe()
Date: Wed, 28 Oct 2026 18:00:46 +0100
Message-ID: <20261028170015.182552534@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

[ Upstream commit aaabefc79b0ff0018e8e3832169bbe359d0551fc ]

In wmt_i2c_probe(), i2c->clk is acquired using of_clk_get(). If any
subsequent operation fails or when the module is unloaded, the clock
reference count is never decremented via clk_put(), leading to a
resource leak.

Switch to devm_clk_get() so that the clock is automatically managed
and released.

Fixes: 560746eb79d3 ("i2c: vt8500: Add support for I2C bus on Wondermedia SoCs")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260916070631.1965713-1-vulab@iscas.ac.cn
[ sashal: adapted i2c->clk references to i2c_dev->clk ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-wmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-wmt.c b/drivers/i2c/busses/i2c-wmt.c
index 88f5aafdce5b4..33d085e564f57 100644
--- a/drivers/i2c/busses/i2c-wmt.c
+++ b/drivers/i2c/busses/i2c-wmt.c
@@ -391,7 +391,7 @@ static int wmt_i2c_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	i2c_dev->clk = of_clk_get(np, 0);
+	i2c_dev->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(i2c_dev->clk)) {
 		dev_err(&pdev->dev, "unable to request clock\n");
 		return PTR_ERR(i2c_dev->clk);
-- 
2.53.0



