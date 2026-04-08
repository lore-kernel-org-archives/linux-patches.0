Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35588B67E;
	Wed,  8 Apr 2026 18:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672175; cv=none; b=cbtsEnzidQ1pO71JPnIq2SM7AorrZZrdOoq4qbi5vrwprfc3rlOBHQ9giCTSpXvRFGxLWUVBo/TlflXQsGaC8vEi5VBRkhqNb2osFqBODnDKO2aY/Z9OYNnrgjvqdMy7VHEQTERD6/9QM2CAtZF5u88YUarNtKZJJGCUG1tBmVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672175; c=relaxed/simple;
	bh=pTHJpJn2xJnkjX58RAL1MWGnEKSjOWb5Qak3kHHZsSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X20dY/NCC3WpdI4ynvDMUvyVu6qijg/MVaQnXp/BilB/OpyLUTyxljUNLfp8gUaTNmwDd6MSSIMLth+ta35wezDuEVN0LC880zfuWv8awI5T6K7z71DkvJdA7lJfbaEObvtUVymV7CmE1nTyXz0dkooNvkXH4/6FrSH/JoYioTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BdHt/Cio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdHt/Cio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15E8C19421;
	Wed,  8 Apr 2026 18:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672175;
	bh=pTHJpJn2xJnkjX58RAL1MWGnEKSjOWb5Qak3kHHZsSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BdHt/Ciofmpx8vfdfjCvrSv3ZM09PG0jvVvzyJ3y3w98MyzkplHDcCM6npHxS1xZZ
	 BDZAnYQgt+9O1odg0aKFxjIgqF+pKaV2X8W36Taa/wz06fnPbAbGO90f//Y+HDQl5E
	 X01uVo2fKH7Efev/yRaTw2ArUC/uXTgOVETHXx3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valek Andrej <andrej.v@skyrain.eu>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 218/312] iio: accel: fix ADXL355 temperature signature value
Date: Wed,  8 Apr 2026 20:02:15 +0200
Message-ID: <20260408175941.900331390@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valek Andrej <andrej.v@skyrain.eu>

commit 4f51e6c0baae80e52bd013092e82a55678be31fc upstream.

Temperature was wrongly represented as 12-bit signed, confirmed by checking
the datasheet. Even if the temperature is negative, the value in the
register stays unsigned.

Fixes: 12ed27863ea3 iio: accel: Add driver support for ADXL355
Signed-off-by: Valek Andrej <andrej.v@skyrain.eu>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/adxl355_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/accel/adxl355_core.c
+++ b/drivers/iio/accel/adxl355_core.c
@@ -699,7 +699,7 @@ static const struct iio_chan_spec adxl35
 				      BIT(IIO_CHAN_INFO_OFFSET),
 		.scan_index = 3,
 		.scan_type = {
-			.sign = 's',
+			.sign = 'u',
 			.realbits = 12,
 			.storagebits = 16,
 			.endianness = IIO_BE,


