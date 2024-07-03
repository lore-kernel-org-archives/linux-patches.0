Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C12C45945;
	Wed,  3 Jul 2024 11:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005715; cv=none; b=Er7ePu9D7eRNCZhHV7M+QFnX+Jjb+HKYRcOx4wwMNWykwbcdEvOnE5lRel/VcQC+fAbDgk13bm8QgzfY1XzcZMwxG4QgkcdOQs3rYn9WohD/4tm3FWpZ+AnVxL2/m+vqgDaM4EJQXk2vb0WtAxg9C/KxpAMX2o/CvGrtX9CYZtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005715; c=relaxed/simple;
	bh=21cRvdAxzQbrbsjKApOWFcBSDrBC1TN5JWXUG5HlIxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LatDEw7uq6spRg3SF51aNDf+/pVw6Gj8jvxIl1NSJDAcG5CN9ptET6CzrWklJId43985q8y2IqxI9LssND9d2BPav/vE6FO5EWIGo7Mtjv97nlQe/Y3XEryu4WvP7+49Dv3jim9Cq7oheK9Mu/odyJPQ/6ZmkT2FgV3q4rRVFKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LvpiH+Bb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LvpiH+Bb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBDCC2BD10;
	Wed,  3 Jul 2024 11:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005715;
	bh=21cRvdAxzQbrbsjKApOWFcBSDrBC1TN5JWXUG5HlIxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LvpiH+BbkUbSXC41T0RmBPGt6CWpTvcDDB/Eq1EUaK/82wKi+jvJRee8ZU+b0IDal
	 d/4CbHrV/crn+IlGXJwWsae4A3sArCO72Shx+bNE21S2cs7is97aHE0LxvgcYYYx/m
	 LiwJE1vsUe+gI1+RBsIjDWwWI/zBUy3TVQJZuZws=
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
Subject: [PATCH 5.15 145/356] i2c: at91: Fix the functionality flags of the slave-only interface
Date: Wed,  3 Jul 2024 12:38:01 +0200
Message-ID: <20240703102918.588444970@linuxfoundation.org>
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



