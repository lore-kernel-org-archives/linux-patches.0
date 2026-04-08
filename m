Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C95835B653;
	Wed,  8 Apr 2026 18:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673236; cv=none; b=Q7kCShyrxehlQVR8LoH3on4MBmV4PlJNzYDC9jcC206pN1purk52mMDtVC6d3vdwY6qFNfKcjBThxDu+MTj2PnxCU+5dgop2976NlDtXxI+gZaDcuZAsuM8LjGPnc7jtVqllNxXBJPLvPN9Fau+8rHzL8gojvSYYo8BQBy8mqBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673236; c=relaxed/simple;
	bh=fnvgDp/Kdj24jGcDwpYXXvHOeoz2Nc32bSNCZfd10Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9zm3weMT2+xr758crmECTikZDNg6gZv/8mIuxqufTGVSIVKZqM2ab5L8ckmsSpDjkK5HV2jnY+Bg2uhZQw+hGs/SX/d8zGlxoVdQ7bnsGGlnLMrQPnnYORy+KLVE4nvIBeSGphPvfXPO8xAzSTOqcxjIRJwNmDD6SZT4XIWX00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjSy8Klr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjSy8Klr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A4BC19421;
	Wed,  8 Apr 2026 18:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673235;
	bh=fnvgDp/Kdj24jGcDwpYXXvHOeoz2Nc32bSNCZfd10Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjSy8KlrbolJQR4x0NALZ0Kcywzqv7cQeXaxiabgk87Exgh/+RnL9LaILbqDXeWkf
	 GjPUSlqjZfleJT37O80d0vPNv0ixKsDJfzY/CpgeaHUFa6S1i9VrGZt6/IODHXGA96
	 6wzqbthKFAQOUP1pt8Wur7klZmjNCAp2LCDsFxoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lixu Zhang <lixu.zhang@intel.com>,
	David Lechner <dlechner@baylibre.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 154/277] iio: orientation: hid-sensor-rotation: fix quaternion alignment
Date: Wed,  8 Apr 2026 20:02:19 +0200
Message-ID: <20260408175939.622220617@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit 50d4cc74b8a720a9682a9c94f7e62a5de6b2ed3a upstream.

Restore the alignment of sampled_vals to 16 bytes by using
IIO_DECLARE_QUATERNION(). This field contains a quaternion value which
has scan_type.repeat = 4 and storagebits = 32. So the alignment must
be 16 bytes to match the assumptions of iio_storage_bytes_for_si() and
also to not break userspace.

Reported-by: Lixu Zhang <lixu.zhang@intel.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221077
Fixes: b31a74075cb4 ("iio: orientation: hid-sensor-rotation: remove unnecessary alignment")
Tested-by: Lixu Zhang <lixu.zhang@intel.com>
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/orientation/hid-sensor-rotation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/orientation/hid-sensor-rotation.c
+++ b/drivers/iio/orientation/hid-sensor-rotation.c
@@ -19,7 +19,7 @@ struct dev_rot_state {
 	struct hid_sensor_common common_attributes;
 	struct hid_sensor_hub_attribute_info quaternion;
 	struct {
-		s32 sampled_vals[4];
+		IIO_DECLARE_QUATERNION(s32, sampled_vals);
 		aligned_s64 timestamp;
 	} scan;
 	int scale_pre_decml;


