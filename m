Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A641C173C;
	Mon, 12 May 2025 17:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072143; cv=none; b=JUPkpH+qzeopJnYALes7Q4K060uAa2pzNwCFn63fQydyF0yFMpTEkp7GefSdLlvor8EROldXRf88lb6rh8iXYtX0KUcRJDPYLXFPKoR6UUdA57MCnxbYuFSu63NgzvQqBNNkf9tzm/EsV9wCi7aULWXjxXkdj+5270OxAkosYls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072143; c=relaxed/simple;
	bh=LHp79cFcqLpTzmfMV0E6nw0KrvUGOEZ6STS2nSXMw4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DrRnR9/KYPC98tp1VRTQ0/wsvQRnxslbCbnX2vmeSbJfStRvymLRV5tVd7SiJowyJfwGptFh8LcWFl2WMtCfpv+lFemGkM82OZBbHHfiUfH99Mxz2VgD/3f7cpYpkPMcvHyeznwR3Ru7MA2Wgj2TlxPhrnC/MEsClpNPdZDoQgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=arDFYOl6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arDFYOl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7072C4CEE7;
	Mon, 12 May 2025 17:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072143;
	bh=LHp79cFcqLpTzmfMV0E6nw0KrvUGOEZ6STS2nSXMw4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arDFYOl6pfMz2pbtN2IfLTVrC7RJCb/rPhsj0wXAhGvuQRfN/gQgqmuSUdASQwMPk
	 NhEaPrW/uZosLuVijMmV2cspZyEshygPCeHf9L2MAd+7G9mq6IVtSD6LZfMfSSz9hn
	 MaJ6aymsSi/BhX3Cy5arO8Vjq83gYMedMlA69IU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 152/197] iio: accel: adxl355: Make timestamp 64-bit aligned using aligned_s64
Date: Mon, 12 May 2025 19:40:02 +0200
Message-ID: <20250512172050.580258098@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 1bb942287e05dc4c304a003ea85e6dd9a5e7db39 ]

The IIO ABI requires 64-bit aligned timestamps. In this case insufficient
padding would have been added on architectures where an s64 is only 32-bit
aligned.  Use aligned_s64 to enforce the correct alignment.

Fixes: 327a0eaf19d5 ("iio: accel: adxl355: Add triggered buffer support")
Reported-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250413103443.2420727-5-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/adxl355_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/adxl355_core.c b/drivers/iio/accel/adxl355_core.c
index e8cd21fa77a69..cbac622ef8211 100644
--- a/drivers/iio/accel/adxl355_core.c
+++ b/drivers/iio/accel/adxl355_core.c
@@ -231,7 +231,7 @@ struct adxl355_data {
 		u8 transf_buf[3];
 		struct {
 			u8 buf[14];
-			s64 ts;
+			aligned_s64 ts;
 		} buffer;
 	} __aligned(IIO_DMA_MINALIGN);
 };
-- 
2.39.5



