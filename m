Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B0E12FB31;
	Wed, 19 Jun 2024 13:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802641; cv=none; b=oQGHVbOge+RdNBV98YrdapU890LUHH4P4tDHDKHM/QVQbJAgbf4lV5J/rwhhHZ2Ra1hbbZvgOkkj15P4SrSBBgtxls6Gdm7SV5LlcYdg5k//r9BqmAMMtTu6o8gAr8eEM1fMjnr8QdHFfydBCc1Qb9tuO5m5h4XMoDcMOeEq1VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802641; c=relaxed/simple;
	bh=y+krx3flX1BvOzBvGZWzZHcghmNMhTOWs03hwmtyXhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXt+v56abDYyp9tfBO4BUhx8gGfhJsil7gtfFNGs4n9+n2oUNdhdi687hbXv1MsQAKr4uPk9BlDLwnUchKXm98KVJ1GagRrleoIvKs0sRvdCfYXzOMgPWVgWdeccVHzZKHJFAwMp8XEriIEHJTfDbjYpQjkHo0rq1TJe3pr1e4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQN+VY+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQN+VY+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0721FC2BBFC;
	Wed, 19 Jun 2024 13:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802641;
	bh=y+krx3flX1BvOzBvGZWzZHcghmNMhTOWs03hwmtyXhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQN+VY+q/Xw/CjEKWoaLW2437gMm/TLdXRw23/+H2UkiAthvMmbLuUFUs4ZeukPYm
	 Zca2fFOIC9fL5T86U9NxZavR1OTGLbKOwNNoRz4T5p9l5oxkTHwcjZ92dwtNKfSyCQ
	 Tl0WVZO/1J6AU/pz9mHXzEo74gLS0dN4VAxvmsWk=
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
Subject: [PATCH 6.6 266/267] i2c: designware: Fix the functionality flags of the slave-only interface
Date: Wed, 19 Jun 2024 14:56:57 +0200
Message-ID: <20240619125616.529784763@linuxfoundation.org>
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



