Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3259126B2DD;
	Tue,  8 Apr 2025 12:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116787; cv=none; b=Ks8PRcbu/S1KKkD9Ikw/AJlwWY5rSTOJG1vU2t6Qql6HPNwQ9/XZy3wSr0N+BTn2HSmdPHyoVNv0qm84RDdAOvx72Q1mZgpRE+Tnj3BdQ2pmwOYkWOppTCr+A5GkfuYY5Vdvckq2CQoJ0c6xpIzehypg2M0M4kHlCw7CLaNXuAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116787; c=relaxed/simple;
	bh=MjY1D7qmlGr3C/LvD42C81VynArqGBJlIAcPSiSip1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C0QVJZt2++LKe7cHo8s6hsM2iGmXw6TtlvfaTnYuAR6apmQ47TFtSoW1KvatTWbalagOQWDNFLJUS1M7BxK5hG9V9pNZajmHCXh76l5GEG/GnOFPHUeESeXyWVR4WNThryMboGkt1Y4slvt7hymQWW5DkhOTZYFq5Hridwharvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JiOpFdu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JiOpFdu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566EBC4CEE5;
	Tue,  8 Apr 2025 12:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116787;
	bh=MjY1D7qmlGr3C/LvD42C81VynArqGBJlIAcPSiSip1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JiOpFdu8N4juFisZADZCQgiEXhj15PDAQi4IdP09KjaarL7EN9mqc2AMXdMEDaRVZ
	 w9TebsPrGDSXTo4w3Br9sDVne2YgtEwSBSMSyBv5S4ZYztZS4UmB8JFlCDR90XJ0v5
	 fSytTaSsBJ1Kgr8du+xqMeNupAgqd3DRfvlToKqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Panchenko <dmitry@d-systems.ee>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 269/423] platform/x86: intel-hid: fix volume buttons on Microsoft Surface Go 4 tablet
Date: Tue,  8 Apr 2025 12:49:55 +0200
Message-ID: <20250408104852.021105575@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Dmitry Panchenko <dmitry@d-systems.ee>

[ Upstream commit 2738d06fb4f01145b24c542fb06de538ffc56430 ]

Volume buttons on Microsoft Surface Go 4 tablet didn't send any events.
Add Surface Go 4 DMI match to button_array_table to fix this.

Signed-off-by: Dmitry Panchenko <dmitry@d-systems.ee>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20250220154016.3620917-1-dmitry@d-systems.ee
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/hid.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index 445e7a59beb41..9a609358956f3 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -132,6 +132,13 @@ static const struct dmi_system_id button_array_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go 3"),
 		},
 	},
+	{
+		.ident = "Microsoft Surface Go 4",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go 4"),
+		},
+	},
 	{ }
 };
 
-- 
2.39.5



