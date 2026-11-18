Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048725;
	b=1/jflbniaSxiH+0abA4K4u9XePBT5Z8W/M/hq1HvxkJbMPCz+y3M2wT/LuUQuqq12E/5
	 s8lRIZMDCl1fgBw/2vy02h7N82ffAKeJPeKz3Y/KZH1i72UZChfCafphkKIlVUp4kz1hM
	 2w6VxrDvqLq4T+OBN+ANFSpapCfvFSKCTH8bh0UeZD8VpgZojsPSuO0dSaVbwkrTbSd/q
	 Hw0MUuIL5R4rozdhuVBxcJVEr6CZTW3sF1qoJKmSKWeWNg1hOqJbXOwcQHtoGTkLFakF2
	 /TJXKca0B6gxSgFlvw89Q3sLi+YLmPQePLaZWWHaXB+IeMztKSc2wcXvZocsWJU04NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=PHoRcuBnW3yn7uK5p0CFkzQZxiG5T6vi7p+v3PcVOqA=;
	b=D28QXM82s7GP0GCAsAqig5vhNrfZKzo4+PHmAtKtYHQUKLh+lsAewLnE67NwOZ7xFmv4
	 qNgJgLU/YykYiFf+aZP837PkKQALCAF6hGok1FU26PG+ozTkek9KUOveLj3GCd8mCH1oj
	 uxDQMQ98KrEUK0h/LD4H/Uhu9/LH/MVVlT+MXA6T5VqExUihRAPdiiwZUMbpeTq2Jcp/A
	 YrTg9W0iEtWS6NSQDLWq5nei5bXak5XXAqno56XGZaEUsAuTrXJuyB4/3zSdlBifPGX62
	 rAr0hkOHjlDjxDXhMvMTXyVagDJ74/MYkZT71CgBOfXBipLBSAgXvLBenYcEP8na3UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v8Up0IS1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9E2606A325;
	Thu, 19 Nov 2026 00:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v8Up0IS1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBDE1F000C4;
	Thu, 19 Nov 2026 00:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048724;
	bh=PHoRcuBnW3yn7uK5p0CFkzQZxiG5T6vi7p+v3PcVOqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v8Up0IS1J5HFmGssmtpP/0dXSUCz/sKbozjkkZx1YdusvQQdbViYbVjEbBTNzXpkF
	 5E4ZNu197ddca3oiqK0YXdEtz1tfKBpCchq+hmGWb+zpspqfIgU9PQBTmMzUPvPZjF
	 QugBsFA/LRmf6a/XOYFhvAC0euCUqD7ephMump24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2097/2857] iio: dac: ad5758: Fix alignment for DMA safety
Date: Wed, 18 Nov 2026 15:52:11 +0100
Message-ID: <20261118150316.910804013@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



