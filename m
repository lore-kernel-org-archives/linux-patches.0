Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062437;
	b=jZtUip/5zIUmCS12ba8KgkedoElUYJdLOdsUXHxQOBHitRemDxqwAOWwNZomebRmRq95
	 NdvDexDYR9S6qR4Tm7b0pnlbILmxvZt//v6tQHoX3RS2sYqEMzOSGKdDh5MJBrEqidPT/
	 xRmxEyj4Jkel8rPwot9MTh7q4qx0cyoWijVaktLI/zpKEvMoYFbc2EkpdDMFTz1nMixu9
	 NcE7yIxFfvcMFFpnEJ9rHXs/OPwdWckWAYyh7jLM4rEdn8zLt8hy2j5JXlJ70UNqZ+Lg3
	 H20DWGyLGurqK8AyehMVpPNNhDyYj26z65xC3Nc9GwrloZ/DwAlKER8vbvjCAYDLnqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DzLGMOy4of8TZBQkKatxiG7IvzCY1W8fBme3dppLRKU=;
	b=bKY2NJbMK1dBwgGqdVQH4/8QrjZhTQcgnEvtfNj9mmnfwETJL4dYot5JkQFp+kk1FPOz
	 104N35MUT54v4I3BUxTn8wKLH6ejKPZOCF3ZlYdRiGID4etQ7nvqpzg7ILkMRLtclF9Ri
	 grnin234DZcFiyL3XDMj3Tg9J99nztqyBiFQN5sc2sCRJb2zkfQdscOA3E/luGLxGGXnR
	 O/olXQVRksjKrnmnx9dYGXrZozxwNkGUoAkoHSxBJBBaaRiw4vVwyvIWXd7qJ4nVKjBjK
	 pLC21uSlYovdfp0xSH070KPjLeqcVdRhzrztIuDtjrI98AWXPY8E7bufJKTpIZ5kVlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gv+w9MGn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7E6606EE8D;
	Sat,  7 Nov 2026 14:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gv+w9MGn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A281F0089F;
	Sat,  7 Nov 2026 14:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062437;
	bh=DzLGMOy4of8TZBQkKatxiG7IvzCY1W8fBme3dppLRKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gv+w9MGnsKgM3NoyvAWuW0MFS7gFAe/5qJm/PSgawlVY1T//jiTCBHkBl4RthKZsQ
	 WZK2KqtiR/5H9IFMjLyhJdeCXsn9T8HRqRzy8yTY31m307q0akhGWBaNdmf3lBIvVf
	 ipfE7CHB6T45a5tHpaSPzI+99HwMFQfccwBQg/e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1321/1536] spi: bcm-qspi: reject oversized dummy bytes in mspi exec_mem_op
Date: Sat,  7 Nov 2026 08:55:37 -0500
Message-ID: <20261107135034.910114015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



