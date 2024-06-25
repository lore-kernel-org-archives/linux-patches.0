Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F92613C90B;
	Tue, 25 Jun 2024 10:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309647; cv=none; b=j3lzrC9o7ynEB2Kz+X3g1g475FR2UJjuLru3psFPWHA0YHLEry7dK7ewiEQaAfU69TmXVuiRIbo/4KEcVQWr2NFoPEYXJdhoyb+uT6HkAjVTIE+BLY7Q8sMlk+jszIAeqpBUvrBD8BlrYH2n+M7pWTnAKjn7ICw9O74onxn/zDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309647; c=relaxed/simple;
	bh=vsativoUauqQ+CXFMFfeLJSK1VKiKefrmN3tPBQQgg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sEFZrS3uK2XPeU57Q7Nztf1UY8sNC2SWvBz+4yDmWZcps3lg/qSdOLA1CHu02Otxam7sq5tapxC2ly1ILWqzby5mmp/wr6zO7bftYDCgTyRJyqcoQlJAIEtlMkk8krStz/c417vrlIoBmNFkfdD5PrpCX8xSmuVensoaRQKPib0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqnu9HDV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqnu9HDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07146C32781;
	Tue, 25 Jun 2024 10:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309647;
	bh=vsativoUauqQ+CXFMFfeLJSK1VKiKefrmN3tPBQQgg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kqnu9HDVYe7g0czU0C3Q4gdhyjwaIDgn5zPdLmURYXAzBd8Jl0BUVmRJI5usfoY+B
	 hl5R2hd8g7ZOVzc+A4QL0/J2BUmbchlzUgSIIasM7cDKg1stWowHtiG0axUC/hp4aY
	 Kgj/q/F0ax3u6CBw7Qr9s1H3FXZTYS+vkXzkhxCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalle Niemi <kaleposti@gmail.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/131] regulator: bd71815: fix ramp values
Date: Tue, 25 Jun 2024 11:34:01 +0200
Message-ID: <20240625085529.208264846@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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
index c2b8b8be78242..4696255fca5d7 100644
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



