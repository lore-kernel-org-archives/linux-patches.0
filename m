Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233012FD69E;
	Tue,  6 Jan 2026 17:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721388; cv=none; b=P5oRnHcjHOMPUxoTQ3uMmMs5w6DqoK4Rt4yEAOqKV7HOb4sJWgJJz5saoviZyHddvx6pn5IrZRSQLd0uVo9cXvu9nfoJGOIc8c5SMPdh19cCPGatBEqhfI+N8Yogh1uxbCp33EuWiaPtWs6yldCeQXpfeOoWSZogYOVAeUGRtkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721388; c=relaxed/simple;
	bh=hWGmpzPhdW1Yo5uvJAJtwKJh6KT/AuHvPJEuDPeFTUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBvgVLZ21HhnYPkGYQYw2odOrPRjOIO88dHPLx/wj7sMgTOOBBspV2R7P7fTbqMNxlrw9sfQuIjKi5I/ZPHZybU2wQyx0lb65z9YmLpk9dxJ3HFSzOOgqE/IacPdcPdgGPzxjUBnK/Losla64wQ3ohYVyJIv6SPsCmPCzUwu6gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOaDUrmY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOaDUrmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4C9C116C6;
	Tue,  6 Jan 2026 17:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721388;
	bh=hWGmpzPhdW1Yo5uvJAJtwKJh6KT/AuHvPJEuDPeFTUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qOaDUrmYGSEZM394RiAtRsp66FNfV1PSuR4oNvdAlaGuhdIcmDkLOMxpjZZjjEYfs
	 x0DDEqpERsCQD8mG8ykDxA9tXV8d1lReiKjaAX0Ey8+mYiGokEkTyB9L6FU8KXb7l0
	 bkZVooaI44nzbcAmjz2BvnfGUdXGg+GC34imPMmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mika Westerberg <westeri@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 520/567] gpiolib: acpi: Add a quirk for Acer Nitro V15
Date: Tue,  6 Jan 2026 18:05:02 +0100
Message-ID: <20260106170510.623724462@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 9ab29ed505557bd106e292184fa4917955eb8e6e ]

It is reported that on Acer Nitro V15 suspend only works properly if the
keyboard backlight is turned off. In looking through the issue Acer Nitro
V15 has a GPIO (#8) specified in _AEI but it has no matching notify device
in _EVT. The values for GPIO #8 change as keyboard backlight is turned on
and off.

This makes it seem that GPIO #8 is actually supposed to be solely for
keyboard backlight.  Turning off the interrupt for this GPIO fixes the issue.
Add a quirk that does just that.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4169
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Mika Westerberg <westeri@kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Stable-dep-of: 2d967310c49e ("gpiolib: acpi: Add quirk for Dell Precision 7780")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-acpi-quirks.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/gpio/gpiolib-acpi-quirks.c
+++ b/drivers/gpio/gpiolib-acpi-quirks.c
@@ -331,6 +331,19 @@ static const struct dmi_system_id gpioli
 			.ignore_interrupt = "AMDI0030:00@11",
 		},
 	},
+	{
+		/*
+		 * Wakeup only works when keyboard backlight is turned off
+		 * https://gitlab.freedesktop.org/drm/amd/-/issues/4169
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_FAMILY, "Acer Nitro V 15"),
+		},
+		.driver_data = &(struct acpi_gpiolib_dmi_quirk) {
+			.ignore_interrupt = "AMDI0030:00@8",
+		},
+	},
 	{} /* Terminating entry */
 };
 


