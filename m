Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48EA4302E6;
	Tue, 21 Jul 2026 20:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664115; cv=none; b=GvRzqJyAJpFz2ZHhAsSHBQqKnJ5zcUcUvTO3mcdQGiJrDeTJkwxaEN5/xiQGRbSm7iqbHxRl1lFtoxz6Ogi2Vad8u3LEAL7awb9czCUFPLBqEUexsUPm4DIbbiTprW2RnS6E8ZO9msVFixskfey6wL7wR9FIDMxXmOyOHYjFKW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664115; c=relaxed/simple;
	bh=Wo4udALKgBJOqazxVqXRhoAaYq9UPX4OdYrgP7C/9N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HEBKzukgKyybcN7C/j8OCatg2wOAhmP6XF0FL6qbejzPcWzPLwN7mzPXDD3UknCYNJUsIPZwNFhybPkfdvwL6sKoBiVJ0K6OKipYm2BS4gKAtf30Kmtp8gMFuRtoy/FwRmT5wi8U+lpxbpV4Z6fC/KEkmYwyu5JrNNKq0sc3gOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OanFDGbz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OanFDGbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BFE1F000E9;
	Tue, 21 Jul 2026 20:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664114;
	bh=6Vceed2IxLZ5Z5EPlgrzz75sRbSoM1TD/e672zzxm4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OanFDGbzhj4msnzFCPUTmpuyenAdNtcDLzxNWompTC9WtAZ2DjttkPHRb8knpZiAN
	 nPXocp1l15X3zxC80MZoViBzO+TxqwlDrzs7kcMX4tl62bxJW9JheCGpMbVIKVcQvC
	 /MZvlFRyX5FI6VNmUmDghGOCLeR7FKgyTAieTckc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 1079/1276] hwmon: (max1619) add missing select REGMAP to Kconfig
Date: Tue, 21 Jul 2026 17:25:22 +0200
Message-ID: <20260721152510.133360061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Crofts <joshua.crofts1@gmail.com>

commit 943a749bdffdd2132fab9240db890e07d93e1fcf upstream.

The Kconfig entry for the MAX1619 sensor doesn't contain a
`select REGMAP` parameter, causing build failures if regmap
isn't selected previously during the build process.

Fixes: f8016132ce49 ("hwmon: (max1619) Convert to use regmap")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Link: https://lore.kernel.org/r/20260629-add-kconfig-deps-v1-1-8104df929b1a@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1141,6 +1141,7 @@ config SENSORS_MAX16065
 config SENSORS_MAX1619
 	tristate "Maxim MAX1619 sensor chip"
 	depends on I2C
+	select REGMAP
 	help
 	  If you say yes here you get support for MAX1619 sensor chip.
 


