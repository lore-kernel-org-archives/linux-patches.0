Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060955;
	b=ciOTotNNQZ6/FfJTc7IDX9nD+mDlnSdnPyQg5Z/FHotBH9y4tA9tkfyssZpFLQwReYOX
	 3EYADbROs/w7DGgUXbj5Z9IPhVLzE7EKE50IGFKX6Bc0YlTdZ9ymo7vD0P4gP4lCxDvuG
	 u0TMX+NX7IBl8ERg/E7+RenX1MIXwMftMsLvEo+Kgi9oZXxR9QKdQhxdvd0opXIUBaWvb
	 Cs7GKq9S6rGjJwl4R/wUMh04vUKUxLq9KHcMDtqKYW2INaeM8YuM3J+52VhTnvJtZ1JQ8
	 tf9AUMChxSaphlnq8SYe/s4IEbUTH3d0u2qgMEEwHr+n4kDB4YrN8xW85VwNVfMsXQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2UzizEm42s+8LCXttSRoRhcR8DHL+UVeZK5W45aPG3g=;
	b=IlEH/bqIeLRBCMUkjaFXb9IF+ZmKPgHMBcWDbb6UZ3VIZoaE8MBpi4lfus941H4PXvej
	 /IB5rUCBY0pl2njb0P40T2k8J3AHMPm57x5m4qIIkC+9ZSDBuu6fAj7JZ26hsa3L2kDT4
	 btvQvh5LzgPecuQTbhtRDy/7mGM4LlcZ7LmRKGY1PeOTiwcXVKeNVnQX9E7SHgy1Ow+03
	 uiTPNENTdGbXz/BYJHmWi4lXmBvYr+pExm/8NOxKrpL+buKKhrPXYe7hVwYcecG/7ZZ+8
	 FJOOIk+P701gZ4rNZc/6F0sMSa4SOiJkPYZtXHYOiZU9zwbHWkOykBBpJ+BdvbeLdPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tyRhAKcg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AAD606A325;
	Thu, 19 Nov 2026 04:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tyRhAKcg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC02C1F000C4;
	Thu, 19 Nov 2026 04:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060955;
	bh=2UzizEm42s+8LCXttSRoRhcR8DHL+UVeZK5W45aPG3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tyRhAKcgFp9Qmw2Y+oZAHV3p4gW3ZNNYbph4axd0v5KWEF4HUYvJgiZlOl5T1V7zf
	 6x5FSxP8HE4Rg7uG9OY3k6xNwnAewrKCa0A0ufqc3Nat6LnnjmzO0Bz79PV6jejjta
	 /QM4b9yighz3uygcPcMbUJoFDc7/7FDp9yLCCYNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1385/1848] iio: dac: ad5758: Reject out-of-range raw values
Date: Wed, 18 Nov 2026 15:57:03 +0100
Message-ID: <20261118150017.450757604@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arka Mondal <arka@arkamondal.net>

[ Upstream commit ebc026be1b719e47bd7f2f1e72fabc875b590f87 ]

ad5758_write_raw() passes the value from userspace straight to
ad5758_spi_reg_write(), which keeps only the low 16 bits. Writing -1
to the raw attribute gives full-scale output, and 65536 gives code 0.

Return -EINVAL for values outside 0 to U16_MAX, as ad5755 does.

Fixes: 28d1a7ac2a0d ("iio: dac: Add AD5758 support")
Signed-off-by: Arka Mondal <arka@arkamondal.net>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad5758.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/dac/ad5758.c b/drivers/iio/dac/ad5758.c
index bd9ac8359d986..0b1ecc3b7a9e0 100644
--- a/drivers/iio/dac/ad5758.c
+++ b/drivers/iio/dac/ad5758.c
@@ -558,6 +558,9 @@ static int ad5758_write_raw(struct iio_dev *indio_dev,
 
 	switch (info) {
 	case IIO_CHAN_INFO_RAW:
+		if (val < 0 || val > U16_MAX)
+			return -EINVAL;
+
 		mutex_lock(&st->lock);
 		ret = ad5758_spi_reg_write(st, AD5758_DAC_INPUT, val);
 		mutex_unlock(&st->lock);
-- 
2.53.0



