Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309E81ADFFE;
	Tue, 26 Aug 2025 14:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216980; cv=none; b=iceQ7Iyug6lVm2uEDwQXpkSgNKIGlliMWELbr7Cwp1mrnwC71HXHAawHyak0ZEmEK0asUr+TD+s+xtGDjs+XOdCxRIjjDB44LOV4MZ0Xxr1zuKO0tOie/VktNlFpCTXTveNFfDuJHqaGFeC2VxzHvgQ6OGCZkR+5+NIAf4sgyWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216980; c=relaxed/simple;
	bh=zOEW84rhogKyqnZrtlAVH+n6loJKyMbEq1qTOd8WRs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BxU7KNoWwphXkj87JwrmJnvPfFef9dIVe4Kv8Z/OtahHzjOsIIFXwJLxYjdrbjjik+JELkY4R5cse9pU1bLsG8FHogy7WAoPGSHWSMVkaTC8uqTQJw+nPZvFM+PPCKAsR1/l+flfte4QGoIAH3XMpt7ZoV+oGtT0AORxBNVw4Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WdGpbdA1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WdGpbdA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F383C4CEF1;
	Tue, 26 Aug 2025 14:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216979;
	bh=zOEW84rhogKyqnZrtlAVH+n6loJKyMbEq1qTOd8WRs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WdGpbdA1cjTK6tpWTRAOns6pVk1H57N09SI7GNmcHDC1peWABuKFVPtvTtfFMubpb
	 vnLejeCLH7vJmF3CB3bVvQqjE8Xfp5/DOMSQq2CFf8RZmqcrtmHARo+8zb1ifFGp0c
	 fsyrPq74sc+SVxZtiITcEtFRjGEEeGTvZcyiJ1lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Andy Shevchenko <andy@kernel.org>,
	Sean Nyekjaer <sean@geanix.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 614/644] iio: imu: inv_icm42600: change invalid data error to -EBUSY
Date: Tue, 26 Aug 2025 13:11:45 +0200
Message-ID: <20250826111001.767873813@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

[ Upstream commit dfdc31e7ccf3ac1d5ec01d5120c71e14745e3dd8 ]

Temperature sensor returns the temperature of the mechanical parts
of the chip. If both accel and gyro are off, the temperature sensor is
also automatically turned off and returns invalid data.

In this case, returning -EBUSY error code is better then -EINVAL and
indicates userspace that it needs to retry reading temperature in
another context.

Fixes: bc3eb0207fb5 ("iio: imu: inv_icm42600: add temperature sensor support")
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Cc: stable@vger.kernel.org
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Reviewed-by: Sean Nyekjaer <sean@geanix.com>
Link: https://patch.msgid.link/20250808-inv-icm42600-change-temperature-error-code-v1-1-986fbf63b77d@tdk.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_temp.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_temp.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_temp.c
@@ -32,8 +32,12 @@ static int inv_icm42600_temp_read(struct
 		goto exit;
 
 	*temp = (int16_t)be16_to_cpup(raw);
+	/*
+	 * Temperature data is invalid if both accel and gyro are off.
+	 * Return -EBUSY in this case.
+	 */
 	if (*temp == INV_ICM42600_DATA_INVALID)
-		ret = -EINVAL;
+		ret = -EBUSY;
 
 exit:
 	mutex_unlock(&st->lock);


