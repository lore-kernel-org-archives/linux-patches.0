Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA3F259C93;
	Mon,  9 Jun 2025 13:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476686; cv=none; b=A9oYHE2Yt2A3ptEjoPM49XS66jcN6kaK+PO24bnprGfN86Wrib7MCKsl8yg2b62e4bQ9ithOf84XHDCht7d/UbMXpvQmh0FJSDaLI8vDpSVZ2VFFm8pQ7jG9rS83OolcLtRHhqCWCI2pvc00jFpCCS6fwgfdmYOR+afYsFIChpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476686; c=relaxed/simple;
	bh=LwIqXgHH/nV0BvoU7aXYecSqA+RtceLcoV9UPQ0gWY4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vk8g5XsAQrvhGuXtkN2BrUKCdrzr8NrTZ/TTZq/WdYKaCJOhG/QA8cGdy16b5WCYoeAVC7B7SU5yqXxIkkIRNg8+OPxWnxNTZiBssoOFndcX1wrK0Mo7Ctz4LD2BEDcgw90RjVH5dfjlJOJGcMIDXbUcg69igux9X+bCAE+o2ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eSOthhml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eSOthhml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3138C4CEF3;
	Mon,  9 Jun 2025 13:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476685;
	bh=LwIqXgHH/nV0BvoU7aXYecSqA+RtceLcoV9UPQ0gWY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eSOthhmls4HDIGPn8pdc96Io3rn5BjBMYA7cIdsolmPAJyCQ1xIMUFoXJJuSRgZcc
	 tUcd/mg0D+e7UbAvuOXiG+mNmb3vezqzQLVFY5WGKRoc7w3TV6q+mponoURIAa255S
	 QnaN+pL/dRP3dhpIKv6Q13YTdQZ+zrWlTKD3gbmJLK/WxZUZX3gHTEL0I8lqxcxz+t
	 zOQyu1GV9kDV7UpEXoCbxtcVhWtLqK4OiRHmOL8a+n7iy5rnbLP3anegGYST2MRcjY
	 2Z5LMcXBUR35StbYG30ePvBBoqmFVjbwSTSUFcCL4GhAl265G2agEojlv3PAjc8VRX
	 3g1XeJl8OMIrg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	lars@metafoo.de,
	Michael.Hennerich@analog.com
Subject: [PATCH AUTOSEL 6.15 23/35] iio: adc: ad7606_spi: check error in ad7606B_sw_mode_config()
Date: Mon,  9 Jun 2025 09:43:39 -0400
Message-Id: <20250609134355.1341953-23-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609134355.1341953-1-sashal@kernel.org>
References: <20250609134355.1341953-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.1
Content-Transfer-Encoding: 8bit

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 4d71bf6021818a039a534c5954acefdfc4d6962c ]

Add missing error check in ad7606B_sw_mode_config().

Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250318-iio-adc-ad7606-improvements-v2-2-4b605427774c@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Now let me analyze the specific commit by creating a diff to understand
exactly what the change would be:

Based on my analysis of the commit and the Linux kernel repository, here
is my assessment:

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Code Analysis

**Current problematic code** (lines 136-143 in
`/home/sasha/e/linux/drivers/iio/adc/ad7606_spi.c`):
```c
static int ad7606b_sw_mode_config(struct iio_dev *indio_dev)
{
    struct ad7606_state *st = iio_priv(indio_dev);

    /* Configure device spi to output on a single channel */
    return st->bops->reg_write(st, AD7606_CONFIGURATION_REGISTER,
                   AD7606_SINGLE_DOUT);
}
```

**Proposed fix from the commit**:
```c
static int ad7606B_sw_mode_config(struct iio_dev *indio_dev)
{
    struct ad7606_state *st = iio_priv(indio_dev);
    int ret;

    /* Configure device spi to output on a single channel */
    ret = st->bops->reg_write(st, AD7606_CONFIGURATION_REGISTER,
                  AD7606_SINGLE_DOUT);
    if (ret)
        return ret;

    /*
     - Scale can be configured individually for each channel
     - in software mode.
     */
    indio_dev->channels = ad7606b_sw_channels;

    return 0;
}
```

