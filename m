Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A40142903;
	Wed,  3 Jul 2024 11:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005966; cv=none; b=MLd689eTy8rViRr99w+u6kqaswmnaAf88oleBtcXIv8l3AHe92E/+9ciiKzMQKiwn47JQU1dYZDtDM0HPgZGtY7y9ebHIoYWVYm6yfrKH4NpeD0SmVLanqlRaa1rBIRdMGsBMPW8DQOseGhgCB2/9YlKQ3FDENEQNj8q/tyMszY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005966; c=relaxed/simple;
	bh=PiDuluqTftUnIBgIy9gZs4c2SY5EBoRxskiSg/3oCb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o33WadSZsZ1y1hpcLlqkjfKRS8UcipSUFyeq+TmpmwHW/oOGkImcI2d0wjurFYunvTEiUE7r7J25n3coCCVtK7vEc0Frkl/YbPYHw35Rl4fkKsIhm9CdVEFgsyR+2mYHlnD6ucbGh6FdbRtFaQch8/0XyhbwMaNFSouQMJ+dqb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZUNPE3fA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZUNPE3fA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60029C2BD10;
	Wed,  3 Jul 2024 11:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005965;
	bh=PiDuluqTftUnIBgIy9gZs4c2SY5EBoRxskiSg/3oCb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZUNPE3fA6wbtU7jzWIw7Pl+FTEVQiXrzdKu0Ka/I4ZulT/dmeR7lK1GlClSFBDGLc
	 BBJW2pKa+ruI4P7ev16ZM/bKh+aV/0+ZmBkvUE5LCNfKhmYqjfiFQbDNkFGHqg02uY
	 rXXQo3uJuGu4pmL/RsWjbKYgemsZ4QgSDhpyo+78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Axon <stuaxo2@yahoo.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 256/356] ACPI: x86: utils: Add Picasso to the list for forcing StorageD3Enable
Date: Wed,  3 Jul 2024 12:39:52 +0200
Message-ID: <20240703102922.801598278@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



