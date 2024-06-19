Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D8F12FB31;
	Wed, 19 Jun 2024 13:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802638; cv=none; b=a9e/a0i97IEW1e5GbD2lSPy1JJGLCWUsA8kQbK4i8H7k3BGPTvZ0W2yvpW8vXO42mcdLtPLZBPtfaFKf8/6noZfTQ4WCLpH6iVOx2F075akd+IK1tPtz3Js5KKYwF8+QjvulVRAGwET8VaPPbB/XJOQhfOvgx5YkVXpS5daM9gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802638; c=relaxed/simple;
	bh=YYEWGdnXqKmdQ9hds0hYiXeS8J2wyHoO52Xc9stg4yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AInoeLFhwcMms/0bu12RNz7g3h7pRsAvJRpGYVP/x5U59Ng3DPRlo9KKz6+CQndwDBdQI5uiBNTMDJVbKFIhmQWwgqfjAfiY1Uo6QSw5U0Ve1BteF7Ht+yRB9hZ5DZgG+69DT2CRVACGaBILDKI3BMbs3J6TsOmlaC48fJzO90A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NRF17uin; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NRF17uin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E446C2BBFC;
	Wed, 19 Jun 2024 13:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802638;
	bh=YYEWGdnXqKmdQ9hds0hYiXeS8J2wyHoO52Xc9stg4yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NRF17uin4osloGlnAoyXWyg4GZmMS2N05l0uxW6xnuhGSWlRtogcIpUlsCTTjSurv
	 eae4glIaJG7PXlX/8KSF+skHvj7i5ojRgMzhnZZvFsODGbASvobysyHkrgbeKn7Xpl
	 nS3bp3QEdM+0pD9yzwc68T9cXi2YPtttVw/SeqLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Juergen Fitschen <me@jue.yt>,
	Ludovic Desroches <ludovic.desroches@microchip.com>,
	Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 265/267] i2c: at91: Fix the functionality flags of the slave-only interface
Date: Wed, 19 Jun 2024 14:56:56 +0200
Message-ID: <20240619125616.492060501@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Jean Delvare <jdelvare@suse.de>

[ Upstream commit d6d5645e5fc1233a7ba950de4a72981c394a2557 ]

When an I2C adapter acts only as a slave, it should not claim to
support I2C master capabilities.

Fixes: 9d3ca54b550c ("i2c: at91: added slave mode support")
Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Juergen Fitschen <me@jue.yt>
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
Cc: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Cc: Andi Shyti <andi.shyti@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-at91-slave.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-at91-slave.c b/drivers/i2c/busses/i2c-at91-slave.c
index d6eeea5166c04..131a67d9d4a68 100644
--- a/drivers/i2c/busses/i2c-at91-slave.c
+++ b/drivers/i2c/busses/i2c-at91-slave.c
@@ -106,8 +106,7 @@ static int at91_unreg_slave(struct i2c_client *slave)
 
 static u32 at91_twi_func(struct i2c_adapter *adapter)
 {
-	return I2C_FUNC_SLAVE | I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL
-		| I2C_FUNC_SMBUS_READ_BLOCK_DATA;
+	return I2C_FUNC_SLAVE;
 }
 
 static const struct i2c_algorithm at91_twi_algorithm_slave = {
-- 
2.43.0



