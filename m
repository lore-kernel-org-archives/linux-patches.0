Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040312;
	b=V3r1G28lENn6fMwvhqCHURJOVvV7C5+MqZ+i5/4GEpc0wlBRf4OtqrcnqGO+DTOLzwUW
	 3KN+TbTi7oPuOB7vgmV7117P19C6aV350mzLSeKX7YgIuuK4KgVJgc6wbn/j3J+21cebW
	 LeRzJXAJXSLNorRqPktqR/NJxwNYM526Qcp6GRV5YuYHA6xF8GKd5q7nT29bQuGoXFE+X
	 Z/S6vbVBeOjBJlFNCdlla7k7X9+35WLmXaGSso8WyA1n+gu3Qp2Edrm+IjdFQFCC/OwyR
	 qjp/fWQ2DLO1COmSjYd1J+NLTJuHm1h991Ue7HV6f7E3/G4837nWo16bA0UyZeOOh0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040312;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=7r+KKZC+2pb1b7bchT7VIoCKsZDNf0zj8uZzIlrn1MU=;
	b=uWTimMUFHKDw+XG8IPWxuYLmhqKtvxZSXpMnwT/u/JGL+Lmw7fSOQ5ZCHVLnG4MWgmwS
	 Mbv2A8T0bkrdYoaa8TFHyf/Giq08eUQjQrHG29VRMSxwTufX+up3xWvPjI1VWqrRv9eNL
	 AsVVfdQ8688hK8ZUUSrSqPd5Uugvz+O9FBCd6DgP42TPMYFe3CaD5lGcuQcE3Tm7Ua2bY
	 f2tAe+yZ/LHzZVOKoUBPfOD76jwSwlaGoyInbNfPCOZooN2WNzrUHukCmvohBzw0fklFg
	 +ryEhyv3UFDAjQP947G9PhvS4+P36RBD+QK+cKSEy1wXXsIVzP9Aw6GVI+B4Mc/4saw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="j+v/Fb2S";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8612606A320;
	Wed, 18 Nov 2026 22:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j+v/Fb2S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217651F000C4;
	Wed, 18 Nov 2026 22:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040312;
	bh=7r+KKZC+2pb1b7bchT7VIoCKsZDNf0zj8uZzIlrn1MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j+v/Fb2SfqB3Z78kebYC1n6YzMJIYXyqgThOESG+6G18rkai046pdCmN79qAcPkc/
	 ujU2Spx4jLSo0fojKEcCZgDgY0IMax7fprA05V7LgNnurWbafAeGAcvdmykAZJ/tcM
	 fnNcTyjwQFimgnFhHSda0W7OWo9kDEv/F4Vyc4BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2413/3318] iio: dac: ad5758: Fix alignment for DMA safety
Date: Wed, 18 Nov 2026 15:50:35 +0100
Message-ID: <20261118150433.879455166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 98771e37a7b52..d7fd2acd7dfee 100644
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



