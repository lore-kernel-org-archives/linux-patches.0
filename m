Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B6F2A1BA;
	Tue,  8 Jul 2025 16:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992429; cv=none; b=c0iWNHyzHZEOXu0kyAvf2IOcVR+dW7JmsvqqQhmF635q7MlPcqcwPdDOqpgxIZ5qMAErg41NsAn6mCo2pRqiXMFsuHUrHhUuoFgG2+S+40PBosSetv5jkr/tS+9A1v6IuXTDnE76ebbxbC58AhCsG/zV+H+oe2rhTufRNbrRkdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992429; c=relaxed/simple;
	bh=lLlNjevhyIo4GAT/KU888I3ETw9jEFESLRxwCYCzveI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CLwcgakWl7aZ7vAkhDcQE185Q4oC5dzRoIUBh0YmfnRVpnOZjhzaikY/+uB+9mdgC2ZomtP9nXe8W2lWsyoCeoJkOY1Empca67Gqb0I/Oww6rYsxtvzzppwwbsz49dbRDdhoTlrqXQwwK0FalQMH0WgZGGsv0kZZTtdxq3Wtwyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OmMwQ1eM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OmMwQ1eM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8742DC4CEED;
	Tue,  8 Jul 2025 16:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992428;
	bh=lLlNjevhyIo4GAT/KU888I3ETw9jEFESLRxwCYCzveI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmMwQ1eMXPRc4EZgpE/QbWAmWKGD7YElXHkjKe4mHaGjMF7wfe0YI7PjMrMO8suOc
	 fMMHattXwLg/iGzl3UnIWRGEe+jQ7EeOZhZKOmbVRND7asHFVDNFpGYPS5GMCtwxgc
	 45fSBqIOjIY48uSsofoOzdGgtAW2NSbxK/WHF6p4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raoul <ein4rth@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/132] platform/x86/amd/pmc: Add PCSpecialist Lafite Pro V 14M to 8042 quirks list
Date: Tue,  8 Jul 2025 18:23:20 +0200
Message-ID: <20250708162233.230015252@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



