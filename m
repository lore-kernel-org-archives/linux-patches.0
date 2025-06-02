Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D2B22259C;
	Mon,  2 Jun 2025 14:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875889; cv=none; b=nSBTqSgmWBBZRM0pOV5AbGN7WkwDqtQ8WN1B0LUAvacJRwBkqPg7lSzkWRGHB7qt3XEcKxCzGuXut2+uHJCkiM7e890MrqYQeZwQVPvcikik5IHdPKlLbiYB1wna9RWFp2dAGsfP9i0khG+3ZbnJBLJvGG9Dxv9PxEdOPnuR0Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875889; c=relaxed/simple;
	bh=RqJANCq+3SyYwWoDxkdwbymxwcXNz/aLI8kFI0WAW5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ByfOsZ/GICj8abdOXVWMeDpNX4ipTyduk+8JChP5YZro0JPQ6tvKs3uDUl9Bzl2tBMCWClO8YLQZUDOeFH3YCG4e+SxFcPflhBbberScu6c5V7C0Oa8v/b7dxwQS3yNkXPqcCkVXzyllES6hWk9Rb/LbY2B1P9Ld91CnVe7wXuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hCC9OK6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hCC9OK6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568D7C4CEEB;
	Mon,  2 Jun 2025 14:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875888;
	bh=RqJANCq+3SyYwWoDxkdwbymxwcXNz/aLI8kFI0WAW5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hCC9OK6RzRvV/MTscdVnDduAK6el30Ca3tV0fmLkbmlvxloOfLcJ2VcAyzB0ANAKO
	 1aRvWtQ7X15BhkklTJBSBkFa9S+3eRVGkjddNno4DZa6DRGFOGE3gKrW/ox9prRPkA
	 fcTZ/aao04RZbPAGxf+XyYzCCNerQxMntmI3pa6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Chau <johnchau@0atlas.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 263/270] platform/x86: thinkpad_acpi: Support also NEC Lavie X1475JAS
Date: Mon,  2 Jun 2025 15:49:08 +0200
Message-ID: <20250602134318.090336401@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Chau <johnchau@0atlas.com>

[ Upstream commit a032f29a15412fab9f4352e0032836d51420a338 ]

Change get_thinkpad_model_data() to check for additional vendor name
"NEC" in order to support NEC Lavie X1475JAS notebook (and perhaps
more).

The reason of this works with minimal changes is because NEC Lavie
X1475JAS is a Thinkpad inside. ACPI dumps reveals its OEM ID to be
"LENOVO", BIOS version "R2PET30W" matches typical Lenovo BIOS version,
the existence of HKEY of LEN0268, with DMI fw string is "R2PHT24W".

I compiled and tested with my own machine, attached the dmesg
below as proof of work:
[    6.288932] thinkpad_acpi: ThinkPad ACPI Extras v0.26
[    6.288937] thinkpad_acpi: http://ibm-acpi.sf.net/
[    6.288938] thinkpad_acpi: ThinkPad BIOS R2PET30W (1.11 ), EC R2PHT24W
[    6.307000] thinkpad_acpi: radio switch found; radios are enabled
[    6.307030] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[    6.307033] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[    6.320322] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[    6.371963] thinkpad_acpi: secondary fan control detected & enabled
[    6.391922] thinkpad_acpi: battery 1 registered (start 0, stop 85, behaviours: 0x7)
[    6.398375] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input13

Signed-off-by: John Chau <johnchau@0atlas.com>
Link: https://lore.kernel.org/r/20250504165513.295135-1-johnchau@0atlas.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index c07b3bcbf795d..e9e63d8cbfbfd 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -10233,6 +10233,8 @@ static int __must_check __init get_thinkpad_model_data(
 		tp->vendor = PCI_VENDOR_ID_IBM;
 	else if (dmi_name_in_vendors("LENOVO"))
 		tp->vendor = PCI_VENDOR_ID_LENOVO;
+	else if (dmi_name_in_vendors("NEC"))
+		tp->vendor = PCI_VENDOR_ID_LENOVO;
 	else
 		return 0;
 
-- 
2.39.5



