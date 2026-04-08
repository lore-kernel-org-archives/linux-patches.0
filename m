Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A443537DF;
	Wed,  8 Apr 2026 18:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674754; cv=none; b=p/t+6tOOoiez1iEoeVgjjGAs5GavqOj/ADS5di7y00SRcrqUwZRl1tK9qcUKL6yi0E4x9s/POsF+zkVcxh2SvTYRdjjB1lsuaONBzY00V/6JZ0uJ6dRuLZ+Nl/Xh+B29eeRKq4akay134PwB0ZmU2pHxgOqKJmhAZE8Lwl39dVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674754; c=relaxed/simple;
	bh=HQ9lDhIPD7Qx9daQ3/fBAnOSIDv1rALpcNQ8r+aVUk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCRwdNij1dZQVhuK1DVGfR88+6UK2CQrhl3uW9TqEPv+mP01GeopT7E/VCwP+bqP3k+x7v7M2d3c2N/2gItRSj/U6q5j7eeUDmYQ9tDcddSTqKbihBcflfH6a2SPeYizZv5CxdYBHaEj3Jd2doLga5SsK+xn3i8byUxBxCKXheE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TabUKy95; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TabUKy95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67235C19421;
	Wed,  8 Apr 2026 18:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674754;
	bh=HQ9lDhIPD7Qx9daQ3/fBAnOSIDv1rALpcNQ8r+aVUk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TabUKy95bhqR+rWsAaRTM/ora00NFKo/CmCpkVr+lKJVY/dhIEx2BMREvfga0nWoo
	 kOsBE5TF1PYNPVa1+llvC0f+Rd1c7as8DQdPdxDOZtLpVjAB3PbZtlEAf2iV8qTeTS
	 yVc/CTFDzK8hrVs8kVCOk8+smV8Cdng0Tcm9BQpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valek Andrej <andrej.v@skyrain.eu>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 221/311] iio: accel: fix ADXL355 temperature signature value
Date: Wed,  8 Apr 2026 20:03:41 +0200
Message-ID: <20260408175947.654370683@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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
@@ -745,7 +745,7 @@ static const struct iio_chan_spec adxl35
 				      BIT(IIO_CHAN_INFO_OFFSET),
 		.scan_index = 3,
 		.scan_type = {
-			.sign = 's',
+			.sign = 'u',
 			.realbits = 12,
 			.storagebits = 16,
 			.endianness = IIO_BE,


