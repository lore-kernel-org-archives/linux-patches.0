Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE0A1B983F;
	Mon,  4 Aug 2025 00:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267704; cv=none; b=SYOuy6ACVSmZCcnps4ekRbwW8IWeeoZJrGuNl81+PyEkbyYv1Vf84bLrJ9Zk85T72n0bvZmMq/tuYH7o/xAwZht9rbDac7Ykj8p11CvZ6XU4q3q2KAau9qJ/Jr9GEWGKR7GtX7YUGCBLnjOGEJJEuVzk8kSiD7Wjksfzl8FcR0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267704; c=relaxed/simple;
	bh=JXfLgUDoHsDqFpeG+J4W5zABe9QDaRGMdNF1WCd2mjo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b+JCcmVg6Tf4FOZ/YtHm/9s28JAA8sjzcYqp3eVb8kOa8ReXQ3nCu5Puh7fDX7OlAbHtY90VYfrEs86OjhmvPCOm6Nm/2bbhoyCQUyoUYaKWdfTM5phYAxnKliVbIzQoL3f9fsjKhrZZ6TLRZuofXm1ngg/OdhSGaHFlQnahArU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JPJpvSa+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JPJpvSa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97046C4CEF0;
	Mon,  4 Aug 2025 00:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267704;
	bh=JXfLgUDoHsDqFpeG+J4W5zABe9QDaRGMdNF1WCd2mjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JPJpvSa+K7PWcQfyZ8mHOrEoRPy/1u0H1b3Ouizknx7EGGr3Ukusv4C2s6rKd0Vl2
	 LJS6rL7QzGh82VDodPpAHx/dQzcK6tJWo8eUO6gZNmb3z/RStkX46YhY0NXZV6pfOt
	 8A053NfYjFVOo73ImLp2Tv3xstld1h6CKpx5bgeX+7pgpMTpIBW9m9dyC7p4Pczw+K
	 HfFcFe0U8Ifv0IJGypl3uNim8mPNEM7DCGR4fpVxsFDtd9aQyGAt75HIzjWBASi69/
	 MCLwfwuq1Kp9uu07DnttA8rjEOsacaDqAdkmm/egSAh+lQiTeyDYI32kzpbwBRxIvV
	 QKhOrhUd/PgDg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Lechner <dlechner@baylibre.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	lars@metafoo.de,
	Michael.Hennerich@analog.com
Subject: [PATCH AUTOSEL 6.6 21/59] iio: adc: ad_sigma_delta: don't overallocate scan buffer
Date: Sun,  3 Aug 2025 20:33:35 -0400
Message-Id: <20250804003413.3622950-21-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003413.3622950-1-sashal@kernel.org>
References: <20250804003413.3622950-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.101
Content-Transfer-Encoding: 8bit

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 5a2f15c5a8e017d0951e6dc62aa7b5b634f56881 ]

Fix overallocating the size of the scan buffer by converting bits to
bytes. The size is meant to be in bytes, so scanbits needs to be
divided by 8.

Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250701-iio-adc-ad7173-add-spi-offload-support-v3-1-42abb83e3dac@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit fixes a clear memory overallocation bug in the
ad_sigma_delta ADC driver that has been present since kernel v5.19. The
analysis shows:

1. **Bug Description**: The code incorrectly calculates buffer size by
   treating `storagebits` (which is in bits) as if it were in bytes. The
   `storagebits` field in `struct iio_scan_type` represents the number
   of bits needed to store a sample, typically 8, 16, 24, or 32 bits.

2. **Impact**: The bug causes the driver to allocate 8x more memory than
   needed. For example:
   - If `storagebits = 16` (2 bytes per sample) and `slot = 4`
   - Buggy calculation: `ALIGN(4 * 16, 8) = 64 bytes`
   - Correct calculation: `ALIGN(4 * 16 / 8, 8) = 8 bytes`

   This wastes kernel memory and could potentially lead to memory
exhaustion in systems with many IIO devices.

3. **Fix Quality**: The fix is minimal and correct - simply dividing by
   8 to convert bits to bytes. This is consistent with how `storagebits`
   is used throughout the IIO subsystem, as evidenced by the grep
   results showing `sizeof(u32) * 8` assignments.

4. **Affected Versions**: The bug was introduced in commit 8bea9af887de4
   ("iio: adc: ad_sigma_delta: Add sequencer support") which first
   appeared in v5.19 and is present in all releases since then (v5.19,
   v6.0, v6.1, v6.10, v6.11).

5. **Stable Criteria Met**:
   - ✓ Fixes a real bug (memory overallocation)
   - ✓ Small, contained fix (single line change)
   - ✓ No architectural changes
   - ✓ Low risk of regression
   - ✓ Bug affects users (wastes memory)
   - ✓ Clear and obvious fix

The commit should be backported to all stable kernels from v5.19 onwards
to fix this memory waste issue in the industrial I/O subsystem.

 drivers/iio/adc/ad_sigma_delta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad_sigma_delta.c b/drivers/iio/adc/ad_sigma_delta.c
index 533667eefe41..71e775a10a91 100644
--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -378,7 +378,7 @@ static int ad_sd_buffer_postenable(struct iio_dev *indio_dev)
 			return ret;
 	}
 
-	samples_buf_size = ALIGN(slot * indio_dev->channels[0].scan_type.storagebits, 8);
+	samples_buf_size = ALIGN(slot * indio_dev->channels[0].scan_type.storagebits / 8, 8);
 	samples_buf_size += sizeof(int64_t);
 	samples_buf = devm_krealloc(&sigma_delta->spi->dev, sigma_delta->samples_buf,
 				    samples_buf_size, GFP_KERNEL);
-- 
2.39.5

