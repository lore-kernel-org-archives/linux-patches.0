Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00073222D55;
	Thu, 12 Dec 2024 15:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018476; cv=none; b=FbdMCnIXgj48e6PC1MWOHBIiHuVtzEkqj7/TScpp6uc61w6m5cyftM+BNZObDEsz3ohsfSnGjjkYcmLxXcLY08AsUebExL+pK/rquw5VMF78v+ptXfbAi+23T6F/22MHyXCndUhGrYjMFsm+yoFmaGwEwQf6UgknXitoX0SaHq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018476; c=relaxed/simple;
	bh=r8oplk/Oc9j7Oz/Dh+PcR7U7OugP2u8ofa7F0ek328Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFg1HAcUnwMaSzFOCKeyekVJ77NtqODarNlndQ8dTkGnE0DFEtdEtPaBvp6CxPgQ40yb9SBxtzA4wsgRZiVMOu/EE7RTcCqCN09Jt2Wdv2O+/nUOZ1BXyM49nXg6urjxduLb8VoruIB9kZtTdFGX+YgSCaDCQIRyPFChOQSKe9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cqdVu0ME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqdVu0ME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A60C4CECE;
	Thu, 12 Dec 2024 15:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018475;
	bh=r8oplk/Oc9j7Oz/Dh+PcR7U7OugP2u8ofa7F0ek328Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqdVu0MEwROxcDY7+m+0M5mjeqk0c/mAP6UEEx4C1EcuFDbDkyYGRjtIsgBHWahiX
	 0y5X2+WKGw02HUsjSmU6TYaN7utCQ3m0Q8G8rOFMJzEXDSCPigFqHZwKZeoU5T5rie
	 4OU7ImcELHi3+rRabE9a1+0LWO3c37Fm+E1QTreQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 304/356] iio: light: ltr501: Add LTER0303 to the supported devices
Date: Thu, 12 Dec 2024 16:00:23 +0100
Message-ID: <20241212144256.575174852@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 061c122fdc5e7..498cff9327132 100644
--- a/drivers/iio/light/ltr501.c
+++ b/drivers/iio/light/ltr501.c
@@ -1612,6 +1612,8 @@ static const struct acpi_device_id ltr_acpi_match[] = {
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



