Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1C02F2619;
	Thu, 16 Jul 2026 14:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210530; cv=none; b=tW8Kz6+haBEXWbNyy4Gw+myd4YsNrgKnKt5vXHL14X+lfjfQREVz1T5BEAyGJugnPYSxVvNdvWjh/kjJ4hQWTVSXTa21iP6po8B3f0R0wbk7DaJxvSSMKmgP8hJkwSWEXAn5RlvXu2LoIoMLvhjyy7M8/rPpO9TcjSsh91vDvQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210530; c=relaxed/simple;
	bh=Lq27Wk+mBDswgoC3RNGgsNKq7om9wm+U4M/S3hnDTYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AyS1OIWtYuO8VraF1kdME9TJXNSIDHXwuc07IE6GbMYYLG5IpmEAKj4LGy/txEk6Azv+uqcqdvBEb4CQroeYtQrp3my29uNqXOIVO3MuHDMNc6wAgenQJxXmlZL+qLG5qYLzZWIwBPp72RDBNxvcamCRSVNe07F+HbUqW2VHi7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2VIYHzzA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2VIYHzzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09DE1F000E9;
	Thu, 16 Jul 2026 14:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210529;
	bh=IHkGgvQtlIvNQIevgH98Pvt1oi5lO2kKod+UET+MrKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2VIYHzzARKSzFrKdzAVk6u2IAWXZl4n/oZ8oHBMEq+A8UK3hP8XX8SAYQHQASRjQk
	 WjlF6CS7wr6fuzTcdBtRb3cT0QMltUOcjj71SIzOA0HtLDO5Xo98ts9FY1mpbbyF7U
	 ITpsGZeGtcixVIcZsgUAwjxIY1gI/OR6we/6AyCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 081/480] iio: light: veml6030: fix channel type when pushing events
Date: Thu, 16 Jul 2026 15:27:08 +0200
Message-ID: <20260716133046.462963055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit c52bb33b641ebaae3e209f97714cb1758206f7d9 upstream.

The events are registered for IIO_LIGHT and not for IIO_INTENSITY.
Use the correct channel type.

When at it, fix minor checkpatch code style warning (alignment).

Cc: stable@vger.kernel.org
Fixes: 7b779f573c48 ("iio: light: add driver for veml6030 ambient light sensor")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/veml6030.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/iio/light/veml6030.c
+++ b/drivers/iio/light/veml6030.c
@@ -875,9 +875,11 @@ static irqreturn_t veml6030_event_handle
 	else
 		evtdir = IIO_EV_DIR_FALLING;
 
-	iio_push_event(indio_dev, IIO_UNMOD_EVENT_CODE(IIO_INTENSITY,
-					0, IIO_EV_TYPE_THRESH, evtdir),
-					iio_get_time_ns(indio_dev));
+	iio_push_event(indio_dev, IIO_UNMOD_EVENT_CODE(IIO_LIGHT,
+						       0,
+						       IIO_EV_TYPE_THRESH,
+						       evtdir),
+		       iio_get_time_ns(indio_dev));
 
 	return IRQ_HANDLED;
 }


