Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7991E2D028A;
	Tue, 15 Jul 2025 13:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586359; cv=none; b=epbEIs9HowgCOjEYjmJYHvK6RDgdKPcE0FjWuNu18aMuoHfnU9LD+GmEVgFfzESjCwkngo8tmENAJUv6odG3w0JyUAd4V7V1+EPXcz8B4E0lpi3fJlpT7H1IFnovTQC0ifsyrN7X4jCbOhuseWZr2ALpT7R2nk/5AJgBa1aBwrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586359; c=relaxed/simple;
	bh=kKG2DY2H8TgvkgiSKX6AVFz6B61s/Myccwb/woumm64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCFkXSIpGGO0lqc02reqveP3U0282WV/uKopzHjMaxBQFoRl5Evbrp/WMnOwDM3n5tKVNRkYzCe0zIZnF43R+z/lJM9LfeDp/hfqQBWTSi6t17JSyTYFhNdOlBADe23ZcNzQW2CVZCkj1XK89oLyVPKtFZ6ibCfQgGO1Ahgg7wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpkpLpks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpkpLpks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAD1C4CEE3;
	Tue, 15 Jul 2025 13:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586359;
	bh=kKG2DY2H8TgvkgiSKX6AVFz6B61s/Myccwb/woumm64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpkpLpksGTrZ9sx1sIPCCWWOD7vf4gLs0SxX0G/f4TT3QIMhWFdVIMJoXVeoZxdxS
	 QW5qFWmwFfuKKdtNGzWXH/G9uSGN5CDwcCkBEdO566bpoc1onC/rB4xfLBtzdqAC52
	 CywJlxqS67+A8OsXjwNNXxK5kr3o8Phr+jdb0Pj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 006/148] iio: pressure: zpa2326: Use aligned_s64 for the timestamp
Date: Tue, 15 Jul 2025 15:12:08 +0200
Message-ID: <20250715130800.554250505@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 886a446b76afddfad307488e95e87f23a08ffd51 ]

On x86_32 s64 fields are only 32-bit aligned.  Hence force the alignment of
the field and padding in the structure by using aligned_s64 instead.

Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250413103443.2420727-19-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/zpa2326.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/pressure/zpa2326.c b/drivers/iio/pressure/zpa2326.c
index df60b3d91dad4..85ca48f2fe665 100644
--- a/drivers/iio/pressure/zpa2326.c
+++ b/drivers/iio/pressure/zpa2326.c
@@ -581,7 +581,7 @@ static int zpa2326_fill_sample_buffer(struct iio_dev               *indio_dev,
 	struct {
 		u32 pressure;
 		u16 temperature;
-		u64 timestamp;
+		aligned_s64 timestamp;
 	}   sample;
 	int err;
 
-- 
2.39.5



