Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF693DB336;
	Thu, 16 Jul 2026 14:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211746; cv=none; b=QmbvW8HvMtBBK0hCK2Rn0xJ4sAWg6X8phXuoBpJRqOjoqiPkk4NzpvkVWnq9SYuiwftAYZZuR7ETIXmdQ3w0FpXj3XBuXLYm+1Kdtgz7RwTwI4H5klvMGFZVxsfPg3JMnC2IlTotA4rlgPhNIQnuT7wPSWb3y4qOaLR6bbS2TzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211746; c=relaxed/simple;
	bh=gTt6oTjxX17k7S+EhmXPsbBdbxRenQ8J9dmxmjhRSPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jcwxwWkr3VISnmAb6fMk/VKTQFf0qIe73VDeKkku8t74bMF4P+u53Zu1R0B5L+otkSYP86J4LlZms0iWvDBPa2TBKsNOK4HzlJuLhQfAHAvWGG+nWcc9jQFolQAiY4B9jW/RW3ve8ospGxDsGmC8dNsYYRc/mY8OGw5NgSrQwzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zfflz6rm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zfflz6rm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47B51F000E9;
	Thu, 16 Jul 2026 14:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211745;
	bh=L/DizqFetlkoEFDXinkZRIG1cKjXWEI5z7lsDKqNDcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zfflz6rmsm8PjlNMu0Gx544PoF6w43TNi9C3UrB5V4bG9TjkWBE/k8oIQun+FDZXu
	 K9I/9Oa1e7xN4DUr5gPpsY0VZoEAfOp2q+PDdKAT8f9OIki++dJMWcA6VrIRD1SDxM
	 i7KoOl9Qa/NgtfxKtCUj/EW09sPR//ECXAPZMISQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 065/349] iio: light: veml6030: fix channel type when pushing events
Date: Thu, 16 Jul 2026 15:29:59 +0200
Message-ID: <20260716133034.779049253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


