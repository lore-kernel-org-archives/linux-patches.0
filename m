Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8858F12FB31;
	Wed, 19 Jun 2024 13:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802388; cv=none; b=ToW2uE3gRxfXGzi1jXr3xJD9h6KcCBJiyGQxmWpwZ8eusvVst1yQexGB4aBTVEGbA8gMqrRy8fjekugtmvQyuxqSWQKK0ruUvOoI3Zx/NhfewQ5q6sJBoijYv4ZChKX3GaUYuveEZV4vNtQnWKZYftp6/OFTMZj/sN2rg0HW830=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802388; c=relaxed/simple;
	bh=zUZax/HxMTt4cwgahFku/ZlguCynivuZA9JQ1xJ/Nrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4sNlmnAYcJ4LrkUB7EkbhHkzurLH9S6qO1Ug4aaLKqCy0gHOStYFEUjRiXVqfW6HvFhWqeazE0PFp85N+UFplU1aV+Kp816CawgIaVzzN1LEqj/rQjbOVFGH1bXOwmFuHuAY2VGlV9GwRQlw9xZu+thw8fQTjrXFkFT2NzSLo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Iqp/7x5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Iqp/7x5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACEB7C2BBFC;
	Wed, 19 Jun 2024 13:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802388;
	bh=zUZax/HxMTt4cwgahFku/ZlguCynivuZA9JQ1xJ/Nrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Iqp/7x5GEauSXAuDsaETN/VGVjREBkkfKXhDMMb7gYbeYOil3ywGe1o5En8FDSnN
	 AAXJVbgcFfvwz3B3r3/GuAf7d07fG2XP4hvoH3E4wxr4QCM30byEtev9NFSdNE0QWp
	 YRq/K9SNpFxKjkowqlNu8t3t2Tna/0Tbhf9YBBaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 179/267] iio: imu: inv_icm42600: delete unneeded update watermark call
Date: Wed, 19 Jun 2024 14:55:30 +0200
Message-ID: <20240619125613.213564631@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


