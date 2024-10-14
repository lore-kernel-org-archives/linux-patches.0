Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2F81A28C;
	Mon, 14 Oct 2024 14:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916352; cv=none; b=RgKuaMRemHpk+lNa3KfZ/bV5FPZw8sYgJtyNQnAjva8HUlR8kziiJUBjy8xqXASDLTiKdQBkbjAIrNHJIMiv5WuM1xg1DCThOOyMQa/WzONhIlgM4b6Td7IbfkBwSpHVG+tcngVDi2qDKz1ArBCB4Kree/sID8j5V2XwjRZAyEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916352; c=relaxed/simple;
	bh=NdgM1zimwg59TfkSAfG+dj46CXOKbJdGmhVBPVZ6sUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z980Bo3Sq97BKhBRf2LMHHsGlOv2xZC0PmMF121+QOMerXI3WNJHDV0iaHHynvgY7QdaDRk0m+b3+qVYGiqHUjdTtjtnFKiI2kHrOjA7vwZnAKR7Jplgc2DDbZERJCtoykwifjnLiNplL/kn+6MNZMh/Pqa1iQbGUeOAi4Ntvkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JjL4hcQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JjL4hcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BF1C4CECF;
	Mon, 14 Oct 2024 14:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916351;
	bh=NdgM1zimwg59TfkSAfG+dj46CXOKbJdGmhVBPVZ6sUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1JjL4hcQXGpLX85k+2uXcLq4Fzz2Q0yRuNWm/4QGCAOL9/UTfFGE5fxiNBIXgimG/
	 zKyx20QRr7ukjnmMKcoI8PJ4CcRBaFJl2rcYyfE9LeCBJbNAkd3eZdENTImNQTv67X
	 6OVT8KTlinwhLcqduKLIudyznW0P0+2mUhJeyKtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 157/214] hwmon: (adt7470) Add missing dependency on REGMAP_I2C
Date: Mon, 14 Oct 2024 16:20:20 +0200
Message-ID: <20241014141051.113844538@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit b6abcc19566509ab4812bd5ae5df46515d0c1d70 ]

This driver requires REGMAP_I2C to be selected in order to get access to
regmap_config and devm_regmap_init_i2c. Add the missing dependency.

Fixes: ef67959c4253 ("hwmon: (adt7470) Convert to use regmap")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Message-ID: <20241002-hwmon-select-regmap-v1-2-548d03268934@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 75d7797a5b943..cfb22c2b9e61c 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -224,6 +224,7 @@ config SENSORS_ADT7462
 config SENSORS_ADT7470
 	tristate "Analog Devices ADT7470"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for the Analog Devices
 	  ADT7470 temperature monitoring chips.
-- 
2.43.0



