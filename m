Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FC82FE079;
	Tue,  6 Jan 2026 17:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721391; cv=none; b=dgNJTrQCe/AqKOfTqWyUOLUA68U4adHdLxjny0dCMvUvbhTR/PaUf8ISfap+jUd9me18yBbZ+p1l7AsSApfDuSkp3SPdlwU+jxGqDMJMJV3rGBeRCJW4yJPdxdyuZnaqLtVr3T5jXQKup9/embH33tdkbcch3HGuhGopbuLAjno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721391; c=relaxed/simple;
	bh=Rke1jB+d0i0h9x7k7OaNuYmtbik7DUikJyLgIrC7U0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KN++Fp2T/s20x2DmXPnLzyaoyBQYAlVaFRrTJhW9ZX9ma4s4Twbs5Br10BdfvCkWct+JjHi9XSVXhYE3MNessoWTGw0DsFY7nM3QgWQq9fKmFl5X6iCMnICzPsgHsLVhEwmEoD5lA6DE78myY0rqKidd9W2oxq1dkoL0SwClews=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vB0aq7Ql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vB0aq7Ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF9BC16AAE;
	Tue,  6 Jan 2026 17:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721391;
	bh=Rke1jB+d0i0h9x7k7OaNuYmtbik7DUikJyLgIrC7U0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vB0aq7QlxYx1ZdfOb07AuW6PyPszyyOLizbEVrjpKoHE2h3NiSUoKWqkIowfA+NnZ
	 6fUk+spEyErdoc8FTknphZTDdGXUbR0sRnznxzeNZM8Zl14TenqbaIEYRedJ2ARVSk
	 k3QD/WmJhuLgsDU7ytwce3C7UfARwYenHc760yCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Chaudhari <amitchaudhari@mac.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 521/567] gpiolib: acpi: Add quirk for ASUS ProArt PX13
Date: Tue,  6 Jan 2026 18:05:03 +0100
Message-ID: <20260106170510.661170997@linuxfoundation.org>
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

From: "Mario Limonciello (AMD)" <superm1@kernel.org>

[ Upstream commit 23800ad1265f10c2bc6f42154ce4d20e59f2900e ]

The ASUS ProArt PX13 has a spurious wakeup event from the touchpad
a few moments after entering hardware sleep.  This can be avoided
by preventing the touchpad from being a wake source.

Add to the wakeup ignore list.

Reported-by: Amit Chaudhari <amitchaudhari@mac.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4482
Tested-by: Amit Chaudhari <amitchaudhari@mac.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://lore.kernel.org/20250814183430.3887973-1-superm1@kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: 2d967310c49e ("gpiolib: acpi: Add quirk for Dell Precision 7780")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-acpi-quirks.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/gpio/gpiolib-acpi-quirks.c
+++ b/drivers/gpio/gpiolib-acpi-quirks.c
@@ -344,6 +344,20 @@ static const struct dmi_system_id gpioli
 			.ignore_interrupt = "AMDI0030:00@8",
 		},
 	},
+	{
+		/*
+		 * Spurious wakeups from TP_ATTN# pin
+		 * Found in BIOS 5.35
+		 * https://gitlab.freedesktop.org/drm/amd/-/issues/4482
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_FAMILY, "ProArt PX13"),
+		},
+		.driver_data = &(struct acpi_gpiolib_dmi_quirk) {
+			.ignore_wake = "ASCP1A00:00@8",
+		},
+	},
 	{} /* Terminating entry */
 };
 


