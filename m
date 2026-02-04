Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CC3244675;
	Wed,  4 Feb 2026 14:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216453; cv=none; b=aC2z3wafIwQJZES5/swa4cQItaSmYOY6tMVI5aIV6gG/7dX1Y6P1SqiLQeKCw1KPUrE7cpBoxkwQp39gEmIE/k85l52TyHjr5sXUPI/knoXy8kNgBH5HxKcXUBJ/PTrwxX7UWNw6QjdEfCVzvQ0zfn9SOWDB1CSBhxbST27YWBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216453; c=relaxed/simple;
	bh=HLRAy30et5aVHBLvzIoXybDCq5FEwiUZZS/z6Jy7UV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p0kAtPYk1rss9TxbXfXiJMIMvnJ1kbgFoQPGJz8FU/NhOyia2ziUuQCgAQVSjrjgzry7QYsWW9kgsPhQb1emDfcof6VWwYG4PFG+gdgrstrE/Fxoh5xO3DSC+790Xqp3Tb0JmLCYrMCt1DJ4WdpFBut52i1b/IElgFSyGJxmtX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zVADDEz7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zVADDEz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB0CC4CEF7;
	Wed,  4 Feb 2026 14:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216453;
	bh=HLRAy30et5aVHBLvzIoXybDCq5FEwiUZZS/z6Jy7UV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zVADDEz7KkdnHMDxO6sTA76WwjJCsvWBWhmUWTTOR+lQS3MZPzA/kS7kUN0YUN4RW
	 KwWm4c9Lj8CsTAwbYKf1YOe2bXkQ21UZfDsU8/I/xY0b2b9msVXDra4nYjz060IU5u
	 psesHHQ6zwMe/QDXVdnvL8jouJn19F3C/sXaY+WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andreas=20K=C3=BCbrich?= <andreas.kuebrich@spektra-dresden.de>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 091/161] iio: dac: ad5686: add AD5695R to ad5686_chip_info_tbl
Date: Wed,  4 Feb 2026 15:39:14 +0100
Message-ID: <20260204143855.019784167@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -402,6 +402,12 @@ static const struct ad5686_chip_info ad5
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


