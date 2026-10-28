Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211326;
	b=BVVvxnRoVfW8q4741JcXjPpHW6ss1ONxsUIKAZIOdpUjz+DPU/RIJxQvw0/rToovSCVs
	 BhDkSJLiMWotRWL8/abRhKdn+opkcvjHd0/3CHeGbnQnIsxEKfAYsdVDY3tR7PChgWbQT
	 7LhHymEPBMCIJiqq4wv7z8ekp37C1YIqknoHoqRYS3PrVcwHPPhLNxAYriiUMG5wg40Mg
	 /Sv7xFifa54fqrELzMoC07eSNgFa3mK4OIAhO8jiX8WPPkAguNnHIDQHBxh7SQEh4+SDY
	 i4OYsBpa5m1XwcmE1x1vdulxDTzL4AUQ5WPNVPF2zIkKrrSWzGYfbrCguhR6lPYMezg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bt7IckuvYmhZq7jOYCLhj+vFwkIpBNeizH/t/b07A2Y=;
	b=RlpYDFWgr6/rAofsgyUlR6SCWGBCq/QoD7mrNi/wptAcmDyKiGEwPBoCIzxRjKUIbI+k
	 6LtNn2YsdogtQzOkxu3aGHqbw3OyNfaGDXF9KGVd2WfRhVoPvLUQqlU0y4ZQT0E2UDRQ9
	 2x0lVuHwUraGFKkx7pr1b7zsR1n1P3PKBRqEkoucGYj9gToik/uS1Nn5jZoNGyPwOTgYt
	 RqU0dy3spF33h28ye2Q0Uypp6bRf7/gmnDrglTbuCBmhVBDGCxyftnBmNmiVOmPFkzEXo
	 nyp9HeZDyFbS8V0jN0lp8sk2V2WG+xknkSlEzRm3ilYsvKZWdi7neWzEibAj/YSXNvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="eMTWymF/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF0F606A32E;
	Wed, 28 Oct 2026 18:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eMTWymF/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D711F01825;
	Wed, 28 Oct 2026 18:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211325;
	bh=bt7IckuvYmhZq7jOYCLhj+vFwkIpBNeizH/t/b07A2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eMTWymF/ykB8luc1b4RAvh7/NMG/TTA0iTDvXiHhbDkhNPEbazH9znnFEOu6ilCfn
	 HwzqH2EUkj7rHkVUyUDtPZT7vwnHw7a5TslQmj9nQtToATjLlgtFtHp4Ja689R1uN7
	 weaCHDbKW4Tk6yGUYDhqXX0FUqpzZFy4Bna1Apk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 338/571] iio: adc: aspeed: propagate reset deassert errors
Date: Wed, 28 Oct 2026 17:58:05 +0100
Message-ID: <20261028170016.037032537@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
[ sashal: Replaced `return ret` with `goto reset_error` to accommodate manual clock cleanup. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/aspeed_adc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/aspeed_adc.c b/drivers/iio/adc/aspeed_adc.c
index 34ec0c28b2dff..012cc9291bef3 100644
--- a/drivers/iio/adc/aspeed_adc.c
+++ b/drivers/iio/adc/aspeed_adc.c
@@ -221,7 +221,9 @@ static int aspeed_adc_probe(struct platform_device *pdev)
 		ret = PTR_ERR(data->rst);
 		goto reset_error;
 	}
-	reset_control_deassert(data->rst);
+	ret = reset_control_deassert(data->rst);
+	if (ret)
+		goto reset_error;
 
 	model_data = of_device_get_match_data(&pdev->dev);
 
-- 
2.53.0



