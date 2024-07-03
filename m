Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430231DFC7;
	Wed,  3 Jul 2024 11:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004620; cv=none; b=V538fDxIHFRgBCt24C0Ai/qTnnh1trnPrt0r+kyrO6tzJ7W3QUjU4vNZhPpUMSJmdKHnRrA9YLhL5SjkOOQNyykG9l8Rt0B/EXB01y8ecd5cIAqSOGT9TSZBruYD3N8/mUrIdLsnIrcqH7x/ByIefqkKnn3DxEu9b/afdihYyq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004620; c=relaxed/simple;
	bh=WCeHf+LZuzpliIognFOGDctRMBp95qZYhjZ6aSz3ilE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qB7GrF9JWtOf6B2bTYwVpL7LxLSgRx+ln7N9A5ZmOCuTWYSCBtqnag55yAjk/sEdf3+YVfR14Qmv3oC1nJPPuMMDF13u+aO60VHDuQClDzie3Os/dicy/Pb0JZ4Gz9e5qCl1kenyYnraMjNpENMXkaIT7u/WwXf0k0SY1DK6TPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MEKl2+54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MEKl2+54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA491C2BD10;
	Wed,  3 Jul 2024 11:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004620;
	bh=WCeHf+LZuzpliIognFOGDctRMBp95qZYhjZ6aSz3ilE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MEKl2+54FTqOKA/+3aAVx09p/Elxeb81NnSgwMj5wj9mGgmKGqIi5rgBWskxOpdnt
	 P0T5ogPBUa+MISveDtFZqk+ZHXxeyKPcYxIAgJ9824N6YT9/pUf3u7c//BcY13Kg+b
	 DxpDvr/DjsQ3Ue8/bnZWKJ/tOdPGuL3NA4f/O6tQ=
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
Subject: [PATCH 5.10 103/290] i2c: designware: Fix the functionality flags of the slave-only interface
Date: Wed,  3 Jul 2024 12:38:04 +0200
Message-ID: <20240703102908.087080304@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



