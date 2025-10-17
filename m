Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8948D330B1F;
	Fri, 17 Oct 2025 15:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716368; cv=none; b=NtF3UfJyoEuMqS9syoKqsloI1ccAiEZ9sCu3/4qJsXbSq2Uxi5vjgr943L4p2u041lkZamyLuJbVlfT8YdG7/aTfo/OK5Jyy5Lb9h17MdHvnUeUt7j41TQnWMz0Kr4YxKpVjj8EeqZDVUachUqYKyTQnZXU90zScJHH/cBa0Xp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716368; c=relaxed/simple;
	bh=WXSPoK7qIl2/2T9B0+hzqXykb9n+bm5SnEv8b96f9s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVejGuSuE/lhjPRtP14+fqzLalKb6A1r3maM0XlOKznCcEYgOtRLT2Lvta0EBfRDL7PNYf0hB7bLy9/tpIAp7HZ290eenidJuuHZ4P8w7cPkjlkzOp41lS9l+pkE72wsJvZi1t1/NTv3fQGodj7SfEwjJCPMtVVoHUcuzN1ZoB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=azKID30X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="azKID30X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFFDC4CEE7;
	Fri, 17 Oct 2025 15:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716368;
	bh=WXSPoK7qIl2/2T9B0+hzqXykb9n+bm5SnEv8b96f9s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azKID30XLfbWn16c8Oyhya88Lml0Wo1QcDIuIj38+lZwQQgV6i8o5y3RMpkC4G6uH
	 2/EvsFxbQnO06i+pe8KXR39NYxpydnlIM+kT8k+bhlmLp8Qm80rMGh3LCF/M9t3XeU
	 W2bq1CecWoZhm8mhSMCdKj93/4++1ugJ5PDEAq5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Tang <danielzgtg.opensource@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 166/276] ACPI: TAD: Add missing sysfs_remove_group() for ACPI_TAD_RT
Date: Fri, 17 Oct 2025 16:54:19 +0200
Message-ID: <20251017145148.531380352@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


