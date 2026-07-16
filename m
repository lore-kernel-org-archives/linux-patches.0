Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC52424674;
	Thu, 16 Jul 2026 13:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209047; cv=none; b=d1fTkPmruJ1R1bC6I15jOqSdVxmn1nig4eQdPoaTK5IALLOHFays7c2r2KodP1/ITyOfBWDLP+kqxYXkSs6EQi7d/P9WglwoXd4by2ootnAre2oeCypMOkBx5CQ/71BZlguqDNJoa4eWOD9e7P0EjHGRCcJMPBdu+9tL1wLyzSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209047; c=relaxed/simple;
	bh=cjy3AJrbt5Nm1BiGBbDJe06fSQXiNFrRaF9frO9x/kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJ661FFx+V6l3AUaRGqA+1BDNJiZMZyLcxd6SKprBVr1ZaTRzXzanicbDksGK6u99oZCExt9YfpXoTmSfWV5AMU0zb+5uqMClbjwh5gq5A2z8PMVNvYaVZLAjOh4UHIIdfKhp79UlHcIKGfdM9f7qZMdKZShlTbWh02HPcWVjz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YBLrEcQW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YBLrEcQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C8F1F000E9;
	Thu, 16 Jul 2026 13:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209044;
	bh=RhuGgdffJ3HO1nUONlbUnCWPnxzQ3ecW+bJqDLL+rUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YBLrEcQWVDQMLx6pRQzu59c6MAcCJ1s6FlL+wbendgFPa63pqPjCFVQ+6W/AaZkC4
	 YNm4O1/OwNqxby4qc3re0x4b7f7rXUNwGYOrBO1jIutQcm7RvM3C5wr3HojMGrpecW
	 8uX81sEUZldMAqFx5rTQuwXRAM6RquQK88+zvrVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 037/518] iio: adc: ad7768-1: Select GPIOLIB
Date: Thu, 16 Jul 2026 15:25:05 +0200
Message-ID: <20260716133048.590686887@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 5a9c90350be4f6f175bdd193e8bd60a7aedfb4d2 upstream.

This driver provides a gpio chip a some related functions are not
stubbed if GPIOLIB is not built.

ad7768-1.c:420: undefined reference to `gpiochip_get_data'
ad7768-1.c:498: undefined reference to `devm_gpiochip_add_data_with_key'

Dual sign off reflects change of affiliation whilst this was under review.

Fixes: d569ae0f052e ("iio: adc: ad7768-1: Add GPIO controller support")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512271235.WwAmAbOa-lkp@intel.com/
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -416,6 +416,7 @@ config AD7766
 config AD7768_1
 	tristate "Analog Devices AD7768-1 ADC driver"
 	depends on SPI
+	select GPIOLIB
 	select REGULATOR
 	select REGMAP_SPI
 	select RATIONAL