## Justification for Backporting

### 1. **Fixes Important Bug That Affects Users**
- **Error Handling Failure**: The current code ignores potential SPI
  communication failures when writing to the device's configuration
  register
- **Device Misconfiguration**: If the SPI write fails, the function
  continues execution and reports success, leaving the AD7606B device in
  an undefined state
- **User Impact**: Applications relying on software mode configuration
  may fail silently, leading to incorrect ADC readings

### 2. **Small and Contained Fix**
- **Minimal Change**: The fix only adds proper error checking for an
  existing operation
- **No Architecture Changes**: Does not modify driver architecture or
  introduce new functionality
- **Pattern Consistency**: Aligns with existing error handling patterns
  in the same file (see lines 117-119 in `ad7606_spi_reg_read`)

### 3. **Low Risk of Regression**
- **Conservative Approach**: Only adds error path that was missing
- **Maintains Existing Behavior**: When SPI operation succeeds, behavior
  is identical
- **Standard Error Handling**: Uses conventional Linux kernel error
  propagation pattern

### 4. **Critical Subsystem Impact**
- **IIO Driver**: Industrial I/O subsystem drivers are used in
  measurement and control applications where accuracy is critical
- **Hardware Communication**: SPI communication failures can occur due
  to electrical issues, timing problems, or hardware faults
- **Silent Failures**: Without error checking, debugging communication
  issues becomes extremely difficult

### 5. **Similarity to Approved Backports**
Looking at the historical similar commits, this matches the pattern of
**Similar Commit #2** (Status: YES) which fixed missing error code
handling in `ad9467.c`:

```c
// Before fix:
ad9467_spi_write(spi, AN877_ADC_REG_TRANSFER, AN877_ADC_TRANSFER_SYNC);
return ret;

// After fix:
if (ret)
    return ret;
return ad9467_spi_write(spi, AN877_ADC_REG_TRANSFER,
AN877_ADC_TRANSFER_SYNC);
```

Both commits address the same fundamental issue: **ignoring return
values from critical hardware communication functions**.

### 6. **Follows Stable Tree Rules**
- ✅ **Important bugfix**: Fixes silent failure in device configuration
- ✅ **Minimal risk**: Only adds missing error handling
- ✅ **Self-contained**: No dependencies on other changes
- ✅ **No new features**: Purely a robustness improvement
- ✅ **Confined to subsystem**: Limited to IIO ADC driver

## Conclusion

This commit represents a textbook example of a stable tree candidate: it
fixes a genuine bug (missing error handling) that can cause real user
problems (silent device misconfiguration), uses a minimal and safe
approach (standard error checking pattern), and carries virtually no
risk of introducing regressions. The fix ensures that SPI communication
failures are properly detected and reported rather than ignored, which
is essential for reliable operation of industrial measurement equipment
using the AD7606B ADC.

 drivers/iio/adc/ad7606_spi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/ad7606_spi.c b/drivers/iio/adc/ad7606_spi.c
index 179115e909888..1bad270a95563 100644
--- a/drivers/iio/adc/ad7606_spi.c
+++ b/drivers/iio/adc/ad7606_spi.c
@@ -174,11 +174,13 @@ static int ad7616_sw_mode_config(struct iio_dev *indio_dev)
 static int ad7606B_sw_mode_config(struct iio_dev *indio_dev)
 {
 	struct ad7606_state *st = iio_priv(indio_dev);
+	int ret;
 
 	/* Configure device spi to output on a single channel */
-	st->bops->reg_write(st,
-			    AD7606_CONFIGURATION_REGISTER,
-			    AD7606_SINGLE_DOUT);
+	ret = st->bops->reg_write(st, AD7606_CONFIGURATION_REGISTER,
+				  AD7606_SINGLE_DOUT);
+	if (ret)
+		return ret;
 
 	/*
 	 * Scale can be configured individually for each channel
-- 
2.39.5

