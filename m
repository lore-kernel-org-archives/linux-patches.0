Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B0235C694;
	Tue, 21 Jul 2026 21:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668153; cv=none; b=IWZb1ANbpZeqpidKdTyGczpoNEXAsVOFEm0lHno8+LijakdEqrG8VpHRZU3d+DGUpdNA5uEjVjysheQFt+olACaKauTnYEaMHbNuzvzEr3BveSKlxQ46yL3yH7TtQzA6iflc70UQes8+dAMWSeJe+LnbOAC30I6IERJLHxxA5Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668153; c=relaxed/simple;
	bh=QYubaG/odMRGWdN8T3G7wPUCcE1TBku82KFxU34IJfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QX05Gd7snW2Ohv7bYiK85m+dSD1TLuGNevlCpzeWqUhHUOwIAuvgUr8SVgSdyP8YAWNrLzIJaqgS4hy2ntVzqJqUNLcWuk5TkPTJlNaflQeygIyLR+BUbV+fbjzssJr087ouJDoS8g61PsWj4ejRGztEb1N4IsVln1b7KwR3skI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0PHe4oqz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0PHe4oqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B16A1F00A3A;
	Tue, 21 Jul 2026 21:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668152;
	bh=0y59o2lcnOjd+mHcfGhuicXk1jftQ+57ny5Jji4X1uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0PHe4oqzLg8cLPVNBuNoSZVsfMW+HP5TdOVO7o3QuOK27cFj/ogTiVgEry8VevVUe
	 V5R7Np0cmPqmQ0HS+O2d857JP8wSq6d8gpnE+A8q8K58rC+J2RgHb2nsKXAksc5pqo
	 pvI+NYcYAA8OFbQits4rFx9x1pqnLglH0y0ITAgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.1 0069/1067] iio: light: veml6030: fix channel type when pushing events
Date: Tue, 21 Jul 2026 17:11:10 +0200
Message-ID: <20260721152426.114678452@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


