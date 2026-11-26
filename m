Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704961;
	b=mVSNjLpBkfjqNDoRZeEo4gFQatMrAsBtak8whiGPy4tmoJOhQp3rghYSaEIk/xdsdVps
	 5CTLcGwQ4WiB+6OzaZqYqXzC3iENhegQQH7ONBcYHPhYLg2RAFTAWxltYaUpTngqomc69
	 zXGf7e5RS92odNV8gLflt1U8LL8f5IRyX/H1XMd+ImNUX7Z1iNTqeMqCZsmHIrAJjZQ/0
	 ipJ5nhemD6lgh0jzQ8Kvu65ygpWi0Oy9ZQsl0Zc6D2VLj8SH6WLoR9R5xH/+jrY8tSBK7
	 3dEx21hNPSeS45DUFZ9XSBd2xNI4SXNZCqt0K2p6S7L4YKMa8YKWnpM7pb7h5TKcOxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SAM/sesTMIRXmAQi3r3ygMODLl3Fh9uf8EDVXeADtmE=;
	b=QZ/2CJNDyqV8tEFi8miULKfbt/iLzgr09R+rujo/dfOJtpbHDtt751ahYD6cxOIEBGYr
	 plWKcruv+aaX0oFmpOl/cvQ0RMBYrf4GaRBm321pkDCbQFcFe6KHPDE7HKfzGettOXLTj
	 eq2OVFbQrQjEuZqvBbeKHdLSVmQa2QU7sRTM2Br0gEw3E9mJ60AGqd5u9JMeth7MnN67H
	 XgXHnIMrobyq2BKbvcjuRKiA7omKzvDJ1Zh3Km5LHaTY4cANtYxYxaM2vUCdLKfOsT96P
	 O+gnRKCTCXY9XJxKVEAVypas3+01uZ8PSSoNkYy76TJ9EFJBkpn50dI5kH4hjkv5+Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ONmbXSDT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1CB606A6A0;
	Thu, 26 Nov 2026 14:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ONmbXSDT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE59C1F000EC;
	Thu, 26 Nov 2026 14:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704961;
	bh=SAM/sesTMIRXmAQi3r3ygMODLl3Fh9uf8EDVXeADtmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ONmbXSDTbgw4gwH4s9MhF/MTScMTQ9GB7l2n/eQ+kSWML83CPXddvWxCvdQbglosb
	 m2tLU3E2fSblPl2LN7FEzgcF4yRNuXWhO1Ds83zaWcLu4IiAlUm1MnmJLFbZOCo1om
	 fKcKPuv/k+Vg8U14mXN2yUuo7A1/RBtGk9cC/TFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongjian Dai <daihongjian@kylinsec.com.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/319] spi: pic32-sqi: fail transfer when the BD ring is exhausted
Date: Thu, 26 Nov 2026 15:36:44 +0100
Message-ID: <20261126144007.553954759@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Hongjian Dai <daihongjian@kylinsec.com.cn>

[ Upstream commit 2066970324a1439e5a2e08c4599098367f8f82cc ]

pic32_sqi_one_transfer() silently stopped programming buffer descriptors
when ring_desc_get() returned NULL and still returned success. The caller
then marked the last programmed descriptor as the end of the list and
started the DMA engine, so the hardware transferred only a prefix of the
requested data while the message completed with status 0.

The ring holds PESQI_BD_COUNT (256) descriptors of at most
PESQI_BD_BUF_LEN_MAX (256) bytes each, so messages larger than 64 KiB (or
with enough SG entries) can exhaust it. Since the driver sets no
max_message_size/max_transfer_size, the SPI core does not prevent this.

Return -ENOMEM instead, and set msg->status so the failure reaches the
caller rather than being silently truncated.

Fixes: 3270ac230f66 ("spi: pic32-sqi: add SPI driver for PIC32 SQI controller.")
Signed-off-by: Hongjian Dai <daihongjian@kylinsec.com.cn>
Link: https://patch.msgid.link/F5276982A630220B+20261017075545.95854-1-daihongjian@kylinsec.com.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-pic32-sqi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-pic32-sqi.c b/drivers/spi/spi-pic32-sqi.c
index 86ad17597f5fd..0b32714633e9a 100644
--- a/drivers/spi/spi-pic32-sqi.c
+++ b/drivers/spi/spi-pic32-sqi.c
@@ -297,7 +297,7 @@ static int pic32_sqi_one_transfer(struct pic32_sqi *sqi,
 		/* get ring descriptor */
 		rdesc = ring_desc_get(sqi);
 		if (!rdesc)
-			break;
+			return -ENOMEM;
 
 		bd = rdesc->bd;
 
@@ -387,6 +387,7 @@ static int pic32_sqi_one_message(struct spi_master *master,
 		ret = pic32_sqi_one_transfer(sqi, msg, xfer);
 		if (ret) {
 			dev_err(&spi->dev, "xfer %p err\n", xfer);
+			msg->status = ret;
 			goto xfer_out;
 		}
 	}
-- 
2.53.0



