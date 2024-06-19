Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F1614A62A;
	Wed, 19 Jun 2024 13:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804119; cv=none; b=WlHcj7E8BY9vLgI7/dUNh+E+Xi9h9VLcgic8HZET+VcyouNW7V+uvNHUnrZ2RgwsDs0L6h5KsEdCMTPr/TDXaaCGASB9CSia2c2C0I30hTpLOEqvq8XYqaBm+mHJM+okByu25fN/sf+U45IEi3WoY9FOGLqaM9cqq5+tZ59qVt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804119; c=relaxed/simple;
	bh=idUWav/9Zq4tsxmQB+Yju9DTBVI8N+verLcqQJyA8VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f78Jr3Lm+TIxXT3slGnE9OylFKEv1bzD6yWoLhkcDioojItSvTQGhB0hmcZNLxf+oM36ohkG03fgFSlcIIvQe4K4JtAZxn6GCbRg5CyNBO4431r2eYMfok/D6FZofuYkktSOm/Auxnb/0zK9oCf9+8waDXB3En9zFPLfRc4C/5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EpVPyD2e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EpVPyD2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EB4C4AF1A;
	Wed, 19 Jun 2024 13:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804119;
	bh=idUWav/9Zq4tsxmQB+Yju9DTBVI8N+verLcqQJyA8VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EpVPyD2etH11HnskNiwozpNDxI0gT8dq0CG/zeee/3uX4nBw63Jod7BpcLnPCg++E
	 oSoUemd0+OywsVsjXO2q8IOCsU7a7gNQSXdXOe+OwVsR2UUG3waS/fBuONiBwIt6SI
	 GUaU7T2xbpIquR74TD2q/E6Cqic4Ry1jPoQXju0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Luis Oliveira <lolivei@synopsys.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Jan Dabros <jsd@semihalf.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 216/217] i2c: designware: Fix the functionality flags of the slave-only interface
Date: Wed, 19 Jun 2024 14:57:39 +0200
Message-ID: <20240619125605.027853653@linuxfoundation.org>
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

[ Upstream commit cbf3fb5b29e99e3689d63a88c3cddbffa1b8de99 ]

When an I2C adapter acts only as a slave, it should not claim to
support I2C master capabilities.

Fixes: 5b6d721b266a ("i2c: designware: enable SLAVE in platform module")
Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Luis Oliveira <lolivei@synopsys.com>
Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Jan Dabros <jsd@semihalf.com>
Cc: Andi Shyti <andi.shyti@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Tested-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-slave.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-designware-slave.c b/drivers/i2c/busses/i2c-designware-slave.c
index 0d15f4c1e9f7e..5b54a9b9ed1a3 100644
--- a/drivers/i2c/busses/i2c-designware-slave.c
+++ b/drivers/i2c/busses/i2c-designware-slave.c
@@ -232,7 +232,7 @@ static const struct i2c_algorithm i2c_dw_algo = {
 
 void i2c_dw_configure_slave(struct dw_i2c_dev *dev)
 {
-	dev->functionality = I2C_FUNC_SLAVE | DW_IC_DEFAULT_FUNCTIONALITY;
+	dev->functionality = I2C_FUNC_SLAVE;
 
 	dev->slave_cfg = DW_IC_CON_RX_FIFO_FULL_HLD_CTRL |
 			 DW_IC_CON_RESTART_EN | DW_IC_CON_STOP_DET_IFADDRESSED;
-- 
2.43.0



