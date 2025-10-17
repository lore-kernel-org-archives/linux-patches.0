Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896031946C8;
	Fri, 17 Oct 2025 15:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715213; cv=none; b=KxvNgKhgfro9cplE5rHAmxozWRF3rh1oIAKDiEqfzY3rxId6XuQz8CeIwpQlArRAjtvhESfJ2RocXwHtGStBgOzo/Mg0Iyr16eb26dYea2B7ymkr1x0sjmtx9BIto4sffWbMqzXfyXfOtDMFjcD73ZTXaWd4lWhHlVpN/mT7UAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715213; c=relaxed/simple;
	bh=G6iMDsXhBDGxooQf2Yv3eWrdTaNYsCWoMlajhounTr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9tI3XzzAmF+6Gyqzs8e1uEL41JizW7Tu+CnYZCTlJUD6u91AXhdnontPCKCTTJORLWl9icwIGkKB7R6fZ3HU/5TcBWrMa7MuhvlQ+9gb3SZudZS9aFvv8xzeDcp8l0Ql4iVuALZHLtOAR0c/lsW1JhLssw3Zr/dq6qPElbEZqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVR2tlrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVR2tlrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F89BC4CEE7;
	Fri, 17 Oct 2025 15:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715213;
	bh=G6iMDsXhBDGxooQf2Yv3eWrdTaNYsCWoMlajhounTr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oVR2tlrRC6Bw+OzetrzsCg54bOtU9qVS7gCx2cG5+reoMD5ZwpPI9hAIDdFmto0SX
	 9k0siW5o3PbKD/Lstj/AXxgDJQldjD+r5ToZsdqBXaKb9iyTB9eViUFGHr0nIZMAb6
	 rgNhntVT8oEFI3tKLFz+eoh0jMJk7kyvU2DPnDUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Tang <danielzgtg.opensource@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.17 138/371] ACPI: TAD: Add missing sysfs_remove_group() for ACPI_TAD_RT
Date: Fri, 17 Oct 2025 16:51:53 +0200
Message-ID: <20251017145206.925506798@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -565,6 +565,9 @@ static void acpi_tad_remove(struct platf
 
 	pm_runtime_get_sync(dev);
 
+	if (dd->capabilities & ACPI_TAD_RT)
+		sysfs_remove_group(&dev->kobj, &acpi_tad_time_attr_group);
+
 	if (dd->capabilities & ACPI_TAD_DC_WAKE)
 		sysfs_remove_group(&dev->kobj, &acpi_tad_dc_attr_group);
 


