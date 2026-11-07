Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064912;
	b=VjKr/aX3eoXAU9UsffeTGqiOMNXuB+CuOhUmUmaBT+gspNvO96VEiOsznm/84yDhs0Vg
	 t/SUWD14pR2RsM95HnjI4yPDqfuZWaLgD9vcQu4S9/Jmk1Zi6xppBEM0CFUUcPv618utq
	 49eWdahn9FDZ5trAWVGioJDF7Gmsg3csz7NCW89z9mS2ma9x2cZetMt9VqzWpMxk4+ghU
	 e+HxxY9qbVxzpaq+DbmFg8IECsrlums019T4qlVO+PY7vrOeuUGGaMivz29POw9RNdhRn
	 NnEDF3732ogKR0yAK/pbsdmTwJ5ILA5hb2vP5vlzL6sU4OxVGpH6ubs+qFFIUakOdKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064912;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iXXCk2OjJBm5cHaajZtBz3AAFiR6O4gQXWIdp6RbKn0=;
	b=X+kMkiCaUsCzW0pRF7uOnTcVh5g41dPBMC38ndjMnxMQfrwLthNg5QsLhBEY8tMHB/Ie
	 yhld/vdafJVgzkgsDzTWlWycPUO5h3zWaAmS/EEtXg8v3C6CdlqmAYK3oN4HGz5jfE3p1
	 ES9RjgKUBq+UJlYc7yVK7X6v97ffeqbNy1XMFIOXuJtZIgHV6ygBTYi75VpxIXuer6Jg4
	 /R2T4xh23Ms1OJnQnfZ/f1Xnb5Wb6Hwl/llcDgvngklcMXVSq+XIuKiZxZKCmuCMpWOEv
	 o9INlL9GXw/GpnTQ5a51gwpJAC6vlgGyC43pV+GwoN5z01ogGsIvTlJMXUom8Bz935A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pzEqwydf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6E7606A9EF;
	Sat,  7 Nov 2026 15:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pzEqwydf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723D61F0089F;
	Sat,  7 Nov 2026 15:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064911;
	bh=iXXCk2OjJBm5cHaajZtBz3AAFiR6O4gQXWIdp6RbKn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pzEqwydfuSZokaW1pgH47lutJze3g4bEITVDgabqCHG8MOKP+sGq9oohEedNh9Tr5
	 pxtKyqr7zv4AO0I2QS9EHC5uhRi/ectKtn7e2roGhS6USC8Cyy9o9ywOhfR0Hnog7c
	 LRmAm/nPAz39/QUUqvoB4bF7mOMli7oSAB0ttx4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0812/1257] spi: bcm-qspi: reject oversized dummy bytes in mspi exec_mem_op
Date: Sat,  7 Nov 2026 08:51:48 -0500
Message-ID: <20261107135001.772741061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 0f96ac59da114..5031b21424795 100644
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



