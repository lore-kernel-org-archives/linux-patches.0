Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213175;
	b=CJVd5qvp536YPVzczULScogqRTpvPHE6QOVRBnQqXpbcrpoyUMGF0yrcQS8PZN6rzbw3
	 eH7RGgyfgLSEKidHhHOjFFuqJEBRGUVyRUguErp0XftsOBdzx1mYecaQmqMvmexC14j76
	 btHRQdl8jg7XBkGM6q5p+jBD7MPkjzMCfxPjRgXC1CY0Rs3JJ9Av+VqH5hAs6lTZkcSmC
	 Y2hGcmxsvTqcsa9l1yCKubyxkMmFz+tQ+2N6GSjS49FaBgNtS5l6mws/eq6GvLkNJA38x
	 htnPsHFfcxdbRsgIACkrw/19SkOqAk7ZZZIc9WiNKvbZVpZjY0B8NKM5qPFzg30Np7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zo/hbV4xYQssJJbefD1u3Om67ah7J9K2UuRpzUIaUwo=;
	b=iwbX6g2MBHBV4w9GuswEKgRTyxbQWV3ppQB5QbKdWhOZuPORLAgfmzmJNaVjV4sblBtB
	 b/xKYzCBih+Jhh32rVmXfXJ+0MX9Kj+nVXFHFAmZKVQSHOhfNSrv70TjhAJPvJI81nTvF
	 biOVVggjFx6Qj9OO5czBA6tUotRdXVhJvGrmrdFQWbKQNQJpM4yXvxLUl85CxDwXXXygc
	 F7QZos++t/pSkbyQ2Zqws+cQwosYOeEV+Pi8pB8PGgD3ThOTsz5cQSTdLv3Qu3EX40Uc0
	 geKcLmyGSdQ8OMALQRLuP33xvGG1I0D2BNqo/g3xztNf0gmovIi3R5ZyTJLYQTLgZ0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iTMHSAot;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BDD606A31C;
	Wed, 28 Oct 2026 18:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iTMHSAot
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447AA1F01825;
	Wed, 28 Oct 2026 18:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213174;
	bh=zo/hbV4xYQssJJbefD1u3Om67ah7J9K2UuRpzUIaUwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iTMHSAotQXe6CriZrC4cMnXpP8JTkgI4Izrn9HDJWcKsc15Q2zJ5mO2aIJBCC0jJ7
	 vjJDtINdlAA54UKdgeWVknj5Soz83K+V6AzjPdUcdxX/fkWUa4KzAFIf12A+NtBeFt
	 iTb0taOz+Yi+qGt+Kp0aJLXqhbyiTc2GpPO8qhto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0413/1887] iio: adc: aspeed: propagate reset deassert errors
Date: Wed, 28 Oct 2026 17:41:49 +0100
Message-ID: <20261028170508.634259388@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 95e4eb426b4bd666fa2f37886c0ddf74a0cc6167 ]

aspeed_adc_probe() continues to register ADC resources after deasserting
the shared reset, even if the reset controller reports a failure.

A failed deassertion leaves the hardware unavailable, so stop probing
before installing the cleanup action and enabling the ADC.

Fixes: edf7550a1f93 ("iio: adc: aspeed: Deassert reset in probe")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/aspeed_adc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/aspeed_adc.c b/drivers/iio/adc/aspeed_adc.c
index e6a9d8d77af53..4cb2210cb38d7 100644
--- a/drivers/iio/adc/aspeed_adc.c
+++ b/drivers/iio/adc/aspeed_adc.c
@@ -553,7 +553,9 @@ static int aspeed_adc_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, PTR_ERR(data->rst),
 				     "invalid or missing reset controller device tree entry");
 
-	reset_control_deassert(data->rst);
+	ret = reset_control_deassert(data->rst);
+	if (ret)
+		return ret;
 
 	ret = devm_add_action_or_reset(data->dev, aspeed_adc_reset_assert,
 				       data->rst);
-- 
2.53.0



