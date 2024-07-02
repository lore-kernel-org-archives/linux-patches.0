Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7F81BE251;
	Tue,  2 Jul 2024 17:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941317; cv=none; b=otJVdNlzCbnH761asaG3NqraKYIObMygTiWtFLaYfR7pVfroqWvl5H3JlsoZIZ9yE7xSR9XXUL1WojHg3MEhHPK8qjZIoDCIo29trJii6FWXUh+I0sxZXchqIpnqEsytYdzQJ/1IJzofkNg083Dq9UgFH9V0iCiMs6JE0TzvPIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941317; c=relaxed/simple;
	bh=6/mZEM5GQYS6cfM2ZD0TvrXBurqNf9KZjv7BdsdxHyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJY4ybVeGKheD7b9jpJ8fWbXv9kdutAWLDhMSoSS1xMkTdcHa/C+DbrXw9UQCfcxl5OIj2QZKdPDYwoDuziuDkEAVTAClObk1/BuPoAS1Y+AQZaOjLYoPexpJ5YNZyt5/0dKpSBa5MFjpsfbeT7tpm1SpYw6ZwY5AuiUgqzWfgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIXvm4d4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIXvm4d4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A7AC116B1;
	Tue,  2 Jul 2024 17:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941317;
	bh=6/mZEM5GQYS6cfM2ZD0TvrXBurqNf9KZjv7BdsdxHyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIXvm4d492rvb9ogxeX4+BBVrZaCxQUXW5hT7FpmZ04t5NcMik/9R2kI6Ix3m+OO9
	 eZLuW0etNhiAU7GpVLskQfusDB3hrIRIgJEG+2uqhIwKs0niAc2sKcZTb75UBWpxGx
	 fibcglAQt+BP9a2NG6Lo8Q8WkwTzzu5xMqGjQ6YY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Axon <stuaxo2@yahoo.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/128] ACPI: x86: utils: Add Picasso to the list for forcing StorageD3Enable
Date: Tue,  2 Jul 2024 19:03:25 +0200
Message-ID: <20240702170226.401226297@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e45285d4e62a4..ef431393381a0 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -213,6 +213,7 @@ bool acpi_device_override_status(struct acpi_device *adev, unsigned long long *s
       disk in the system.
  */
 static const struct x86_cpu_id storage_d3_cpu_ids[] = {
+	X86_MATCH_VENDOR_FAM_MODEL(AMD, 23, 24, NULL),  /* Picasso */
 	X86_MATCH_VENDOR_FAM_MODEL(AMD, 23, 96, NULL),	/* Renoir */
 	X86_MATCH_VENDOR_FAM_MODEL(AMD, 23, 104, NULL),	/* Lucienne */
 	X86_MATCH_VENDOR_FAM_MODEL(AMD, 25, 80, NULL),	/* Cezanne */
-- 
2.43.0



