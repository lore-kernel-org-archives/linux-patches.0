Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064085;
	b=dslrbmkQeN7CqFZK93N7aWAoU4PEmQWZUmjLavbV2ZUPnkdnyfEZeZWSpAzTy/8pvB7O
	 byLsgU62eYudLN9yppHYH5Qzrk7caP5YCUGI+310fC1NZsOdpDZFra2zgbulLhOf9B/Jk
	 /qHe4KahOab5QaPW64G/O2MvLhQg8q07LoNiktAcLrjPPKMeYWCtfD4607XdrafB4HkSF
	 ZHe5VKk/IW7TZAe+omhAC6tRfQ/i57v9nFIJpcFhDbN8j9dEZhMm4BeiqSCNtvkFWSiXh
	 aYbt0fSp6bIsf0gVcBqb/0wxVhTJ96Pz5IbNDvPvTzxNKbWFmvZhNX1/eHo5nrzLnUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6nt57PrBVkwV19QuHeBlIwNNHeScg+LC/SMXY/5sasE=;
	b=hkRYgtehCE/B+Sg16HjoKZm9mvqEi5bFcaqDWk5+Jtj9M5SDWA58q+AVR8aOuCbOqrz/
	 f4xFhpPR3txDyetGpiQP3lj+0Y4WnSlUEIy+iqPmZ8Tmf7TM071deJ0dJfvCMmElX0BtI
	 PiZSiEW4cWboZf3QxuqBEEX8WXESP2i+7vA8eceT6HK+82nZqAmW8Z5oj3JTWQScZSuG1
	 NqAJ6TwhKv0JgOrPPfuU04eMsujU03zCCSiJ3F9Yjj//9mb37EPl6HXUtS1fGdPPPPaDs
	 wC0UDGsk7CuPxk5XtAp0H6HFHDiK/fxlszYEp3fV3N9wVarhj8Sd8YHlesHj7gv4pxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rnukiYDP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A714606CE4F;
	Sat,  7 Nov 2026 15:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rnukiYDP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCA71F0089F;
	Sat,  7 Nov 2026 15:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064085;
	bh=6nt57PrBVkwV19QuHeBlIwNNHeScg+LC/SMXY/5sasE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rnukiYDPVTZaMBlYmJHPEfoMtXCaxlqsV5Qg52WiTntpE0fU2Llj2k0QBfdYGPZg0
	 ULcUsrv8RL82PDJJQwAPM2MAZ6YlAbzH/LjYHkoOxIOh+/lOy02P/7sJn/vCXeMmwY
	 wh7f7NFseknGc58MypBG0gHLxn7kE52El22qeJLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Ariana Lazar <ariana.lazar@microchip.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0212/1257] iio: dac: mcp47feb02: Return len when disabling EEPROM store
Date: Sat,  7 Nov 2026 08:41:48 -0500
Message-ID: <20261107134945.398400637@linuxfoundation.org>
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

[ Upstream commit 6d96f5a03ebdcc664f5d2fe0a170ca0ea513e3a5 ]

When state is false, return the number of bytes (len) the buffer has
instead of 0 to properly signal that the input buffer was fully consumed,
preventing unnecessary write retries.

Fixes: bf394cc80369 ("iio: dac: adding support for Microchip MCP47FEB02")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260804134616.1D8A21F00A3E@smtp.kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Ariana Lazar <ariana.lazar@microchip.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/mcp47feb02.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/dac/mcp47feb02.c b/drivers/iio/dac/mcp47feb02.c
index 1b1a4972f7719..fdc266ba1536f 100644
--- a/drivers/iio/dac/mcp47feb02.c
+++ b/drivers/iio/dac/mcp47feb02.c
@@ -467,7 +467,7 @@ static ssize_t store_eeprom_store(struct device *dev, struct device_attribute *a
 		return ret;
 
 	if (!state)
-		return 0;
+		return len;
 
 	/*
 	 * Verify DAC Wiper and DAC Configuration are unlocked. If both are disabled,
-- 
2.53.0



