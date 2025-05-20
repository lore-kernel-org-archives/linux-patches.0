Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B39242D9A;
	Tue, 20 May 2025 14:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750046; cv=none; b=N8fYEjeAt7VjAOdoNMGem5e8Iog9j/E+w6amv9Jx3Y4kMkJ+ZuSgRmQMJUyOgOF++YGS5ra7YMQtKtRRRoPWTd5RUS4D5ixzbBD86113DpX4Bot3RisygLK+cHKRmSfpunwjBFizp5OfpcjltOk1kkGN2ZmAp0AwYSyzJ1SclAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750046; c=relaxed/simple;
	bh=XhLaos/6lmTUC+Wrdax3IhR6KUVxhKVNwUR0/qbnNYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i6lsdGuoZ/yfS/M3qOiandHHvoq3RimqRJlDnLutIqTN7aJD1rYBMEnW9zlCCbqVCXbywwQ83VTi4ppUfuZ1xe0BRp+MjIdtrzB0A/e0J2JkuIix35EYh203gtXfQfuzRO70fGrUMbKGuleGZaFOu18u2S7qMI9guYWaU2ltAwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMmIgttO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMmIgttO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D96C4CEE9;
	Tue, 20 May 2025 14:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750046;
	bh=XhLaos/6lmTUC+Wrdax3IhR6KUVxhKVNwUR0/qbnNYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qMmIgttOF3PlNEoTUu6bHDCQUPf+TuHq+jlDrbNGTJ4rHD+zpzdGvOI6G3heyb1KB
	 9HgFnz0sB2txbBIHNuBPj+jR9Uq7+EgLJdA64T4BdUAa/uhzIyTOsXgxwsnRD4D+te
	 ccRdtlh6znfilkCc8dreVjZJPsJv7d58+kP+bbcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/143] iio: chemical: sps30: use aligned_s64 for timestamp
Date: Tue, 20 May 2025 15:49:39 +0200
Message-ID: <20250520125811.005559011@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



