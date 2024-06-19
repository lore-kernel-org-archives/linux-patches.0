Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A904313F428;
	Wed, 19 Jun 2024 13:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804116; cv=none; b=DQJJRGfnFLHP6NZcw4n9d7NDzmNNZfQ/I6n3pMmT1UYVYcfLwbzrCRPjYAjLnrV6+Syja1AkIRqE9Pp7tet+7bQjdeAvyIxNB3clCu7fsvDw/DWQLEG5uK8rjAkZQ9c3s/6kTRlQVkLETW8sP8MKyl0sqO0UWImmtV9U8YDkz9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804116; c=relaxed/simple;
	bh=iDuT7tGLf4HLoxLvB5I8kbt/QYdv4B2EdT+DEh2A1YM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLaIuIu8jYqW9oskiCeU3G74fI7pzJJeYpR3Y5awfaGjozGeiDzqKF91tzRA30O4sSsPwaMtVg0gJLN9n1oVyvKUrfUdu8gO2swznmqKNauxzat+dfdwKCcbkIZtrEm526yv+fUbd2MU91Yf3Lcj2r8LMdALtenL3ZOR1zRj4FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJqNUaZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJqNUaZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13A6C32786;
	Wed, 19 Jun 2024 13:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804116;
	bh=iDuT7tGLf4HLoxLvB5I8kbt/QYdv4B2EdT+DEh2A1YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJqNUaZXhpx0vrUSnQMsS+NfgW9Iyw3ED4qAWlg4+CvBF2ftPRln4NmLCWi9EM1ww
	 gNwFJyuaoeyxltURLqSRsWtfEVL70OPS0ZOf/jjH0khBLx+Ba+zAJ8Gdr4TkcHTeUh
	 8BDkeXz8+HjA9IdONuwzypQrf6EcivB5byiCSieU=
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
Subject: [PATCH 6.1 215/217] i2c: at91: Fix the functionality flags of the slave-only interface
Date: Wed, 19 Jun 2024 14:57:38 +0200
Message-ID: <20240619125604.988791256@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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



