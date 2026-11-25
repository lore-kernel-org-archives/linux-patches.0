Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620714;
	b=OAKI403VMIKAwH60jFmP09kDhvP/JSEq2t14YabffpkVMXNEURsmWkBzvqxIYujOpj+G
	 FDaSTP4n/vcz/vHfQbtMV3MkY59JRxUZc5OGEkYssO0eI9oCRihP+4YeI1sEA4PzNiZty
	 rvyLmyogn4FWUUg5VO6A+gf0jj99vjiTZyVJchxkB/pn2ZLJEqZEGUmaHWrQUO7+RCvki
	 s4lmL5XNkS9H0QL4KIAYfCnCQOutIyP5pJJrTh8rzmBlcRMD1ME1BbItUPtj9uySoS+1F
	 MH4hYib7fiSuqIWyRwawCll7/k+JQTpEFIF2cua9Qnvf7QXQ+b9b0DF4fWZBRam9pOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9ZJC6iVdW69M+L6VTxjUnm3XJPDzpNiBNiCQAmR/7Vw=;
	b=TSqJHxpdiXICR+HhQUFc6hLU/UKsY1ehI2mx4u5CWfk+Zpi1Nk9h3kqGUt5oNaefumE0
	 5vBc7RwqYEqo167T2kuuOQiUsm6EQR0YnMqiPAEYIoxrmYZGiJ7SuLitTsYWQ5OANS7qw
	 gkJovUkL1aD7t8guyUoj0yfcSLkdSUeJfMYHQ7hglGKAaNB7yIFFQsv44bK9LHV5/2PQ+
	 zBxIf8ZACZQpaNpcKZ8etznTn182JeHlrILEuiU02v/fq2Ua8OkJDIAH7rVS942Yy7rA9
	 C4M7eCGe2AsDltc8AjYoDbsfC3kS85oKGI1wMoWwm2ZbsQC/1Q8lV+O9XHFq6cl2xLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=En3eXSCz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D815B606A31E;
	Wed, 25 Nov 2026 15:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=En3eXSCz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34FD81F000C4;
	Wed, 25 Nov 2026 15:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620714;
	bh=9ZJC6iVdW69M+L6VTxjUnm3XJPDzpNiBNiCQAmR/7Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=En3eXSCzSn0VvJMaalmH1Al2sjY2fJuHGmUaadwfDVeU11ubs2jmExE4AvxFCsMxG
	 hlwaERof84SrDKAPKaZozhbiyaV0OViX6FZqtTA4v8pnuM22bYEANZwH/heangoFbE
	 Equaxny2ASOIzG/TuQ+Xt2PHMlAISCAD32ACSVTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shashank Mohan Jain <jain.sm@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0986/1005] iio: magnetometer: mmc5633: leave cache-only mode before the cache sync
Date: Wed, 25 Nov 2026 15:38:44 +0100
Message-ID: <20261125143844.753978547@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shashank Mohan Jain <jain.sm@gmail.com>

commit c794a0a82fb189d98c635c5791c67c672ad80eb8 upstream.

mmc5633_resume() marks the register cache dirty and calls
regcache_sync_region() while the regmap is still in cache-only mode.
It calls regcache_cache_only(false) only after the sync. This
ordering has been wrong since the driver was added; it happened to work
until regmap started rejecting a sync in cache-only mode.

Since commit afc8e3ee8307 ("regcache: Validate cache_only state in
regcache_sync_region()") a sync in cache-only mode is refused with a
WARN and -EINVAL. Every resume now gives

  WARNING: drivers/base/regmap/regcache.c:536 at regcache_sync_region+0x1a4/0x1c0
  ...
   mmc5633_resume+0x2d/0x70
   dpm_run_callback+0x7d/0x1c0
   device_resume+0x175/0x270
  ...
  mmc5633_i2c 1-0030: Failed to restore control registers

and the control registers are not written. If the chip lost its state
during suspend, it runs with the reset value of CTRL1 while the cache,
and with it the sampling frequency attribute, still has the configured
value. Writing the same frequency again does not repair this, because
regmap_update_bits() finds no difference to the cache.

Leave cache-only mode first, then mark the cache dirty and sync it.

Reproduced in qemu with the I2C driver bound to an i2c-stub device: set
in_magn_sampling_frequency to 3.5 (CTRL1 = 0x02), clear CTRL0 and CTRL1
of the stub behind the driver's back to emulate the power loss, and run
a suspend/resume cycle with "devices" in /sys/power/pm_test. Without
this change CTRL1 is still 0x00 after resume and the warning is
printed. With it, and also with the regcache commit reverted, CTRL1 is
0x02 again and there is no warning. Not tested on real hardware.

Fixes: 6e5f6bf2e3f0 ("iio: magnetometer: Add mmc5633 sensor")
Signed-off-by: Shashank Mohan Jain <jain.sm@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/magnetometer/mmc5633.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iio/magnetometer/mmc5633.c b/drivers/iio/magnetometer/mmc5633.c
index f4dae7ba1335..b651f01e1b5d 100644
--- a/drivers/iio/magnetometer/mmc5633.c
+++ b/drivers/iio/magnetometer/mmc5633.c
@@ -499,13 +499,12 @@ static int mmc5633_resume(struct device *dev)
 	struct regmap *regmap = dev_get_regmap(dev, NULL);
 	int ret;
 
+	regcache_cache_only(regmap, false);
 	regcache_mark_dirty(regmap);
 	ret = regcache_sync_region(regmap, MMC5633_REG_CTRL0, MMC5633_REG_CTRL1);
 	if (ret)
 		dev_err(dev, "Failed to restore control registers\n");
 
-	regcache_cache_only(regmap, false);
-
 	return 0;
 }
 
-- 
2.56.1



