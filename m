Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20B72D77F5;
	Fri,  9 Oct 2026 14:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557570; cv=none; b=Le3D5zc24aMAhWlxV2F3CmRwzONcBkGMu9hfshlFi9tmb7ceNV3D+5yX0s5j0j8t8k7D/KqKkh4rmfO83t/OHH7SUh9RhfKkd2Y3tUCTx6LfWTervDwW8bXElnT5mzdmL5cmAIJY/6830qXgVjgM4J+usyVG9uuzXiBZa5wg7Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557570; c=relaxed/simple;
	bh=63SZn63Xyp43gCtlQFzIjgeJV95WQkKoEu9rCumOTFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+TxVNz/jgtA60Om1B/ahBm5rgQDVu6ugok/IhQ2Lu489Y7bfjuTwOLcTlpwFWnwbmJ4GCrzs+hYdGodVHOh41OpWRO7MweGavdgJIjadjV1l0DF9SsByMNJeu84ewlQUw1xRz3QGjjLTXrsE5gfibywF2VMkuhXuz0TGpCe6j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UK7LPZBI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UK7LPZBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A821F00893;
	Fri,  9 Oct 2026 14:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557569;
	bh=3iE+/Lf0U8xMJfk6KKCAqX50Gi03awutrJKhhEyDxEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UK7LPZBITT0Y59tpns/LVM3ooVE3gskQGbuFtdIzSIRyMobV5YDR8ZO7pXSS8cdHV
	 JHC+VBst0h6cuJLe4ZzogwLoevIP3o9k97Ec8R2cWG7xZ2nMnSo/uKl/9yJUopMcNA
	 6A7FVDauOOXbwnM45xZmWWZvgG6p4FaXoN4jQQg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 407/428] iio: pressure: rohm-bm1390: Return error when read fails
Date: Fri,  9 Oct 2026 16:12:24 +0200
Message-ID: <20261009140955.162443873@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

commit b0e951ffc5a28141a106562997ca136ec6a0e1a3 upstream.

The data reading function ignores the cached error value, and
unconditionally returns 0. Return cached 'ret' -value after stopping
the measurement so user knows if read failed and data is garbage.

Fixes: 534674463a59 ("iio: bm1390: simplify using guard(mutex)")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/rohm-bm1390.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/pressure/rohm-bm1390.c
+++ b/drivers/iio/pressure/rohm-bm1390.c
@@ -289,7 +289,7 @@ static int bm1390_read_data(struct bm139
 	if (warn)
 		dev_warn(data->dev, "Failed to stop measurement (%d)\n", warn);
 
-	return 0;
+	return ret;
 }
 
 static int bm1390_read_raw(struct iio_dev *idev,


