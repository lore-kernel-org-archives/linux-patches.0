Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1EB2D77FF;
	Wed, 28 Jan 2026 15:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614615; cv=none; b=W8fBzux19OjiQ6mY0VBxQmZ1iEtDnLTSe+cV+HgATJMzVZTuryzAjehV3Icw0ZzunmN2brvHyQgzNJy8WcRqoLosjQEKNzSuVB1vJHuo5PN6xUpJZD8INEcieX9m0wJz6yWsloat++GXsrsS7QI3qlSkSMd84SRRbMbVlVZUpAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614615; c=relaxed/simple;
	bh=BthJTBUs7J5mWyvwJUF7klpxDI6++B4vNOr7yg6551I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gmlYCccMtVM+U8y9YmLUn7JGTk4fYGyQEYAXjrflk+na6byo/M2I/AAoIrey8TItpHHzB6iyrqv0Q/po+uXUc0uRv2rsvSP5KTcpxHjx4SjDSc7HiJZ5CeXElSjw6rYcTKjv/pnAupl9Y8UUhwRzLoj4EgsT7k4KUEEfUwXFDws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LvbSGMSN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LvbSGMSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1812C4CEF1;
	Wed, 28 Jan 2026 15:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614615;
	bh=BthJTBUs7J5mWyvwJUF7klpxDI6++B4vNOr7yg6551I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LvbSGMSNpAqWmZ/dYm33hiGpOxcAcizY3sAeW7VjUGr/+WRS7xJP+hT10VqMbk7Qp
	 i8PwCxvWH6Q0MjLqjl9EMdsO7zmFR+ojfrl+ZJptpZeJ1YTDXxzG7B8GsDB8iCWMFH
	 WncdIC2HNeypXEj+YWAqH1qJdKChSsraXlbT/Qs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andreas=20K=C3=BCbrich?= <andreas.kuebrich@spektra-dresden.de>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 191/254] iio: dac: ad5686: add AD5695R to ad5686_chip_info_tbl
Date: Wed, 28 Jan 2026 16:22:47 +0100
Message-ID: <20260128145351.672257911@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


