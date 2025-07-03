Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F5C86348;
	Thu,  3 Jul 2025 15:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555916; cv=none; b=KtxjUckHar0k4Wl/dsSxmkkP63MELEqU2dcItDBc8t0hdUi+HF7GFyUseQ3zTAcFLv9aPnqRTcDRPKbFzRxU3JRZR1+xPX4GajzYLcn/DmeqwP82zsXgX/RyO/phO8UYIZTctwRU9vtHjmlGbtem1SzeMBDCrPy+aKVPxHgbwMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555916; c=relaxed/simple;
	bh=EHdEeODl7ZBX221lHBoHeFEqL3LmuA3S76k7YuqSZts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddxKa/MdJuUYphCG0VphIPhTBLXcpgFTNIMV1NHQTO0MsnN0KEzTa/GFoPasUVaufVljsgQp/UKM+z2ZNdZMxsfv2n7gUQendBVErIypUZQYZQi341Hn6UnNGK3hu8rER9ZfMj3KlIC62hD3+3kuJXENoz/CqS0uGtlzYu0lZEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mK11grs2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mK11grs2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C3FC4CEE3;
	Thu,  3 Jul 2025 15:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555916;
	bh=EHdEeODl7ZBX221lHBoHeFEqL3LmuA3S76k7YuqSZts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mK11grs2zDskM6NnkcuLu1rV82KRooLUoeAYXIibxdYTwzjwmuZrCkrNqx4VEqEe9
	 beFcGd1CBZKhpJNu1KFNsH5dEbfP6XxK6GMFD4QvTpDptikwKzXv7y5yPlHw1Fjosm
	 HXrOZfOw708Y4mLsge8J35joP0cdZBJaZXJT4jZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/132] iio: pressure: zpa2326: Use aligned_s64 for the timestamp
Date: Thu,  3 Jul 2025 16:41:47 +0200
Message-ID: <20250703143940.113839039@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fdb1b765206bc..7f352a79c1a55 100644
--- a/drivers/iio/pressure/zpa2326.c
+++ b/drivers/iio/pressure/zpa2326.c
@@ -582,7 +582,7 @@ static int zpa2326_fill_sample_buffer(struct iio_dev               *indio_dev,
 	struct {
 		u32 pressure;
 		u16 temperature;
-		u64 timestamp;
+		aligned_s64 timestamp;
 	}   sample;
 	int err;
 
-- 
2.39.5



