Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C313E008D;
	Fri, 15 May 2026 16:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862453; cv=none; b=GyW7TGzDScSmIpPvGpboE8XP3War81cAwKK2qCTGbo3QCBTRnZeNfOdS2Vs974Tt6faBq2sVQ1EQDeLSO3GWKi6GPJMcYZ/c7XJ+CiyVvnd4WjtwPe2K3Uy26V5qLyGZq+WXPH6RE9mMe07JteQ5dG62wMUHH1dVzBey4tnhgig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862453; c=relaxed/simple;
	bh=6Mi4F1z53ZP/fA1p/EV1gtauExl3BaiJvpT9c0eW7QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+5tWFfzR4No2CF8iCbbDu/2pNtHMYp3lKIsF8dJC65huIaMwu8zq56aCcxsHaafCgA7OSXG1VKO/1OJcACeytOtZqUh9nibm2SVVcL0YBVWg0f4g2tpLeBsL862sYEhvu3rN+pG4epDG9hxE/SEozJw1k3nxAurpDVohWVUzYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Do67/je8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Do67/je8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BFCC2BCB0;
	Fri, 15 May 2026 16:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862453;
	bh=6Mi4F1z53ZP/fA1p/EV1gtauExl3BaiJvpT9c0eW7QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Do67/je81+d2wCBI+BIGAqGSp6oZlXSlUxeeUaJ3LuKXyXGdLobavlX4UkA6ALEBX
	 v67JtrKaA2mR58b/+ARH9bgrXSHceQxwQ4bQP/OHqwfroi6CjPhaUStfjrGq2uOc/w
	 kdr1yPjcFMBnOpjSMwk5M+F38yZ5TK+heyxJBrpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Heimir Thor Sverrisson <heimir.sverrisson@gmail.com>
Subject: [PATCH 7.0 055/201] media: ipu-bridge: Add upside-down sensor DMI quirk for Dell XPS 13 9340 and XPS 14 9440
Date: Fri, 15 May 2026 17:47:53 +0200
Message-ID: <20260515154659.727754885@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <johannes.goede@oss.qualcomm.com>

commit 2c10400e4a233200046d023ab2377bc56fd48dea upstream.

The Dell XPS 13 9340 and XPS 14 9440 have an upside-down mounted OV02C10
sensor, just like the XPS 13 9350 and XPS 16 9640 models.

Extend the existing DMI matches for handling these laptops with DMI
matches for these 2 models

Reported-by: Heimir Thor Sverrisson <heimir.sverrisson@gmail.com> # XPS 14 9440
Closes: https://bugzilla.redhat.com/show_bug.cgi?id=2440581 # XPS 13 9340
Fixes: d5ebe3f7d13d ("media: ov02c10: Fix default vertical flip")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ipu-bridge.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/media/pci/intel/ipu-bridge.c
+++ b/drivers/media/pci/intel/ipu-bridge.c
@@ -107,10 +107,24 @@ static const struct dmi_system_id upside
 	{
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "XPS 13 9340"),
+		},
+		.driver_data = "OVTI02C1",
+	},
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
 			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "XPS 13 9350"),
 		},
 		.driver_data = "OVTI02C1",
 	},
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "XPS 14 9440"),
+		},
+		.driver_data = "OVTI02C1",
+	},
 	{
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Dell Inc."),


