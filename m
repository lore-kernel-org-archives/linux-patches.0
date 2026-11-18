Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043006;
	b=yxB8F6Plfhk5HbgPUerVtkBpwpqS/YjjeAEUa/s53H6Ao9EX/BRYz/j4tCvhP63fBWwL
	 iC9EQPv43ILdSXUFSEHV7GAsHNpc0RCLf8s5ZIKMHf8ltXduywYfYzwsHbRcE74BGXDx7
	 vzbtCbnLTImeTCI/atUXyjwEyw1bPq4mBp1HWAESDdZhX8EclZp+Z9uUvIIoZ03BTe8li
	 T2x/goml0xgCmnmOk9NwltbXawlk553ZDi4Lhsrac2MW65+r3TUSIBcmeOadFKBdcMClN
	 yJWpTcBy46o8ff8UwHmKosjP5GRefIeuibsrST2ifrKkYIS1MKjxqd4MANnnKrQDTGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ISvAPnJ2bcnM5xVukRZShH+MZcKjs/cKKNrSdriKF18=;
	b=bv8h9y1Ja1rgOdCPTfryD+ncYImfvljY51EeUE/MhVo7S7hyHSQjwIEe+fSDB6FHW0HA
	 z3TDWUePadl/l3Pw0pCSu/5RvfscfGoKZtGOdUtu9VqhH/dvCtIxspRD911jJOSEWerap
	 yWQAG4hxq+eRLE4HwDdzek0RwbXVltmHv87mR4unRen1N84LxwJfHFgUowuKPBkD9AnhX
	 aaI/N/E2p71reySR4/41FRFBP0QmPQ+H4syD1dLyWLN27MTryPOmMjfKhqfJr1F1OlsX8
	 6dbtOiupypI0oXw0jI//WhPxOOrTDlJd/cL9hcCh2/auMximlSVauaN07ZDxVShpD4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A9xpxvj7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4955606A31C;
	Wed, 18 Nov 2026 23:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A9xpxvj7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6ED1F000C5;
	Wed, 18 Nov 2026 23:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043006;
	bh=ISvAPnJ2bcnM5xVukRZShH+MZcKjs/cKKNrSdriKF18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A9xpxvj7BQYw/MEMCbmttc8mcGxSFH7PNUOXGM9REN/7ugquqGbLo2jBxudTmXu9m
	 QS8goXeUyzjwJOghUHOA/ocAnOeRHb6wm39S9VEJhpFBtM0vFeyzxJSY3OQDwtI4EZ
	 GmJL0LZUyH4Cd5sIfTD1qp8xpD9V5CG/oS+6oN1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0055/2857] iio: adc: max1241: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:18:09 +0100
Message-ID: <20261118150203.290443038@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 790a2080e0c9eabefea3561dec301172043de236 ]

The driver has a match table for the spi bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/max1241.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/max1241.c b/drivers/iio/adc/max1241.c
index a815ad1f6913b..4520f9b48eaac 100644
--- a/drivers/iio/adc/max1241.c
+++ b/drivers/iio/adc/max1241.c
@@ -201,6 +201,7 @@ static const struct spi_device_id max1241_id[] = {
 	{ "max1241", max1241 },
 	{}
 };
+MODULE_DEVICE_TABLE(spi, max1241_id);
 
 static const struct of_device_id max1241_dt_ids[] = {
 	{ .compatible = "maxim,max1241" },
-- 
2.53.0



