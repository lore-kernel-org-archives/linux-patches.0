Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B9C421F1F;
	Tue, 31 Mar 2026 16:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974765; cv=none; b=oe347TyThqtrBZT1hU6YQV+rCC0A7OXidWgzapEdrtl/fBBXXBwWswyguQnKVC2ORVLFzrURhJw09MpFNjhEkHfVxbiuu7kZEW8qcXVtM49JgZp0cqEwnA/510N6UkYX8Jo5aC8zqEWblmxBBb409jMVzV+5gi2s++Kf7OLYZeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974765; c=relaxed/simple;
	bh=+eaCIVaXE5k0FaH54WkQpG/hFXRVQy7hojoIfRwxFb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KF3Yw7MAxruE8u7Zp2YnXJz8C6DtVO/7gWGom2Sk97QpQ/oPvSDCIPLNV1sFSi2YFiX/Hxs/QmJCuUb47WnIScbrkeJ+AB8Qo+wD5diW8VDhAcJ53k6wqlDcU6A7x1bnNSodlk7t4UDoP38Oa0i7RFqop7jDAKVdpJlwpQ8my0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scvrXCYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scvrXCYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE8DC19423;
	Tue, 31 Mar 2026 16:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974765;
	bh=+eaCIVaXE5k0FaH54WkQpG/hFXRVQy7hojoIfRwxFb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=scvrXCYzkb+8q5SzqyuoVu+7F/LWieFBK7E43dY0xbeb/MvNQKBdHz67qmcbHUc1q
	 JpU6kOfpsYc4Zt9+FZQDbMd6ZM4ZrjWJBVj7MSmpk0w2WoqX11P/2szwgoy9bIMvNQ
	 37RSWQ9T2HY2QrdIK8gVkbv4FIch3ONiFP/XMZQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 036/342] platform/x86: oxpec: Add support for OneXPlayer APEX
Date: Tue, 31 Mar 2026 18:17:49 +0200
Message-ID: <20260331161800.234146122@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 144a454103b93..59d6f9d9a9052 100644
--- a/drivers/platform/x86/oxpec.c
+++ b/drivers/platform/x86/oxpec.c
@@ -11,7 +11,7 @@
  *
  * Copyright (C) 2022 Joaquín I. Aramendía <samsagax@gmail.com>
  * Copyright (C) 2024 Derek J. Clark <derekjohn.clark@gmail.com>
- * Copyright (C) 2025 Antheas Kapenekakis <lkml@antheas.dev>
+ * Copyright (C) 2025-2026 Antheas Kapenekakis <lkml@antheas.dev>
  */
 
 #include <linux/acpi.h>
@@ -142,6 +142,13 @@ static const struct dmi_system_id dmi_table[] = {
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



