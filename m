Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656E82C2346;
	Wed, 28 Jan 2026 15:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615292; cv=none; b=EnGnZUMxCViwTsuow1yjg7zHQFp0gWezUKaWEEsjJ9bjCF07Ry6KdsnqPOGpbUprgHJwSHuiclWCk1XDzVJn1yue0kNPZNGKUYjwCl82VMOVcb+xt9/UU3bFji2/WIpQhfjBA7EXMsXjdrXwdM9tnxCukqebk8eIUlBj2oGR214=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615292; c=relaxed/simple;
	bh=11jQvHeKf1jhLonLBi9BAnL0tQ7hMb/WrPRcKfIueGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pRA/h5qjfAQrUHGvRXFz8nntoMZjz9KjBAE2IUQwBTgZhn79ektwg/tBiTRzIjBU+jiWorcqI3ZyBvhXD7W579Lz9k0ImQ+rzqr797sIxcTNvq5WqPBpc1rVAwjci+lSA4WlDcH6X2plWBlsFzXjhJCrs6Xfrjdq1lTbxPVM/m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVzeaz6m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVzeaz6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C682FC4CEF1;
	Wed, 28 Jan 2026 15:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615292;
	bh=11jQvHeKf1jhLonLBi9BAnL0tQ7hMb/WrPRcKfIueGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVzeaz6mC8RlAArc9vlMTUXmK1M7jrKhksbTVPaovL3XrOl4ePE2Us8g0yyVBBZQI
	 ATcYta5nWeBgGVSHxP3mivb0AlGaPqr26gNjn7Nc37OT5Z7YJlMH4ka19XoKEec6T1
	 43RxYMwVCIDo/I/Es/JeQPeEJMfB3+N3eubjONOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 135/169] platform/x86: hp-bioscfg: Fix automatic module loading
Date: Wed, 28 Jan 2026 16:23:38 +0100
Message-ID: <20260128145338.865936181@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 467d4afc6caa64b84a6db1634f8091e931f4a7cb upstream.

hp-bioscfg has a MODULE_DEVICE_TABLE with a GUID in it that looks
plausible, but the module doesn't automatically load on applicable
systems.

This is because the GUID has some lower case characters and so it
doesn't match the modalias during boot. Update the GUIDs to be all
uppercase.

Cc: stable@vger.kernel.org
Fixes: 5f94f181ca25 ("platform/x86: hp-bioscfg: bioscfg-h")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260115203725.828434-4-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.h
+++ b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.h
@@ -57,14 +57,14 @@ enum mechanism_values {
 
 #define PASSWD_MECHANISM_TYPES "password"
 
-#define HP_WMI_BIOS_GUID		"5FB7F034-2C63-45e9-BE91-3D44E2C707E4"
+#define HP_WMI_BIOS_GUID		"5FB7F034-2C63-45E9-BE91-3D44E2C707E4"
 
-#define HP_WMI_BIOS_STRING_GUID		"988D08E3-68F4-4c35-AF3E-6A1B8106F83C"
+#define HP_WMI_BIOS_STRING_GUID		"988D08E3-68F4-4C35-AF3E-6A1B8106F83C"
 #define HP_WMI_BIOS_INTEGER_GUID	"8232DE3D-663D-4327-A8F4-E293ADB9BF05"
 #define HP_WMI_BIOS_ENUMERATION_GUID	"2D114B49-2DFB-4130-B8FE-4A3C09E75133"
 #define HP_WMI_BIOS_ORDERED_LIST_GUID	"14EA9746-CE1F-4098-A0E0-7045CB4DA745"
 #define HP_WMI_BIOS_PASSWORD_GUID	"322F2028-0F84-4901-988E-015176049E2D"
-#define HP_WMI_SET_BIOS_SETTING_GUID	"1F4C91EB-DC5C-460b-951D-C7CB9B4B8D5E"
+#define HP_WMI_SET_BIOS_SETTING_GUID	"1F4C91EB-DC5C-460B-951D-C7CB9B4B8D5E"
 
 enum hp_wmi_spm_commandtype {
 	HPWMI_SECUREPLATFORM_GET_STATE  = 0x10,


