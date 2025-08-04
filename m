Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2F5136358;
	Mon,  4 Aug 2025 00:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267113; cv=none; b=n/JuC2Vnos61b1sgRYDLoErVAv2SqQtCAhJ3MKT28L+dOlrIHOz/nEcyhGBegRjg19fDsCp1QPAWXqUkD+L5UmCh6ERE2w+4HM5/e0TUwnLCQgNXZDbz1U/e8FvGeq8XNGs3odoe6QA7vGUYwvMZQJubW5EbsXBco3Hgmj+jkdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267113; c=relaxed/simple;
	bh=aTPv+xjAr6TJo90MCp9pMjW1VnsjCB9dZW4cIZXjwSY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C/6iP5dWZ8Wdh61yC804AOpspg9ziVy8PyoW/S9LmFeMllel0+ZWN8h0/QVV6V1prDnL9bj4ygs+ySev5Ni2ThGW1p4keXJ5pG2BNU0IvtuDOPjPvB5PGfRHZJKK04XqyS8YHlJ2r4OdSxfl/2BbZ8uGTWfRMHRRhF2m/JUw3Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OmTBKRku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OmTBKRku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FEDC4CEEB;
	Mon,  4 Aug 2025 00:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267113;
	bh=aTPv+xjAr6TJo90MCp9pMjW1VnsjCB9dZW4cIZXjwSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmTBKRku5RLDeJmFGVc0UTCdYj6mCgYmJCE3wIKjDV2ivLYmFQGqLL3lHLSlbTUBd
	 9gopPHh6I8i2fQdWXj/X3Xf5xHuIedKnoSyHq9JIWU9qvzkXYbK+2zU1Ge0McGJg3o
	 0srYsgz4utYbMzvc/tXTVR5lccgBtKBVMYZwbpDLacQfNs3izF9XQmCVaeILHF9nUs
	 UmSxi/e90EMhsUmDaW/RvbESURvkNiAsbpuNTab3NTzBTm1EcooyUP3buHo0J1NjZF
	 f3/ueqFJMUvFRzIWSKGrB7xzayjvStmt6qYPCgv9FXAbb7AVudJUkbIWEtMc9B5nxL
	 MOwL+vI4LyCfA==
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
Subject: [PATCH AUTOSEL 6.16 32/85] iio: adc: ad_sigma_delta: don't overallocate scan buffer
Date: Sun,  3 Aug 2025 20:22:41 -0400
Message-Id: <20250804002335.3613254-32-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002335.3613254-1-sashal@kernel.org>
References: <20250804002335.3613254-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
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
index 4c5f8d29a559..6b3ef7ef403e 100644
--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -489,7 +489,7 @@ static int ad_sd_buffer_postenable(struct iio_dev *indio_dev)
 			return ret;
 	}
 
-	samples_buf_size = ALIGN(slot * indio_dev->channels[0].scan_type.storagebits, 8);
+	samples_buf_size = ALIGN(slot * indio_dev->channels[0].scan_type.storagebits / 8, 8);
 	samples_buf_size += sizeof(int64_t);
 	samples_buf = devm_krealloc(&sigma_delta->spi->dev, sigma_delta->samples_buf,
 				    samples_buf_size, GFP_KERNEL);
-- 
2.39.5

