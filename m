Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058649;
	b=CXScr6pZvGnHUzfRQYgbIRlEUBbuxz6UJ2iWF6aQpYm2Cq45nBvC7EN0NOSgDqDtKiT4
	 biWUdedM610F9Zmb7LV0pOsInJpc/xe9ekv0HzI12ldPbquKumxwOwndnNp79DH1IBGsS
	 /wK/M39Nw/6Q37aB2WNHOsZ2CrX4SoClIOqVdcj5yzfExilvO9nw4ASHWacH35w8KMnjg
	 2lO25hSTCRa5iASQUTSKfe9MzK16USr+n0KuQbLANRmJ19CkqfovW/iPx59SBU8Fq2oVY
	 CFvpfe08hZexcW4Exr+sLRFO5jIVLTxk3brD7/LtMidXCLTzGHp+LSGn7K2sB4ED4WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XbUumOrW4cq8R0mk+P5HXQCoALGxhswyjo2+d9VykyI=;
	b=zs1nzDQXFaJ8zOsAoxb81MwA8bDrAMfo7BV3HyvJtHQ6BHzs7WscyI4sUonXfJRdiwIL
	 zV9tfjc8GCAojgQAaxt0jolGowdb7WII+qnoQ+xkgkS07lVgRSWqlPX69pRBpzUJ+y9RN
	 qYYRZ+MLFoFUKQ/fqZeBWoUfyKmuCXljy0ygJOV01XFdk1wOwiZAb+Pzkhwzc8OaZl+3v
	 4xVbZbPhRXy1zA5A0mmYZL594We/IDBpm2zIXAtw6QJ1ZxZ2PAs2+NoTACzp7we/F6XdB
	 ASZuM0tP5yWvFaKES+6bQPHk0Chw8Dpc6CVV3m+JUY6pIxjPKbw1rNkgDEgbE2Q7+fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=08OyHx5N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2061B606A31C;
	Thu, 19 Nov 2026 03:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=08OyHx5N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DF51F000C4;
	Thu, 19 Nov 2026 03:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058649;
	bh=XbUumOrW4cq8R0mk+P5HXQCoALGxhswyjo2+d9VykyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=08OyHx5N/xvuV9NbYLKk9gAYKK+rOm+yecV5Cq7YXcFUja6EjmPbcmdAbpYSU2HAv
	 sU/JkkOr0QLERyE0R5WD7mTPwUZv0d2IlY9bt17IjUZNzIVY93wZv1aPfGKqNkER/r
	 Rxb6OrmwCNCYymlRhtozOTNp8yvibdcQTdDstzvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navon John Lukose <navonjohnlukose@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0560/1848] i2c: designware: queue only one read command for block reads
Date: Wed, 18 Nov 2026 15:43:18 +0100
Message-ID: <20261118145938.319085187@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8a3d35cacdcb5..b2a10c8d8773c 100644
--- a/drivers/i2c/busses/i2c-designware-master.c
+++ b/drivers/i2c/busses/i2c-designware-master.c
@@ -346,6 +346,14 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
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



