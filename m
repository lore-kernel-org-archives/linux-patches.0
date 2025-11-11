Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99157262A;
	Tue, 11 Nov 2025 01:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822838; cv=none; b=nL9xSqYxNS3oawn+KE0PlSz3A7cfqLAUNh5LQhSsTUam2DhAv/bqLptc+q/GM2l66lDXVzVvt2tji9hSWDl7yoUYRnWHiM2FJT499GuJMMWIOh52DWa9n0YyGl43MtewWmQfIUShnmU1mIbE77mE1IvhEEwkyr6/0CKg1aeOe0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822838; c=relaxed/simple;
	bh=/UfDtX14bQkNVlqwNF+K2GDz5lWLcxvVcFnuNwk6cX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnjh+2Bj4dXyilO4uKtPd/rYKWXioj4Vbh0Gqu0oEr+ixIZsu6t/QmkCdjx4RlUf+DqjeXS/4SxCbIekwW56Tf4wBianwSjfr1z/zAJji6v+oIKCSXcXOfhrA8AOpH8U07fZgnqH8rKxY0AsCF5iiJJDH2BXbo8ZCiRY+Coxt/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JetkWtO+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JetkWtO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F9BC4CEF5;
	Tue, 11 Nov 2025 01:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822838;
	bh=/UfDtX14bQkNVlqwNF+K2GDz5lWLcxvVcFnuNwk6cX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JetkWtO+7D3s+o48FhiBllY0HmXi6+HnDrSVSgJI65o2F3a6sq5emxnG0N6Y7S/0P
	 xtl5p0iv9hscvHNPr5sKc8tduYjyceumbqmnq396I3FvjxXlJ2RX9WgXUiW+9+sZGq
	 lqUiPOyeFQIWJEbKwe/Y4PyYOEDaEEjcPqrGy3eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 118/565] hwmon: (k10temp) Add device ID for Strix Halo
Date: Tue, 11 Nov 2025 09:39:34 +0900
Message-ID: <20251111004529.610099303@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c457ba4706197..ccf0e9e853acd 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -551,6 +551,7 @@ static const struct pci_device_id k10temp_id_table[] = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M20H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M50H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M60H_DF_F3) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M70H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M90H_DF_F3) },
 	{ PCI_VDEVICE(HYGON, PCI_DEVICE_ID_AMD_17H_DF_F3) },
 	{}
-- 
2.51.0



