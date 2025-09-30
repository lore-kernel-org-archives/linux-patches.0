Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E810B1EE02F;
	Tue, 30 Sep 2025 15:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244516; cv=none; b=Oy2JxggAOnSoS/kAU452RI830C7F8gEWmcQK7+goJEN1NPBtg41RPTn1TIn1gZJvDziOIgJ9Mo/NqT+nRf9RPytyv8B7U2S0chSnibGAw6edek+ZVKUCh9cfpIDO04tTNYrcXBfXDC3wbCwazvIJ9rdcVC+E83YWkAsf/UjpSNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244516; c=relaxed/simple;
	bh=5bGP7PxUcHk2DD+HlSQMCFcoAbuuZCvXLroKRBCnlbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXnl3eiPoawCHYy5cJvP0Tym8ySn1iZxS9WwGjoTM5dhJmXNA9HVRParFgz8b3t0v16SJnVz4t4z6+c3HellZHJniuEE2yT95M0molGTO5O5ObuzI39pnF5xJsWvR8OCIAgMYQGs4tfISTZpOo3SxUtrFQz7G+22QCnsqPYnHek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AuK1DWyp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AuK1DWyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A952C4CEF0;
	Tue, 30 Sep 2025 15:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244514;
	bh=5bGP7PxUcHk2DD+HlSQMCFcoAbuuZCvXLroKRBCnlbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AuK1DWypoHUwRrwTAVlQkK215t7B809xtddSwkjDn5k3zCT46YYNU6pzg42WmfNpP
	 D748wcBF+tc5RTPT5smK2aDGiBBW60+D3Wmlitv6Qxx5kjFKCFJuvcCxLvXvL2zYCj
	 M1sTb9udCspRm+GOCVY0FdCS3nBrmGLUHVZdQQ7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Chaudhari <amitchaudhari@mac.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 031/143] gpiolib: acpi: Add quirk for ASUS ProArt PX13
Date: Tue, 30 Sep 2025 16:45:55 +0200
Message-ID: <20250930143832.484270364@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

From: Mario Limonciello (AMD) <superm1@kernel.org>

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-acpi-quirks.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpio/gpiolib-acpi-quirks.c b/drivers/gpio/gpiolib-acpi-quirks.c
index c13545dce3492..bfb04e67c4bc8 100644
--- a/drivers/gpio/gpiolib-acpi-quirks.c
+++ b/drivers/gpio/gpiolib-acpi-quirks.c
@@ -344,6 +344,20 @@ static const struct dmi_system_id gpiolib_acpi_quirks[] __initconst = {
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
 
-- 
2.51.0



