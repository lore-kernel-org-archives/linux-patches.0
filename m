Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A126017B515;
	Fri, 27 Sep 2024 12:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440042; cv=none; b=oij7eDpBbjUl2Ch8uxB+P9e6Z32URMsS/kQno8KBm88Gdn3rbaCKiVi3H+tRNO2LcM1Eg9EkMKBDLjuBNgWx91THl7N2ZXTYh2f9VraqCYJdPsmkmBQvAT9S3cZauwBplY6zLM8Lrbb1ZavzahU8n+KYfueYsG0eARHnuHvEWiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440042; c=relaxed/simple;
	bh=S0QegfBZWRD0ouawBjdum1NclEDf+6qDeNwtsf35v4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A3E0a+80xyChkKFE7tmbENLk9clZNRwbfu9dHLaBP3DIQ6lVtHzGFBUom1gOvKfk/Miem7lIys/o/ipJb04eLJXRJqv3qdaK2iVJoeK6Lt22RE2BM6xqHqxKfqePDyG6xeM0ch5ez5pHv/jL/TWO9ky0QJclP1Q3mwV0952wsYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+P0jF48; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+P0jF48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1A2C4CEC4;
	Fri, 27 Sep 2024 12:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440042;
	bh=S0QegfBZWRD0ouawBjdum1NclEDf+6qDeNwtsf35v4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1+P0jF48mPwHtoWcm8UDt3nVj3V7GdKcRSXw+j5li4XhsaVrPy3suMFI0hgHWa9gT
	 3S8YpJLhQmmGIFm14k2jn4YumzEdSymn+zpoLAgpS/ku5dYWIJVO6GzMXcN4L0hbLk
	 ciwWjUxBZGOCPSknMRZ0qbhaQXJo5VqH4GkRWigE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 12/58] platform/x86: x86-android-tablets: Make Lenovo Yoga Tab 3 X90F DMI match less strict
Date: Fri, 27 Sep 2024 14:23:14 +0200
Message-ID: <20240927121719.298295929@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a3379eca24a7da5118a7d090da6f8eb8611acac8 ]

There are 2G and 4G RAM versions of the Lenovo Yoga Tab 3 X90F and it
turns out that the 2G version has a DMI product name of
"CHERRYVIEW D1 PLATFORM" where as the 4G version has
"CHERRYVIEW C0 PLATFORM". The sys-vendor + product-version check are
unique enough that the product-name check is not necessary.

Drop the product-name check so that the existing DMI match for the 4G
RAM version also matches the 2G RAM version.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240825132415.8307-1-hdegoede@redhat.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/x86-android-tablets/dmi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/platform/x86/x86-android-tablets/dmi.c b/drivers/platform/x86/x86-android-tablets/dmi.c
index 141a2d25e83be..387dd092c4dd0 100644
--- a/drivers/platform/x86/x86-android-tablets/dmi.c
+++ b/drivers/platform/x86/x86-android-tablets/dmi.c
@@ -140,7 +140,6 @@ const struct dmi_system_id x86_android_tablet_ids[] __initconst = {
 		/* Lenovo Yoga Tab 3 Pro YT3-X90F */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
 			DMI_MATCH(DMI_PRODUCT_VERSION, "Blade3-10A-001"),
 		},
 		.driver_data = (void *)&lenovo_yt3_info,
-- 
2.43.0



