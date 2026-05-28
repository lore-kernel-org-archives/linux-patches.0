Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DACC1A9B46;
	Thu, 28 May 2026 20:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001524; cv=none; b=Rt0rgb0s2CQ3F3NhELrp+Tlbi+Y+xaRFagyZJb4JhEZnAnSFhAP2nPU6BHyV4rse07hW4IxOC0nA/zEVPVCAqGHPspEkEHOduO+H19EO8ZqdJewsnJQ2q6kDyNknQGroEmYq+ZfKv6NmhNF6dhhhljPXw0Tgzjx0hD4vFMe4PRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001524; c=relaxed/simple;
	bh=aeC+bDnfRY2ka9DYcj9/LZf0AHp1KNZLqa2spyBFtbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MCwJXRk9zVuq6Y4TAB4QhQQYnkTeb5+Z8DonqA1lsGHD0NMDmSgRNzoIE5LQO3RzBlqcksxl3LtOnelI3CNKCR/w+WN0lgrdzpJ+J78Lk+oTD/DD7zw/b8FQzDrL4GfCUCOSnMFeCR7w8ATXYJdSAjV7UeUKf52I5B1k6Lcn68c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GzL44iDd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GzL44iDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219471F000E9;
	Thu, 28 May 2026 20:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001523;
	bh=QC0I/XmCubv57lMzif5wvDo2FpICfbb6Jaqpy0oveZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GzL44iDdpfrCRR6u0YKhF8PSnT+cwrFpWLs0Ud+vssRjRuB38kHxff8MsWXhKvy/6
	 PN1p5kZF5+x+L0QvFn5/NVVd5R9O7fdIHaFjtc9qaalH8WgcXdDUFgjOr1rCFrisN5
	 PSims2IZqYhIDvblOUSHvYRgc6Iw1u5Wii6YuSRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 159/186] platform/x86: hp_accel: Check ACPI_COMPANION() against NULL
Date: Thu, 28 May 2026 21:50:39 +0200
Message-ID: <20260528194933.252579557@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit abfbe5ee8ae89f1f5449790423d5dd3e423545bd ]

Every platform driver can be forced to match a device that doesn't match
its list of device IDs because of device_match_driver_override(), so
platform drivers that rely on the existence of a device's ACPI companion
object need to verify its presence.

Accordingly, add a requisite ACPI_COMPANION() check against NULL to the
platform/x86 hp_accel driver.

Fixes: 8ebcb6c94c71 ("platform/x86: hp_accel: Convert to be a platform driver")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/2425918.ElGaqSPkdT@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp_accel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/hp/hp_accel.c b/drivers/platform/x86/hp/hp_accel.c
index 52535576772ad..aeedc77bed7fc 100644
--- a/drivers/platform/x86/hp/hp_accel.c
+++ b/drivers/platform/x86/hp/hp_accel.c
@@ -300,6 +300,9 @@ static int lis3lv02d_probe(struct platform_device *device)
 	int ret;
 
 	lis3_dev.bus_priv = ACPI_COMPANION(&device->dev);
+	if (!lis3_dev.bus_priv)
+		return -ENODEV;
+
 	lis3_dev.init = lis3lv02d_acpi_init;
 	lis3_dev.read = lis3lv02d_acpi_read;
 	lis3_dev.write = lis3lv02d_acpi_write;
-- 
2.53.0



