Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590705;
	b=GnnWU+JdwOJ35+Vzu7wJwuEl3u+yr0ZLiejDz6lCde6C9xILA6Qlj4hAc03OMPJNoXrA
	 XTSwBwFXFu/WKDLQs41pxlIPRjq/W0I8Jk9aj70ZrlrjD5BpMuavfmzOO9Pn4B0cXLxyY
	 FIOzaKsIWZ6M8h04yMCll86CKYF4orCE5kpyE+7A//miGBA2RA3JZFHQcZzfbTGX08Zv/
	 H8DN30YvcfQ232ksKvw/lqBKKcVilZs8Je+WB9ZJ2e2pYSsrTwqWDyLPM84R6loVQb5wI
	 CIZ01aRBwqJSMSTJhxXVWql9hDDO/QOz9NwHeW2H5BuA6EMjWl8GlJOu5gGbT6dFKNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=IPr9sDbgNwBx+YIT0n477Ep/uX5vYIEz126mz0vFxdE=;
	b=wIGAUzYd50nvbUDYoT/vZ7RC+6yjRGTesOj9KhvUe7JTCIEV+TZjb5I7JEnULEkuxpLF
	 nBaZsr3OM0/lP9iqZx49zhG+RcVzJk328+NrrRineeP+ApVuUhLuAtVK5QT7T5KDYwQNm
	 lrAXahPODlZ9MjaPljGyqcrMUZWUHcIyTErxJJ2JZ4a3bKzDasuqDgzjZlHN5PV0+o/yo
	 7CULIiUKXPknChbE/7ZTbloCkljnouMKlbmfm+bD/ct8nPFkB25rah7bJhaHORHjNvPLl
	 RdNp7sd4smd2672aCjX3ognflW1vMtPXC8yVp1DHw2zprdYUQ7AWYmQRuy5uRw36kwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G08Odvvj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037D9606B224;
	Fri, 13 Nov 2026 17:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G08Odvvj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43A21F000C6;
	Fri, 13 Nov 2026 17:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590704;
	bh=IPr9sDbgNwBx+YIT0n477Ep/uX5vYIEz126mz0vFxdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G08OdvvjWSdIeUjsTR6hdX6t50W8uSafQWWVfZ0BltPb4xzfBtIPzThiU+BMQ5Hba
	 UoFCK+FSHXQ0knTUk6WnbdGgkEYx3tKR5MD3K7CAlqaHb9MPi4AjSG6z5w78ntI8sm
	 8dwOT7MgT3neUk0UzIyeqPjSphvBaouzQz9Tpbc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 615/686] iio: adc: ad4080: enable address ascension for chip identification
Date: Fri, 13 Nov 2026 10:52:28 -0500
Message-ID: <20261113153842.720805765@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

[ Upstream commit c051d08d98771132868abf0cb95b6de95ab3060a ]

The two byte bulk read at AD4080_REG_PRODUCT_ID_L expects PRODUCT_ID_L
followed by PRODUCT_ID_H. After a software reset the AD408x defaults to
descending address mode, so the second byte comes from CHIP_TYPE (0x03)
instead. CHIP_TYPE reads 0x07 on all AD408x parts, so an AD4080 reports
0x0750 rather than 0x0050 and every part logs "Unrecognized CHIP_ID".

Set ADDR_ASC along with SDO_ENABLE before the read. This is the only
multi byte transfer in the driver, so no other access is affected.

Fixes: b66cddc8be72 ("iio: adc: ad4080: fix chip identification")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad4080.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad4080.c b/drivers/iio/adc/ad4080.c
index e15310fcd21a3..584f273c6bb35 100644
--- a/drivers/iio/adc/ad4080.c
+++ b/drivers/iio/adc/ad4080.c
@@ -455,7 +455,8 @@ static int ad4080_setup(struct iio_dev *indio_dev)
 		return ret;
 
 	ret = regmap_write(st->regmap, AD4080_REG_INTERFACE_CONFIG_A,
-			   AD4080_INTERFACE_CONFIG_A_SDO_ENABLE);
+			   AD4080_INTERFACE_CONFIG_A_SDO_ENABLE |
+			   AD4080_INTERFACE_CONFIG_A_ADDR_ASC);
 	if (ret)
 		return ret;
 
-- 
2.53.0



