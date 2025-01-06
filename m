Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B6D14900B;
	Mon,  6 Jan 2025 15:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177226; cv=none; b=XiwtTh7dMwMS5jgZzOXf4DajlLJG2RRRAX8rgEVx91bg58mjtNFnW/ldCjW3faFbg37nTiozYfppKxSgsGCQQiKZf9lwOq6J6JVLjdrRfomALzDGVk3ehFWDY232uMtLE1e51ggAMttGnMJ0paBypTcUcnaQC0j64//EnqTJx38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177226; c=relaxed/simple;
	bh=MBxd3thoNJtQTIRqIjiT5Vb9I0hLhRSwYNItWIE5WC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mt3noQskARxD4g/5ttPtsRTrunCqCtte8t1bvBwAhbRtMt7/et69tJ04Y2jlFkFKahjdsielg20FmZMEzn3ima+10nf9HlDwYwTGEdXRm9TdXjVELrKIA6RDFqc3IFL39SzOFD4o4KycjHDxr3U+2hg4igXiw7Tn0xKfYKs/6NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHRoBlPI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHRoBlPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A86C4CED2;
	Mon,  6 Jan 2025 15:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177226;
	bh=MBxd3thoNJtQTIRqIjiT5Vb9I0hLhRSwYNItWIE5WC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHRoBlPIMveptkhuaFz8AmYJenFCycZr3kwlF6jy6bI/qzPLJaE5gHjpsM2Ld5c3L
	 Oss/VW+MmI8GrAdtcQKJ9haeTXYbJBnQ/27+jd07jY2nTFGOH6iQF6ZOP8CedltNUV
	 MW8dI4sLcStqk2M9xpYDZBQoNtYZwKXJoz2HYDRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/222] iio: adc: ad7192: properly check spi_get_device_match_data()
Date: Mon,  6 Jan 2025 16:14:26 +0100
Message-ID: <20250106151152.955618405@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit b7f99fa1b64af2f696b13cec581cb4cd7d3982b8 ]

spi_get_device_match_data() can return a NULL pointer. Hence, let's
check for it.

Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://patch.msgid.link/20241014-fix-error-check-v1-1-089e1003d12f@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7192.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/adc/ad7192.c b/drivers/iio/adc/ad7192.c
index ecaf87af539b..fa6810aa6a4a 100644
--- a/drivers/iio/adc/ad7192.c
+++ b/drivers/iio/adc/ad7192.c
@@ -1039,6 +1039,9 @@ static int ad7192_probe(struct spi_device *spi)
 	st->int_vref_mv = ret / 1000;
 
 	st->chip_info = spi_get_device_match_data(spi);
+	if (!st->chip_info)
+		return -ENODEV;
+
 	indio_dev->name = st->chip_info->name;
 	indio_dev->modes = INDIO_DIRECT_MODE;
 
-- 
2.39.5



