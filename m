Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CE529B201;
	Wed, 23 Apr 2025 15:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422488; cv=none; b=FNSNpHlWWv2lVhE6OYlnmtCXpfK5FGZOaRJxUk04d68OyICBAP2Ua3/OZfAjMUsP/2gXMUvr/YFXL9/Gkx9XKD1tUukmeo9EIGnFqAbwhM0bNTcfWG4qcsoIBu5Wkle7qHgdc2oixYsBrudP88+1YkfT+MRFvHAn2VRIaw1WLW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422488; c=relaxed/simple;
	bh=rxuMse+B5mIWf6rDJI8BcBu5DWN1TfHXA2wivZbKTzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QMuKctsgDiLGKZsYxG8AjfCmd+eKbkxtwmGlByu7hy9NWfdHWkJ6PK1SGAHth4sC23ItYq48Z5c4KlDmibBU8+fp5grLh5JIWEwBejh5+zAg0C12VW2MjLlfcRrMKnLalq89IGjXqh+GI8SS56WgJziAoLS0whWn5df4xyJ9TFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lv6iBihW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lv6iBihW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8017C4CEE3;
	Wed, 23 Apr 2025 15:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422488;
	bh=rxuMse+B5mIWf6rDJI8BcBu5DWN1TfHXA2wivZbKTzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lv6iBihWWlc/mIWsJmfOUTdXf7K4ViZ/Kc0rxpexiJCuLFDV+l9UUt5vvB5oZONsA
	 Jjb9qogRSvgZHoQnR5G4xUpldEx0d0BbsOdtDTJe8RQkLnDmXSDzT4hXY9lndB+sMM
	 cwNi+sbF7uFYYGXSFnKFUJOFSxL3CY1V4yLcPAzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Juergen Gross <jgross@suse.com>,
	Jason Andryuk <jason.andryuk@amd.com>
Subject: [PATCH 6.6 370/393] x86/xen: move xen_reserve_extra_memory()
Date: Wed, 23 Apr 2025 16:44:26 +0200
Message-ID: <20250423142658.618138384@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

From: Roger Pau Monne <roger.pau@citrix.com>

commit fc05ea89c9ab45e70cb73e70bc0b9cdd403e0ee1 upstream.

In preparation for making the function static.

No functional change.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Message-ID: <20240725073116.14626-2-roger.pau@citrix.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
[ Stable backport - move the code as it exists ]
Signed-off-by: Jason Andryuk <jason.andryuk@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/xen/enlighten_pvh.c |   82 +++++++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 41 deletions(-)

--- a/arch/x86/xen/enlighten_pvh.c
+++ b/arch/x86/xen/enlighten_pvh.c
@@ -26,47 +26,6 @@
 bool __ro_after_init xen_pvh;
 EXPORT_SYMBOL_GPL(xen_pvh);
 
-void __init xen_pvh_init(struct boot_params *boot_params)
-{
-	xen_pvh = 1;
-	xen_domain_type = XEN_HVM_DOMAIN;
-	xen_start_flags = pvh_start_info.flags;
-
-	if (xen_initial_domain())
-		x86_init.oem.arch_setup = xen_add_preferred_consoles;
-	x86_init.oem.banner = xen_banner;
-
-	xen_efi_init(boot_params);
-
-	if (xen_initial_domain()) {
-		struct xen_platform_op op = {
-			.cmd = XENPF_get_dom0_console,
-		};
-		int ret = HYPERVISOR_platform_op(&op);
-
-		if (ret > 0)
-			xen_init_vga(&op.u.dom0_console,
-				     min(ret * sizeof(char),
-					 sizeof(op.u.dom0_console)),
-				     &boot_params->screen_info);
-	}
-}
-
-void __init mem_map_via_hcall(struct boot_params *boot_params_p)
-{
-	struct xen_memory_map memmap;
-	int rc;
-
-	memmap.nr_entries = ARRAY_SIZE(boot_params_p->e820_table);
-	set_xen_guest_handle(memmap.buffer, boot_params_p->e820_table);
-	rc = HYPERVISOR_memory_op(XENMEM_memory_map, &memmap);
-	if (rc) {
-		xen_raw_printk("XENMEM_memory_map failed (%d)\n", rc);
-		BUG();
-	}
-	boot_params_p->e820_entries = memmap.nr_entries;
-}
-
 /*
  * Reserve e820 UNUSABLE regions to inflate the memory balloon.
  *
@@ -133,3 +92,44 @@ void __init xen_reserve_extra_memory(str
 		xen_add_extra_mem(PFN_UP(e->addr), pages);
 	}
 }
+
+void __init xen_pvh_init(struct boot_params *boot_params)
+{
+	xen_pvh = 1;
+	xen_domain_type = XEN_HVM_DOMAIN;
+	xen_start_flags = pvh_start_info.flags;
+
+	if (xen_initial_domain())
+		x86_init.oem.arch_setup = xen_add_preferred_consoles;
+	x86_init.oem.banner = xen_banner;
+
+	xen_efi_init(boot_params);
+
+	if (xen_initial_domain()) {
+		struct xen_platform_op op = {
+			.cmd = XENPF_get_dom0_console,
+		};
+		int ret = HYPERVISOR_platform_op(&op);
+
+		if (ret > 0)
+			xen_init_vga(&op.u.dom0_console,
+				     min(ret * sizeof(char),
+					 sizeof(op.u.dom0_console)),
+				     &boot_params->screen_info);
+	}
+}
+
+void __init mem_map_via_hcall(struct boot_params *boot_params_p)
+{
+	struct xen_memory_map memmap;
+	int rc;
+
+	memmap.nr_entries = ARRAY_SIZE(boot_params_p->e820_table);
+	set_xen_guest_handle(memmap.buffer, boot_params_p->e820_table);
+	rc = HYPERVISOR_memory_op(XENMEM_memory_map, &memmap);
+	if (rc) {
+		xen_raw_printk("XENMEM_memory_map failed (%d)\n", rc);
+		BUG();
+	}
+	boot_params_p->e820_entries = memmap.nr_entries;
+}


