Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE412221F00;
	Mon,  2 Jun 2025 15:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877567; cv=none; b=N4Jw0J3HWZQgF2sdAwv/zly5xDibjLF5rNLOxcTFTgKTI8b0w/Ih/Tw0YXWdRwv8f7Hc5NMnT/9uj5Wsc8/vdNQYpIY2PzecA4/YW7rRk54EpX92l/jskIbQtYXWXb1yNpJ05cjTOYyFhMQnFfXecDRet9P8vB/62jgzBfUHNJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877567; c=relaxed/simple;
	bh=dO90ZopGRBi9h7zVx7q65lzka/SE51ORMBrfS54YsQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FEr5qab9Cl5Ir9NGAZcZN7sTdCYapon97wBNi6iEarH4o3dvg8Dv8nEnbbfjFKFnmlNgIRdJz9uCDITw7WSPWFOCdkQUKfCt3V9U8d5KbdWo8gUqU/Ebu0AmrcSwQOFWnbze2S2MQLE6SG+Irjm4K+T6ys8E8UWG7B+flAe0wRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CsvBi4Vs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CsvBi4Vs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC94C4CEEB;
	Mon,  2 Jun 2025 15:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877566;
	bh=dO90ZopGRBi9h7zVx7q65lzka/SE51ORMBrfS54YsQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CsvBi4VsoqGpjk1+YtjCvNVOVkPoCq8MRask/F9lzZozj5x4jb3NAD6XskmYAB8aw
	 O6WD+c6/u0ugLqW9yFWvvru1nHk3tqqYJtZhyMK5Ss3zfa33LBWuJIGPRfyaEPKoIR
	 WpAj5OhuJti95pkYpUVeR1JlSDlvewMN7we1tZ+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Chau <johnchau@0atlas.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 318/325] platform/x86: thinkpad_acpi: Support also NEC Lavie X1475JAS
Date: Mon,  2 Jun 2025 15:49:54 +0200
Message-ID: <20250602134332.852113241@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 26ca9c453a59c..295939e9ac69d 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -11517,6 +11517,8 @@ static int __must_check __init get_thinkpad_model_data(
 		tp->vendor = PCI_VENDOR_ID_IBM;
 	else if (dmi_name_in_vendors("LENOVO"))
 		tp->vendor = PCI_VENDOR_ID_LENOVO;
+	else if (dmi_name_in_vendors("NEC"))
+		tp->vendor = PCI_VENDOR_ID_LENOVO;
 	else
 		return 0;
 
-- 
2.39.5



