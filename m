Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8219B13D600;
	Tue, 23 Jul 2024 18:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760128; cv=none; b=s6cvPt0yGDx0qadx/eBzLc54bOcq8ocjkcXSXlktCEqUV/IsDX3A6xKNYrCinifpSo8VzS7c8e3dIgmM/agNo3+A0WGfQuGY8bWjrmq/NQVwYFdWUQprIVOsIeE+1oas7+ow1BD2EQQroKx2iROwH4JjrwRuzc6T2v80WX0QMwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760128; c=relaxed/simple;
	bh=sF4hHDH9A9WsTTV1cZcWrwLhUvuf093V4a8lAFC1rMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KdXTa1oFUB+OjKzMSDsm5Sy6nHYtdaAZ1rC58TfRS66NtkZPmvKvFdqfNYwyVWlvWzMHT0/tHxfp66RzZ6hmtIVn8b0PSODIQDSULYNgu/ra+Y0Ep2n73ImhANPjXljKxNg5K0kaHxrszLtlkr0vyoo56CKa9vEZtolHDGFgfAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gRQVkcFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gRQVkcFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E2DC4AF0B;
	Tue, 23 Jul 2024 18:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760128;
	bh=sF4hHDH9A9WsTTV1cZcWrwLhUvuf093V4a8lAFC1rMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gRQVkcFU4EqxoOqsWgTFG6fVk73z4pVLTnvezJ5MJ2hXc93c5qvtkQlOBi2xlJD+h
	 1jGBpM/hJJjlPW9E17Yy9gUVGgNP6X1YYARcnspFL4EZg4tXL3X/VcYqYTpaxESLNZ
	 DSFA1946TpQbt0IMS4leV9g/t0kt0uVbiKQVKoIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Agathe Boutmy <agathe@boutmy.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 112/163] platform/x86: lg-laptop: Change ACPI device id
Date: Tue, 23 Jul 2024 20:24:01 +0200
Message-ID: <20240723180147.803294941@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 5d4df782ce8e1..c19c866361beb 100644
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



