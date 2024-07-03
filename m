Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CA6191F7A;
	Wed,  3 Jul 2024 10:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004235; cv=none; b=ZNoEu+ZnRq0kJPGo6EybEdh7uss9zZaYkyooM421+mfKYNBwNz/rRxYRTqvVTqnP+yRhEfIt0QiHqeoqndwoajVgdGT+NPOn1A9TTc3/4RN3Fi1xiC63IYZZk/GlqZDJU6lll1A8KqMdlYV0o0iN7hqTf+RaKyFDaj85Mml5Q3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004235; c=relaxed/simple;
	bh=U1UcC/hgv0y/j00xYbFFNSN7jC56ug4HWWCDDGkQ9s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULYxLTYmDvrsM8ilWMRyRdTU+23tRMx59xg2n5HrgojVpYYAQEmHpZRITTMatsdPVPo7D/Li844SBWrDJI44by448rp3F5W8sQXHVznuKoy7Z8AlqhY+Jn/WmbaC0Gq5tIGbvHZFjFAhhLKD59L4YhR4mt6H+9Pg8vpfLDPCL1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BS7IOdRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BS7IOdRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FB6C2BD10;
	Wed,  3 Jul 2024 10:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004234;
	bh=U1UcC/hgv0y/j00xYbFFNSN7jC56ug4HWWCDDGkQ9s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BS7IOdRCwspfNuVmUTcSVV79ecFcN3JJczdsx5Fo4X4LRtPUy/aEZs2FD4r9RBBGt
	 rhOFG6siufIgUhuSPe9CqVhLWwINiQPMHa1SxM/RrW/2nVp2+No6E0C6LXDoOx314K
	 u1q1JBl2IgUpyTCfMB97rBO6/CmAvAUVrhJqLNKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Ardelean <alexandru.ardelean@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 132/189] iio: dac: ad5592r: un-indent code-block for scale read
Date: Wed,  3 Jul 2024 12:39:53 +0200
Message-ID: <20240703102846.468876314@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d9c1242db99f1..5c242479bb811 100644
--- a/drivers/iio/dac/ad5592r-base.c
+++ b/drivers/iio/dac/ad5592r-base.c
@@ -377,7 +377,7 @@ static int ad5592r_read_raw(struct iio_dev *iio_dev,
 {
 	struct ad5592r_state *st = iio_priv(iio_dev);
 	u16 read_val;
-	int ret;
+	int ret, mult;
 
 	switch (m) {
 	case IIO_CHAN_INFO_RAW:
@@ -415,23 +415,21 @@ static int ad5592r_read_raw(struct iio_dev *iio_dev,
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



