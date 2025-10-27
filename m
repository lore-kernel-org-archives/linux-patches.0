Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C02323406;
	Mon, 27 Oct 2025 18:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590687; cv=none; b=ai/SnI0IyGHB9MZNBp3RIy+ChxOHVoCywb/ruxdrNfFU7gQ+P7pLmK4AvbqWlVwAjFy4juG6BHlSTAMA1usHGg3wjppjcBgv0Qx1wuBNNQP9oVGUkJJH2YCHCZmcaeIXH5w3IdHoB2/qXT5MfkJJDhnJoHV2JW9ZNoFBZQ28UZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590687; c=relaxed/simple;
	bh=nJeozG1QgEgDkCJCxEC791D79IGYKK5dPGsFCGUAw6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhAPY90zA2+OK/LhczzUPw9uALop/ArYV3VXeutWQj3KFvjjF4RqGUw5QSV9FpIFF2fKcN19WGjg+WYDp0TCv7IyFQSc5reF9D+wuvQXI/YGRml53jCIsMkKy+QpChu9roILRNiG/wqkKdcXmX0W9r3qBPer/Qw5ShpoHb1AKOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rhu24PS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rhu24PS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F85FC4CEFD;
	Mon, 27 Oct 2025 18:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590687;
	bh=nJeozG1QgEgDkCJCxEC791D79IGYKK5dPGsFCGUAw6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rhu24PS6VRmmu6eVroki451PMORhA7I6MEZ3wJPJKZRWK0DnyyJ3rmedvObLZawxX
	 6pOLCEBXDJrzkYDDv/sBA27JeIOvzxrTKkxetKnfMgbSfmFWB1FQ5b3ashdx3m1LTa
	 B3zLvvj2t37u4HdCNtQXD+2nKKKmp9KEDQzW8q8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Tang <danielzgtg.opensource@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 100/224] ACPI: TAD: Add missing sysfs_remove_group() for ACPI_TAD_RT
Date: Mon, 27 Oct 2025 19:34:06 +0100
Message-ID: <20251027183511.664919163@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Tang <danielzgtg.opensource@gmail.com>

commit 4aac453deca0d9c61df18d968f8864c3ae7d3d8d upstream.

Previously, after `rmmod acpi_tad`, `modprobe acpi_tad` would fail
with this dmesg:

sysfs: cannot create duplicate filename '/devices/platform/ACPI000E:00/time'
Call Trace:
 <TASK>
 dump_stack_lvl+0x6c/0x90
 dump_stack+0x10/0x20
 sysfs_warn_dup+0x8b/0xa0
 sysfs_add_file_mode_ns+0x122/0x130
 internal_create_group+0x1dd/0x4c0
 sysfs_create_group+0x13/0x20
 acpi_tad_probe+0x147/0x1f0 [acpi_tad]
 platform_probe+0x42/0xb0
 </TASK>
acpi-tad ACPI000E:00: probe with driver acpi-tad failed with error -17

Fixes: 3230b2b3c1ab ("ACPI: TAD: Add low-level support for real time capability")
Signed-off-by: Daniel Tang <danielzgtg.opensource@gmail.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://patch.msgid.link/2881298.hMirdbgypa@daniel-desktop3
Cc: 5.2+ <stable@vger.kernel.org> # 5.2+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_tad.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/acpi/acpi_tad.c
+++ b/drivers/acpi/acpi_tad.c
@@ -563,6 +563,9 @@ static int acpi_tad_remove(struct platfo
 
 	pm_runtime_get_sync(dev);
 
+	if (dd->capabilities & ACPI_TAD_RT)
+		sysfs_remove_group(&dev->kobj, &acpi_tad_time_attr_group);
+
 	if (dd->capabilities & ACPI_TAD_DC_WAKE)
 		sysfs_remove_group(&dev->kobj, &acpi_tad_dc_attr_group);
 


