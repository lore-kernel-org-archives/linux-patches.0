Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024687;
	b=ACF3n85+pzoHC2vJNX5UN6pjojTPFTMSyD/R8ZWSh2+NiZLhVUKlHJ1t94blF+GQd2Pq
	 eoxReyGc31zUAE3PcllUcsTsRigbFM4e/ttHhiDTVNuyONw8FzDTYjBga45UvFSDl7JLS
	 tMDYjg5mI6LYkrKZbf+Pa4WGJMHHjbceleH8+N2deBDGG/eSWE1h6UxHm7iYKTV/+aPwN
	 iKS/KioHpeHMN8AsQsW8+PZLXg706nlQ9eWFD0R1+MemTO9Sie3rgaRh3kjBAg7N9coNN
	 V4XSWVctHaTFzO888W6Fbx8wOuQM2sbWVkQyHw8NjtC0K0evAB5j01gB5xcz9TGVwLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024687;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=I6mBYHF/07FvbkuQEQUO5KJaiXfxUfCOqZSbCP5qo3A=;
	b=rMadZM/LxP54nFHhvMs/uy6Ok+oMev54z23nv0Hs5m6ZIAeyycgREFk7zrx/wOJy+5iZ
	 xY1+gWh8JsPCwD+1fMvV8vav/4oVuaTB7+Z/4nfMRcmrbmYmL4enW2TwtMsgzKmkqcZ/6
	 BwjFx5cvhyIb0IqNpNTABOlkqF/cw+seOjgdPI10i8in8Kpw4xqiAlEmdUPSxb1B6RlxZ
	 7DUlPVRpp3eW8rhdWh0AbmwlYXfXPA5iMCvEgxwZALqkZS4iqGbhvuxzw0cEaAw2fixqT
	 0ll8+dSSlk5F2V7wKdTVi+Uwbk5rgftSF79u6ZI7yptZR8BPLH+sXt/mEP1nYdFmeLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qv7J8Epc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33DA606A31C;
	Wed, 18 Nov 2026 17:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qv7J8Epc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7AA1F000C5;
	Wed, 18 Nov 2026 17:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024687;
	bh=I6mBYHF/07FvbkuQEQUO5KJaiXfxUfCOqZSbCP5qo3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qv7J8EpcvpwaiBeXGm9/u5khASwbYErw8aVJmMO7rj0yh7RNI/oYVBzJFhwAI090u
	 scYHDyI8YCB27J8sb+m6RFyaXl+VTliANea9qrs+LRi7OdT3F1TuH6wYEc93wl3Bog
	 7OKOm7Y1HZLndfKG1xFpdZHJfuQZ/lzhwpbsO9qE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0813/2151] iio: dac: ad5758: Fix alignment for DMA safety
Date: Wed, 18 Nov 2026 15:42:28 +0100
Message-ID: <20261118150151.716727432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arka Mondal <arka@arkamondal.net>

[ Upstream commit 465bdce79a9fe140a4b46b95f6bdfd880d197148 ]

ad5758_spi_reg_read() reads into st->d32[2] with spi_sync_transfer(),
but d32 is not marked __aligned(IIO_DMA_MINALIGN), so it can share a
cacheline with the fields before it. When DMA is not cache coherent,
the cache invalidation after the read can discard CPU writes to those
fields.

Mark d32 __aligned(IIO_DMA_MINALIGN). It is the last member of the
struct, so nothing comes after it.

Fixes: 28d1a7ac2a0d ("iio: dac: Add AD5758 support")
Signed-off-by: Arka Mondal <arka@arkamondal.net>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad5758.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ad5758.c b/drivers/iio/dac/ad5758.c
index 4ed4fda76ea97..27d5c460254ef 100644
--- a/drivers/iio/dac/ad5758.c
+++ b/drivers/iio/dac/ad5758.c
@@ -118,7 +118,7 @@ struct ad5758_state {
 	unsigned int dc_dc_ilim;
 	unsigned int slew_time;
 	bool pwr_down;
-	__be32 d32[3];
+	__be32 d32[3] __aligned(IIO_DMA_MINALIGN);
 };
 
 /*
-- 
2.53.0



