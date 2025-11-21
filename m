Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776FB266584;
	Fri, 21 Nov 2025 13:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732304; cv=none; b=AH5LPIjdf5eZLHC4WZh20uv4CmdNlvn+2zlqwb4qX1IyL+WXEQf3W9OhE0JipdUaCqqibaGT2oDV/PRJTpDsPwURpfzlCZBuJA0Gm7GXaip/tAr9eO2q9fEgol/ElzRWuEk0w/hEVsIPxTk4oGAWiolwJTY3QmdbD4Hg1zaEuyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732304; c=relaxed/simple;
	bh=lRL0i099FrOcLNMydqaQq8tOqoW9Byj8iwPl20r6Xps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kP18spTRSgGxcbEk0qo+zJEJRE2fkxUQ0Eqd+ZhStbntgNfQGY41yZt73IapHaCnWLt3aHbjBMv+hFzaX0Vp/YwMSeNpDkkG5qv3fBkkJHq3AB3ffVNODJeee1R96IZS1XltWOMFCGxwa8vwfwBgHsWtOLBnSmNjRFVBNdVsqxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrUCoP3v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrUCoP3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F372EC4CEF1;
	Fri, 21 Nov 2025 13:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732304;
	bh=lRL0i099FrOcLNMydqaQq8tOqoW9Byj8iwPl20r6Xps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MrUCoP3vr0HfyHVJFpc172NzQEPyqx5wAcPka3MVmV8PNfzzk4iEWw3JD86LXLDo5
	 ljWCWo6wuIhPC3UqFL4pzjjdaDlMg82/03xh3SzG29fd0MRqyxWQxHH7R5Wpwzd+CO
	 rCKSciyro83DeCjuQ1vm5mlPWvixiRtAw10rrQNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/529] hwmon: (k10temp) Add device ID for Strix Halo
Date: Fri, 21 Nov 2025 14:06:14 +0100
Message-ID: <20251121130233.692431310@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rong Zhang <i@rong.moe>

[ Upstream commit e5d1e313d7b6272d6dfda983906d99f97ad9062b ]

The device ID of Strix Halo Data Fabric Function 3 has been in the tree
since commit 0e640f0a47d8 ("x86/amd_nb: Add new PCI IDs for AMD family
0x1a"), but is somehow missing from k10temp_id_table.

Add it so that it works out of the box.

Tested on Beelink GTR9 Pro Mini PC.

Signed-off-by: Rong Zhang <i@rong.moe>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20250823180443.85512-1-i@rong.moe
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/k10temp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
index 759855412e50d..dc82e33d59c5f 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -554,6 +554,7 @@ static const struct pci_device_id k10temp_id_table[] = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M20H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M50H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M60H_DF_F3) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M70H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M90H_DF_F3) },
 	{ PCI_VDEVICE(HYGON, PCI_DEVICE_ID_AMD_17H_DF_F3) },
 	{}
-- 
2.51.0



