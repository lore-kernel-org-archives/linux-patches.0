Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CD452ED5E;
	Wed,  9 Sep 2026 13:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962353; cv=none; b=LCUMol7SkCcR/5t3Uspy/KJSLN5wgHp5cHLxWo5pbd/+9xZYZqxdxENng9h6S246jS0v9dZdQNyy44zVkH+vPrqqAjMVsyMwAZTtyGg2KMlRpZntdTiBYePxecU6U7peFYveB7syLJykwvxR79/qeg3eHGUTYjKXw5/6ilVXmXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962353; c=relaxed/simple;
	bh=ggWKhgGkK0mZYYIglnxbk0sP3cLejF/9p5Ufo56jmes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDvBESlRMsh+mXiceQwryCPnQRDR4V4CQ/iA6CJdyl2eQqqrhDoKKz5k4mDTJsxY1edBryw3kNZkpLGYpQflm2mtKPL3KGniAXDPWlFIcTRcCFzjvMNIN8QBy8eGAOzFdPzzTusi1WeX42VcfhUONqPEtcT+5HdbVaDDptQ/BhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqwXVfFs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqwXVfFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0571F00A3A;
	Wed,  9 Sep 2026 13:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962352;
	bh=U3cKeG/9b5rjh+4G+AYOGVq2U2NriCaLPdlHVi7enuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EqwXVfFsgC+H4CIaCSdUX8FRvd/8kDSH0T3B2lqjT86f4zY8rO7VZyUfSU+zXExki
	 utjzELm8C2v0es4LRvG3vfYd/MiXJjtlb+Wz4slP9mw2aHHq5nH1DRdK5gxsGGptHF
	 Ygz1fsqLivO7aAH3BoydcZjAe5DcRx79otMcCcSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 262/556] iio: adc: max34408: add missing select REGMAP_I2C to Kconfig
Date: Wed,  9 Sep 2026 15:39:02 +0200
Message-ID: <20260909134239.755490078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Crofts <joshua.crofts1@gmail.com>

commit 947f1079074a260ba200419d5cba6b8549d5ac0c upstream.

The Kconfig entry for the MAX34408 is missing a 'select REGMAP_I2C',
causing build failures.

Fixes: cf27775838c5 ("iio: adc: Add driver support for MAX34408/9")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -1087,6 +1087,7 @@ config MAX14001
 config MAX34408
 	tristate "Maxim max34408/max344089 ADC driver"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  Say yes here to build support for Maxim max34408/max34409 current sense
 	  monitor with 8-bits ADC interface with overcurrent delay/threshold and


