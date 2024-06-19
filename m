Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93A382495;
	Wed, 19 Jun 2024 13:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803216; cv=none; b=Y8EQbMs5Gtp551gs8FwwYHJje3wPwBC0cf9y87ko5o6/U3k6zzojyOqNdzUSsUAur2LTkAkTOxCWKrdobWAbgPEf0bOJkaSu8tfwAQPrh9YmMBSE8dBw+cZOSCe9BLQKlwijq0VOJL/2uW1K/4YMcaIFQqGjbhELXhzbAo1DwdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803216; c=relaxed/simple;
	bh=W9j/mLoXBdKVnOgGvdPIF3J/hw4CaDW2k7tpWLdxYME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tq9OIhlL4flZW1BV+j2J4PzawAPpLuuHMOXuFnEjOsDQOqSqOb91VQTifA/i7HIzL/FG3AVyHoWhwUpVpSRIxooEyE/78FgWCKDlvGGtXnBi1FbiDEFGlfr0CsH8OexABpH6NrdmIJPiCPAeqZm/b3NqzCS/g7hITt0dsK5CxaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/2NP2iX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/2NP2iX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB2CC2BBFC;
	Wed, 19 Jun 2024 13:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803216;
	bh=W9j/mLoXBdKVnOgGvdPIF3J/hw4CaDW2k7tpWLdxYME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/2NP2iX/cBHMyWiUJ11oaSX+SD1Ch9FpAmJZY3A+F7O9CBL6HQFl699gFKi1xM+R
	 t3rv2ssdkF6UaAwgB8b/rZbYKPvd5jCWxtHdxc8rxvStIRpuDYsrDgyE/8gPPfQNp+
	 milDuGTfzP3kXjoCd7bpJ9CJnrlqHXX2Q6i0k7ZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.9 193/281] iio: adc: ad9467: fix scan type sign
Date: Wed, 19 Jun 2024 14:55:52 +0200
Message-ID: <20240619125617.375978846@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit 8a01ef749b0a632f0e1f4ead0f08b3310d99fcb1 upstream.

According to the IIO documentation, the sign in the scan type should be
lower case. The ad9467 driver was incorrectly using upper case.

Fix by changing to lower case.

Fixes: 4606d0f4b05f ("iio: adc: ad9467: add support for AD9434 high-speed ADC")
Fixes: ad6797120238 ("iio: adc: ad9467: add support AD9467 ADC")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://lore.kernel.org/r/20240503-ad9467-fix-scan-type-sign-v1-1-c7a1a066ebb9@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad9467.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ad9467.c
+++ b/drivers/iio/adc/ad9467.c
@@ -225,11 +225,11 @@ static void __ad9467_get_scale(struct ad
 }
 
 static const struct iio_chan_spec ad9434_channels[] = {
-	AD9467_CHAN(0, 0, 12, 'S'),
+	AD9467_CHAN(0, 0, 12, 's'),
 };
 
 static const struct iio_chan_spec ad9467_channels[] = {
-	AD9467_CHAN(0, 0, 16, 'S'),
+	AD9467_CHAN(0, 0, 16, 's'),
 };
 
 static const struct ad9467_chip_info ad9467_chip_tbl = {


