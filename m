Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BFC418A58;
	Tue, 21 Jul 2026 21:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670956; cv=none; b=dJ3UsReKATcJwSnvjZefQ/Jr+qmVdLa+PkGyQjOCRLOWavSf13EqjfRNIlnJxb5gQK/ys6ObImka2+j6aJRey0l9SUhZt3nx83tcvGgkx3zZ9O8bwWNVyKt5OuqY6GhJk4+gvZB0s3MqSYnwOaUQo6t1PC/gQXqyFT5vVKmRLeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670956; c=relaxed/simple;
	bh=eCYPl/5slJCRpHT4lm/ncJU9D4N09hw1ZYqRhCCgFLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzkfGU5NnwXsqy1VmuQl6tr1kFzNMT2Z/SKKhGoUQvPhvWVg1ay/4PprIM4R4ekgq9nyr08tNhFzTEOsyRTWPWiN/e02lD9dpbDSqwrNWQCHKv+QopV5YIm+Y3z+oiYmz/Ni4vVP9+XyokTKukCskn1T5bCjyQ39yoHjFvgRthU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X5MDyfah; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X5MDyfah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592901F000E9;
	Tue, 21 Jul 2026 21:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670955;
	bh=H/MQQ63u5yU4Y5nEsubhR7zD7ObySZUa8hplyqw3MNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X5MDyfah4TjT6RF0MItZckIwPxIWq7usA7mtmdok+LnvkLafaH0FXGNE/UYl30GHl
	 OyG5ZmNJB6yHrK8Xv/Wk4ZVAzODfNZjuGednKTns/LPo+rKwnW5eJ2Lk8C/dDIAkHy
	 jcVQd9spUHGNAzeuik3rGMxtrd8syV4agXG9yL1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.15 063/843] iio: light: veml6030: fix channel type when pushing events
Date: Tue, 21 Jul 2026 17:14:58 +0200
Message-ID: <20260721152407.406737518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -710,9 +710,11 @@ static irqreturn_t veml6030_event_handle
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


