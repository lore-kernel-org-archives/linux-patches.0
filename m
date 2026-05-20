Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F842348C55;
	Wed, 20 May 2026 18:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301793; cv=none; b=IrQUy7gjBbmnNPC2dELqD1RuaZ0tUOLVsFfpUv3Xuq7dHClIqubGdvGVdlO2JgDAbKTIFPUcESftxNS+Skq2TGM1SGb1fNK+lUhOMO2P1O/2Gb7wdJGPWFs3wO+Iny94Cq1uXGeZMPXAaXjCx9YUA1Ov4gWNxGoOK0fmQRiWgqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301793; c=relaxed/simple;
	bh=e9otPkZty8UgCCl9VYTpSxygTbHw5NaJjtchOw3d35U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pKemhAuCaFHVrpl65oLsN2fE+BSnShzJcwmmjjs0kUTcRUZk62uUdNGmjlo9lrbXmTd3I4/KlqMPL2SyyNJ1wcazXwWTvZJtM/xkqX7uSVqJKBqX/XjyXLZEBhpmBSnv9ghH8hMK0zYhUOU/riOUu6ae/hxXQyCdjcN3R6KkJJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=atRNwJrK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="atRNwJrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D559B1F000E9;
	Wed, 20 May 2026 18:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301792;
	bh=9T/oBmHhpamSuF7vtsVCtI0yaLT770140kCITJXRWGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=atRNwJrKIKgKdC/mgpw+vngbiJXdb20Px465hcYrRXLx+cWjak7Ud/zIHXtX3I2jb
	 M6mbeAjxqXhGe49kdP1/9xFtlUo+SCJ2SIL/ICfSXr7RGP/IlKrl9NLujFOpG5I3oj
	 zbXYbPlJugdYpDnN0JaAxMohcb1jnH3PdnlwcXSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Jean Delvare <jdelvare@suse.de>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/508] firmware: dmi: Correct an indexing error in dmi.h
Date: Wed, 20 May 2026 18:17:25 +0200
Message-ID: <20260520162059.070248942@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit c064abc68e009d2cc18416e7132d9c25e03125b6 ]

The entries later in enum dmi_entry_type don't match the SMBIOS
specification¹.

The entry for type 33: `64-Bit Memory Error Information` is not present and
thus the index for all later entries is incorrect.

Add it.

Also, add missing entry types 43-46, while at it.

  ¹ Search for "System Management BIOS (SMBIOS) Reference Specification"

  [ bp: Drop the flaky SMBIOS spec URL. ]

Fixes: 93c890dbe5287 ("firmware: Add DMI entry types to the headers")
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Link: https://patch.msgid.link/20260307141024.819807-2-superm1@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/dmi.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/dmi.h b/include/linux/dmi.h
index 927f8a8b7a1dd..2eedf44e68012 100644
--- a/include/linux/dmi.h
+++ b/include/linux/dmi.h
@@ -60,6 +60,7 @@ enum dmi_entry_type {
 	DMI_ENTRY_OOB_REMOTE_ACCESS,
 	DMI_ENTRY_BIS_ENTRY,
 	DMI_ENTRY_SYSTEM_BOOT,
+	DMI_ENTRY_64_MEM_ERROR,
 	DMI_ENTRY_MGMT_DEV,
 	DMI_ENTRY_MGMT_DEV_COMPONENT,
 	DMI_ENTRY_MGMT_DEV_THRES,
@@ -69,6 +70,10 @@ enum dmi_entry_type {
 	DMI_ENTRY_ADDITIONAL,
 	DMI_ENTRY_ONBOARD_DEV_EXT,
 	DMI_ENTRY_MGMT_CONTROLLER_HOST,
+	DMI_ENTRY_TPM_DEVICE,
+	DMI_ENTRY_PROCESSOR_ADDITIONAL,
+	DMI_ENTRY_FIRMWARE_INVENTORY,
+	DMI_ENTRY_STRING_PROPERTY,
 	DMI_ENTRY_INACTIVE = 126,
 	DMI_ENTRY_END_OF_TABLE = 127,
 };
-- 
2.53.0



