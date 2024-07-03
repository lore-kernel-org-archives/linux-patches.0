Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932DC1850A8;
	Wed,  3 Jul 2024 11:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004922; cv=none; b=OCrgmPzS+Ilsri43SzeSmQZJG1+2lcUTy/1II2E2HLX55x1duBXB+XhTJJuVGTB8yZ/2+tth/dcgARBVLagPwl6D0BN6lYQ7Sbg47ayraKx4+ngEPuQho9iqD0F46DzYYodpN3A0zalf7lDzh/HAv2lrOTbdzx/mDDMdrYVT6Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004922; c=relaxed/simple;
	bh=s7oTOKZlbOg+vOrqKjyv3KwCF6cSUUkauFfjmUj/fgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXoVSU3XLGFxwC7/HBL/BTxoUkQ0Wix5S/6nTgTBsj2dBoR4ZgrRBlWR9xsKf6GzMjeilT9ILalfiCs59XXWumNSJ3EwJX+3UL9NytSxT/xq2X56YIf7oycu1VLBVY/GgYXOmaPVtDWZUmVZnL1zFL0u+0bFKvp1lZcitklB3hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4F2uUcp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4F2uUcp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A02DC2BD10;
	Wed,  3 Jul 2024 11:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004922;
	bh=s7oTOKZlbOg+vOrqKjyv3KwCF6cSUUkauFfjmUj/fgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4F2uUcpPOAvydrhNO6M7t1yS5amv5qbVTbdh7lRY6l8hYawYsku6gY+iFVmbNTAw
	 cJZwxOAiKPLZaydWIqM7zqBOUcfoX6vQmS3uKEHcgBV3LRyoctFpqBH+zEWEd04Fwc
	 3QjyLN1K/yNe7XLITzBR57ioZnpGtFE50/ro1gHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Axon <stuaxo2@yahoo.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 202/290] ACPI: x86: utils: Add Picasso to the list for forcing StorageD3Enable
Date: Wed,  3 Jul 2024 12:39:43 +0200
Message-ID: <20240703102911.792649818@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 10b6b4a8ac6120ec36555fd286eed577f7632e3b ]

Picasso was the first APU that introduced s2idle support from AMD,
and it was predating before vendors started to use `StorageD3Enable`
in their firmware.

Windows doesn't have problems with this hardware and NVME so it was
likely on the list of hardcoded CPUs to use this behavior in Windows.

Add it to the list for Linux to avoid NVME resume issues.

Reported-by: Stuart Axon <stuaxo2@yahoo.com>
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2449
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: e79a10652bbd ("ACPI: x86: Force StorageD3Enable on more products")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index f1dd086d0b87d..7d6083d40bf6b 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -204,6 +204,7 @@ bool acpi_device_override_status(struct acpi_device *adev, unsigned long long *s
       disk in the system.
  */
 static const struct x86_cpu_id storage_d3_cpu_ids[] = {
+	X86_MATCH_VENDOR_FAM_MODEL(AMD, 23, 24, NULL),  /* Picasso */
 	X86_MATCH_VENDOR_FAM_MODEL(AMD, 23, 96, NULL),	/* Renoir */
 	X86_MATCH_VENDOR_FAM_MODEL(AMD, 23, 104, NULL),	/* Lucienne */
 	X86_MATCH_VENDOR_FAM_MODEL(AMD, 25, 80, NULL),	/* Cezanne */
-- 
2.43.0



