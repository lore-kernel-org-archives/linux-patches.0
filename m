Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052797;
	b=DYHMraD20Fp+xoXoF9ixs+WE+QuFry/uiw+v/9WDBWlM2ER5hjyZPLUsC3uO1Jfd87HD
	 N6VYOkyxd7cVbv1emH/iJkOmFckTTxxh5fHwpT8pAXYK7jQwI6AH4YEzu8kfc6buNT9O1
	 gfDUo12ZEsEcui6Lq73n31YevHrxwTiYUkIMy8JalKnkW2CjZr3/Ie7xdXreVeTMYH+G1
	 XEgRITZzniKaDF44tX+NKm1NY0EZkJjlzWHHxqjPvzhGz7v3akM68abNLhKJxzgwOIf+Z
	 /Ms7bvoUmOHZvOlCrM//0J3TE0OoVFPalSuvcOestrUssBsii3Oarn3iKJ/q/7FaF6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s2HxU20Ge+Pmm7i+wWBFzr5koyUDQeZ0guGuRfaDd2U=;
	b=ONIUQVJTMfUG5iNio817FqUTtjeNJr5g9WUI2F2uUNGHV3UUFAV/7Zf36tYzdSZ1x8UT
	 yyV692KNM7aGnCJQPqziUWeaGuyxS7d4KQnBmEJZ6pODYYCOSfb4Kb4cbqRBWRnUBVzq5
	 lBz4TQxaRG9uJmII6npT8ykNxBlQTxnIXhd9InBjs8d+hTkz559dccwxr5H2Lq08gNm9n
	 Jlq9YAD+PFO0JzeZ1txelXAFc4cquBuvdRkqyvUDKD4jjLAWQRhOOVdK+SIpMHz5JRbjS
	 iaOPctSEUi2I/ntFVEr+/d0TAE4nBnlsEIBSnskowMxmAUx6NUkgJMUOUlUbHJgbBiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b4TRnx9x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD72A606A31C;
	Thu, 19 Nov 2026 01:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b4TRnx9x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBCF1F000C7;
	Thu, 19 Nov 2026 01:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052797;
	bh=s2HxU20Ge+Pmm7i+wWBFzr5koyUDQeZ0guGuRfaDd2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b4TRnx9x7Byz8F3SpqziRnGWN3U1WGpo6kBKQmV2gtdEQUd1RTfM8BuSBJ+Q3Avvn
	 hrYTyT/vFWtDJ+5MMpvz04z6h1fLBV8sGAjU0dvUSMIwtwRkC7jwUTdzGF4isFs8Na
	 UEvUPUkaxH9C+Y6jSQnhXE6Xn3VjKhVN7cHDGyxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navon John Lukose <navonjohnlukose@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0693/2214] i2c: designware: queue only one read command for block reads
Date: Wed, 18 Nov 2026 15:39:29 +0100
Message-ID: <20261118150039.448139566@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ff715c0acdb2b..1ff6f77ebdf40 100644
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



