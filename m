Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA791AAE27;
	Mon, 14 Oct 2024 15:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918203; cv=none; b=PEINQyuNdtu903SCUcbOuT+VBoSFInyIpbsiTjsoHNhGuh7D92UOYeYg4ykwO8kMtDebDw8j8wjOqkSYtqiMp5Yj+0RkMrZGryVYK7Y8oWxht6PrDvo3MZ2Em2n+5SMa4mIXRvi4xCYm87g8ZObGGqP+V1DmZnvgCrWC0/aRmFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918203; c=relaxed/simple;
	bh=QYNUlvrOHhPh1uy2w3g8FUD/DesaJ8jjJnsi7AFkrX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXsUMTswIQSdrpgjO0DsF06JqHmH2LB79xt70fatCVhJr4WPfyrBFdvjDJ5V5SdPgb3l7A1B844UNR4WHO6RVkeAT2YIkSjBRxE7pz4PFNCrueeieMdbx4qfiJKOe5fQbBdIY943pXW7JxfxKKjh1fdkRcEarZpvHxLHs0cBBjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kp/CzrHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kp/CzrHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2F3C4CEC3;
	Mon, 14 Oct 2024 15:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918202;
	bh=QYNUlvrOHhPh1uy2w3g8FUD/DesaJ8jjJnsi7AFkrX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kp/CzrHo82KndL3RCdNi2JJ+2cKdjPp6glqzwtADqPsszm4ogY8f49KY4tyIgNZgc
	 uzREOM4oXlBCyQltnoZApJUT8AVpZntmbEMvPMvSGue0rkp56neS86kKTsMyurtmr9
	 ER8tak1EuY+FWCYxrzYtjrzDllItdYPKC6xAuVQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 252/798] iio: magnetometer: ak8975: drop incorrect AK09116 compatible
Date: Mon, 14 Oct 2024 16:13:26 +0200
Message-ID: <20241014141227.835885459@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8762e0f085b80..d2b606bf13ead 100644
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



