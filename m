Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E308143757;
	Wed, 19 Jun 2024 13:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803498; cv=none; b=g3+PxAtYT3QgAWqUkVJYmxMjlkz7HD4qLs0CMHZW32v3Aqs0PlbeoNRNuC4O1deaDPIlgz89J+SDi6ojWAZKxiQjjKFhn1gD7qcBRafsypz4R95Gjewh0rkl9T1clrLhoagHNptu7mLZDUB1R5gCWEAdI7JL0tLNA+Sp7Te4Avw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803498; c=relaxed/simple;
	bh=KTfaokCNG9O1CSAUDRI6XKPzOzzUNodcp5G5t1GkXPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kR0RGvfWEkOjk6zj4Cji6qJebBZYGnaYtklKS9G9pmqh7GRdb/Xzao2YWgonVMm2+WASQ9SBFdtW36wh6s0Fvyjxbd8TURUvPxtbhQET3ge0FdZgJwAuJd3/4MvMiFz2Z9gZyg9CXNL+TcELevWIOHMr4p/5uSSnx7kyTtMIzC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GpYxhmCh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GpYxhmCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13184C2BBFC;
	Wed, 19 Jun 2024 13:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803498;
	bh=KTfaokCNG9O1CSAUDRI6XKPzOzzUNodcp5G5t1GkXPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GpYxhmChNNER++5fDaq97+QYC9PpconQmOWeXOVcQ5T2UcnzAIRMH73LJWXfaUJpz
	 uDr6Z6C1guFyL9DS5XcHlptIduDgXG9rGHo3ykfe7Wu8F22FqtGsuB7ndxBGHH0r8S
	 4kPsaV5XeLcYN7Qf8ZxK6WjNNhYvdDynlYLVHVfc=
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
Subject: [PATCH 6.9 280/281] i2c: designware: Fix the functionality flags of the slave-only interface
Date: Wed, 19 Jun 2024 14:57:19 +0200
Message-ID: <20240619125620.755268926@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 2e079cf20bb5b..78e2c47e3d7da 100644
--- a/drivers/i2c/busses/i2c-designware-slave.c
+++ b/drivers/i2c/busses/i2c-designware-slave.c
@@ -220,7 +220,7 @@ static const struct i2c_algorithm i2c_dw_algo = {
 
 void i2c_dw_configure_slave(struct dw_i2c_dev *dev)
 {
-	dev->functionality = I2C_FUNC_SLAVE | DW_IC_DEFAULT_FUNCTIONALITY;
+	dev->functionality = I2C_FUNC_SLAVE;
 
 	dev->slave_cfg = DW_IC_CON_RX_FIFO_FULL_HLD_CTRL |
 			 DW_IC_CON_RESTART_EN | DW_IC_CON_STOP_DET_IFADDRESSED;
-- 
2.43.0



