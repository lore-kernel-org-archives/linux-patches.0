Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617858;
	b=NPTbx90jSMcO1MiBNFa4/0jew7K5tD8w7pVfj/8bkMmfi4nZv9R3LEpwwRDuKmDAG0Ho
	 IQmV4dDoVRuD6dQFh9LxFMWrwTwTgsIzPUPG6Qv8yltWKCJwK32VSSELFvyZkWe7rkoGt
	 GZC9qs27EiC10nRRp+UpJ2KoJbwy/nYgF5tSCI9s7NvjUZAlgxT/rYpUOt2m7KfIcbpAH
	 FGit6i8HpfPc9GWW5Hgjk25VBVfLekLXTdUoRFVMwVHc8Z5mOPKjInyGrWlEAS9MkblpT
	 sPrJMPCi+SrIbQFDHGwQT/abdx7BxQN+pMoZtvf5VOGCcVvucW/bLM45ElB3LkTsBmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ydn4OBI6/GsYhGlsB6InUu9yQ0zvtHnVT/l6K7T9OYI=;
	b=BkayV7+YHGdZ8Cxhsen1bLamOHIIZshDviD8AW4pgGZtySk4DaCfbKb6n64E2wNUA/PV
	 luYIi/LqPiljt/dMvRt6WbZt7G7kKt6rSS82GfVOHVgmt50/rgktaM5lPzDCyl/FFAueW
	 7G75VL9pOOvEaYpl8CJCFN6+DqbxFKL6aHIRW+Y3vbPuUQBLzyU8kJklrAJFb3RyJPP8k
	 PU7P3WJxQO3Hd7TbnAgHWKUGRU+3etoTYoX1OfwQZi7Qlexb6T/td5rZfIuCoOXXvCn2N
	 HJSjzErd0zNOrDJmNNlKEj67A/XsDOPsyUOfO17buczoJRYaWdrOjy88/7KeX6UzPDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=amBu3M3K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DBA606A31E;
	Wed, 25 Nov 2026 14:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=amBu3M3K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1C91F000C0;
	Wed, 25 Nov 2026 14:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617857;
	bh=Ydn4OBI6/GsYhGlsB6InUu9yQ0zvtHnVT/l6K7T9OYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=amBu3M3KJwSyRh2BLvG3HMxoALwQ47D4P29y0opyx4v3eI82FXyJ6XaMyEjqukCBE
	 uMlGA1Q1hPeg0diWZrWElOwxjDsJcjPgMTEvLx9xSrOWZCBrFmJHvpTO2DyGFwtX2l
	 WgmzMGbb2o1Uk6jkDjRnxPSBM9DZ4mpWAbrxownM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongjian Dai <daihongjian@kylinsec.com.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0097/1005] spi: pic32-sqi: fail transfer when the BD ring is exhausted
Date: Wed, 25 Nov 2026 15:23:55 +0100
Message-ID: <20261125143824.017513429@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
index 5d3921e29461c..35f0c60a31d64 100644
--- a/drivers/spi/spi-pic32-sqi.c
+++ b/drivers/spi/spi-pic32-sqi.c
@@ -297,7 +297,7 @@ static int pic32_sqi_one_transfer(struct pic32_sqi *sqi,
 		/* get ring descriptor */
 		rdesc = ring_desc_get(sqi);
 		if (!rdesc)
-			break;
+			return -ENOMEM;
 
 		bd = rdesc->bd;
 
@@ -387,6 +387,7 @@ static int pic32_sqi_one_message(struct spi_controller *host,
 		ret = pic32_sqi_one_transfer(sqi, msg, xfer);
 		if (ret) {
 			dev_err(&spi->dev, "xfer %p err\n", xfer);
+			msg->status = ret;
 			goto xfer_out;
 		}
 	}
-- 
2.53.0



