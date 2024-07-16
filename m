Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D3517A93F;
	Tue, 16 Jul 2024 15:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145112; cv=none; b=qrkEI8MoB6Oh1hwLlAsZe0/AUqdQeCIL2639/LwZ/rm77uq04KSX+S95hYpzAZ4RNYRfvg1ZFjMUANRXOHa9f63D0+7YLkUEWY3BSi3nbw9a68lepxe0gVDXMprAN1vgzsU4QppowbBq530uODITAYD7c6NfYLuFw9Lx23jCBNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145112; c=relaxed/simple;
	bh=aJFHNT03quOwq09DolWro+OFmW+M9+vO6Gtms200VxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qr0ZW9804Oa/UCLGEtJ8OvxeNRbn9Umi9lVx/SGOGH9b5PNyCvVQ6U9ARRQ6k0B3mP0AeSrHFYlx3/Mvjf85bjo9k6lFVpvasqGI4LWFCw3+eqlQAjWE1EfMYDMoyQtdX6iLauY//CnodOChHroj0WukWBVbXMKczsmF9ZWoNWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BP1565cH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BP1565cH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A500CC4AF0B;
	Tue, 16 Jul 2024 15:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145112;
	bh=aJFHNT03quOwq09DolWro+OFmW+M9+vO6Gtms200VxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BP1565cH1bMRGT+5naoLrJ3RWBkAWtzVdG6ROu+x7ho9yazbffhInISATF0mghd20
	 Knm9IRVdXshrq+GQaM1G8SH7y4rthGcCP9YlIpyAs4v5/l225Mir0JLU2fL6kOo6X4
	 zHdGsBAXc6GwYzoRj2Yew596l6uMGQCdT39qTbyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.9 103/143] platform/x86: toshiba_acpi: Fix array out-of-bounds access
Date: Tue, 16 Jul 2024 17:31:39 +0200
Message-ID: <20240716152759.941476757@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

commit b6e02c6b0377d4339986e07aeb696c632cd392aa upstream.

In order to use toshiba_dmi_quirks[] together with the standard DMI
matching functions, it must be terminated by a empty entry.

Since this entry is missing, an array out-of-bounds access occurs
every time the quirk list is processed.

Fix this by adding the terminating empty entry.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202407091536.8b116b3d-lkp@intel.com
Fixes: 3cb1f40dfdc3 ("drivers/platform: toshiba_acpi: Call HCI_PANEL_POWER_ON on resume on some models")
Cc: stable@vger.kernel.org
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20240709143851.10097-1-W_Armin@gmx.de
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/toshiba_acpi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -3304,6 +3304,7 @@ static const struct dmi_system_id toshib
 		},
 	 .driver_data = (void *)(QUIRK_TURN_ON_PANEL_ON_RESUME | QUIRK_HCI_HOTKEY_QUICKSTART),
 	},
+	{ }
 };
 
 static int toshiba_acpi_add(struct acpi_device *acpi_dev)


