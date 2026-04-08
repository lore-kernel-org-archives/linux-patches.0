Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D893624B0;
	Wed,  8 Apr 2026 18:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673379; cv=none; b=C3uBC4YpNPU6MxF/3BzQ8fVqdy8ppgY+iTRF70GYvK6Qk8CnkenN+5u0FV8Q8VBdUqM2gjO4Cjoy8kvNjhN+xnfS3rw/VCeOiSRcp4Ppdvw7ZUGae4vXG93tUBFIVM4o8rtG+a+ijc3tt4NrEJNRXHCYuaZfHrydGmBuVFm6zgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673379; c=relaxed/simple;
	bh=ADIadsSptDIqcYx5nkZO0A4jEsOcFgizmlhUZYUQCDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hA1DdjrH37++V0mHPjc/a+kdt/ZquUzdPdKymFSmARHTXWMQKHBRVoOYFOBFBS3e8Z0Z44m/Y5q0Shi9qXVUZ+sqgDoCrrJA+fAt8Kavb142HoNLFwOfQhYv+JiML10gYorfIqIXauNCE3pc2n0S/h8qA9QFbAZOFmLM036uyFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxvzrWNx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxvzrWNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FDF4C19425;
	Wed,  8 Apr 2026 18:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673379;
	bh=ADIadsSptDIqcYx5nkZO0A4jEsOcFgizmlhUZYUQCDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxvzrWNxpEyeY1mJnC7ohtzaf8WAcbYGk/UzTU8dV31K8d06Rf0w/4gZ4jJZSTXfS
	 AVMR/FodU0hC+R+1nUaVRLfhxrdAy69t/PD95iTga17z5NA+GTdkKaWgljSMr6iQxg
	 6Ar9qCL++O9NE9YKciC6MQaxuOBU3nSV0tOpwXzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valek Andrej <andrej.v@skyrain.eu>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 182/277] iio: accel: fix ADXL355 temperature signature value
Date: Wed,  8 Apr 2026 20:02:47 +0200
Message-ID: <20260408175940.658535968@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


