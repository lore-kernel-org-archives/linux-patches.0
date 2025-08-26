Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6250221FC3;
	Tue, 26 Aug 2025 11:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207729; cv=none; b=JE2AcSvqScQktV8ZWABh/ZQNouvYdHrdB6t9K0kT2OPb1GB8n+vIVxEbhJFsijKjksZFSQcl2RwHsFvnxMFKSLpV/Wt6ybHq/hQwGVpQOPpbDfp3t9MCXp+MMDdRCK6NUOm51sheihynt6FvmN8aJ0eWAXVVCXLPkYgVcoTfD5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207729; c=relaxed/simple;
	bh=Re6TdDaNA0KmN05WMcIcLPsHClB3qKVlWmI77Wzp/FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKVe2suv64lRYPBV7Pu5LRcLRar54IPNtZfCkMscVcPx01ikCF2wF3Uar2MGuLUmYKVLjMViMJU2RlMpS6t3qc7jVJvtZpx5YciY3kzIJKS9dCjfLGoVwvhV//SuWSyLiceXE+JJvLi/kLnDlch16u71KfngJVmzddxmIxH6d0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKxM30nA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKxM30nA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02989C4CEF1;
	Tue, 26 Aug 2025 11:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207729;
	bh=Re6TdDaNA0KmN05WMcIcLPsHClB3qKVlWmI77Wzp/FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKxM30nALBHPZrxmQpfSIdurwsf67R+EFKgRTGzVtFwt/WlCQQ9SU/BLkYStRaWrC
	 VWZ+Rro6nDizt8gp4mTcaIOqZ6m/naR8yLxXXMOqf1plvVjWyA5noIss6Pz0zjXvmd
	 ERo2RK0vKgOApzPsZrWnFF3K4U2KP3PAR2xVZLSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Andy Shevchenko <andy@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.16 295/457] iio: adc: ad7380: fix missing max_conversion_rate_hz on adaq4381-4
Date: Tue, 26 Aug 2025 13:09:39 +0200
Message-ID: <20250826110944.671482830@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit b04e4551893fb8a06106a175ed7055d41a9279c4 upstream.

Add max_conversion_rate_hz to the chip info for "adaq4381-4". Without
this, the driver fails to probe because it tries to set the initial
sample rate to 0 Hz, which is not valid.

Fixes: bbeaec81a03e ("iio: ad7380: add support for SPI offload")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://patch.msgid.link/20250811-iio-adc-ad7380-fix-missing-max_conversion_rate_hs-on-ad4381-4-v1-1-ffb728d7a71c@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7380.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/ad7380.c b/drivers/iio/adc/ad7380.c
index 6f7034b6c266..fa251dc1aae6 100644
--- a/drivers/iio/adc/ad7380.c
+++ b/drivers/iio/adc/ad7380.c
@@ -873,6 +873,7 @@ static const struct ad7380_chip_info adaq4381_4_chip_info = {
 	.has_hardware_gain = true,
 	.available_scan_masks = ad7380_4_channel_scan_masks,
 	.timing_specs = &ad7380_4_timing,
+	.max_conversion_rate_hz = 4 * MEGA,
 };
 
 static const struct spi_offload_config ad7380_offload_config = {
-- 
2.50.1



