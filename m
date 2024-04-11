Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943FC1448F3;
	Thu, 11 Apr 2024 10:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830078; cv=none; b=YjOZ2S2hU02SiBLyfXNZ1+AcMF4epvmpzJMDyv+SBtgKOQhMf6emrMCq9AyHVVklw8ZCKnLThwjK0on3J/bAmqex3mrpT+k6g3bok52YwGtpDbnCSxFK4BZJdZ5FIPZ1lUkKgRuYFHQK1Wrso1I0pc2FaXbGMzYwL7oT2mIRuYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830078; c=relaxed/simple;
	bh=+p6xUj+sU28dPfS/V8s/kkLtq3pUGuBskKTXlGKOq44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBJKkQuL2ZdYNb4MGrBdcCiKGRHWgCi172afDRbxk/xj+206F5VfnH7tH8bF5Hdhgt7ECvQXqQGCtMVW3S3bRhMnGOklRgtKIDGEdTXW9FEVO9PXY4GfMElZnHiOxAC91bZIVsKNDea6UgCFiU/OHQkshkwGVpMEHTAEDX5r1Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yA6xfjUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yA6xfjUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21F7C433F1;
	Thu, 11 Apr 2024 10:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830078;
	bh=+p6xUj+sU28dPfS/V8s/kkLtq3pUGuBskKTXlGKOq44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yA6xfjUhmkn4e8Ewi2wa0T2BixQ2UAwkwpHOyFK1dZGdDiUKBKmqK92doglFMobTJ
	 Dy/+D4sff1fO0WBDLc8sil2TlxPffFmJsa/KfZ7pvmwRb6s/1dj15Bm3EELBi97IFM
	 o3zbLdpcYv2icJqr8428WBYYNA3WIDLGpSrgz1eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sviatoslav Harasymchuk <sviatoslav.harasymchuk@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 028/143] ACPI: resource: Add IRQ override quirk for ASUS ExpertBook B2502FBA
Date: Thu, 11 Apr 2024 11:54:56 +0200
Message-ID: <20240411095421.759270250@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sviatoslav Harasymchuk <sviatoslav.harasymchuk@gmail.com>

[ Upstream commit 0793e511c4c66c38dd26add86f7236bcdc70c3b5 ]

In order to fix the keyboard on ASUS ExpertBook B2502FBA, add an IRQ override
quirk for it in analogy with how it was done for other members of this machine
family.

Link: https://lore.kernel.org/linux-acpi/20230411183144.6932-1-pmenzel@molgen.mpg.de
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217323
Signed-off-by: Sviatoslav Harasymchuk <sviatoslav.harasymchuk@gmail.com>
[ rjw: Subject and changelog rewrite, fix broken white space ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index c843feb02e980..b5193049d7b1b 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -489,6 +489,13 @@ static const struct dmi_system_id irq1_level_low_skip_override[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "B2502CBA"),
 		},
 	},
+	{
+		/* Asus ExpertBook B2502FBA */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "B2502FBA"),
+		},
+	},
 	{
 		/* Asus Vivobook E1504GA */
 		.matches = {
-- 
2.43.0



