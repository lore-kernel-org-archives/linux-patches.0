Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEE1176ADB;
	Wed,  3 Jul 2024 11:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005939; cv=none; b=HuYZqiZbmPjgKlAXZvomO/XmKMVvNDDdo54SiDvKZ9QKNpjM1VilFy4S3qFg1FMco6+DjVXvP+5hRrpvunpA2f0bi6ONOC6DKn33bnKpYajhzDQjvuUBXuAGqzhIFlvV9sHxDCnE0kURCsuo6tDx/kOdb+U3lTPVGvgBZDa77Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005939; c=relaxed/simple;
	bh=jciSOBkx1zwYf0fQQEcTUuA9jhNKxUPw0ah+x6PkP3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bh9GGgB2x/jEsNFQl1fe7M9kuKmXfBdi97m3Qtz4tzGFN4R3vgfGZ7Rpc2TCJwkemoSiYJi0cQlYy2cTSSInbILZmGa+EHnAxduZq1MRz4wbTUr3C44fnpNjXPaL7NZ0KxwjmkEeZV7am7S8efwpDky02eitwZEa/4UdLc71nr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epzgsX05; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epzgsX05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0A6C2BD10;
	Wed,  3 Jul 2024 11:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005939;
	bh=jciSOBkx1zwYf0fQQEcTUuA9jhNKxUPw0ah+x6PkP3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=epzgsX059tk57nFxawfx4QqyysaTuR+63KSv7q+B5raqxeyBL+jNvlSQUzDTrmKkX
	 cbJHy1E+FdUOE9cJDQnmG1KG3FbUItepRpLHwl+zAVOkWQ5RMTCb8EBsIZJgC0VI3m
	 fWmlxBP0EG0gJydd/fyxIi4uxljYqMc+OjZ4/JN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalle Niemi <kaleposti@gmail.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 215/356] regulator: bd71815: fix ramp values
Date: Wed,  3 Jul 2024 12:39:11 +0200
Message-ID: <20240703102921.246475488@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

From: Kalle Niemi <kaleposti@gmail.com>

[ Upstream commit 4cac29b846f38d5f0654cdfff5c5bfc37305081c ]

Ramp values are inverted. This caused wrong values written to register
when ramp values were defined in device tree.

Invert values in table to fix this.

Signed-off-by: Kalle Niemi <kaleposti@gmail.com>
Fixes: 1aad39001e85 ("regulator: Support ROHM BD71815 regulators")
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://lore.kernel.org/r/ZmmJXtuVJU6RgQAH@latitude5580
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/bd71815-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/bd71815-regulator.c b/drivers/regulator/bd71815-regulator.c
index 16edd9062ca91..5d468303f1029 100644
--- a/drivers/regulator/bd71815-regulator.c
+++ b/drivers/regulator/bd71815-regulator.c
@@ -257,7 +257,7 @@ static int buck12_set_hw_dvs_levels(struct device_node *np,
  * 10: 2.50mV/usec	10mV 4uS
  * 11: 1.25mV/usec	10mV 8uS
  */
-static const unsigned int bd7181x_ramp_table[] = { 1250, 2500, 5000, 10000 };
+static const unsigned int bd7181x_ramp_table[] = { 10000, 5000, 2500, 1250 };
 
 static int bd7181x_led_set_current_limit(struct regulator_dev *rdev,
 					int min_uA, int max_uA)
-- 
2.43.0



