Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062400;
	b=pA6HHivmJfas0gDPKL327w+pA9lx1BxjlccPya9v8D7JubFSJ55RbYSnT6w7KbRUz4TX
	 TxZSMGn++GWi7dgHVha9Vv7g+0Hb48pBrCOzAgRprF5WjPoXcl464knP0QeM1wKDUIoWG
	 72UXVX0ETcnqKibBWaJw80DT17NlFh3lNexNYHQw3Ele5JHTw7yZRDZ8o7qWZK4XRAol1
	 IEO19qFG39ajwJPEyMqRsvxpCFpTjL8oy4Oiayk+NLTZgwXC2fCOvGXIvMUiaKG2TQlZh
	 8ioSrD86WLrKpJ1KZneJqY8UjqffsOuhqsod0BvEHqewoS7mLzqryTEBU7kL4Rj47OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3ZT7u0LH7EXuPpPw6hVvxS+1vh/rIOVZTihcHIFqZ0I=;
	b=u0cOdbbQtCxaptpnebgv2fWmg2e+Yr5Zfi7MOAzQ3O3oBvovGJaQKYvvkokN1BzPk9OA
	 gCbkB1fsfOrJWFBbWhfqdcHr/HMkurHXD5i0XC7rsiNLluE0olVXCWj2aXSFMWIHKqkuQ
	 QWPYTVFGceJUNHmQ4aSIiNCKNtJY+bqkqYZw0I6fcNHJ5tz0LPu6mB/ZMcXTBqkR/Doig
	 IxuGOr2DEdbWgHXR8j/BCbXTX6ZjCuRVSpWNZTxqBQp93V9etaxmFdkQie9NoOBtH+obR
	 CP16MlamT4H3nvDJ9Tya6VTQUSNGAR/iphG1yQzFhEkjB6tMoVx8Nxof06KuHcapSKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RYkMEHNt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A29608362D;
	Sat,  7 Nov 2026 14:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RYkMEHNt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930B61F0089F;
	Sat,  7 Nov 2026 14:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062399;
	bh=3ZT7u0LH7EXuPpPw6hVvxS+1vh/rIOVZTihcHIFqZ0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYkMEHNtBwbx4AKT7gpGXdab6fCNsaGJc8Q+ho0w2mcM4rbsQmRSVlxaPyIeJhjbU
	 U5ygRZFEd3f5P8gM5lZOtput/QQcFdYlyTv5YnpH1G/YAYHeIfRTZBFw8VHycAwETo
	 l2sPYb0v8XPKBLc9xCm/04cKw5AxP5orcvc43tLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1316/1536] spi: npcm-fiu: limit UMA data_size to the 16-byte staging buffer
Date: Sat,  7 Nov 2026 08:55:32 -0500
Message-ID: <20261107135034.768320277@linuxfoundation.org>
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

[ Upstream commit f0be928a41384ea93c876364f360779f70359249 ]

npcm_fiu_uma_read() and npcm_fiu_uma_write() use a 16-byte on-stack
staging buffer (u32 data_reg[4]) and move data_size bytes to or from
it. data_size comes straight from op->data.nbytes, which is supplied
by the SPI MEM operation and is not bounded by the driver:
npcm_fiu_exec_op() only validates op->addr.nbytes, and no
adjust_op_size callback truncates the transfer to the controller FIFO
size.

A SPI MEM operation with addr.nbytes == 0 and data.nbytes > 16
therefore overflows data_reg[] on the kernel stack (write path) or
reads past it (read path), corrupting the stack.

Reject data_size larger than the staging buffer in both UMA helpers
by returning -EOPNOTSUPP, so spi_mem falls back to the generic SPI
message path. The chunked path in npcm_fiu_manualwrite() always passes
at most CHUNK_SIZE bytes, so it is unaffected.

Fixes: ace55c411b11 ("spi: npcm-fiu: add NPCM FIU controller driver")
Cc: stable@vger.kernel.org # 5.4+
Reviewed-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Link: https://patch.msgid.link/20261015-npcm-fiu-uma-datasize-v1-1-7dee91cadee6@xiaopeng.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-npcm-fiu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/spi/spi-npcm-fiu.c b/drivers/spi/spi-npcm-fiu.c
index f3bb8bbc192f2..5be83535ae865 100644
--- a/drivers/spi/spi-npcm-fiu.c
+++ b/drivers/spi/spi-npcm-fiu.c
@@ -342,6 +342,10 @@ static int npcm_fiu_uma_read(struct spi_mem *mem,
 	u32 val;
 	u32 i;
 
+	/* data_reg holds at most 16 bytes */
+	if (data_size > sizeof(data_reg))
+		return -EOPNOTSUPP;
+
 	regmap_update_bits(fiu->regmap, NPCM_FIU_UMA_CTS,
 			   NPCM_FIU_UMA_CTS_DEV_NUM,
 			   (spi_get_chipselect(mem->spi, 0) <<
@@ -397,6 +401,10 @@ static int npcm_fiu_uma_write(struct spi_mem *mem,
 	u32 val;
 	u32 i;
 
+	/* data_reg holds at most 16 bytes */
+	if (data_size > sizeof(data_reg))
+		return -EOPNOTSUPP;
+
 	regmap_update_bits(fiu->regmap, NPCM_FIU_UMA_CTS,
 			   NPCM_FIU_UMA_CTS_DEV_NUM,
 			   (spi_get_chipselect(mem->spi, 0) <<
-- 
2.53.0



