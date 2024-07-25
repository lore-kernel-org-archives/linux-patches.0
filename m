Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6682913C816;
	Thu, 25 Jul 2024 14:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919170; cv=none; b=SYyxD3svITx8Qq+t94DMnnfbXhXeunRoQND2vx5cvLUtfMEU5Fg029ueUzqS6w03wMPXCZK9OiI27Wrs3v3uFQnqsOSXolPg0G2jSk3LPPowvFUyO4+6QZwMqDU7SOnSatGaqOfFm4HROctpdB0GO8Rv+LseSY59Y1po0CXwWEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919170; c=relaxed/simple;
	bh=4vhxNZ0K/+5frh+ZM8UwTo6YxpCQBvc9voKtlrT5pnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EUhRwr8vZnvZG8EV0PSoyBMPZry4Z5O0bLlSzplxIrltY/8rwKGl2tasy6/qYhZS/JrZcSmC2SCDHTg1dR9vDYlGlEx/EdTO/zI7glLxxnh6ZeHG4SYE+397jaiW9KfWdeO+267tzIMoBZgYRkYahuz0dj+mceIljuK9VqEwmgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c8pyd6bW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c8pyd6bW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1EB1C32782;
	Thu, 25 Jul 2024 14:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919170;
	bh=4vhxNZ0K/+5frh+ZM8UwTo6YxpCQBvc9voKtlrT5pnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8pyd6bWnDV2ZSBDKqnUzY5OGPyPqCX3vULcJjh+UDkqP7yn4u8+u7cGJheQDHQfN
	 O0AibWvzmw9POZ2Ymi39gjnE9/1M70oY/kEbCVMBjsv2hkfUAtLA4Px/rrlWFJGAUc
	 nrffo16u+QvrupUcNe3bMyY6/TP+0+kIiQy0NMKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Agathe Boutmy <agathe@boutmy.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 46/87] platform/x86: lg-laptop: Change ACPI device id
Date: Thu, 25 Jul 2024 16:37:19 +0200
Message-ID: <20240725142740.169745154@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 96960f96f775c..807bd4283b979 100644
--- a/drivers/platform/x86/lg-laptop.c
+++ b/drivers/platform/x86/lg-laptop.c
@@ -718,7 +718,7 @@ static int acpi_remove(struct acpi_device *device)
 }
 
 static const struct acpi_device_id device_ids[] = {
-	{"LGEX0815", 0},
+	{"LGEX0820", 0},
 	{"", 0}
 };
 MODULE_DEVICE_TABLE(acpi, device_ids);
-- 
2.43.0



