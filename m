Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674E812FB27;
	Wed, 19 Jun 2024 13:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803237; cv=none; b=nBPLNwIu9I94xnHT18wwHpw0DOwj/hs4hl4VNYClaMAVRqDziHdDthxqie54rDpYwajX5wbX9V/MZs47sMR1viXyuTdC46KwtdxX/8sWblP9rCeKYW6TlfdUe+xcLmqCFQx0+0YWLAUtBSnJi2mkyXvH2sfUSIH/7OB74N54W2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803237; c=relaxed/simple;
	bh=FucJRmndb13jAc5VUIBxXgXf/ezTmHqv5jhr7OrvTd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qck7MsgLFSpsN5qI69z/m873uSZ6Sns2dSw4RLMdZfKYT+7vLjLw44j36xrmVdpcbDM8VhSLg62jjUqvTOOotLJmnUnLQh6fPCSN7e1Jej7p3ZQRdVqJWA7LHA+rwFEd5qrtaTlQP1SYq7B4mJzg1lfA+2BENq6Fwvo7hv+Un90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ESgj1Qhf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ESgj1Qhf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E2AC2BBFC;
	Wed, 19 Jun 2024 13:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803237;
	bh=FucJRmndb13jAc5VUIBxXgXf/ezTmHqv5jhr7OrvTd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ESgj1Qhfz+xqdK96etQSt+uZCMpQJJGoywivmA0z5e9m55aRGPNq9WzJA+IR/Ri81
	 3ZyB5cTj7F7PWhxALgZyi/l3uHIxlya/T/7oufDG9MpTocISB+TvQ9WyQ/saBqFBsO
	 401dRoMdQVqtt+UAFZBI/imbO4aVJjStaetMPhdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.9 199/281] iio: imu: inv_icm42600: delete unneeded update watermark call
Date: Wed, 19 Jun 2024 14:55:58 +0200
Message-ID: <20240619125617.609733100@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

commit 245f3b149e6cc3ac6ee612cdb7042263bfc9e73c upstream.

Update watermark will be done inside the hwfifo_set_watermark callback
just after the update_scan_mode. It is useless to do it here.

Fixes: 7f85e42a6c54 ("iio: imu: inv_icm42600: add buffer support in iio devices")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://lore.kernel.org/r/20240527210008.612932-1-inv.git-commit@tdk.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c |    4 ----
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c  |    4 ----
 2 files changed, 8 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
@@ -129,10 +129,6 @@ static int inv_icm42600_accel_update_sca
 	/* update data FIFO write */
 	inv_sensors_timestamp_apply_odr(ts, 0, 0, 0);
 	ret = inv_icm42600_buffer_set_fifo_en(st, fifo_en | st->fifo.en);
-	if (ret)
-		goto out_unlock;
-
-	ret = inv_icm42600_buffer_update_watermark(st);
 
 out_unlock:
 	mutex_unlock(&st->lock);
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
@@ -129,10 +129,6 @@ static int inv_icm42600_gyro_update_scan
 	/* update data FIFO write */
 	inv_sensors_timestamp_apply_odr(ts, 0, 0, 0);
 	ret = inv_icm42600_buffer_set_fifo_en(st, fifo_en | st->fifo.en);
-	if (ret)
-		goto out_unlock;
-
-	ret = inv_icm42600_buffer_update_watermark(st);
 
 out_unlock:
 	mutex_unlock(&st->lock);


