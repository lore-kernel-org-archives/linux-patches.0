Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C27E3043CE;
	Wed, 28 Jan 2026 15:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615194; cv=none; b=V/jsIWNmogKqvryMr2Tt/gUEwmrw/czkUYV35xwUukgR3buPegvedJslVcbxztEiKsa1M+AVxpC0OhIFK8b/gZfuHvRDbFVp3DMk7KGcITXM7NR9T1ln71L2l/QD3IY6FmzbLR67o5VYt6ReMfhZnDOUvF7Vd6feswihSD75es4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615194; c=relaxed/simple;
	bh=qv3U6ptsfOQqj4QbfWotRObOxu6rxnKak+1Vw6I9PFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qqEt+KbU55UtTsaJoslitkwavpPKjzGz68lnATeeJ9NKWimsMmdc8HBGXehZpz7WX71p9/ATJ9QBoGBFF65Gl9Le0n3kexL/KEIRZ1r5Z+jgRfQAd6MTUaySEtwhU/1Z7nrbI0hKmiJWd3oi6sd3sLUplnVfmeUnlv/iki92YYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZE6uttM1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZE6uttM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3250AC4CEF1;
	Wed, 28 Jan 2026 15:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615193;
	bh=qv3U6ptsfOQqj4QbfWotRObOxu6rxnKak+1Vw6I9PFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZE6uttM1yGGfKQ2SyG7hHH5qVNhqG90VoGXuFiFqxIh3DgmY7J5QfqHZn5IZm1Cwm
	 1gozLuB7ZZHO+ge/HgbOYeeUdcFrE43/Gd6g5GpeqFH7H/fAbrz3ThUscXzHQNUX/6
	 RWqrK2n+EDOw9pIYlSQPEPOP1MqRIHCwAYW7rbcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Tomas Melin <tomas.melin@vaisala.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 106/169] iio: adc: ad9467: fix ad9434 vref mask
Date: Wed, 28 Jan 2026 16:23:09 +0100
Message-ID: <20260128145337.822806688@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Melin <tomas.melin@vaisala.com>

commit 92452b1760ff2d1d411414965d4d06f75e1bda9a upstream.

The mask setting is 5 bits wide for the ad9434
(ref. data sheet register 0x18 FLEX_VREF). Apparently the settings
from ad9265 were copied by mistake when support for the device was added
to the driver.

Fixes: 4606d0f4b05f ("iio: adc: ad9467: add support for AD9434 high-speed ADC")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Tomas Melin <tomas.melin@vaisala.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad9467.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ad9467.c
+++ b/drivers/iio/adc/ad9467.c
@@ -95,7 +95,7 @@
 
 #define CHIPID_AD9434			0x6A
 #define AD9434_DEF_OUTPUT_MODE		0x00
-#define AD9434_REG_VREF_MASK		0xC0
+#define AD9434_REG_VREF_MASK		GENMASK(4, 0)
 
 /*
  * Analog Devices AD9467 16-Bit, 200/250 MSPS ADC


