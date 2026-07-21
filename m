Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180EA35C694;
	Tue, 21 Jul 2026 22:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673133; cv=none; b=Pi51T/0tljjEOxh9FOy9RqFrUECXWKEhGDAelpiNrfmLoFW/+qMPVcyPaBDsCmBPsYvyNB1n8kl5QLPLuR6nqHR7bDiUaac9VT/G//dJqZ1t0ONrQq0Y6qSp7YlESGXV1ahzD4zgxztVMixB9zmStoOxZVlnflgFzV/jrzzsAWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673133; c=relaxed/simple;
	bh=ZDrkj6Aoi43uZRBHqmVfI/L5YK+g7BNqxK+tUyG1ubk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HtboXFw5U3AcxbElOk8FOaRSlGgajjF2l5FfHL/yp65EZIybEe4mLIg5sBWzU+upyKM0BwPd01HRu3QpRkRgLhimI0Ab0cnwDl23VBEF4vqACLdLsCd6XIHuodlVaVwImzV5EgM7ZaMr44PrS9Nuoo3GW4l6G0MCm1oML2F9wW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cH5ZJ8QO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cH5ZJ8QO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7853F1F000E9;
	Tue, 21 Jul 2026 22:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673132;
	bh=UKfmJ1Uq28ISHEyQWomB15Pi2u9vWp8hS6JSUMcEQSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cH5ZJ8QO1Mjvbl+Zy2IixoQ3XYNkZwDXQ9mdiCny5m8Ds1pxAwE3N67edj/ySzE6Q
	 SABKfmjOtdFsaXNGstG2A3A5D3gadvY2Oa9MErNTpYCNK2m0nUUPHSs0MzdrIobs3N
	 rM0BnDEvdEk0h6V0Kk878dvunMX3wJTHw7SZwotk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.10 048/699] iio: light: veml6030: fix channel type when pushing events
Date: Tue, 21 Jul 2026 17:16:47 +0200
Message-ID: <20260721152356.793606923@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


