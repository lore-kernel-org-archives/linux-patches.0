Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815C777636;
	Tue, 23 Jan 2024 02:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975513; cv=none; b=irGd1nrlEYLua+0BxwC4ICdgE5Rwu87KwDO0xWdw8WgkN0qZ8l31yujQgd5wPIa8iNxwQa2/FXdQ1Fc6TwDrFk9sDlK84br5VZH5Qff4Vu4VhhGFABRR48vu9Ibc78JQRaT8k8rBe+qeFscpaAFR50t00t6NXK4+az8aqoCaq+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975513; c=relaxed/simple;
	bh=vPjkLJH02sU7LKfzl6ijweCFnrZ0bT1DiTr8ADTUII4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9gpPYA2EWbDtGUxMVN7AvcsoVksuFfyoLYdGsh5DvqqBshUYobTUyCW+qWaQvx6W3kytkfOySFrF5I7r4ChCEuUafz8CBuCv+vYIbT5p3GhRReTIIEWUYrTYyW5fWoPLC8g1ZAMqW4MTIuC/JjIXbSt6mGLZP2zieQVuN+pORw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXob0S3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXob0S3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2B9C433C7;
	Tue, 23 Jan 2024 02:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975513;
	bh=vPjkLJH02sU7LKfzl6ijweCFnrZ0bT1DiTr8ADTUII4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YXob0S3JMqe4U51t5WFA2e0ET8CizQD9EHskYislrR/bdzCZgX5lFHpF+OSIF1SYr
	 LC4Pr/1bbY7zfpHJD0XbGoOyOPep4HfuX0s/241BmQ9Inrq/oStDBBFaC2r9NBKubT
	 lQ/MWH15Ect/95yR9lH31+WSSYjmJyrsMX9iQ+wI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dang Huynh <danct12@riseup.net>,
	Nikita Travkin <nikita@trvn.ru>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 441/583] leds: aw2013: Select missing dependency REGMAP_I2C
Date: Mon, 22 Jan 2024 15:58:12 -0800
Message-ID: <20240122235825.475498616@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Dang Huynh <danct12@riseup.net>

[ Upstream commit 75469bb0537ad2ab0fc1fb6e534a79cfc03f3b3f ]

The AW2013 driver uses devm_regmap_init_i2c, so REGMAP_I2C needs to
be selected.

Otherwise build process may fail with:
  ld: drivers/leds/leds-aw2013.o: in function `aw2013_probe':
    leds-aw2013.c:345: undefined reference to `__devm_regmap_init_i2c'

Signed-off-by: Dang Huynh <danct12@riseup.net>
Acked-by: Nikita Travkin <nikita@trvn.ru>
Fixes: 59ea3c9faf32 ("leds: add aw2013 driver")
Link: https://lore.kernel.org/r/20231103114203.1108922-1-danct12@riseup.net
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index b92208eccdea..3132439f99e0 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -110,6 +110,7 @@ config LEDS_AW200XX
 config LEDS_AW2013
 	tristate "LED support for Awinic AW2013"
 	depends on LEDS_CLASS && I2C && OF
+	select REGMAP_I2C
 	help
 	  This option enables support for the AW2013 3-channel
 	  LED driver.
-- 
2.43.0



