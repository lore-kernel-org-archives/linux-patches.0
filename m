Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A52A158D97;
	Tue, 23 Jul 2024 18:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759659; cv=none; b=FY8C/DEfmf0c0bDa97oCuLd2bQCgv99S0tbnZlPTuppKaUhb7HKGV+L6l/I0rsahjSe2f3MugGHoT9in58OuSIoPdt92YoupvRSP7zp06/hbUAUiR/Jo7by+GD6F0fnbz7mQpBYkIKOGS+py9tCizKldhrbknLTpX9oSRivVZMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759659; c=relaxed/simple;
	bh=yv6kftk0itiZMDLS7s+uW3YaeaDAY/GpFCxui8JHF+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OpZR2K9yezA56R6YAEuBsoCBp3zo771pdIiJvSjmMQ30Q68JXu2fnI8YEmm6NGjQancJRvoMFXtQeEMn3u5ysp9ucQd2kQtI/OQom5LepJQdXh2SGmsmRmDdiPDBPb/hcOumXyAyq+MrPwhuY4KRYMqpJQI9a/ygziHn0ESSn60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2g8qkPj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2g8qkPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D207CC4AF0F;
	Tue, 23 Jul 2024 18:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759659;
	bh=yv6kftk0itiZMDLS7s+uW3YaeaDAY/GpFCxui8JHF+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e2g8qkPjBm7e8RWEHyeKJ+iYkBtjBvN2MYqaumkFn0o8lbXbg2LrdUHrUZqKA9e5j
	 mJ7V9o5QC+3j1ZmAkrAS7V8Ot3bWkH6yi2nSG78yWVcxHZT2a/ga3PDFQuAtRpqHlc
	 rcFHXKJ6ukrIPONj70527lGeXRg7vd50s6L0lLeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Agathe Boutmy <agathe@boutmy.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/129] platform/x86: lg-laptop: Change ACPI device id
Date: Tue, 23 Jul 2024 20:23:52 +0200
Message-ID: <20240723180408.030665251@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 58a54f27a0dac81f7fd3514be01012635219a53c ]

The LGEX0815 ACPI device id is used for handling hotkey events, but
this functionality is already handled by the wireless-hotkey driver.

The LGEX0820 ACPI device id however is used to manage various
platform features using the WMAB/WMBB ACPI methods. Use this ACPI
device id to avoid blocking the wireless-hotkey driver from probing.

Tested-by: Agathe Boutmy <agathe@boutmy.com>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20240606233540.9774-4-W_Armin@gmx.de
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lg-laptop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/lg-laptop.c b/drivers/platform/x86/lg-laptop.c
index 545872adbc52a..8f8eb13b2a6b2 100644
--- a/drivers/platform/x86/lg-laptop.c
+++ b/drivers/platform/x86/lg-laptop.c
@@ -768,7 +768,7 @@ static void acpi_remove(struct acpi_device *device)
 }
 
 static const struct acpi_device_id device_ids[] = {
-	{"LGEX0815", 0},
+	{"LGEX0820", 0},
 	{"", 0}
 };
 MODULE_DEVICE_TABLE(acpi, device_ids);
-- 
2.43.0



