Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8ED12FB085;
	Wed, 28 Jan 2026 15:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615210; cv=none; b=TFrPh12o4KSEmRG4dp9nsyC+ojlw1rWRojILOynZlg8PtPfH/V9ZkOEOTOfnxLjXTcgnA09J5bxF5xfGZv9H2hPce8tIvaYUaxvLjKWM16AzaH2gXYfSQ0Vptt7tGABxF8W7Gv+Z7Uv5UA4QTQwAMIPcRvOnUOhRAimNUc9lbGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615210; c=relaxed/simple;
	bh=qw2WbEAzyypuxVChHLBNTZc7OXiOXf4NlrGPE+aOmkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s1O3Fvd/zqvNfJTHl3sh+8WVKIo6aMJ68FoThfq+J5cwjI+GgQdj9QUDHBMseDUachEqas9ujjnbrEXpZmkhZfmk7mfNRtwwSyqWzEYeqpfiSFt8CE/szjgdt305bo0oLqXsy1xiqRAHRjJYW15mg6FTY4fj3tzOrlrSImo844A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0EEoD3aV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0EEoD3aV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18655C4CEF1;
	Wed, 28 Jan 2026 15:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615210;
	bh=qw2WbEAzyypuxVChHLBNTZc7OXiOXf4NlrGPE+aOmkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0EEoD3aVty7Xs9YlwoxJLj/zxzdAFb46qMn0nghGiX6subQg4CoOGfnce+sizhkYO
	 0x6+19MHZTVMvH57HOHwXJUGtvUuhFaEYuLE5I8ZE4eP7Mdhe6aulm3nvR5/EP82ym
	 gG5A0elFNiDWMhXC02mf+BKE9K/4Mn/qN3DG8VBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andreas=20K=C3=BCbrich?= <andreas.kuebrich@spektra-dresden.de>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 110/169] iio: dac: ad5686: add AD5695R to ad5686_chip_info_tbl
Date: Wed, 28 Jan 2026 16:23:13 +0100
Message-ID: <20260128145337.966090556@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kübrich, Andreas <andreas.kuebrich@spektra-dresden.de>

commit 441ac29923c9172bc5e4b2c4f52ae756192f5715 upstream.

The chip info for this variant (I2C, four channels, 14 bit, internal
reference) seems to have been left out due to oversight, so
ad5686_chip_info_tbl[ID_AD5695R] is all zeroes. Initialisation of an
AD5695R still succeeds, but the resulting IIO device has no channels and no
/dev/iio:device* node.

Add the missing chip info to the table.

Fixes: 4177381b4401 ("iio:dac:ad5686: Add AD5671R/75R/94/94R/95R/96/96R support")
Signed-off-by: Andreas Kübrich <andreas.kuebrich@spektra-dresden.de>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5686.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/iio/dac/ad5686.c
+++ b/drivers/iio/dac/ad5686.c
@@ -434,6 +434,12 @@ static const struct ad5686_chip_info ad5
 		.num_channels = 4,
 		.regmap_type = AD5686_REGMAP,
 	},
+	[ID_AD5695R] = {
+		.channels = ad5685r_channels,
+		.int_vref_mv = 2500,
+		.num_channels = 4,
+		.regmap_type = AD5686_REGMAP,
+	},
 	[ID_AD5696] = {
 		.channels = ad5686_channels,
 		.num_channels = 4,


