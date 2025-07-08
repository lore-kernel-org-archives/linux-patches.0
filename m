Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1ABF2E5B21;
	Tue,  8 Jul 2025 16:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993070; cv=none; b=XgcBPMKOX0TR2fUqWGWUepeDmes+2CuzXE4X/V8y3pJA1f91/TzcndXERT1zWY4PJz9ea4EUCTS9xR+cIQaMwkBR/QtwZU3SW4o3mjHIDZtG1Qmg3h6QOcmEWOkG6nBgRP4NKnwJRIjMUHQiWEFloKBUygbGmwXOQo0BcqI4L8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993070; c=relaxed/simple;
	bh=9DwblJQBPOF5jgRyIgwMS4V28JRvO/qFrLScjVqpPg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R0iQgs/PWc5TSLtEo1De6NJUfPGFVwY9qU2lhTt7kmHC38XQBuLt7S0n2LZ+TeE5Pwxh4JpsVS0kymt+1PsubPmHAHWciHfZovp6eRe9Mjx+G2clF2OWVJglPYgwYHKDnGDsUV5XQQvSMXmg45tcvSoZ9w5i6XyiVvZRCrwCX/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJHc/P+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJHc/P+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571D4C4CEED;
	Tue,  8 Jul 2025 16:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993070;
	bh=9DwblJQBPOF5jgRyIgwMS4V28JRvO/qFrLScjVqpPg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJHc/P+LvA1akqDJbQFyHfZVAJazTEebrJbaI4l1V4TR4mzvgLuiRJBtuJ3yfVnda
	 Lnk1QRpdcuAeSPLSz9Kpptrs6XbEsZhEjaP+085sEF1wUqchIEe6WMRvFvw35f6l4g
	 TR+Ev9nNuJKTS3QdoowUO+G8qMWxdNhvFSSiaHW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raoul <ein4rth@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 178/232] platform/x86/amd/pmc: Add PCSpecialist Lafite Pro V 14M to 8042 quirks list
Date: Tue,  8 Jul 2025 18:22:54 +0200
Message-ID: <20250708162246.097453228@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 9ba75ccad85708c5a484637dccc1fc59295b0a83 ]

Every other s2idle cycle fails to reach hardware sleep when keyboard
wakeup is enabled.  This appears to be an EC bug, but the vendor
refuses to fix it.

It was confirmed that turning off i8042 wakeup avoids ths issue
(albeit keyboard wakeup is disabled).  Take the lesser of two evils
and add it to the i8042 quirk list.

Reported-by: Raoul <ein4rth@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220116
Tested-by: Raoul <ein4rth@gmail.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20250611203341.3733478-1-superm1@kernel.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc-quirks.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index 2e3f6fc67c568..7ed12c1d3b34c 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -224,6 +224,15 @@ static const struct dmi_system_id fwbug_list[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "WUJIE14-GX4HRXL"),
 		}
 	},
+	/* https://bugzilla.kernel.org/show_bug.cgi?id=220116 */
+	{
+		.ident = "PCSpecialist Lafite Pro V 14M",
+		.driver_data = &quirk_spurious_8042,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "PCSpecialist"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Lafite Pro V 14M"),
+		}
+	},
 	{}
 };
 
-- 
2.39.5



