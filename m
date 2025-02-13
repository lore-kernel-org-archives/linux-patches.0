Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83DF281349;
	Thu, 13 Feb 2025 14:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457348; cv=none; b=UwvwALVZSxWIolTKA0BZMPZTTNC3YWnpf2DtIGoyqKp+NuwvqHz5jwZvHzNh7pyZMuBqQiQD69vYMPfdtJCVQDpqRboGaSREohDo5H6nZ615mrsPx0Vrf+tNuSaAfuMgTS5GaCxbHWfm8TD/X/UDZpxkc2kYrv5x+966mQGVGh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457348; c=relaxed/simple;
	bh=p7vUPm4e/pJJBSCc/gPf4GoYHPludNfG2iGTJ1IgtXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RnfiPCSCFKDZmjUZvRldX7WbGPgTUDGvGtDPaHquZu4MsT3bc3k6TvALiewpeOB9dMn1n3RJ4Jn8Fh1beE+y1zvtsq3c6pvSi7yBdcY8zsJOP7FLBqwu9ERE3X8+/ZU8vbEWQmjweGAY/nwSE9DeOyEr9I56iTKW2guGMh7KhnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HuOO5xX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HuOO5xX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2187C4CED1;
	Thu, 13 Feb 2025 14:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457348;
	bh=p7vUPm4e/pJJBSCc/gPf4GoYHPludNfG2iGTJ1IgtXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HuOO5xX1XpdGEzQamN1LJwamAHgWFh2MQvLREbBJ7864LGLFcgA5FDnujP8ukkkWk
	 igJqF4ZJKDnJtyPITAAOxGLHQ7mi3O0hXYAg9o3qAP5E8WEe4R5exMExWyyt6ebkHQ
	 T1QfdeUueMZOhASYhl2kitq9uRFJeY3D7KCyCSuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Johnsten <ejohnsten@gmail.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/422] platform/x86: acer-wmi: Add support for Acer Predator PH16-72
Date: Thu, 13 Feb 2025 15:23:53 +0100
Message-ID: <20250213142439.795512077@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit c85b516b44d21e9cf751c4f73a6c235ed170d887 ]

Add the Acer Predator PT16-72 to acer_quirks to provide support
for the turbo button and predator_v4 interfaces.

Tested-by: Eric Johnsten <ejohnsten@gmail.com>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20250107175652.3171-1-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/acer-wmi.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 844e623ddeb30..f69916b2eea39 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -398,6 +398,13 @@ static struct quirk_entry quirk_acer_predator_ph315_53 = {
 	.gpu_fans = 1,
 };
 
+static struct quirk_entry quirk_acer_predator_ph16_72 = {
+	.turbo = 1,
+	.cpu_fans = 1,
+	.gpu_fans = 1,
+	.predator_v4 = 1,
+};
+
 static struct quirk_entry quirk_acer_predator_pt14_51 = {
 	.turbo = 1,
 	.cpu_fans = 1,
@@ -603,6 +610,15 @@ static const struct dmi_system_id acer_quirks[] __initconst = {
 		},
 		.driver_data = &quirk_acer_predator_v4,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer Predator PH16-72",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Predator PH16-72"),
+		},
+		.driver_data = &quirk_acer_predator_ph16_72,
+	},
 	{
 		.callback = dmi_matched,
 		.ident = "Acer Predator PH18-71",
-- 
2.39.5



