Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059079;
	b=jIpOjV+uOWJPinaM0e5qXe6mN+v4ZaXKsPc3PeEc678dBv74dvLgvH0yykQ5+VR6AirE
	 zF/cGNTGy8IAP7tcYEcQKVepBi1IrBBw+ePiaaIniV4wHOn29xVlghoYaFPdc6S3aTFtX
	 wQ47JhuE1+YLkiLHqDZ48MYKMAKO9AVVlSs27drfUdcjQvaQ1JrnyKBZxGlmz6VbxVYRu
	 1ypfiMF0SIUdhFLkcMjknFJnhANsRXRglvZpX5IxfBEiI3m4oj8vj9vNOt1OsFv+oYPYa
	 A33EAv6w4PRVdPKB6RqKTSBjOZbLHJrXcjRBTw2Ak1jK8mZSxeIueKkQAjxhElhd3Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uHS+3DNHWXv4kpMzKBIbgPNRGJGtE9X31EHCCbmcNOQ=;
	b=VdT5B3+TuGxz+ZUus+DXwp9zc3aUIqumlJDlCvYJqld8W4vQIdkuJkE/mggSXLJpUz94
	 C5KOS5asD2MzfKUaU2aG+vnXDb5BMN3m6AoprbBQUHdtfLiUujL+VPTDLK0it+WIzR6Dg
	 znUSdfV3MqR1NXzxf5GD7QMWI9FMlaFPHSf4I1WcvJmexaKAwm8UlFBcze41jx7Xn/4T7
	 b0P+9uBo7HhjvT6uEPxg4xeINAHchx5RUS+kZkRj45xyuLCM85hI2OCDT4Hxg4fXdmPwy
	 Ijb98jC+A5UgNScocOQqMrQFSivB+X23WlWjennG/EIf+73RbJ0XsI6IuY+8tV73aFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CgmcvyS+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AB260A2604;
	Thu, 19 Nov 2026 03:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CgmcvyS+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1091F000C4;
	Thu, 19 Nov 2026 03:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059079;
	bh=uHS+3DNHWXv4kpMzKBIbgPNRGJGtE9X31EHCCbmcNOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CgmcvyS+JPkP+ff7hRyEeDdTjTAHMTXwge68AxeCBr2592Y9pqAshnuKX4vVwUgjr
	 88WmvRdz37DTvzfCBtU2ZzleWO8aQIt3cTBSW/Z7dUgiXvJTxEbtlfjWT4IUSwF9zu
	 1P3JgPFYTKJjRhAoKiGCrJSBFKgxAeaLqOfNWifk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0662/1848] spi: bcm-qspi: reject oversized dummy bytes in mspi exec_mem_op
Date: Wed, 18 Nov 2026 15:45:00 +0100
Message-ID: <20261118145943.469396150@linuxfoundation.org>
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

From: Weibin Liu <liuwb@xiaopeng.com>

[ Upstream commit 9e44f0df3fff215d9033089e85980048c3ac132a ]

bcm_qspi_mspi_exec_mem_op() builds a local command buffer cmd[6]
holding one opcode byte, up to four address bytes and one spare
byte, and sets t[0].len = op->addr.nbytes + op->dummy.nbytes + 1.
bcm_qspi_exec_mem_op() only validates op->addr.nbytes <= 4 and never
bounds op->dummy.nbytes, which spi_mem_check_op() also leaves
unrestricted. With addr.nbytes = 4 and dummy.nbytes >= 2 the length
becomes 7 or more, so write_to_hw() reads past cmd[] on the kernel
stack and pushes the leaked bytes into the hardware TXRAM.

Reject operations whose dummy phase does not fit the remaining byte
of cmd[] by requiring op->dummy.nbytes <= 1, so such transfers fall
back to the generic SPI path instead of overrunning the buffer.

Reviewed-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Fixes: 5f195ee7d830c ("spi: bcm-qspi: Implement the spi_mem interface")
Cc: stable@vger.kernel.org # 4.18+
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Link: https://patch.msgid.link/20261015-bcm-qspi-dummy-bytes-v1-1-c319da3c2497@xiaopeng.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[ Adapted for 5.10.y: this tree returns -ENOTSUPP instead of -EOPNOTSUPP. ]
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm-qspi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index 898658ab1dcd4..a01748cf88e4e 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1024,8 +1024,9 @@ static int bcm_qspi_exec_mem_op(struct spi_mem *mem,
 	u32 addr = 0, len;
 	u_char *buf;
 
+	/* cmd[] holds 1 opcode + 4 address + 1 dummy byte at most */
 	if (!op->data.nbytes || !op->addr.nbytes || op->addr.nbytes > 4 ||
-	    op->data.dir != SPI_MEM_DATA_IN)
+	    op->dummy.nbytes > 1 || op->data.dir != SPI_MEM_DATA_IN)
 		return -ENOTSUPP;
 
 	buf = op->data.buf.in;
-- 
2.53.0



