Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF5D15CD55;
	Mon,  2 Jun 2025 14:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875284; cv=none; b=XMiuW7uNTd3PKnk9/zV/wHvAk04CsroxQ13xE2hDJP32gGUG7dHnsQYPvOLXYXoaEfKcBERQ9kNQC0p5/6589yy2AXzqxnx+i5jPvdxssuSHbD9/s5b8uyLVIipwDtgap0sZ33b9R3uNBe0VPVNr1nm7ydrXYCfLhmobyxhAGkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875284; c=relaxed/simple;
	bh=wXsPeRSRrc4CLxT59ArkUySTWCY4LS4vDyEjhSdCxs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jND2IFROL8ZnMwrvFcMRea5dNeKFNUGLRkl5WXyLYhSljnwAhTcUlDan49CnytCBGVn77Hf+TJbYfVHrl3zdnhFvcqFfwtEiTtJEKzefS2X7nFetV1pn8J145ZmwrHkg2KlwxsfTdjCiNqlIswvQI38e07chy7qCvrk28Ov7w0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZUdaOGf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZUdaOGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46830C4CEEB;
	Mon,  2 Jun 2025 14:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875284;
	bh=wXsPeRSRrc4CLxT59ArkUySTWCY4LS4vDyEjhSdCxs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IZUdaOGfIFnKWJSFtYJCX83ZDgJlLyuE+NcbV6jUkQAWMwjJtPEBZYLs6Mk49wyYQ
	 Z+9xxzY6pSL+aRodWwmMge0dMMtDq3CItpMJOJEZdPLguRVcY2SZSTKdjxs7VxLfk9
	 NuXalzvyi5AsnVh8WyFy6qig3tcC6GssJgdZQ+Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/270] iio: chemical: sps30: use aligned_s64 for timestamp
Date: Mon,  2 Jun 2025 15:46:10 +0200
Message-ID: <20250602134310.642425025@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2ea9a5c4d8462..002628e31b5c9 100644
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



