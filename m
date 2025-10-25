Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB67230ACE8;
	Sat, 25 Oct 2025 16:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409231; cv=none; b=C+8lHdCCf2x4XkN/DZI9qlror3wyBJCusfskfWi2/RTNLIjDsZ+Wf3R3LAgTcak11KDSk/TfATxeBoiRUwQguKKZNo+tOe073J4F2rLLZax5TdtTJ24sXwtNom5UTC5hlCQy7DVtcwhI5rozfgPTmLcS3HqvRzc6R9PwRrZkqng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409231; c=relaxed/simple;
	bh=tCDP0s7LLfFYsPtJAEB2G6FQJfyQtNO6EeViMTFEejM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sTm96gVpyqjjKD4nNdigTqeBauvUaAl/EOXmgaX+eDA+fA+emo95rzG5AwameffseK11S94qes3Iugny2ymmo94q2bsrtg77SgZfnzsKEw4yG9PPkSPndMp1z4WwtajRpsHErig2vy7KqPj5VpnS3Y5Q/YJiqMF0wWwMMfyB2RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NkzJBP/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NkzJBP/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6B1C116B1;
	Sat, 25 Oct 2025 16:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409231;
	bh=tCDP0s7LLfFYsPtJAEB2G6FQJfyQtNO6EeViMTFEejM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NkzJBP/UU6PDXMoLHpM7YgvzYIQdIfgAUUQNO7N3jmm9Njm8QCGublNzaqk2ihQxp
	 baxpnxHqlGW3sqVquDWgmi10RYdbRGlo3fwUrJvfI1Pi8Jbvvufao9TxnlMNb0nY3J
	 n658n7nj+FQqL8HdWb0Wwr0cysOVTz23XzR7Vg5GY+WGzumBrtLij5XxTYActUd00K
	 6xTKO/pNi0/dmFNpud4IylAtZF1IO6UKFDKTzloew5DopCUpMcZANK5+WWyj9kS5iU
	 lumQ7tsYXRhxPxGRgtFwAvOG1zMZdCSqI8izO07sx4l0/DptKD0AUYAEYVla+6w2h5
	 UXGT39h88nxAg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	dlechner@baylibre.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17] iio: light: isl29125: Use iio_push_to_buffers_with_ts() to allow source size runtime check
Date: Sat, 25 Oct 2025 11:58:02 -0400
Message-ID: <20251025160905.3857885-251-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit f0ffec3b4fa7e430f92302ee233c79aeb021fe14 ]

Also move the structure used as the source to the stack as it is only 16
bytes and not the target of an DMA or similar.

Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://patch.msgid.link/20250802164436.515988-10-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed
  - drivers/iio/light/isl29125.c: Removes the persistent scan buffer
    from driver state by deleting the in-struct field “/* Ensure
    timestamp is naturally aligned */ struct { u16 chans[3]; aligned_s64
    timestamp; } scan;” from struct isl29125_data
    (drivers/iio/light/isl29125.c:34).
  - drivers/iio/light/isl29125.c: In the trigger handler, introduces a
    stack-local, naturally aligned sample struct “struct { u16 chans[3];
    aligned_s64 timestamp; } scan = { };” and fills it instead of the
    removed in-struct buffer (drivers/iio/light/isl29125.c:~157).
  - drivers/iio/light/isl29125.c: Switches from
    iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
    iio_get_time_ns(...)) to iio_push_to_buffers_with_ts(indio_dev,
    &scan, sizeof(scan), iio_get_time_ns(...))
    (drivers/iio/light/isl29125.c:~171).

- Why it matters for stable
  - Runtime size check: iio_push_to_buffers_with_ts() validates that the
    provided source buffer length is at least the expected scan size
    (indio_dev->scan_bytes). This prevents subtle under-sized pushes
    where the core would write a timestamp into too-small storage (see
    include/linux/iio/buffer.h: the helper checks and returns -ENOSPC
    with “Undersized storage pushed to buffer”). While this specific
    driver’s buffer sizing has been correct, the added check is defense-
    in-depth and can prevent memory corruption if future changes
    introduce mismatches.
  - No functional/ABI change: The new helper ultimately calls the
    existing iio_push_to_buffers_with_timestamp() after verifying size,
    so data layout and user-visible behavior remain unchanged. The
    driver still fills active channels via iio_for_each_active_channel()
    and appends a naturally-aligned timestamp.
  - Safe stack move: The per-sample buffer is very small (16 bytes:
    three u16 values plus natural alignment and a 64-bit timestamp), not
    used by DMA, and pushed by value into the IIO buffer. Making it
    stack-local avoids persistent state without concurrency risk because
    push copies the bytes immediately; the poll function is not re-
    entrant for a given device due to trigger flow
    (iio_trigger_notify_done()).
  - Precedent and consistency: Many IIO drivers have been converted to
    iio_push_to_buffers_with_ts() for this exact reason (runtime size
    checking). Keeping isl29125 aligned with that pattern improves
    maintainability and uniform robustness across IIO.

- Risk assessment
  - Scope is minimal and contained to isl29125’s trigger path and struct
    definition.
  - No architectural changes; no behavior change except a sanity check.
  - The zero-initialized stack sample avoids any chance of leaking stale
    bytes if fewer channels are enabled in the scan mask.
  - Performance/stack overhead is negligible (16 bytes on the stack in
    the IRQ/poll context).

- Dependencies/compatibility
  - Requires the core helper iio_push_to_buffers_with_ts()
    (include/linux/iio/buffer.h). For stable branches that don’t yet
    have commit introducing this helper (8f08055bc67a3 “iio: introduced
    iio_push_to_buffers_with_ts()…”), that core commit (or equivalent)
    must be backported first. Branches that already carry the helper can
    take this change standalone.
  - No other dependencies beyond existing isl29125 driver and IIO
    buffer/triggered buffer infrastructure.

Conclusion: This is a small, low-risk robustness improvement that adds a
valuable runtime check without changing behavior or design, and it keeps
the driver consistent with broader IIO conversions. It is suitable for
backporting to stable trees that already provide
iio_push_to_buffers_with_ts(), or alongside backporting that helper.

 drivers/iio/light/isl29125.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/light/isl29125.c b/drivers/iio/light/isl29125.c
index 6bc23b164cc55..3acb8a4f1d120 100644
--- a/drivers/iio/light/isl29125.c
+++ b/drivers/iio/light/isl29125.c
@@ -51,11 +51,6 @@
 struct isl29125_data {
 	struct i2c_client *client;
 	u8 conf1;
-	/* Ensure timestamp is naturally aligned */
-	struct {
-		u16 chans[3];
-		aligned_s64 timestamp;
-	} scan;
 };
 
 #define ISL29125_CHANNEL(_color, _si) { \
@@ -179,6 +174,11 @@ static irqreturn_t isl29125_trigger_handler(int irq, void *p)
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct isl29125_data *data = iio_priv(indio_dev);
 	int i, j = 0;
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		u16 chans[3];
+		aligned_s64 timestamp;
+	} scan = { };
 
 	iio_for_each_active_channel(indio_dev, i) {
 		int ret = i2c_smbus_read_word_data(data->client,
@@ -186,10 +186,10 @@ static irqreturn_t isl29125_trigger_handler(int irq, void *p)
 		if (ret < 0)
 			goto done;
 
-		data->scan.chans[j++] = ret;
+		scan.chans[j++] = ret;
 	}
 
-	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
+	iio_push_to_buffers_with_ts(indio_dev, &scan, sizeof(scan),
 		iio_get_time_ns(indio_dev));
 
 done:
-- 
2.51.0

