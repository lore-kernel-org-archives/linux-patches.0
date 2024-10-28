Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9184A18FC7F;
	Mon, 28 Oct 2024 06:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097323; cv=none; b=f8yA76HdtvfQ4mbRhkbcvEqp7tz1xcT1d8bk9OFEZ6APwyeu4LZDVggPNViFniOFUumvyydD3rGncL3mtC+cfJ28ED2NI1mfoTYFgx952UsrGlz4cHZAjggoaTEgcSlHf+r6o+dtaTjD7M/c6Dbm9rQHstZ0NTTjXdgc8g/6/hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097323; c=relaxed/simple;
	bh=Kzq5AcwmQATzsyDMXuKwD1V/ZmegVjrqYMDWN7xSufo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQ7e0gi+5DdWfYrdwY1u76kUf+J8TE/5Vui/rzmRKvXY9HkOvFDhkEXUO5Lp8adpLbu/HZu6LdD1WnDqjKAqZIKND1P6wwa0lfO7rmPBWp2RnEpDlDWCw/G9TD5bAtA3hM6vI9tkYEnzmmua2l26oJFh/6n+JvzpLIteSrAus98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p8Sg6Gyo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p8Sg6Gyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BA7C4CEC3;
	Mon, 28 Oct 2024 06:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097323;
	bh=Kzq5AcwmQATzsyDMXuKwD1V/ZmegVjrqYMDWN7xSufo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p8Sg6GyoVTAOdZZdyJIjdUklBk8lPDa21ZPceFCDRilVceQDGADmJbcAbbgxxO9jJ
	 p47Buko0kcl+fXhWAHEFzb2hZDskOlxYorEzz1gDWlucGgpwQnv0gZqyxAPUSEXuBj
	 w1yZQ4CjgLUk2y/J1yIcWeH/tkRgi4wKN2ZLxDLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Crag Wang <crag_wang@dell.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/137] platform/x86: dell-sysman: add support for alienware products
Date: Mon, 28 Oct 2024 07:25:18 +0100
Message-ID: <20241028062300.997224500@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Crag Wang <crag_wang@dell.com>

[ Upstream commit a561509b4187a8908eb7fbb2d1bf35bbc20ec74b ]

Alienware supports firmware-attributes and has its own OEM string.

Signed-off-by: Crag Wang <crag_wang@dell.com>
Link: https://lore.kernel.org/r/20241004152826.93992-1-crag_wang@dell.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-wmi-sysman/sysman.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c b/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
index b2406a595be9a..3ef90211c51a6 100644
--- a/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
+++ b/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
@@ -524,6 +524,7 @@ static int __init sysman_init(void)
 	int ret = 0;
 
 	if (!dmi_find_device(DMI_DEV_TYPE_OEM_STRING, "Dell System", NULL) &&
+	    !dmi_find_device(DMI_DEV_TYPE_OEM_STRING, "Alienware", NULL) &&
 	    !dmi_find_device(DMI_DEV_TYPE_OEM_STRING, "www.dell.com", NULL)) {
 		pr_err("Unable to run on non-Dell system\n");
 		return -ENODEV;
-- 
2.43.0



