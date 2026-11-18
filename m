Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053151;
	b=QcJ4OAfOZ4hME6z+mhtGdhyYouwFv0STm0rDn+kF9ps81Zpr1Ednahx9hS64IZd6lnmO
	 VkoZwGD1MBfU6hRVGuI6/716o1b6MhBMyM6SW9cbr0WKa7zoKr81L3ZLcfmv82ZmSZ1wU
	 eDaoDVkdDm3sgbglxMEUUkLd+UZBMT3Tys+d/7MLABTcrJi9eXXu3iMsACvIqpiKVEufT
	 nLT8pLWvWuIc2XBfpkXKHrQqevMi8Jj6xu2L6CQT4oFK7hQOcFH9SXkwMCDeOL+64xA8a
	 7L23+xedDiFhkfjrdNRUn/tln+tmmSu/7ohtyyv6Ild8hs4D0iH+JKbab54BGJjc3IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ikLpLdHBtHb+YG19uaOG7WIstszMPvQUNjKD56ZKOOI=;
	b=idOrq5HGpss/0UY7BOas0e37JpuaoBK5H8xD8L/aDZR6z7kIYLuWPm3t7NU0gDsj7L6+
	 /+/Ng3TWLD2srEdN2x2yEWcEtx4L1FedjilY7Xn5nip0xWUH6TQSvr9oCHxCHxjqIwmgY
	 DYjACSgACU/ZUAVX4jkBRxjeOnzbNk6QjV8+txvPqlMtuURPwinJsPF93D/yto4frNlF2
	 JmcpBQ0eYrv1/23IR06InJHUqnG8dzKisOAg3nBOJvL3kkEmOD9OrjJ9arCBAOjCZ4h49
	 43bjeO/QCkJWXq8sSYkrAU91nGTycAOvn7DL7BaJqNuGEh99BHt27wDU//gsA9BAUiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wvN4G3LL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20566606A31C;
	Thu, 19 Nov 2026 01:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wvN4G3LL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739DF1F000C4;
	Thu, 19 Nov 2026 01:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053151;
	bh=ikLpLdHBtHb+YG19uaOG7WIstszMPvQUNjKD56ZKOOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wvN4G3LLEAKBOWKBsceosJSClCtAlxBoX9dgMjP4MaG2y2jDnEqFwXZBthE2YF1oK
	 LWrxmdUhv9JNWaKLa3Ndpc3vYrdGnG0G9aqYX+glFTs8IdZ3Sawn5jWxRFMbK7peil
	 K3tydNZ1JnYrjJ9IlrWgIyn0YM4BrdErl1vJEHus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0816/2214] spi: bcm-qspi: reject oversized dummy bytes in mspi exec_mem_op
Date: Wed, 18 Nov 2026 15:41:32 +0100
Message-ID: <20261118150044.200293826@linuxfoundation.org>
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
[ Adapted for 5.15.y: this tree returns -ENOTSUPP instead of -EOPNOTSUPP. ]
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm-qspi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index bca7ac570b94a..2c8f0d9717945 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1025,8 +1025,9 @@ static int bcm_qspi_exec_mem_op(struct spi_mem *mem,
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



