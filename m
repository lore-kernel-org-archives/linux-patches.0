Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017630;
	b=WAOFPDA8pzFFLKXECyAZCjGTBBXo8mRJt4xEkSxKJB+/P6YdUEwUYnxvdNCCxkTwXYB+
	 WutkR/K/0Zv6cvom0nGEv+aMpZEIGCnVEt6RLRo0Fq7Q5A06/FwEl0sSd4csHyiiYwG6/
	 HMSpoCatq58SDiIjAbBatg+CMxP6O/e7i7qGgtKlnwyqx0rgxva2NK6XQVVOi0pIBmF5s
	 zw06HAZ+LLJI+trcCCB27B4ToB4/kEiEuNS5i53dFyT6V6gLnKWQBoMkiE8lgI0pLwLUr
	 awaRribR3Tvey++kYOjPdgK3QTdc0HN3YwvbuUUH8yBz8iLGB1Syu6d+EvafHwl7daA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dA3FqcttcnuSGS6hme/9EYZviDZ0TB+equfnWmSqGJ0=;
	b=ccIqnjGjz0ApBX9XRAFTSwMDOg4v7c8Ex6NDgjFQnfGSYYCl0rgN1S/ZhRmN/M9rXGtp
	 bYz0b12tAzBkZFyM/ZD1tJZi2ukSGcrJaT9G7/KjUBL8ltgb8PAklVltFb690s5b28Nz0
	 H6WKuBEDA43/c2hOFrYe1ZM5QK2P3wjXe/1z/D+lyIJVus7MINEJyaE8DC7P6tJ9PM4/e
	 1GCXsicJ4oDsvg+0F0k1UgaXhwnWkAt3/JW3zyL01Cn2efAG57XmnhNnByG8mBE1S0M8l
	 vl4qj0VQKeVzWW+tnh4DUWL/7RviVW2thK881n9goUBMuTKqjN4iskQEpBuA7yX1WmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xX4zoojt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B6A606A337;
	Wed, 18 Nov 2026 16:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xX4zoojt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262571F000D3;
	Wed, 18 Nov 2026 16:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017630;
	bh=dA3FqcttcnuSGS6hme/9EYZviDZ0TB+equfnWmSqGJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xX4zoojtLpYv7viamjc0bAKpAsXzmiJxHmvwCONoIx7sCVOgstxzJGLyqqtD7g0gv
	 XQnmwa4+/C6oiS5kCbHLO2nkPqSv7Y5AVfDvo3Lf3Qxlb5dqcj3IFqyUGIKoY3/uUH
	 5drryj3XAoCfOl4EQEy0Z21I6fT29xBC7tDk5eDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ariana Lazar <ariana.lazar@microchip.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0951/2651] iio: dac: mcp47feb02: protect EEPROM store sequence with mutex
Date: Wed, 18 Nov 2026 15:36:31 +0100
Message-ID: <20261118150322.142019557@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

[ Upstream commit 55b0514c2863d01e9b168d8a6ad0040d628fb534 ]

Move the mutex lock into store_eeprom_store() to prevent race conditions
when reading volatile registers and writing them to the EEPROM.

Fixes: bf394cc80369 ("iio: dac: adding support for Microchip MCP47FEB02")
Closes: https://lore.kernel.org/all/20260819125128.970911F000E9@smtp.kernel.org/
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Ariana Lazar <ariana.lazar@microchip.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/mcp47feb02.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/dac/mcp47feb02.c b/drivers/iio/dac/mcp47feb02.c
index baeb1be455c6f..5353013ff98c5 100644
--- a/drivers/iio/dac/mcp47feb02.c
+++ b/drivers/iio/dac/mcp47feb02.c
@@ -442,8 +442,6 @@ static int mcp47feb02_write_to_eeprom(struct mcp47feb02_data *data, unsigned int
 	 * Wait until the currently occurring EEPROM Write Cycle is completed.
 	 * Only serial commands to the volatile memory are allowed.
 	 */
-	guard(mutex)(&data->lock);
-
 	ret = regmap_read_poll_timeout(data->regmap, MCP47FEB02_GAIN_CTRL_STATUS_REG_ADDR,
 				       eewa_val,
 				       !(eewa_val & MCP47FEB02_GAIN_BIT_STATUS_EEWA_MASK),
@@ -469,6 +467,8 @@ static ssize_t store_eeprom_store(struct device *dev, struct device_attribute *a
 	if (!state)
 		return len;
 
+	guard(mutex)(&data->lock);
+
 	/*
 	 * Verify DAC Wiper and DAC Configuration are unlocked. If both are disabled,
 	 * writing to EEPROM is available.
-- 
2.53.0



