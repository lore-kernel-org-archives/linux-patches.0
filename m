Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063429;
	b=eXOOB5RwjWjFXIF9tdx8Lo3SShUzo75EiE43X2vvdUiLruSLL2yHq147QUQpkxtquNWe
	 Svn1s58HAFwZdZLJoVgHl+J+dAQU/siENqr5ApNCsqtvEHhE+zzwW7rCrrUikRr/HeU+A
	 befFFXFIj3jkJ6kHJ7dh+BI4FnlhAvkUTusCOzDIt9ha17E9LljZF64Sk5Lscnx3/IX1F
	 IjY3pPnfITUPjFp4NiZcrIaM/L+W9wBCpsmkUOe1Ie8IDPKb3KwJM65Yo/2nHtQy3zl71
	 qq2jeveH38KdxcsE+dnHuH756evX2ZiUYdhvrHA03JLg3G6OHuiibrg7S6iLXc7bE9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yisZXRJWN/2WDct4AP5D1gjk5mMP9U6VBJNULWMmBeU=;
	b=UVl/lqkcThTHNl+yD8pA5JBa6gElpar/6FJjxu/EQhA9xa55jDlWwBVo6mwBYFXMNuES
	 /oRzlOVCCeiWR0gxdprr+gG8ea8lmvYiwHKa1mF9aOhqzlKe0RCRgmGCvLLQVjpI4eVOl
	 0WOnqrS+BJTG7TRbMMwGTQSTD2hhuBQcpB2rbUJ6R69Jqt6GQ/T/b5Tn9rcqu0wt8hXsl
	 iqdMWzHafuvPbLB13dCotAH3YRqGuxrRPgAZKVSkByMFkZT1UpeeM/6r/SidZHlhtMsDE
	 yOQKjpTc/W+POFVCg9X3bFezQ8LUqvxTRkYVwhfBX5ELjTFmTYRxqpfZSud1nmWf5nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="A/6CEBrd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE8C6083625;
	Sat,  7 Nov 2026 14:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A/6CEBrd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFEC1F0089F;
	Sat,  7 Nov 2026 14:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063429;
	bh=yisZXRJWN/2WDct4AP5D1gjk5mMP9U6VBJNULWMmBeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A/6CEBrdHK2Q0PNXRK63NxwQDCqLwBUOshXNFJdwzT6Vt4Vq4p53V67xP2kcg+fpD
	 gLbL5icvuUAwlzUUTsN21muL8HZa/7nmXasC0qDRmq2dDRR4cu1fpa1g1Vw8L7Zuha
	 rBQKmoSE53T5ZUkJC2wDeNHijIbBnK0APR/wcYPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 593/869] spi: bcm-qspi: reject oversized dummy bytes in mspi exec_mem_op
Date: Sat,  7 Nov 2026 08:54:35 -0500
Message-ID: <20261107134913.211854101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm-qspi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index ae5545be0a45c..de333a4a3200d 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1197,8 +1197,9 @@ static int bcm_qspi_exec_mem_op(struct spi_mem *mem,
 	u32 addr = 0, len;
 	u_char *buf;
 
+	/* cmd[] holds 1 opcode + 4 address + 1 dummy byte at most */
 	if (!op->data.nbytes || !op->addr.nbytes || op->addr.nbytes > 4 ||
-	    op->data.dir != SPI_MEM_DATA_IN)
+	    op->dummy.nbytes > 1 || op->data.dir != SPI_MEM_DATA_IN)
 		return -EOPNOTSUPP;
 
 	buf = op->data.buf.in;
-- 
2.53.0



