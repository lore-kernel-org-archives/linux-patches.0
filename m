Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEC31D5141;
	Wed, 25 Feb 2026 01:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983504; cv=none; b=e23dG9BV/BfZWkQLMglbci+TOIXwqncBNaz49CxA46kP0BiDQZQNh35ZRnaGvXfj+htZyUByLjNZdYoAr2aO7R6yhfkpfdqnnAG5PtgOB8HFRfPbgn2b9dsLBtA+lrT98gvmeh7ZG/p4oCYp7FTVnuNVRSudmEgtT4H/DPGqtAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983504; c=relaxed/simple;
	bh=oe7536zB96Lrp6XkXJJ0UHvmJadlge8Uope1AjDLJXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2H5y2qDdpTgpIQaKxF+i4+C92FBzw9Dg7ALAozWydkd/wPEno7sYmTsarBomErBhx2ReTef5Apo3jE/rFJCq/iywKCwpII/39oqEHK33w3IFLtD71pritcpPg9hhP9zkJwh5wdprLdrrTG8yDozjjhDvUQXU6thpWW8oz6BGa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0QAcc4db; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0QAcc4db"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E73C116D0;
	Wed, 25 Feb 2026 01:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983504;
	bh=oe7536zB96Lrp6XkXJJ0UHvmJadlge8Uope1AjDLJXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0QAcc4dbpw3mOOQaY9Ye/ry8obV4ULfj2OAsneDEGb0XxjkmyUWBAvvLoTAcPF88C
	 3c8fsGxL8ZHoYlA3RJ942LsUGx0ObflS6Pf4QI+iJNjcRGGeK5Oa4Lkm6EIHQfXZJG
	 fv1qhMGP1RACpRUVRVmK54erBhrrT65Hq5gXc7CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petre Rodan <petre.rodan@subdimension.ro>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 577/781] iio: pressure: mprls0025pa: fix spi_transfer struct initialisation
Date: Tue, 24 Feb 2026 17:21:26 -0800
Message-ID: <20260225012413.952314896@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petre Rodan <petre.rodan@subdimension.ro>

[ Upstream commit 1e0ac56c92e26115cbc8cfc639843725cb3a7d6a ]

Make sure that the spi_transfer struct is zeroed out before use.

Fixes: a0858f0cd28e ("iio: pressure: mprls0025pa add SPI driver")
Signed-off-by: Petre Rodan <petre.rodan@subdimension.ro>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/mprls0025pa_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/pressure/mprls0025pa_spi.c b/drivers/iio/pressure/mprls0025pa_spi.c
index d04102f8a4a03..e6bb75de34119 100644
--- a/drivers/iio/pressure/mprls0025pa_spi.c
+++ b/drivers/iio/pressure/mprls0025pa_spi.c
@@ -40,7 +40,7 @@ static int mpr_spi_xfer(struct mpr_data *data, const u8 cmd, const u8 pkt_len)
 {
 	struct spi_device *spi = to_spi_device(data->dev);
 	struct mpr_spi_buf *buf = spi_get_drvdata(spi);
-	struct spi_transfer xfer;
+	struct spi_transfer xfer = { };
 
 	if (pkt_len > MPR_MEASUREMENT_RD_SIZE)
 		return -EOVERFLOW;
-- 
2.51.0



