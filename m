Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8E52DF137;
	Thu, 16 Jul 2026 13:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209138; cv=none; b=gF+BOQ1veECqX6yG4K7L/VC2BFTBYNFFvrf5Ehq8iI8/94GB+rkeGsCVKLbrgV/TfArpomb+UKcZbYFDvG/onov6CfHaL17O1eFMMgzlcEdnVWg/6f5pYWcXF6hTIEeqLlPAGAxAOhuaDf12JaIiPQx2sC/EFZku2G2OSwmTcjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209138; c=relaxed/simple;
	bh=Eyep8Zcr9wmeOcdbeEukg5OXX/dQpKfG+IZZjsfawc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgzUB4BqcPKGMl84v59bvCElC94CwotzpFMoxba4bxcSqKuajgA3zVlQvXzbS90RU8M1JqbTV79jVFNehpwpco2SVDMQBGjkPUohRlmT2UgiSnUbn38DsOwbysInOqknA4Gby+/KX/e7ypLfHBfhEnSmmg06NGxJ5lIC0SIe328=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZbGIsMn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZbGIsMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A061F000E9;
	Thu, 16 Jul 2026 13:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209137;
	bh=sILhqhtaNK9s/y7HPhjyYq7ne6jNs6yXlEDHhZ/vZnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wZbGIsMnQQvLI9lalFR2Iz6YqQf5BOQhVVkZFWbXxcZ9k/RwylLSO81kzcD9C510o
	 6AgVqVxkWwfU0p41HbTqraAuiw9RmS6/6U4EnA6b6SNukl6Zmi2MjY1nV+wPt1zwoo
	 bjMmphsWL/mTu7qVyll9eSR1n5COALrweeBQYiy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 069/518] iio: light: veml6030: fix channel type when pushing events
Date: Thu, 16 Jul 2026 15:25:37 +0200
Message-ID: <20260716133049.295466849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


