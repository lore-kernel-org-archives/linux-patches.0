Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FA130AAD8;
	Tue, 26 Aug 2025 14:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218408; cv=none; b=rlPlMhA2qI6i2iH0+poOLfAHwKzjLPPewcpwFZek83Wrhp/4YOQoAiK0iiQPnUhL2FUjRnaxsDvxVVbMEFMcX6eH4VmcRho1L4wL+T3iYVitN3UlVxJIgpIT0fCmwLhyH6LZj/Z3AladWqxIP2h3VZ4llvHr5lkag8VRAwsB/Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218408; c=relaxed/simple;
	bh=a/GWlP0uyC/zhBRfjrPostSKwANlPPlMfVNJ+7BGQLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KA/jQAljbvclWf6fpzNPsi0Zatt/Wzj1KWuNwgPqRacuySwBkyJnvs0sfRqwJBMn3n//y9nSSlRbUSlQuaclbgB9baEVjdMpU4Il3rVNM9PKO8UgxZlojWYUNNABaiQtuaUgkYdKsN1UXPrKdOEqkBXJmtbtlgPgg2apqCLAaLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vH14Uh6K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vH14Uh6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99410C4CEF1;
	Tue, 26 Aug 2025 14:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218408;
	bh=a/GWlP0uyC/zhBRfjrPostSKwANlPPlMfVNJ+7BGQLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vH14Uh6KMARTKf8h6/gaDseWADFGqenROjJvYhknJyZOCaTcPY72aqIhIFB9ghGwk
	 wFA04AVlwWtO4esKhlOBT5R7H4rhS4UjNhWb7yERWOyPlD7vQYzJN2r7kixzpqtDZi
	 PAJAQsUs9pP7IWVwYxE+jdT05BuiEW2LPAOxQYfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Andy Shevchenko <andy@kernel.org>,
	Sean Nyekjaer <sean@geanix.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 503/523] iio: imu: inv_icm42600: change invalid data error to -EBUSY
Date: Tue, 26 Aug 2025 13:11:53 +0200
Message-ID: <20250826110936.848373147@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


