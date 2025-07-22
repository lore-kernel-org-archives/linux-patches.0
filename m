Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC21FA32;
	Tue, 22 Jul 2025 14:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192932; cv=none; b=bFRKs27VP0PB4QI7rlbHl19DDA1n9y6uBh+mbU+e+IFo/rGKmjz9PcPYvyFTnUmCVztb5kTWNqdF1tVa6W9GiBJGjr/bbDx/uR6h/opAqRFURXitDWTWnICKms1zGJniPBVUGSMjvVJbFIACu9OztwcC8GOkCBKHsciNXB5o3ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192932; c=relaxed/simple;
	bh=J5+h4I/pINuYt2rXZzpXYWW6s3RuzFacV+OltdeKcQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMCrVwPAlVDVL4MOOk1z3ysIyrAT561/GlIvc7r2MLvzn20Y4CV/77ux5Y/nEg4NAItsd/m982GH5ZMIGdgHc9Xc+dI/KhsInn8g7gNNaGhZIuoiMtjhGJ23/CX6patt//QEny594+ZuocFThuLyQN7oMAsZ/ESmjL/dkLstcWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fgjJf0XQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fgjJf0XQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A381C4CEEB;
	Tue, 22 Jul 2025 14:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192932;
	bh=J5+h4I/pINuYt2rXZzpXYWW6s3RuzFacV+OltdeKcQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fgjJf0XQPjl9ZYHJ82cKIiX460tCuzSikOHvotD2cMoKwra1zj3jtPCOtjVFkq2Kx
	 DOUjm1A7zrvI4bJ3UqwpebUgJwKNX9HEpKe1wX0P9zCmSxC1AvtPqNPGKjMcRGlUlP
	 PE/v0tcOTZzGO9tFM+bbProibR/LIqe1kWjRVkZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@csie.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 068/158] iio: adc: axp20x_adc: Add missing sentinel to AXP717 ADC channel maps
Date: Tue, 22 Jul 2025 15:44:12 +0200
Message-ID: <20250722134343.310649752@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wens@csie.org>

commit 3281ddcea6429f7bc1fdb39d407752dd1371aba9 upstream.

The AXP717 ADC channel maps is missing a sentinel entry at the end. This
causes a KASAN warning.

Add the missing sentinel entry.

Fixes: 5ba0cb92584b ("iio: adc: axp20x_adc: add support for AXP717 ADC")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Link: https://patch.msgid.link/20250607135627.2086850-1-wens@kernel.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/axp20x_adc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/axp20x_adc.c
+++ b/drivers/iio/adc/axp20x_adc.c
@@ -217,6 +217,7 @@ static struct iio_map axp717_maps[] = {
 		.consumer_channel = "batt_chrg_i",
 		.adc_channel_label = "batt_chrg_i",
 	},
+	{ }
 };
 
 /*


