Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA39C15FA89;
	Mon, 27 May 2024 19:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836648; cv=none; b=FR1TDDFILbzUzqUP0WLDupevPho+HdpAkXk+OsCbuRgSIVmp1CilYMhT+b0KFw0uW8CzVupRhoygMPP+OD151qlJCoVZq0b+PEnbrS6auKv+m/qJE3jV8D62zD9pKGa5fv5WCjhKoBzjrsDUREbV3R+4mfwggkBPR72Kdsh6KNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836648; c=relaxed/simple;
	bh=IqWHBx6EkiKRqKDijPmLZrRwvEGSD2t7O/5tWbeQiOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuqWCn3C0m2Z7xDctliMVIL27IFyiO800I0P2++9rwcjCN2kttvlEJ4qnC9cdy2FniylIVcqqjXY1RMEOjqofg5+CuiWUNsa/zozMxgbHfj/KETFvJqDINwyBPV1NK7cp87bPF4xX7q9SiA+X+Wzspv29XWfSTBL5u8jqZ+Uyh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BwMCkZCz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BwMCkZCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F321FC2BBFC;
	Mon, 27 May 2024 19:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836648;
	bh=IqWHBx6EkiKRqKDijPmLZrRwvEGSD2t7O/5tWbeQiOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BwMCkZCzDL76grKi3ErKmd6p7p77eNmBXGURW6tVgC7sPBB1g+Pjjs95AiCuhQXmR
	 D/REk77uW/hRMC5cw1wU6n5CIgB+CVpkZfysClN6Qapb53iZGTYkpxDQhnx+gtVGtQ
	 EBHiHpS/UCMJDv/FJWGhYxjKf8o+qHBxhaK/S7a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 134/427] ACPI: LPSS: Advertise number of chip selects via property
Date: Mon, 27 May 2024 20:53:01 +0200
Message-ID: <20240527185614.384666059@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 07b73ee599428b41d0240f2f7b31b524eba07dd0 ]

Advertise number of chip selects via property for Intel Braswell.

Fixes: 620c803f42de ("ACPI: LPSS: Provide an SSP type to the driver")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_lpss.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index 04e273167e92a..8e01792228d1e 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -325,6 +325,7 @@ static const struct lpss_device_desc bsw_i2c_dev_desc = {
 
 static const struct property_entry bsw_spi_properties[] = {
 	PROPERTY_ENTRY_U32("intel,spi-pxa2xx-type", LPSS_BSW_SSP),
+	PROPERTY_ENTRY_U32("num-cs", 2),
 	{ }
 };
 
-- 
2.43.0



