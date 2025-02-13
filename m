Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E2026B094;
	Thu, 13 Feb 2025 15:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458852; cv=none; b=ZpWL8zSID4r1qtl6//HwE0hwNeZ/A69x0qaFi0yPtPlKpeR6dUl/7mTRQaQdRA3/xCGOY5oeyPiCBrkiACBj+n7HAcewHVtvs8Y9EyIeXwWdWMalR7MkLUvxiYaNZsJQ7JBkLmqCTSLUFxK9b4SeMeQrbd95x9auAtfvyCT0rK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458852; c=relaxed/simple;
	bh=nxp4nLCba5bvppoR17FrVCeZcPKsPntz08rsp5a44GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xen7ZrUlyVebYi5sHXpZ536zK9MEA2++4lrqvLTIEHGz91znb2ZnnOMgfN53bXERlDYHPZzxnYNq18vs1ikeBXMH/E+ZunDRuphPX/q07W3wVm1jEs4DKeLPzv9xDnikQrxruxiCRu3vVIgL/nBi3aH5cDKfLkxgIl+Cd/zPx+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCMVnNdl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCMVnNdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA96C4CEE4;
	Thu, 13 Feb 2025 15:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458852;
	bh=nxp4nLCba5bvppoR17FrVCeZcPKsPntz08rsp5a44GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCMVnNdlWSnkD9ZrlfGaCK8W6oLWTIpX/h0dMZ0BEJcTYtCVBoR2f9TiMfUNBMiYc
	 Let/dAJrzNbixUA/QASST1+BhH5CiX+E4cI/o/lG9+JWXGEezwE8YUeLebamyuV8gh
	 dpZHDtohmcnLJQZuYvrRvz/VUxak9WIr8Giw91jA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rayan Margham <rayanmargham4@gmail.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 094/443] platform/x86: acer-wmi: Add support for Acer PH14-51
Date: Thu, 13 Feb 2025 15:24:19 +0100
Message-ID: <20250213142444.236827284@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 9741f9aa13f6dc3ff24e1d006b2ced5f460e6b6f ]

Add the Acer Predator PT14-51 to acer_quirks to provide support
for the turbo button and predator_v4 hwmon interface.

Reported-by: Rayan Margham <rayanmargham4@gmail.com>
Closes: https://lore.kernel.org/platform-driver-x86/CACzB==6tUsCnr5musVMz-EymjTUCJfNtKzhMFYqMRU_h=kydXA@mail.gmail.com
Tested-by: Rayan Margham <rayanmargham4@gmail.com>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Kurt Borja <kuurtb@gmail.com>
Link: https://lore.kernel.org/r/20241210001657.3362-2-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/acer-wmi.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index d09baa3d3d902..5cff538ee67fa 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -393,6 +393,13 @@ static struct quirk_entry quirk_acer_predator_ph315_53 = {
 	.gpu_fans = 1,
 };
 
+static struct quirk_entry quirk_acer_predator_pt14_51 = {
+	.turbo = 1,
+	.cpu_fans = 1,
+	.gpu_fans = 1,
+	.predator_v4 = 1,
+};
+
 static struct quirk_entry quirk_acer_predator_v4 = {
 	.predator_v4 = 1,
 };
@@ -600,6 +607,15 @@ static const struct dmi_system_id acer_quirks[] __initconst = {
 		},
 		.driver_data = &quirk_acer_predator_v4,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer Predator PT14-51",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Predator PT14-51"),
+		},
+		.driver_data = &quirk_acer_predator_pt14_51,
+	},
 	{
 		.callback = set_force_caps,
 		.ident = "Acer Aspire Switch 10E SW3-016",
-- 
2.39.5



