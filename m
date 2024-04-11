Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DC6145B08;
	Thu, 11 Apr 2024 10:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830419; cv=none; b=ZmMgv5MUJSTEAxpIWZmyQ7dn5gDZ3DmDT1tQB49cDXFUcoLBOoCy9FE1g9bgmnb2dJUXOX/GsaqYnwcK48k+RCU+32BKXSO7nW4sfcK45eNToiyLaLeQi3c4osIlSCNNWyd7u+CZn32MSVSM4zGuAq8Y4Ne9uFORVGvDicCcSos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830419; c=relaxed/simple;
	bh=WNCA8VGWX6yuB938XY/CAKMIoZm9VEdIXMVHQMF6aPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JNc0hi56CNLtkmPN1rbRTjT/r3sQAIR9ed/B5ftiuGL96WxBXgVUiRlbaZe7XPFeXFXIp+ylXi4doTQEZTf11lg1PHmysGgfRSJksvdIhSZhI/qKfUeH7VIJo9V3Rz9KxRFe9dHo6S9FZqpaS+nHPNKljpSqREvdUnj8yYRClj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5WxrBCN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5WxrBCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC491C433F1;
	Thu, 11 Apr 2024 10:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830419;
	bh=WNCA8VGWX6yuB938XY/CAKMIoZm9VEdIXMVHQMF6aPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M5WxrBCNE18KJ2IM7DYhO0EJvN+fKE4gK7trypY11NgkXSbCANt9xC/YNMKeltjwT
	 zjGRFYUOWZz+8OA9CFdfKK+zbHDTQHo1ZQ+r9RiiAY/cs3OYY3Izm1Q9F0yNl6ZvG5
	 qAKVqDeGVRF4UDghCyODzxJZ204QFmqTP97NBHng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SungHwan Jung <onenowy@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 101/143] platform/x86: acer-wmi: Add predator_v4 module parameter
Date: Thu, 11 Apr 2024 11:56:09 +0200
Message-ID: <20240411095423.948079324@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SungHwan Jung <onenowy@gmail.com>

[ Upstream commit f9124f2a454a6f1edb4eae9f0646b1a61fd74dba ]

This parameter allows predator laptop users to test and use features
(mode button, platform profile, fan speed monitoring) without
adding model names to acer_quirks and compiling kernel.

Signed-off-by: SungHwan Jung <onenowy@gmail.com>
Link: https://lore.kernel.org/r/20240220080416.6395-1-onenowy@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/acer-wmi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 771b0ce34c8f9..ee2e164f86b9c 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -276,6 +276,7 @@ static bool has_type_aa;
 static u16 commun_func_bitmap;
 static u8 commun_fn_key_number;
 static bool cycle_gaming_thermal_profile = true;
+static bool predator_v4;
 
 module_param(mailled, int, 0444);
 module_param(brightness, int, 0444);
@@ -284,6 +285,7 @@ module_param(force_series, int, 0444);
 module_param(force_caps, int, 0444);
 module_param(ec_raw_mode, bool, 0444);
 module_param(cycle_gaming_thermal_profile, bool, 0644);
+module_param(predator_v4, bool, 0444);
 MODULE_PARM_DESC(mailled, "Set initial state of Mail LED");
 MODULE_PARM_DESC(brightness, "Set initial LCD backlight brightness");
 MODULE_PARM_DESC(threeg, "Set initial state of 3G hardware");
@@ -292,6 +294,8 @@ MODULE_PARM_DESC(force_caps, "Force the capability bitmask to this value");
 MODULE_PARM_DESC(ec_raw_mode, "Enable EC raw mode");
 MODULE_PARM_DESC(cycle_gaming_thermal_profile,
 	"Set thermal mode key in cycle mode. Disabling it sets the mode key in turbo toggle mode");
+MODULE_PARM_DESC(predator_v4,
+	"Enable features for predator laptops that use predator sense v4");
 
 struct acer_data {
 	int mailled;
@@ -734,7 +738,9 @@ enum acer_predator_v4_thermal_profile_wmi {
 /* Find which quirks are needed for a particular vendor/ model pair */
 static void __init find_quirks(void)
 {
-	if (!force_series) {
+	if (predator_v4) {
+		quirks = &quirk_acer_predator_v4;
+	} else if (!force_series) {
 		dmi_check_system(acer_quirks);
 		dmi_check_system(non_acer_quirks);
 	} else if (force_series == 2490) {
-- 
2.43.0



