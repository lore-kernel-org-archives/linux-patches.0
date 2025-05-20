Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48578EEDE;
	Tue, 20 May 2025 14:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749691; cv=none; b=MxAI1hEfz74OGAufHayMpPIsMKyr+yIUCsjt/T0yf0RJQdd1SOyfNCXy3ZctYDQYYSxR88c7LopBSOpp4TitemrGZVRVivuHhVjBavqY64nwgcj8NM5ncJla8NO7KAHTCUR36AtsIJkWmY+uBZm+CIbpsBAO+H/QsktNciBB55s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749691; c=relaxed/simple;
	bh=R/0p6AAvGM60moBW7DedJ52IWCH8SC+hfg9hesqEyRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kkN8ell44qvzu+9OkDva9U7li8a3Piq4umatA1NxdAiVgdCRo94np8BefqltNHR+lEU5Lmw+HYTe5QfEItCNtkOsCp0I8PY6zxSa/HWP7wiVvIl73WIoZmrXoj+BaGkPO9i7ulo7ueySIML6x9dw0FGLU7wqfnIFfwt/3o2/IcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CSCkIDMq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CSCkIDMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE295C4CEE9;
	Tue, 20 May 2025 14:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749691;
	bh=R/0p6AAvGM60moBW7DedJ52IWCH8SC+hfg9hesqEyRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CSCkIDMqD5taCLkWKrKY0vyAHMevQTMRfRfnkL5OwmhKMIKsxqYcpaNrRmHrdCru4
	 uHTKSO3IFgN89gAbyZiG61i3EMh5G4F8KJzkFBgIyDHXoTRtDkJu5qIsIjL/EuxZcO
	 wBoXohSPbBsMoeojtDajQC4FvfxSoZcmA4XXdCsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/117] iio: chemical: sps30: use aligned_s64 for timestamp
Date: Tue, 20 May 2025 15:49:54 +0200
Message-ID: <20250520125805.141238804@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit bb49d940344bcb8e2b19e69d7ac86f567887ea9a ]

Follow the pattern of other drivers and use aligned_s64 for the
timestamp. This will ensure that the timestamp is correctly aligned on
all architectures.

Fixes: a5bf6fdd19c3 ("iio:chemical:sps30: Fix timestamp alignment")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250417-iio-more-timestamp-alignment-v1-5-eafac1e22318@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/chemical/sps30.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/chemical/sps30.c b/drivers/iio/chemical/sps30.c
index 814ce0aad1ccc..4085a36cd1db7 100644
--- a/drivers/iio/chemical/sps30.c
+++ b/drivers/iio/chemical/sps30.c
@@ -108,7 +108,7 @@ static irqreturn_t sps30_trigger_handler(int irq, void *p)
 	int ret;
 	struct {
 		s32 data[4]; /* PM1, PM2P5, PM4, PM10 */
-		s64 ts;
+		aligned_s64 ts;
 	} scan;
 
 	mutex_lock(&state->lock);
-- 
2.39.5



