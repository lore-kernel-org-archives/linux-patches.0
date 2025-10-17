Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5EA23EABB;
	Fri, 17 Oct 2025 15:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713237; cv=none; b=o5lT5m+BO+wASzs+vox+Ia1Rz6yDKTOBha1FO/Nz6Ik9F6Hq/4hXJwES/Z1AXPqAYC2Tv124QIZSbqOtZRA38kuvSsHSDSyWIL+IyZBakvQ+0DWQIPT2dZWw2b20fWv0NO7pd8c4m1E+35h6R5QbGhE5LEts1wRvJqFzZUm6vC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713237; c=relaxed/simple;
	bh=fk+B3A0uEqxoJkjlz9rvuFfHx9/nIZbj7xHuILV0WZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=olOMe67O9ylkmS4enDOhfrBeIqOM3sHEOX+jU78t3XFDhivHbmZB1yUH61UGRGxh0Kd9Yf7w6Bmnz3B0uo5g835KC5U4Xb26KcP/SwBhAE2LFh9U0VBouDsCK69fVJcq1gyS4NU0UVeDJ3IpOs+REJvrKvYfM6RuQwB0sTFPf3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ec3QZiEP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ec3QZiEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFF8C113D0;
	Fri, 17 Oct 2025 15:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713237;
	bh=fk+B3A0uEqxoJkjlz9rvuFfHx9/nIZbj7xHuILV0WZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ec3QZiEP3lqQwCSp4Jcs3bTgUjtqKtW8hGvkgX+iF7i/YVqmQ6/SmonLpqTirZ/5r
	 ONfoNU1STARuxuUkwdsI1i9jC9rGnnE8e8KzShA4uQKSsVrvnp5jdFMEolylUmcuJ1
	 5GfVnIFdvpZYZBCt/P64pxYaDDErMBZdaxIc4wOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Tang <danielzgtg.opensource@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 052/168] ACPI: TAD: Add missing sysfs_remove_group() for ACPI_TAD_RT
Date: Fri, 17 Oct 2025 16:52:11 +0200
Message-ID: <20251017145130.935736506@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


