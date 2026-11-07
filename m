Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061428;
	b=5IGDsu2D/aIr19XaGyrOAGzctRew5Dp9LbAm2bsedoR50hNB+XUXXfDPmOaXeL7gd7OB
	 80Pfgt1pF4113k20dteaJY6b/4a3elObDKkXqynaBLZ5w01NaJGH/G6I4cxZfaDQgIZsL
	 wD4d/wMsrYT1nNHl4+DgOv7tmeKARiexvNnJ2OiS1bC/o65faJvs4K4za5KPdzSm7uRb+
	 fk+lWKxCBuuKCspJ36OX0DbqNlITxfM70uHvde5rTGuvblVGIQ0+n9DRtXzwLOTk4OVS6
	 Jrt0ComJpeuB0+uqL+n0xM5Q8gNo5vnRaKj3OKhoU8lSIDcEv4SBTatO1zR/QX5PQ/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Uq2XfX6ma6incn4UGAWJBh3mGji/twPGNJMiytAgLGQ=;
	b=bng21G5LdfOzbENgzZsBJssXX1Qn3s4PuKJup/uWXZucOqlWXfD7aQWdZlJmqNjbIlf/
	 64fhcqQ66U8CA2B1+61JnKczSqqyig0uhC2LRknYHJY/wcFE3WAngxYeIizNkrqABO3AK
	 QV05Mf8otR6dLIxL4wc4mBAK/2kKlA8iOdf1Qnuf9AOn+cBTzDMACC4z9Is5kjf67Qh/L
	 Lftgaw54nHciZn99LkwmLhYCFmDDGftH212wIliDxVH18FBemF1fUWeai2R8xSl42AcXw
	 kYpWHEfCuivUbdWuYn2vjLYua+hvw1tI2AwdGyzNbx3bbFAEf/TwjzjMsXGBcuQDftQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5mM6ihn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36BA606A326;
	Sat,  7 Nov 2026 14:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5mM6ihn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BE41F0089F;
	Sat,  7 Nov 2026 14:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061427;
	bh=Uq2XfX6ma6incn4UGAWJBh3mGji/twPGNJMiytAgLGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5mM6ihnQbZvB2qHXCxv5UBwWwPem8u+9O4XX9Gm0vOWoc2QaYMilIpEgFycz3MF+
	 M5GkVlSZ5BKRHT/ll6CkyTdTrtjIPmgTEvmRsmhoaTT3DBTu33VawsV4Kp8hVeW0yl
	 zQuSKB5ubtU3QQDeYHGHddMIAPMoQGRurA0fI9yA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janani Sunil <janani.sunil@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0499/1536] iio: adc: adi-axi-adc: Initialize state mutex
Date: Sat,  7 Nov 2026 08:41:55 -0500
Message-ID: <20261107135011.470116125@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janani Sunil <janani.sunil@analog.com>

[ Upstream commit 549b71ce050637dd32678371ad76c445a2f8c9aa ]

The AXI ADC register access paths serialize transactions with st->lock,
but probe does not initialize it. Initialize the mutex before registering
the backend.

Fixes: 7ecb8ee5c93b ("iio: adc: adi-axi-adc: support digital interface calibration")
Signed-off-by: Janani Sunil <janani.sunil@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
[ sashal: Changed devm_mutex_init(dev, ...) to devm_mutex_init(&pdev->dev, ...) because this probe function has no local dev variable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/adi-axi-adc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/iio/adc/adi-axi-adc.c b/drivers/iio/adc/adi-axi-adc.c
index 5c8c87eb36d19..4fd4a8d759250 100644
--- a/drivers/iio/adc/adi-axi-adc.c
+++ b/drivers/iio/adc/adi-axi-adc.c
@@ -359,6 +359,10 @@ static int adi_axi_adc_probe(struct platform_device *pdev)
 	if (!st)
 		return -ENOMEM;
 
+	ret = devm_mutex_init(&pdev->dev, &st->lock);
+	if (ret)
+		return ret;
+
 	base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
-- 
2.53.0



