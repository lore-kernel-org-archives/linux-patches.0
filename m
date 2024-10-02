Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB511D0B8C;
	Wed,  2 Oct 2024 14:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878455; cv=none; b=NulfvBewyYGH/gny1Z/pBLN17rWCcNtaiu71HEeXxIJdH+hOPgGJ0QOLlgjJgtSkFZhmGX9cJf74sgv2bv5G5BEcZZ//P9sCaucHmyJANq1fagvOkr7CnUfFnhBaYORM6pUaXqGGxPbUPjgWK31UHzZO0mt2yrSzwKDbEIOb4m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878455; c=relaxed/simple;
	bh=oZTYDCsutgOItnwIW7tsiJYfmg4FJrhljbqSHsjJ314=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jI8B3rbzMAI7Z3PZCL6jSiCTxaGpvGnJOdv/bUd58Xb1hw68sz7xrriQFOkVwtLM4Yg6URL/UW26gDvM1vWAjOOPQyYErQtWH94zACgWYUvCYp3ve/hnbbPCe5+Gksr1b7jFK9w4f3222FJ6uPRWQ9UyCLyhtpK7oQ7gwu5DCNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/pZeUXZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/pZeUXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1492CC4CEC2;
	Wed,  2 Oct 2024 14:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878455;
	bh=oZTYDCsutgOItnwIW7tsiJYfmg4FJrhljbqSHsjJ314=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/pZeUXZ2+DiDWXdtkm3D5x33Hik8ojkwAVlFoSqrlstrYqtEdjQEmdP+pOH+wFI+
	 enAABoa8ml9/pX1B8NA4UOanIafQFIMaoxTyG5cbt9n7y/7wVgUBjCcQ6cGlx3zNSQ
	 dPejpkwSqtvqGwIltxIYT3ixLuiPMtaAHdUG3Nyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 420/634] iio: magnetometer: ak8975: drop incorrect AK09116 compatible
Date: Wed,  2 Oct 2024 14:58:40 +0200
Message-ID: <20241002125827.681258804@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index dd466c5fa6214..ccbebe5b66cde 100644
--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -1081,7 +1081,6 @@ static const struct of_device_id ak8975_of_match[] = {
 	{ .compatible = "asahi-kasei,ak09912", .data = &ak_def_array[AK09912] },
 	{ .compatible = "ak09912", .data = &ak_def_array[AK09912] },
 	{ .compatible = "asahi-kasei,ak09916", .data = &ak_def_array[AK09916] },
-	{ .compatible = "ak09916", .data = &ak_def_array[AK09916] },
 	{}
 };
 MODULE_DEVICE_TABLE(of, ak8975_of_match);
-- 
2.43.0



