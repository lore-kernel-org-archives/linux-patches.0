Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9791714A1;
	Thu, 15 Aug 2024 13:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730044; cv=none; b=Zg3SAY2lTdo8/qO+I+7yMrZ3UusktRmRr8fo1p0TZ44voTC4pHfbz7R9JxuVMUz9o1WriBX1bf9BZSeoyPX9r91KVOj/F0k65Ib+7oQIOFEbOD1CwXRGJKBnQn+EnoN8O2LPs8gs2Y0S2MB333GB9oD0JIQoOScNHnDu1qdEiuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730044; c=relaxed/simple;
	bh=eIStSxETZq31TdmUl2jveBJ5Mg762GIF2L29yFx9IBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbyr9tHYFy8EGjS13fX4TTnCQqB7VQwdBrSbviLK1VG28s7XSN1zF8mETVcB3GhYKS6ljdETPEN9RQk2btG9+DB/dntJhB38qWX5DP/3s+0fnJVb0UP7gQFMzpn69Cdlye1xp74bYRc7tHmwHACAetvAWFHvhQVx+SKvy8kMnVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xwmV4/sX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xwmV4/sX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11189C32786;
	Thu, 15 Aug 2024 13:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730044;
	bh=eIStSxETZq31TdmUl2jveBJ5Mg762GIF2L29yFx9IBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xwmV4/sXMXFz0ROt9mYOomWSstE8iA5MZbp22Flel5qlaPADWziDnjFsnwUq5UlLc
	 mP4nEsxG7FjAiHawkRV1q/3mxBCvNTZrCkS2ICVJ3LPk63QfUs4xZYxu/5+9uywXFy
	 fBnztRWNMIwNyXvUOhqKXWrvGNNumNC+UxTBEGfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 286/484] spi: spidev: order compatibles alphabetically
Date: Thu, 15 Aug 2024 15:22:24 +0200
Message-ID: <20240815131952.455174880@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit be5852457b7e85ad13b1bded9c97bed5ee1715a3 ]

Bring some order to reduce possibilities of conflicts.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230120075651.153763-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: fc28d1c1fe3b ("spi: spidev: add correct compatible for Rohm BH2228FV")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index c083d511f63dd..14bebc079ddbd 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -709,14 +709,14 @@ static int spidev_of_check(struct device *dev)
 }
 
 static const struct of_device_id spidev_dt_ids[] = {
-	{ .compatible = "rohm,dh2228fv", .data = &spidev_of_check },
+	{ .compatible = "cisco,spi-petra", .data = &spidev_of_check },
+	{ .compatible = "dh,dhcom-board", .data = &spidev_of_check },
 	{ .compatible = "lineartechnology,ltc2488", .data = &spidev_of_check },
-	{ .compatible = "semtech,sx1301", .data = &spidev_of_check },
 	{ .compatible = "lwn,bk4", .data = &spidev_of_check },
-	{ .compatible = "dh,dhcom-board", .data = &spidev_of_check },
 	{ .compatible = "menlo,m53cpld", .data = &spidev_of_check },
-	{ .compatible = "cisco,spi-petra", .data = &spidev_of_check },
 	{ .compatible = "micron,spi-authenta", .data = &spidev_of_check },
+	{ .compatible = "rohm,dh2228fv", .data = &spidev_of_check },
+	{ .compatible = "semtech,sx1301", .data = &spidev_of_check },
 	{ .compatible = "silabs,em3581", .data = &spidev_of_check },
 	{},
 };
-- 
2.43.0



