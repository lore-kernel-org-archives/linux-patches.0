Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA042F3C32;
	Fri, 10 Oct 2025 13:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102310; cv=none; b=Q4wlFlBi+bokV/wRKQI4uTqqSm5VebT0OWhOrV0lRRT1qvIfaX8bnQ2ZAuViorUR8obrCS5P34ji0TMYPwQEzuqqUNygRE5w61rXbrrst4L/XyZvQvAajVeHA2L8SChTHv07XOXxcgcWlNSvgJyTB/l3zQ4V2RyHukpeVrQ0LFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102310; c=relaxed/simple;
	bh=FdWvGbHhgV/CaeijXHtWTr0KCztKl8ebl9gFPeYm02Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PN8Ph96vWwfTOFpP1SsPBYNF2uvyLFv1s7MthNaSYOqpBvpMcSDI+gSBuQEjDTOSrKFnOddb7s6y1dGPfKqDRqAs5kqgKjiP6iZ9XQSq2oWHzwg/c7/IXGxra+oLv01nmj1xftInVRlQqbGlcMPYSQmqc9RRaXtgYKLbAFZqBvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6ri0BmW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6ri0BmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEA7C4CEF1;
	Fri, 10 Oct 2025 13:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102310;
	bh=FdWvGbHhgV/CaeijXHtWTr0KCztKl8ebl9gFPeYm02Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6ri0BmW8mONvgKRJy9n2A6l/b5XIphhI58p9gVGaUbgJqM8LXTTXE6WJ/W90LMtP
	 gteCws25Fud5jAznZm9a6hyr5K7hy2ZxTn+nmDPcsp6GkndbLuMyvIg47xVr/KqLdG
	 WYUEtRH/jIRoOzmg390DgYOHwWSW4s2JXCmJrOjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Mika Westerberg <westeri@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 12/41] gpiolib: acpi: Ignore touchpad wakeup on GPD G1619-05
Date: Fri, 10 Oct 2025 15:16:00 +0200
Message-ID: <20251010131333.868542755@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit 3712ce9fa501617cdc4466d30ae3894d50887743 ]

Same issue as G1619-04 in commit 805c74eac8cb ("gpiolib: acpi: Ignore
touchpad wakeup on GPD G1619-04"), Strix Point lineup uses 05.

Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Reviewed-by: Mika Westerberg <westeri@kernel.org>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-acpi-quirks.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpio/gpiolib-acpi-quirks.c b/drivers/gpio/gpiolib-acpi-quirks.c
index bfb04e67c4bc8..7b95d1b033614 100644
--- a/drivers/gpio/gpiolib-acpi-quirks.c
+++ b/drivers/gpio/gpiolib-acpi-quirks.c
@@ -317,6 +317,18 @@ static const struct dmi_system_id gpiolib_acpi_quirks[] __initconst = {
 			.ignore_wake = "PNP0C50:00@8",
 		},
 	},
+	{
+		/*
+		 * Same as G1619-04. New model.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "GPD"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "G1619-05"),
+		},
+		.driver_data = &(struct acpi_gpiolib_dmi_quirk) {
+			.ignore_wake = "PNP0C50:00@8",
+		},
+	},
 	{
 		/*
 		 * Spurious wakeups from GPIO 11
-- 
2.51.0



