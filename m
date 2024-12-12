Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65139748A;
	Thu, 12 Dec 2024 15:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017217; cv=none; b=pVf72h/BlCoWixbJsFa1LzAqTyuW93t4rc4CdZhqJ10b0mJ13Gecpk1oi3D4XTLHN+OBdZmgKqCFeC+8Ng68sxLc/bSizzLbxf9dSq/ufVsZ2N2Rd9A0qrWwP85Ly7/WzL7TIRY46L/O5ZJuunNSzoVKHrhR1mGTv8QxinJt9/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017217; c=relaxed/simple;
	bh=pl/5oVihgVjMzOkojUK/gH5arALrVJnMfNuAGokVZNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F120WajjZ/K4uH9GcMM+DBqeJHH2gQsmsJA9Sr+mI/6l9glQnya1uzQwUk+PV7Kvb+YP7Wm7morhQPAw3S0HE7VVGtQv6nDVptdQm/Ml9lf1q6irHf5pGi9kcYQH8z3vjritc/O/6Ohv7bWEe6SIZHGrJsLu3oI2p0ZBm0+rCTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H7n7kE05; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H7n7kE05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C513FC4CECE;
	Thu, 12 Dec 2024 15:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017217;
	bh=pl/5oVihgVjMzOkojUK/gH5arALrVJnMfNuAGokVZNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7n7kE05dcQmEfSfgUVXTetBOHb6Maq/muw7/aF/2EAYO8hhXX0tBtOpRhrWrTNtM
	 LNg39GRME8a/Ss3DBxpQd1XSVXnHNBEf7ZGxfOHCQMa584xMkIAnGWVOrpcm/FV26o
	 +6owtcgffD4cvf4iGgScogPUP3tfhivE1ybZLUJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 415/466] iio: light: ltr501: Add LTER0303 to the supported devices
Date: Thu, 12 Dec 2024 15:59:44 +0100
Message-ID: <20241212144323.152714574@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit c26acb09ccbef47d1fddaf0783c1392d0462122c ]

It has been found that the (non-vendor issued) ACPI ID for Lite-On
LTR303 is present in Microsoft catalog. Add it to the list of the
supported devices.

Link: https://www.catalog.update.microsoft.com/Search.aspx?q=lter0303
Closes: https://lore.kernel.org/r/9cdda3e0-d56e-466f-911f-96ffd6f602c8@redhat.com
Reported-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20241024191200.229894-24-andriy.shevchenko@linux.intel.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/ltr501.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/light/ltr501.c b/drivers/iio/light/ltr501.c
index 8c516ede91161..640a5d3aa2c6e 100644
--- a/drivers/iio/light/ltr501.c
+++ b/drivers/iio/light/ltr501.c
@@ -1613,6 +1613,8 @@ static const struct acpi_device_id ltr_acpi_match[] = {
 	{ "LTER0501", ltr501 },
 	{ "LTER0559", ltr559 },
 	{ "LTER0301", ltr301 },
+	/* https://www.catalog.update.microsoft.com/Search.aspx?q=lter0303 */
+	{ "LTER0303", ltr303 },
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, ltr_acpi_match);
-- 
2.43.0



