Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D03242D7F;
	Wed, 28 Jan 2026 15:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615964; cv=none; b=RSuCfTZflIsOhObH+fDuDYP7lu0nMnV5D76fhXzz0xAq1tWhH+lHjMsS2r2y6tkHOdVyWUHbp3SpwKMjo2MEpsqsd/kOs4OgTqbbxPgKRU9bwXzdZSYQ2UCirnc+gCISnuAlin9qTyiQsQ3DI3kKDhoijEOXy7yFjL8YXJsLhUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615964; c=relaxed/simple;
	bh=b6JcWIl61CFND0AK9R17ARV/HUz2LnG/x/W1z3q+rIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K9wabBU75yjiIATzdBfeTKraZnSYOFKv7hgxW4ivywGjP68ZnJ4+mc0BAFbBD34WDSAG3DjPKl4zPJOAvMO3KbS9pMYsZ1luGQkWSWszz+FDsZw9/AGxOtvmm0D8lxySPoc3GO6LkJBIc8gNF4Xa4OxlsEegofSwM1pQFJHbHm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F1bt/VYr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F1bt/VYr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5263C4CEF1;
	Wed, 28 Jan 2026 15:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615964;
	bh=b6JcWIl61CFND0AK9R17ARV/HUz2LnG/x/W1z3q+rIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F1bt/VYrDgr9vz/D5jR9KHNTOUHa6g2CT3mLGqk050EyKHfYkOeBbl0otEmZwG5w9
	 km5A76xppGRjwJPKDT1nharO847XuwkTKS9p/dJhwMcsQyXgz3baFMBMTroECSk/nN
	 aC6XhnQIH1Pz+jeTz7bMGxbBtw6xjge4aBUghUlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andreas=20K=C3=BCbrich?= <andreas.kuebrich@spektra-dresden.de>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 165/227] iio: dac: ad5686: add AD5695R to ad5686_chip_info_tbl
Date: Wed, 28 Jan 2026 16:23:30 +0100
Message-ID: <20260128145350.389741309@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


