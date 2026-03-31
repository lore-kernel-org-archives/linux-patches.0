Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9ED423A7C;
	Tue, 31 Mar 2026 16:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976362; cv=none; b=jKaYYbzBz0JsSc2zvKnMrowlGwyYvr6nwhSgnTd/c3eJqlyX8xCjWVsQ3ezhW4wpG5GYmSyzYFUGo/xW3ypRMh8QAtJpiF5x97+/wEXEhdIdyaxA0+QcfnqPh3xZWuBk7no2wIGRq2ZBOv6Tq3S62djwNEvk1FuHss0lj6gMfwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976362; c=relaxed/simple;
	bh=6phVvRMb6ZQPUmSEq3bnLL9haGUFKvF1WUmYncfTb5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MjxMYjUxkwmka0DB5xsM+1hKBIazs6W/YznjGwDgrfd0YNzORAnEA2TbdQ6mJgsCEgDGXWDfPngCc0ZJGmhxg82w8XV5GtdHoe0Y/+1Awn7i5UCl5e12+GQ1kg89Ol4BRl2LyGGSadzceUTY6jqcIvbxMsnSUMGFXxcu+Ux9aSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSQrUQJS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSQrUQJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86BCC19424;
	Tue, 31 Mar 2026 16:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976362;
	bh=6phVvRMb6ZQPUmSEq3bnLL9haGUFKvF1WUmYncfTb5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSQrUQJS90Mv28WO0Oundmr3yuolyOGYbOm8rrnfJJ3b4lJgMyuRN4ijFXr0QdO6g
	 RuSXDX94Zf+31BpKXq8kdQCSXG5PkjW8PVisQJrzNWl5IdQpvyrhDZshf0WvParja5
	 vjJ8F6aWCj+m+I1uWiM0kJFeGM/Ds1BJbWbs/I8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 030/309] platform/x86: oxpec: Add support for OneXPlayer APEX
Date: Tue, 31 Mar 2026 18:18:53 +0200
Message-ID: <20260331161754.591027319@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit 3385ea97c14d271dcb0c6e6fcf16972f819eecd8 ]

OneXPlayer Apex is a new Strix Halo handheld. It uses the same registers
as the OneXPlayer Fly devices. Add a quirk for it to the oxpec driver.

Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://patch.msgid.link/20260223183004.2696892-2-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/oxpec.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/oxpec.c b/drivers/platform/x86/oxpec.c
index 54377b282ff88..9511791f04d9a 100644
--- a/drivers/platform/x86/oxpec.c
+++ b/drivers/platform/x86/oxpec.c
@@ -13,7 +13,7 @@
  *
  * Copyright (C) 2022 Joaquín I. Aramendía <samsagax@gmail.com>
  * Copyright (C) 2024 Derek J. Clark <derekjohn.clark@gmail.com>
- * Copyright (C) 2025 Antheas Kapenekakis <lkml@antheas.dev>
+ * Copyright (C) 2025-2026 Antheas Kapenekakis <lkml@antheas.dev>
  */
 
 #include <linux/acpi.h>
@@ -208,6 +208,13 @@ static const struct dmi_system_id dmi_table[] = {
 		},
 		.driver_data = (void *)oxp_2,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ONE-NETBOOK"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "ONEXPLAYER APEX"),
+		},
+		.driver_data = (void *)oxp_fly,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "ONE-NETBOOK"),
-- 
2.51.0



