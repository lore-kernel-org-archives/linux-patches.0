Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D386FB0;
	Wed,  2 Oct 2024 14:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880149; cv=none; b=bWmptGsoaKEKa+MU6hp2ynL3ofdz2hmlBK2JTV+7hfb1pvmWBAR3EQPEinFOkTmJrzuCWPjo5OqRDIUW8oYhxnZM0acP+mL43LMDhw6qR/c+hpWrKJlAsGA1GmQQ78ZQCXi1ISzXCSRlJXsIJWGE2QPi0GfICLURnWxBQg6PxGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880149; c=relaxed/simple;
	bh=KrABpt9MLBelVRHFZeKqINhqQs33BYyeoTMahidCeXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nR25z8Q9/y9DOdGKYneItudX3GrR75wZakXloRBSXJbYF0Pr8ihemJBShAs7OabE93ZquX/yH2TCPGqFjxIFninBV13bn2EdtcJJpk+5mIAI43bpa9al6J0ijHnZjDUYXnxHvcMDOl+jSu8nlqZt/Q7qVTUmdaAJ4QXcohdBd8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UstD8qKV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UstD8qKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8E0C4CEC2;
	Wed,  2 Oct 2024 14:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880149;
	bh=KrABpt9MLBelVRHFZeKqINhqQs33BYyeoTMahidCeXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UstD8qKViV0iLGqYkwKBgUGOQ76d9XhTGeaZ5SV3hv8Px5rJnAgjicmFp2s91DR/4
	 pS1WWfLygelWCEH++lTmO1Iv68zd5d1fLtey1IAXfsn6y3R3TMpgJ4S/dKKPG3uRmI
	 Ej84b+7KT6sxLup0LUdHlpYU9le2oK2/tnv+mMbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 359/538] iio: magnetometer: ak8975: drop incorrect AK09116 compatible
Date: Wed,  2 Oct 2024 14:59:58 +0200
Message-ID: <20241002125806.597494198@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit da6e3160df230692bbd48a6d52318035f19595e2 ]

All compatibles in this binding without prefixes were deprecated, so
adding a new deprecated one after some time is not allowed, because it
defies the core logic of deprecating things.

Drop the AK09916 vendorless compatible.

Fixes: 76e28aa97fa0 ("iio: magnetometer: ak8975: add AK09116 support")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20240806053016.6401-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/magnetometer/ak8975.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iio/magnetometer/ak8975.c b/drivers/iio/magnetometer/ak8975.c
index 104798549de11..a79a1d5b46394 100644
--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -1083,7 +1083,6 @@ static const struct of_device_id ak8975_of_match[] = {
 	{ .compatible = "asahi-kasei,ak09912", .data = &ak_def_array[AK09912] },
 	{ .compatible = "ak09912", .data = &ak_def_array[AK09912] },
 	{ .compatible = "asahi-kasei,ak09916", .data = &ak_def_array[AK09916] },
-	{ .compatible = "ak09916", .data = &ak_def_array[AK09916] },
 	{}
 };
 MODULE_DEVICE_TABLE(of, ak8975_of_match);
-- 
2.43.0



