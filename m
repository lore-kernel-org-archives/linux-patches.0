Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705773;
	b=4XkR+smMw2miH4MLMBjki7EyCG2FjqAOQMmrJWkJL5mrLbphOnswEMJ6+rjX0Toa2Njw
	 P2ag2jVYMqDCTtfp1AeoDk2cCr2u/Z2isKgtrSZUld9gVmTMdgi8qa9/a21fHOb4QYC1d
	 7H8M+vvp9cg98TamJQYKbBTEWPstxs5lmLPrkQWbIsVm1Nl+TkxUURqvY1s59hok9Lgb+
	 cSqhOkWZDYAZ0cinarBZf6cBwv7zy8E02TxPupeec5KhI0zt613l7thTT6WWz8+SAlViH
	 FAQ/n7FTxtiK8RWsMYbSxir7dc17lPt5baN3biF8dCiRRRUEYKIWkf6Oakx8U7FhJGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705773;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G2QS/UqAkHlHK5Dj791rJUydBPTHpZYIDf6qIPKoq80=;
	b=JosL3d7U8YidZxzWCxFBTvT1xea0lPddkIJkj2COXm5vqTBJEl0tUJAbvkeBeTMzy7Fc
	 WBej8vwTXT2XVbtSgxPzoEo+i2WE0jHqIEQYzAf2UkkSC+ynCPUziKSFbxzqF2NDFKlSj
	 3T/C25ksEnktVafZEEdUh5AMNUL74eRkuJzcDPLHRdoOXbmHnEvkwSV8JlKDReC3MJyUt
	 47zIVfX0+Mt2G4LVnK4FXH9hJ/9njY5R8oLnJoBmD/8byfvUeWTD3RaLbEPf5dkFtt+xU
	 oLEhYj1Tz6Yfi0hxgd20KXCIe/bjK0DBVT6iOkvzI0sCg1MNj7zAKus/4g80ZmjDVeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hjjQZJgT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0555606A32A;
	Thu, 26 Nov 2026 15:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hjjQZJgT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B421F000C4;
	Thu, 26 Nov 2026 15:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705772;
	bh=G2QS/UqAkHlHK5Dj791rJUydBPTHpZYIDf6qIPKoq80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjjQZJgTcu3B0Z+Og4g4aEhS+M8qD5nvGDfnpMpyo6Bpa76gWYjwT8NpOT5/67qsM
	 5ZcOcxLClJJml1WGEzC8AHl4XH43iA+If+k2Y6dhJPNFBKYVDznRuwPa2fkZQYGgdG
	 +3dpAyPip4EofaxQFfhISckPed+aQDhHCuNL9yCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shashank Mohan Jain <jain.sm@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 308/319] iio: magnetometer: mmc35240: leave cache-only mode before the cache sync
Date: Thu, 26 Nov 2026 15:41:16 +0100
Message-ID: <20261126144013.708586550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -538,14 +538,13 @@ static int mmc35240_resume(struct device
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
 #endif


