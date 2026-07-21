Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4BE4307AD;
	Tue, 21 Jul 2026 20:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664892; cv=none; b=Ob16p9ppBKnbi04v5HNVShBGFeZg/viyFacrIWeab6a84Rz3SzHoj6zLCtDfsewjxBzuQGlWiK4x97MBT4ngqOH8AoIRrvpNn9LvOX0qsAFTocVKW/NWgVtcP6YDS4Gv80qbeYcE/iHbogZnlawS6iEPvC4mF4U6m2PwflpFnWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664892; c=relaxed/simple;
	bh=X0IHYON+nBObM5VVkNVVQRSrb8UP0WGsrP4MuY0Xn/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqoXFSSStud1zZ/cib8ot9BzAfjXi8ItECtu9641dAb2Xeq0gXKZKPJTyU0hX5Azoc3BufbQ7Vk1r9ItrWH12nanp6LF5v8Ard+GPehDompAthCYKfLm/HztyUxfSSFxQcrrnT5NQ90uFQtF5bCSdexoCu3cFqxdAZq5hB3cuAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sd9DQCZT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sd9DQCZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3321F000E9;
	Tue, 21 Jul 2026 20:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664891;
	bh=R+4LcjJp4ybmtU5KvUUXJ1t9J7CZ0hi7R3U06+sJt4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sd9DQCZTN7UY+817rSqwvibHzF4StQ4ntMHEWzmFQGZuWj5aaK7Q9F3wIeRrMu5x1
	 oIxL/wlomqnqRef2HamKZ77ETXLEtwCNBtM4K6BFRfMhHKHZHpE2BERtvFzmFwqvie
	 TaliohEALlgu+z3NqUQmMOHxLkfhFeLjpwHrANCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.6 0099/1266] iio: light: veml6030: fix channel type when pushing events
Date: Tue, 21 Jul 2026 17:08:56 +0200
Message-ID: <20260721152444.017894269@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


