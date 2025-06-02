Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62954231851;
	Mon,  2 Jun 2025 14:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874588; cv=none; b=L9/PNfeWSOt0wsqDlMK/mvY/6SAEJQciwfLx5AJzbQl7pTol0uJ+y8/6b3brdKKq9RJtfIS1MFQWwIGewyepJYoiTytfGSAghWMBke9yOWEI72jkNzdEMuf20myaoNPt0yaT3UWMWB7vWfJJsclUyEKP55lyZl58z3rJ04cTh2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874588; c=relaxed/simple;
	bh=OPfqgJoXV/CmALAloEP/TP5dxoEL7z5meNrl3iuHYFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOI/9MuA7vQsD/EQ6cdD7J29/yIZxJcU8bTXWlN5BxQfJnb6+b95T6lGNOIPWmzoDhltmQ+BCPlP1Q0TBAf48Q/6jhwBh9ZBaxVyaA+G1e1QJYAKAo4CMWPX4cO/BCEywWL33RmlkIUd68MyBxOJUJvlJfyt2Tn7izuThVsi0+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V20VaLyV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V20VaLyV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8BEC4CEEB;
	Mon,  2 Jun 2025 14:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874587;
	bh=OPfqgJoXV/CmALAloEP/TP5dxoEL7z5meNrl3iuHYFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V20VaLyVwE1NJPCyLFMm3Z1xOiQ/AYKGS88qCqMvFmkBUO6i4W8GzHyuzrzH1Gxm+
	 BlDkQCVcXgSALScyikrzeY2q9us7LTIiC0k4rhdgB9YBmeB/P/8onapjKZ9FpWEl9e
	 DLNkLkmOL8U1dow4vBKzbWINRPdw3RxsJQFlZKLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Shahrouzi <gshahrouzi@gmail.com>,
	Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 042/204] iio: adis16201: Correct inclinometer channel resolution
Date: Mon,  2 Jun 2025 15:46:15 +0200
Message-ID: <20250602134257.333818081@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Shahrouzi <gshahrouzi@gmail.com>

commit 609bc31eca06c7408e6860d8b46311ebe45c1fef upstream.

The inclinometer channels were previously defined with 14 realbits.
However, the ADIS16201 datasheet states the resolution for these output
channels is 12 bits (Page 14, text description; Page 15, table 7).

Correct the realbits value to 12 to accurately reflect the hardware.

Fixes: f7fe1d1dd5a5 ("staging: iio: new adis16201 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
Reviewed-by: Marcelo Schmitt <marcelo.schmitt1@gmail.com>
Link: https://patch.msgid.link/20250421131539.912966-1-gshahrouzi@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/adis16201.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/accel/adis16201.c
+++ b/drivers/iio/accel/adis16201.c
@@ -214,9 +214,9 @@ static const struct iio_chan_spec adis16
 			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 14),
 	ADIS_AUX_ADC_CHAN(ADIS16201_AUX_ADC_REG, ADIS16201_SCAN_AUX_ADC, 0, 12),
 	ADIS_INCLI_CHAN(X, ADIS16201_XINCL_OUT_REG, ADIS16201_SCAN_INCLI_X,
-			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 14),
+			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 12),
 	ADIS_INCLI_CHAN(Y, ADIS16201_YINCL_OUT_REG, ADIS16201_SCAN_INCLI_Y,
-			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 14),
+			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 12),
 	IIO_CHAN_SOFT_TIMESTAMP(7)
 };
 


