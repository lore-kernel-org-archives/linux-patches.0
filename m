Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C16346FB0;
	Wed,  8 Apr 2026 18:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673942; cv=none; b=fZl5g7iNSFxK2C0vb7TlEk/LOqPS8XdABiOEFWEcInD2+mGDr979qZ42qQIFR0f/7miaecvaFRvw2l0kjDTyH2Uo+rZehr6hLNz0B60uZrJ7jGfT3k9xBsH2IiY3N6hI7GSPA/JnEVZH9DKn41txQ+JBBzyOqoY8C/8HC/ojSTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673942; c=relaxed/simple;
	bh=/XZ9wtxt9oNnPJ7KN5pwvJMnfulhzRTlqdTv8zcDpHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUqfWKmxp/MVbYlJOdkDBICRlB/gw5+aaRIy4Iy9kpHvYSPxsBRKrQRD4z3oL8ro1ADrVTw5cQNmu8rTX/ZLqL2puPjwmv9uqR8//7jmmWO91g7K4JYb2Z28EHNINKY9/0vrNyo6yTYhNuUoBO3V90MYQCzD7lVQAGAvYiGTeQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sw1qB175; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sw1qB175"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C53C19421;
	Wed,  8 Apr 2026 18:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673942;
	bh=/XZ9wtxt9oNnPJ7KN5pwvJMnfulhzRTlqdTv8zcDpHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sw1qB175RP+AU+aFsz4dkjVqiVUpFKrAfr0K8et7myvdxtVssMpfLQHJtXFGWqNE3
	 LjMnuiw2zHuJZhYM/Tu9Vn/+syhNFCxd5P6qLK28EM69K7XP+NMQ+Iqp361gbsG8Eh
	 By1/+Jc6wsJ9agrLEgXY9YMfRLPaqnL0pIoc9NKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valek Andrej <andrej.v@skyrain.eu>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 149/242] iio: accel: fix ADXL355 temperature signature value
Date: Wed,  8 Apr 2026 20:03:09 +0200
Message-ID: <20260408175932.669151836@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


