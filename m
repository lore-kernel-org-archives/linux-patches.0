Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A069F216E12;
	Thu, 12 Dec 2024 15:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018720; cv=none; b=M1RwqkSa+epjs5LcBBG5Pd6+TEmebX71JZEfNwb6zpEB7hQoojfDttoBGNKPibKOGI5fjkVx9pF3QvNUek9f3ld10Q70l2M1YZeOnKmFAiGlnUy/Cuj8msmSAvn44bZgfCSR3Td8TmcarrQD2xRQ3zzVIxvIcLykSuVL0Fp7xy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018720; c=relaxed/simple;
	bh=MrGjDQNoloQHBfbvYyXoYIezeONhstrhdsx1H221T6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eGO+ZgnPLm0WrYJcg8uS4sLTAXWRGImYDL3AEggJJqVawZAK05ofHQVYnFg15oQ5Pg2busc+lkB+8DXiLsWnlI8LZyBgpVBRYbwbJx3ZD95K0dy7E08lmdfT/in3v26SHjKbblAJSfN11DN5QCqmgaYt1BsIq2fjWdFuLYIvl9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6O1pEnx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6O1pEnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F322C4CECE;
	Thu, 12 Dec 2024 15:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018720;
	bh=MrGjDQNoloQHBfbvYyXoYIezeONhstrhdsx1H221T6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6O1pEnxIU8OCRn+XptQKj4ZOxkF2f0SF2ZwjowkIJ3FYtuWVvFkBbiV4jQAv+Vdl
	 eafDOCMjE64IPSjZXCQmKG3k2AUKImhs8gphcGu2eqH0hEiD0/dIPuLNgtuixl7ZSC
	 AP9pP5EN2gw/gCUEmVjz07JpvMf/b46OfwNZY3eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Borja <kuurtb@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/772] platform/x86: dell-smbios-base: Extends support to Alienware products
Date: Thu, 12 Dec 2024 15:49:19 +0100
Message-ID: <20241212144350.536400492@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kurt Borja <kuurtb@gmail.com>

[ Upstream commit a36b8b84ac4327b90ef5a22bc97cc96a92073330 ]

Fixes the following error:

dell_smbios: Unable to run on non-Dell system

Which is triggered after dell-wmi driver fails to initialize on
Alienware systems, as it depends on dell-smbios.

This effectively extends dell-wmi, dell-smbios and dcdbas support to
Alienware devices, that might share some features of the SMBIOS intereface
calling interface with other Dell products.

Tested on an Alienware X15 R1.

Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20241031154023.6149-2-kuurtb@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-smbios-base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/dell/dell-smbios-base.c b/drivers/platform/x86/dell/dell-smbios-base.c
index 6fb538a138689..9a9b9feac4166 100644
--- a/drivers/platform/x86/dell/dell-smbios-base.c
+++ b/drivers/platform/x86/dell/dell-smbios-base.c
@@ -544,6 +544,7 @@ static int __init dell_smbios_init(void)
 	int ret, wmi, smm;
 
 	if (!dmi_find_device(DMI_DEV_TYPE_OEM_STRING, "Dell System", NULL) &&
+	    !dmi_find_device(DMI_DEV_TYPE_OEM_STRING, "Alienware", NULL) &&
 	    !dmi_find_device(DMI_DEV_TYPE_OEM_STRING, "www.dell.com", NULL)) {
 		pr_err("Unable to run on non-Dell system\n");
 		return -ENODEV;
-- 
2.43.0



