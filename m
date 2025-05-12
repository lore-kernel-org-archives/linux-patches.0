Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485C61A08CA;
	Mon, 12 May 2025 17:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072147; cv=none; b=qSg61k93V7lKThWppLvRsuBcDiapKzXcH/zp4c3DiGSAiOErn8qbTGAL+AUG3Qi21sFBodaQTNbPmwHan8zbzfD9D++wTpvj2ZBMQ57YQ3cMtRRoZxKMN+EEYrT0aojjTfFYVtsjJyrkm5kGLWbejcVFFv0QFC1yD6J1H79xFcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072147; c=relaxed/simple;
	bh=x1YBtPxSCBJeOT1V/ImO6nPytd9XXVNebrBIWPX6o2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M7R9uD7cnco9zfuPs1Sv4144DOtcO8ERKhOAJX1RbFu/vFxBhJkHLoFB1X1nMiEBllXhR1DSJ6SbVYjcxIVY0KBo+kDEOOPPU+xtBe8jBBDit5+JqmrvVy1z09GRkxuv7Uhhp/A2Yukl3XDXIDb7+2ldD+PaLsp6KiIHl7QYSzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZKbHrjgN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZKbHrjgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92749C4CEE7;
	Mon, 12 May 2025 17:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072147;
	bh=x1YBtPxSCBJeOT1V/ImO6nPytd9XXVNebrBIWPX6o2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZKbHrjgNJPjYGvcxBcYJdeRJ+hjwTEOn7vtq9oKu7fKqvHiL5jelAXM3tjgnRhE//
	 +OF4Rjv2ychoCb8H1NyvWBe232fGk9iTHTbKK9HAC6HFIfYB/cgU8srg9yJQX+4k7+
	 JFnazo0RPTacQfrix52nzbZ3MhCE6OrNH19CAg8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Andy Shevchenko <andy@kernel.org>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 153/197] iio: adc: dln2: Use aligned_s64 for timestamp
Date: Mon, 12 May 2025 19:40:03 +0200
Message-ID: <20250512172050.619011827@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 5097eaae98e53f9ab9d35801c70da819b92ca907 ]

Here the lack of marking allows the overall structure to not be
sufficiently aligned resulting in misplacement of the timestamp
in iio_push_to_buffers_with_timestamp(). Use aligned_s64 to
force the alignment on all architectures.

Fixes: 7c0299e879dd ("iio: adc: Add support for DLN2 ADC")
Reported-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250413103443.2420727-4-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/dln2-adc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/dln2-adc.c b/drivers/iio/adc/dln2-adc.c
index 221a5fdc1eaac..e416501770855 100644
--- a/drivers/iio/adc/dln2-adc.c
+++ b/drivers/iio/adc/dln2-adc.c
@@ -467,7 +467,7 @@ static irqreturn_t dln2_adc_trigger_h(int irq, void *p)
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct {
 		__le16 values[DLN2_ADC_MAX_CHANNELS];
-		int64_t timestamp_space;
+		aligned_s64 timestamp_space;
 	} data;
 	struct dln2_adc_get_all_vals dev_data;
 	struct dln2_adc *dln2 = iio_priv(indio_dev);
-- 
2.39.5



