Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EEF223320;
	Thu, 12 Dec 2024 16:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021485; cv=none; b=BeMYZgE3Le97cxLt2InTD5Dd1NftgUpCWZWi4ji83RYY9VRZZXm1mPYySGaHLG+DT8RS9qWg4S/M9wTDc2o5S2n90aVD16oSLnUa0amNTCVRSLowYNd/VaCDPfQy2tXg6JH07/14kol4NSVXtcseL7BP6QcvM8P8XczR6b92CAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021485; c=relaxed/simple;
	bh=Lj82KgxOiOwgH/ouPoCMGUgUmv4BaZ8NglmcIgGOSLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujuNX8qmRD/v1SXPcYf1WF4Cq1/yzolfR6vHVhxtLqNuq0pUuXtNVp/FxaSmK5b/QHbuH640IxO6atJdpBSle1pCr6uOgHlBgVlR77AvjH1vQTnoNmbAT9HcC/1baYyRjJXMXW24L1/TKC34koo8vSBt9nMFAyWsS3bhVR0wfPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7YU1iB9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7YU1iB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F355EC4CECE;
	Thu, 12 Dec 2024 16:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021485;
	bh=Lj82KgxOiOwgH/ouPoCMGUgUmv4BaZ8NglmcIgGOSLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7YU1iB97744R1M+8M+sVdtnOSiDI1+Vox1Ho8KGlFBx39B/Gjrhv3UCZGnsNz5xN
	 CKMaJI/PaM7p7iF0jQT1Bs95M43yps65L3EyJ4bVSwvyo9hoE+0DjAGaGqG0JFdOkw
	 V+vWPuW+RLtdEs6XbvMVthzGyJuXthcPw4CQxB98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 721/772] iio: light: ltr501: Add LTER0303 to the supported devices
Date: Thu, 12 Dec 2024 16:01:06 +0100
Message-ID: <20241212144419.683516332@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 74a1ccda8b9c4..49f293232a709 100644
--- a/drivers/iio/light/ltr501.c
+++ b/drivers/iio/light/ltr501.c
@@ -1631,6 +1631,8 @@ static const struct acpi_device_id ltr_acpi_match[] = {
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



