Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EA123184E;
	Mon,  2 Jun 2025 14:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874581; cv=none; b=DOm6Q+Ph8JD5VLKTAIkC7qDhzFUvjRHBYBDrYqhTHT8UbBDyagMfT0Ulx20Dt6OgSiy4v+1klOgj3HlYpk+Kia2gULqrMw4tfPTKpjJ62igQ9x4yQYdTJc1ySrIebBCF2P1rglwS099rTCrO1NLyblI+bx7vmpVTuxfm6J9y72Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874581; c=relaxed/simple;
	bh=QJJEFX958S69sOtuHIZ7L2ZALXUCj/EBQSa+BaTj0SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZNCtqMX1ypfkhMDxb7gbtJ7eBzlSikYiI2ieYxrn5L0X7ZtCnqHmR+3znngORDos94cL4NWI6jeZftfR6jCd5OXe+4nMr7okwx1ybcLIcq01D+2IFtKEMsXgJ4x+dDI5l0XQj/bN3KU8PFK1HewwXXGlQh5LlTi7ONt/vPIClZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtHMOQzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtHMOQzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3AFC4CEEB;
	Mon,  2 Jun 2025 14:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874581;
	bh=QJJEFX958S69sOtuHIZ7L2ZALXUCj/EBQSa+BaTj0SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qtHMOQzMfKL+iRKYGZhPect409PbV405NnogkaGjOVYBlQbo1OYq1qD9OwiTyk+lh
	 zLp6YAyLWry7aLBHUxN24g4cztn/q7lZzn9yXZ0X6qBs0mfi/5E4F+47V8gQjfB2Tf
	 i47WN/Olv6ogFOjX60Hj6doj1TEqlYWG8sSBcuLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/204] iio: chemical: sps30: use aligned_s64 for timestamp
Date: Mon,  2 Jun 2025 15:46:41 +0200
Message-ID: <20250602134258.353174076@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c0845d892faad..0e466106becb4 100644
--- a/drivers/iio/chemical/sps30.c
+++ b/drivers/iio/chemical/sps30.c
@@ -232,7 +232,7 @@ static irqreturn_t sps30_trigger_handler(int irq, void *p)
 	int ret;
 	struct {
 		s32 data[4]; /* PM1, PM2P5, PM4, PM10 */
-		s64 ts;
+		aligned_s64 ts;
 	} scan;
 
 	mutex_lock(&state->lock);
-- 
2.39.5



