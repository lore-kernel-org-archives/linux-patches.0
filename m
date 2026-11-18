Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050951;
	b=qypcKHgXKUWHPwYaXMFbuSAemOqq7EUTV3U7of+15lPjZqhO5yca9MmN03gL1Z+2vgRB
	 2oU0Ix6BJNFWUzcRJThCR3dzKWl/EuK/C8vNzbszsSd7RdXmMi9KnMxpgy24IWsEzMdfL
	 rvES/OKr2t2S0x01z/m8Egy5r4QJye9UNDTjdF8ax0Zxy94GN3mPgotK9SwEij4JH6G6u
	 uiDBe7Wq1S15ZH36JG+scK6VnCuxMFcKCzgZZ7QDyRyBoJ4XBtKcFgkLSCUF5OqmuS8sK
	 zFZZe4MyXOAV3JEfPiMJz8HDTGkwEmJUDdIWf4Hd8B0t52GLTt3p0i1ERiwCp9/i1lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8h6qrWYAzFAx8WhYsmNGlLVnhn6iBojtDR05UDzqPu0=;
	b=pktjMDi9u8pAAb/Z83bYNCTW8U15zowvcF3oe5O7V6+gGgnNYspPO/dxaOad/qWwVw2s
	 ALotNd4Skc/HHRsHXIAOoafzEyty0cxbN3UvkAXtiNpdKOW6Y+sUvyUvEVMOgEZATuZ81
	 Hi5HeM0qSW8hxESqlBjf21TDtjDOCQ+5nazP05pwnKSSRpCgnml4JTd0MUOsaxNVoAV9H
	 jC9Rnn0ZRQGHFEbyxN6fYFY7+Vq5Eame4zJRW45H2tT5qcJWiTAhQQapuulvWCQTyTx75
	 rKxds4cYufXOW/wgW9S2whq2y7+hbboduuYeRGg2EG0bIDkYBYvikWDWsUT+QKYMf4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="PmxyZC/8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70614606A33F;
	Thu, 19 Nov 2026 01:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PmxyZC/8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8A11F000C9;
	Thu, 19 Nov 2026 01:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050951;
	bh=8h6qrWYAzFAx8WhYsmNGlLVnhn6iBojtDR05UDzqPu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PmxyZC/8teQzn3/JvV/MzAumVrSDpgipffN0+WSUc+7+sBZ0O6xR2qag9zVK0qyTR
	 No6M3YLkBtiHZQrQOjY1Bccy8DkHgs4C4pUG6v/Me1/z668gI/FpRN0ANEWL/huqSA
	 UaDmBwGoQkfS7mJxIgA1Yc0c267n8vcafnPww3Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0035/2214] iio: accel: fxls8962af: clamp the device-reported FIFO sample count
Date: Wed, 18 Nov 2026 15:28:31 +0100
Message-ID: <20261118150011.489448568@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 2f8225b91eb478ca2e9aec8aaef4d229765bcebe ]

fxls8962af_fifo_flush() transfers the sample count the device reports in
BUF_STATUS into an on-stack buffer sized for FXLS8962AF_FIFO_LENGTH (32)
samples, but the count is a 6-bit field (0..63) that is only checked for
zero. A device, or an attacker on the I2C/SPI bus, reporting 33..63
overflows the buffer by up to 186 bytes: a stack out-of-bounds write.

Clamp the count to FXLS8962AF_FIFO_LENGTH before the transfer, mirroring
the clamp already applied in fxls8962af_set_watermark(). Conforming
hardware reports at most that many samples and is unaffected.

Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/fxls8962af-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/accel/fxls8962af-core.c b/drivers/iio/accel/fxls8962af-core.c
index deff8ceb42fa1..8ea12a051a2be 100644
--- a/drivers/iio/accel/fxls8962af-core.c
+++ b/drivers/iio/accel/fxls8962af-core.c
@@ -709,6 +709,8 @@ static int fxls8962af_fifo_flush(struct iio_dev *indio_dev)
 	if (!count)
 		return 0;
 
+	count = min(count, FXLS8962AF_FIFO_LENGTH);
+
 	data->old_timestamp = data->timestamp;
 	data->timestamp = iio_get_time_ns(indio_dev);
 
-- 
2.53.0



