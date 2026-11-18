Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045725;
	b=CwPfbi6zwHtzZ7xA5qzhe/tOC8b0H848HO8VsSWNXEQAfJ0Sq8QO+GE8t7qJj03PGCPy
	 cMqwhlNcLt2mOFAyXcggWnVh5HyupsLxLKvEdCtcliDHIO6rUivIBgN2KnJQyLRH41JVQ
	 +m3LmVHiH/ZypaDXOCw/MHp/6XFdX9PQU8XL8fktqRBAA0/k4Cx/v6hDvNdByGG9pMMEo
	 CMcaFB+pBTBvneDvpbDsPepDf6P7YF0SLfc1CUGmQcpEjw7C2G5W8Cnx7T+KVavZGu6Cf
	 ZW4UxRJnS/BkJZoNT/9sON7Noru4VKM8uBH3GtQg888vLTTMFWLU07s8wFglBnPYKYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lNG6/vV7O2Ti7nn5M+0lqJvTRnHVGMTQCdYynLu+h4w=;
	b=YDmgmtaW6rOAgDp8fMAV/G3QDSJIBZgGvmQnNOqT7QJpYi6/6xzMuSKdxXCLN8rr1CJr
	 7xd50QE/vOAIWn7d5/Ik+iqRW/NVZZdEQyi0Z6UzWXUT1R2PRlE0TE11e/i2EK2n53rrl
	 6SLh8aA9/VvfSedC5V6xjvk2mggkBFSwg+XeUQwRodScMnQapWN8tHzQO+2livx88LKZD
	 nisPyggb2CBsiHrU56gKYB2yLqYfTH+iH8kKUE9EPVLKjIhBoFqaNzwH5h+dorUFGF5Xe
	 R8Kgi/tukpFOf0RwofRgHd0zJ4YlVAGo48+CK7ZAejpTjzKmL6jTHXhGwP4Uz39KQ5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pebCLdni;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15123606A31C;
	Wed, 18 Nov 2026 23:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pebCLdni
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661481F000C4;
	Wed, 18 Nov 2026 23:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045724;
	bh=lNG6/vV7O2Ti7nn5M+0lqJvTRnHVGMTQCdYynLu+h4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pebCLdniKrhpJLv0kVU2A9t1lnZ6DLg7Ix4SAcVinKqlb4gWm+QX6SfGjvNcUrGq3
	 cKy53Aud/sJEA+B3hvQnmD7dMBKoWnMjPmrlJ3uE/u9nlKy4MnYSvisvG9na0p89eN
	 3+Is2mIHUd8MyW+Lkgemcb7YUwU/sEmQgMPIFnzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navon John Lukose <navonjohnlukose@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1024/2857] i2c: designware: queue only one read command for block reads
Date: Wed, 18 Nov 2026 15:34:18 +0100
Message-ID: <20261118150238.469268360@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Navon John Lukose <navonjohnlukose@gmail.com>

[ Upstream commit 73dae605cad7921800677d982bfaeb81cc930dec ]

i2c_dw_xfer_msg() pre-queues up to rx_fifo_depth read commands based
on the initial msg.len. For I2C_M_RECV_LEN transfers the real length
is unknown until the first byte arrives and i2c_dw_recv_len() runs.
When a large initial length is passed, the surplus pre-queued reads
leave rx_outstanding non-zero after i2c_dw_recv_len() adjusts
msg.len, so the completion condition is never met and the transfer
times out. In a loop, this repeatedly times out the controller and
disrupts unrelated driver-bound devices on the same adapter.

Queue only one read command while I2C_M_RECV_LEN is pending.
i2c_dw_recv_len() re-enables TX_EMPTY, and the rest are queued once
the device-reported length is known.

Fixes: c3ae106050b9 ("i2c: designware: Implement support for SMBus block read and write")
Signed-off-by: Navon John Lukose <navonjohnlukose@gmail.com>
Cc: <stable@vger.kernel.org> # v4.10+
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-master.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/i2c/busses/i2c-designware-master.c b/drivers/i2c/busses/i2c-designware-master.c
index a09e610d740cf..3437116135086 100644
--- a/drivers/i2c/busses/i2c-designware-master.c
+++ b/drivers/i2c/busses/i2c-designware-master.c
@@ -441,6 +441,14 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
 				if (dev->rx_outstanding >= dev->rx_fifo_depth)
 					break;
 
+				/*
+				 * For block reads, queue only the length
+				 * byte until i2c_dw_recv_len() runs.
+				 */
+				if ((flags & I2C_M_RECV_LEN) &&
+				    buf_len < msgs[dev->msg_write_idx].len)
+					break;
+
 				regmap_write(dev->map, DW_IC_DATA_CMD,
 					     cmd | 0x100);
 				rx_limit--;
-- 
2.53.0



