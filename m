Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8A51940BC;
	Wed,  3 Jul 2024 10:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003650; cv=none; b=aUJOxXzSEp5texrWFj0GOEwQzBhx6VIcUAdkzYfQw3T9BJQEn8P07dQLeA9OpS3eYDBIGJQsjQn0HbCsTTE1CWz/pvFqsvhB2tHBlkcP35FdfNS+220Bg/gRQ0Csn2Z21qfnvVcu2bWQKUw25bcHqoeyEY9VfvfYlW9hdL+D+8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003650; c=relaxed/simple;
	bh=XoHhO4nqmIBjNDnlFBJ/i3Z0xK6HDqcoI8oEsfiJOBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdoBWmDRmjenWkvmZ/ok88wpVI04P172GjzNtgK6RlKNYf7v/71tRYu/a/ZpJett/l9UK6B6ylnlbmmOSoM3LLmlQBz4sL6XeoGNJWessoqFas24/FMo4Q6FyTqh/9FLu5MLF1+LYW0hfPxwGHetuZ6P0uTLKYpxgKyXE8hSh80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H4g9XzyP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H4g9XzyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6671CC4AF0E;
	Wed,  3 Jul 2024 10:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003649;
	bh=XoHhO4nqmIBjNDnlFBJ/i3Z0xK6HDqcoI8oEsfiJOBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H4g9XzyPRh1L1J7wPlF0hRqNq2/b66ouqYDK4OOtnpQX67m6R1//I92+WjLCSDR7u
	 uuyvW4tgaR9CwUpFtA5r61bM4NsSRYEXsLOy7OR3Btsm858VhwaxkPuK+Rd8uV0fQ+
	 R7bnFeLUFLtxnJ+dSnpX0VDyPwkKgkZib9+bE34U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Ardelean <alexandru.ardelean@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 091/139] iio: dac: ad5592r: un-indent code-block for scale read
Date: Wed,  3 Jul 2024 12:39:48 +0200
Message-ID: <20240703102833.877773299@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandru Ardelean <alexandru.ardelean@analog.com>

[ Upstream commit b004fe33034cc64f72c20923be71cf1e6c9a624c ]

The next rework may require an unindentation of a code block in
ad5592r_read_raw(), which would make review a bit more difficult.

This change unindents the code block for reading the scale of the
non-temperature channels.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Link: https://lore.kernel.org/r/20200706110259.23947-2-alexandru.ardelean@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 279428df8883 ("iio: dac: ad5592r: fix temperature channel scaling value")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad5592r-base.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/iio/dac/ad5592r-base.c b/drivers/iio/dac/ad5592r-base.c
index 87824c03c0124..427946be41872 100644
--- a/drivers/iio/dac/ad5592r-base.c
+++ b/drivers/iio/dac/ad5592r-base.c
@@ -378,7 +378,7 @@ static int ad5592r_read_raw(struct iio_dev *iio_dev,
 {
 	struct ad5592r_state *st = iio_priv(iio_dev);
 	u16 read_val;
-	int ret;
+	int ret, mult;
 
 	switch (m) {
 	case IIO_CHAN_INFO_RAW:
@@ -416,23 +416,21 @@ static int ad5592r_read_raw(struct iio_dev *iio_dev,
 			*val = div_s64_rem(tmp, 1000000000LL, val2);
 
 			return IIO_VAL_INT_PLUS_MICRO;
-		} else {
-			int mult;
+		}
 
-			mutex_lock(&st->lock);
+		mutex_lock(&st->lock);
 
-			if (chan->output)
-				mult = !!(st->cached_gp_ctrl &
-					AD5592R_REG_CTRL_DAC_RANGE);
-			else
-				mult = !!(st->cached_gp_ctrl &
-					AD5592R_REG_CTRL_ADC_RANGE);
+		if (chan->output)
+			mult = !!(st->cached_gp_ctrl &
+				AD5592R_REG_CTRL_DAC_RANGE);
+		else
+			mult = !!(st->cached_gp_ctrl &
+				AD5592R_REG_CTRL_ADC_RANGE);
 
-			*val *= ++mult;
+		*val *= ++mult;
 
-			*val2 = chan->scan_type.realbits;
-			ret = IIO_VAL_FRACTIONAL_LOG2;
-		}
+		*val2 = chan->scan_type.realbits;
+		ret = IIO_VAL_FRACTIONAL_LOG2;
 		break;
 	case IIO_CHAN_INFO_OFFSET:
 		ret = ad5592r_get_vref(st);
-- 
2.43.0



