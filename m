Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064086;
	b=Ms35Z+SpDpzxV4BFHbmM/poGjtKScSIsLSmWqWbs8Z0JKlUahOIuUYzJ0YX4tqH/EPzJ
	 7+4Sg89bRjvgi0FOsGN4QnU/p8qQ70kP5ZinX9rThKVddfMWNqMG2DfzMdS4STv+7CcEr
	 MpqQ7kGvza3gKefWQLCBGSciz9/tnrX1Cx3nXtNNcEeUbVmcrjPj7rTLDWRVAb3vTZNRb
	 wbkz6AXVJDVG2vMo+b5ovspzP6Lg1wneLzsssXpi5R1A8jypSSjcyUYFkHy6vbZEBqmRl
	 8pt+Ax1OZmSFCYNz2XCGZGh4b2n4+fp9Xq4HKeMvCQyeIjFKucOhq1DzmlRDJ3e8wGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064086;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bShoOGb3P1sUlS2tWmGZHvRS9gu07P6nBilRHI8saB8=;
	b=hMhyJpBRlSKo01YToz52IMY/RvqMbMNJDhBn5m7pxBxzjqBkggLuWhCcSEEARsoko0ER
	 FSWT7MW17ghzYcTuYI1O4ub00IAWdLEmt9tZDPVvOntf+UaLMCYkrWkKboEvsZabrnVJF
	 4g4IF5SAsx7uElIKjrMRxGX6fdqWzSktjGgJFk0hBNSd1BhbNr19INL6MxN1WCPxIm3QL
	 WfNrNzeIPBxemvIZ3Ds90LWbKhhQZ04fGfRvynDEsD2LHg/Rofbrgi+FarhTy44KkvMUg
	 T9FAaDZrTn4JBd1cJq1qKPRJ3WBPMtVJg4i16psaC5XjqHa0BZInzLsUI9ggKH3IFvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p7WN1Hxc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1C2606C026;
	Sat,  7 Nov 2026 15:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p7WN1Hxc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9EB1F0089F;
	Sat,  7 Nov 2026 15:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064086;
	bh=bShoOGb3P1sUlS2tWmGZHvRS9gu07P6nBilRHI8saB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p7WN1HxckvdzUnAHbTS49mZn5DPf/WwkqysP9S6J0lOzrD/NTDbEzP/4Srzv8D2U+
	 7L3Raq+hgzttr88Rz3BOHoIf+XLGreaytV4nZn2639YTW9mCeHPBDk0CIkCIb8Rurd
	 Lf754f2hC3RK4R0DsiSjr/AH1N6tjL2yKLsX/+m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Ariana Lazar <ariana.lazar@microchip.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0213/1257] iio: dac: mcp47feb02: Increase EEPROM Programming Write Cycle Time
Date: Sat,  7 Nov 2026 08:41:49 -0500
Message-ID: <20261107134945.425704452@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ariana Lazar <ariana.lazar@microchip.com>

[ Upstream commit 77f5e4bd63db9be9978a6d2ac821a249a3d5fd82 ]

Increase the EEPROM write polling timeout to prevent -ETIMEDOUT errors and
incomplete nonvolatile write cycle, according to the time specified in the
datasheets (11-16 ms).

Fixes: bf394cc80369 ("iio: dac: adding support for Microchip MCP47FEB02")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260819125300.6B9211F000E9@smtp.kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Ariana Lazar <ariana.lazar@microchip.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/mcp47feb02.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/dac/mcp47feb02.c b/drivers/iio/dac/mcp47feb02.c
index fdc266ba1536f..7758e37080958 100644
--- a/drivers/iio/dac/mcp47feb02.c
+++ b/drivers/iio/dac/mcp47feb02.c
@@ -447,7 +447,7 @@ static int mcp47feb02_write_to_eeprom(struct mcp47feb02_data *data, unsigned int
 	ret = regmap_read_poll_timeout(data->regmap, MCP47FEB02_GAIN_CTRL_STATUS_REG_ADDR,
 				       eewa_val,
 				       !(eewa_val & MCP47FEB02_GAIN_BIT_STATUS_EEWA_MASK),
-				       USEC_PER_MSEC, USEC_PER_MSEC * 5);
+				       1 * USEC_PER_MSEC, 150 * USEC_PER_MSEC);
 	if (ret)
 		return ret;
 
@@ -507,7 +507,7 @@ static ssize_t store_eeprom_store(struct device *dev, struct device_attribute *a
 
 	ret = regmap_read_poll_timeout(data->regmap, MCP47FEB02_GAIN_CTRL_STATUS_REG_ADDR, eewa_val,
 				       !(eewa_val & MCP47FEB02_GAIN_BIT_STATUS_EEWA_MASK),
-				       USEC_PER_MSEC, USEC_PER_MSEC * 5);
+				       1 * USEC_PER_MSEC, 150 * USEC_PER_MSEC);
 	if (ret)
 		return ret;
 
-- 
2.53.0



