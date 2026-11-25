Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626295;
	b=47dOWJrSd8EV7bXE7LE4H99ocdvNdZHyO2mDMVQuel0k8tUt/RGRcSJZgWq2TS73LJy0
	 Oja5T80x53jDOSJxwq2MjiikaIHBhcwtIVpI+cJWnsSkO01fbAYmKNadzJW2MDdgTkS6p
	 6TAdP7ZpFz/0H9ywcdqG6ND2nejYlNn+9l+pXpdS8nmwosVnvbnRYQN5KMY3DYM0hNHjV
	 OdcvSxHHLmA5oh6H165KI+TDidTHGD08w5a4/RGJ8TKyHdV/g2Zzc5mztMzJ9989nxwOt
	 6dhNnhFsL8XEkeBnb+ywAzQpb2EO2tGm7xo19r6UTgIpc4aOvfA3fX/LRKBT57Qs6ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2YfG5sqAmhexZVdupP6uDuY4JzqtHqJOD7KB/VP/pS0=;
	b=IPnZ6qSGOfYsp/WbCF/mOCWBglFWbpSDVQuQF6oO4xK467yNN2g4JCbMR9aBgxS7sJCP
	 WpCf1l2FE8vaDQFKCQVFzrtW0tMRyqlNbaVG0g4gh9lGpniImCskfjomifLAZADRyxVi7
	 bqQm2H/D1CqnbJe/KTYoGYsu+OBjGKxT7vCO/OtRU+PWh/6hxij0g5bNKQJ4i/pIDR+wf
	 nEF+OI6rhunVVXKZ5wwodDJs8Pf68RaBgOklCEilO+owjAb223/UQZlxN0Ni4X3pf1254
	 QPmE24h+2vp5RTJ5s8y1MlPsfWUzvmAEwl2/4kvvR7lucGas8mbusUFc+EHFSVJUPYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iyfBKAQw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEE0606A32C;
	Wed, 25 Nov 2026 17:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iyfBKAQw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B091F000D1;
	Wed, 25 Nov 2026 17:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626295;
	bh=2YfG5sqAmhexZVdupP6uDuY4JzqtHqJOD7KB/VP/pS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iyfBKAQwK7T2U+vMSTJy8eGWfMSGiczYlde+TzG+H6KH718/iRf0AQa9lzjxN1eui
	 05157MIMtlooKX2B+RdF1OwjtBW/aoaux01bsb+86Qd5wF9DslJ9Gsq2z405Z4iB2q
	 eXg//Y8w00TNLhxl2XfMordcbzjUhje7g/GO2KjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shashank Mohan Jain <jain.sm@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 795/816] iio: magnetometer: mmc35240: leave cache-only mode before the cache sync
Date: Wed, 25 Nov 2026 15:39:03 +0100
Message-ID: <20261125143907.574829371@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shashank Mohan Jain <jain.sm@gmail.com>

commit 38e05cf38df705b7fa9e8ada931589fa96816f09 upstream.

mmc35240_resume() marks the register cache dirty and calls
regcache_sync_region() while the regmap is still in cache-only mode.
It calls regcache_cache_only(false) only after the sync. This
ordering has been wrong since the resume support was added; it happened
to work until regmap started rejecting a sync in cache-only mode.

Since commit afc8e3ee8307 ("regcache: Validate cache_only state in
regcache_sync_region()") a sync in cache-only mode is refused with a
WARN and -EINVAL. Every resume now gives

  WARNING: drivers/base/regmap/regcache.c:536 at regcache_sync_region+0x1a4/0x1c0
  ...
   mmc35240_resume+0x30/0x70
   dpm_run_callback+0x7d/0x1c0
   device_resume+0x175/0x270
  ...
  mmc35240 1-0030: Failed to restore control registers

and the control registers are not written. If the chip lost its state
during suspend, it runs with the reset value of CTRL1 while the cache,
and with it the sampling frequency attribute, still has the configured
value. Writing the same frequency again does not repair this, because
regmap_update_bits() finds no difference to the cache.

Leave cache-only mode first, then mark the cache dirty and sync it.

Reproduced in qemu with the driver bound to an i2c-stub device: set
in_magn_sampling_frequency to 25 (CTRL1 = 0x02), clear CTRL0 and CTRL1
of the stub behind the driver's back to emulate the power loss, and run
a suspend/resume cycle with "devices" in /sys/power/pm_test. Without
this change CTRL1 is still 0x00 after resume and the warning is
printed. With it, and also with the regcache commit reverted, CTRL1 is
0x02 again and there is no warning. Not tested on real hardware.

Fixes: 553a776b7908 ("iio: magnetometer: mmc35240: Add PM sleep support")
Signed-off-by: Shashank Mohan Jain <jain.sm@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/magnetometer/mmc35240.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/magnetometer/mmc35240.c
+++ b/drivers/iio/magnetometer/mmc35240.c
@@ -534,14 +534,13 @@ static int mmc35240_resume(struct device
 	struct mmc35240_data *data = iio_priv(indio_dev);
 	int ret;
 
+	regcache_cache_only(data->regmap, false);
 	regcache_mark_dirty(data->regmap);
 	ret = regcache_sync_region(data->regmap, MMC35240_REG_CTRL0,
 				   MMC35240_REG_CTRL1);
 	if (ret < 0)
 		dev_err(dev, "Failed to restore control registers\n");
 
-	regcache_cache_only(data->regmap, false);
-
 	return 0;
 }
 


