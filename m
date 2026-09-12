Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC772DC321;
	Sat, 12 Sep 2026 15:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226454; cv=none; b=la73//xSeCo17+iNEFXiee/OkixlkKx7gA3PXm55NDarzTPoe3OBICI5SQ3eidWtXq3Z1jMxZRtDlAGD5HU126fybfz1z/TuOZJAEYz2m5vAVOK1ZFT3UKG2gC0Sfi9IE/TuiMT5rKHIHAaiTLtvUQ/cO8r24IeY7H9wwft8rT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226454; c=relaxed/simple;
	bh=aXyWBv5cDqNa3fpvMaH29eRvggu2r9gRRrGO0Pi9fcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYK/B8bYO+Z88vNZueOYHT5Loc0MgR0Sf9A/KoD51uLPHFzwRf3pY1K6r2cEvk9d+Ravcda/PtujYYOsxtxVQ4kQF4j6v3AY1pceK0/Tig9Q6uxDha3i7noiBt+beNj0UZrrN1J+cggZ7+Cxu8DxZvZs7kKRjj/ma2xu+W1QYGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShozbLPH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShozbLPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D321F000FF;
	Sat, 12 Sep 2026 15:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226452;
	bh=il/cL3SDm5O+pV4YwlAEN0VX0TQe38cbY922jIKcjhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ShozbLPHaMkGClq0HtEweSHNkK7Ex/UdxMgPEHKgu6s7c3QkqRnt6gGxnAZ/IUI6T
	 v7UkJqbJYGOmt+q9Nc1idttTOjvkY0a2li/HYTGacybpe6M23mk6mX2+wlFPrSyaVH
	 VatkJ7llyN6AzrlH3Z1QTF/eAwqZG6RzEjfZFmr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1403/1424] ACPI: processor: idle: Remove redundant static variable and rename cstate check function
Date: Sat, 12 Sep 2026 09:03:55 +0200
Message-ID: <20260912065638.679686427@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huisong Li <lihuisong@huawei.com>

[ Upstream commit 4d613fb1ea0516e1f69d3a4ebfbf2572d5da5368 ]

The function acpi_processor_cstate_first_run_checks() is currently called
only once during initialization in acpi_processor_register_idle_driver().

Since its execution is already limited by the caller's lifecycle, the
internal static 'first_run' variable is redundant and can be safely
removed.

Additionally, the current function name is no longer descriptive of its
behavior, so rename the function to acpi_processor_update_max_cstate()
to better reflect its actual purpose.

Signed-off-by: Huisong Li <lihuisong@huawei.com>
Link: https://patch.msgid.link/20260311065038.4151558-4-lihuisong@huawei.com
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 66c62e6773c5 ("ACPI: processor: Add cpuidle driver check in acpi_processor_register_idle_driver()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_idle.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 190381cb67240..af7e1f0262fa6 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -836,19 +836,13 @@ static int acpi_processor_setup_cstates(struct acpi_processor *pr)
 	return 0;
 }
 
-static inline void acpi_processor_cstate_first_run_checks(void)
+static inline void acpi_processor_update_max_cstate(void)
 {
-	static int first_run;
-
-	if (first_run)
-		return;
 	dmi_check_system(processor_power_dmi_table);
 	max_cstate = acpi_processor_cstate_check(max_cstate);
 	if (max_cstate < ACPI_C_STATES_MAX)
 		pr_notice("processor limited to max C-state %d\n", max_cstate);
 
-	first_run++;
-
 	if (nocst)
 		return;
 
@@ -857,7 +851,7 @@ static inline void acpi_processor_cstate_first_run_checks(void)
 #else
 
 static inline int disabled_by_idle_boot_param(void) { return 0; }
-static inline void acpi_processor_cstate_first_run_checks(void) { }
+static inline void acpi_processor_update_max_cstate(void) { }
 static int acpi_processor_get_cstate_info(struct acpi_processor *pr)
 {
 	return -ENODEV;
@@ -1385,7 +1379,7 @@ void acpi_processor_register_idle_driver(void)
 	int ret = -ENODEV;
 	int cpu;
 
-	acpi_processor_cstate_first_run_checks();
+	acpi_processor_update_max_cstate();
 
 	/*
 	 * ACPI idle driver is used by all possible CPUs.
-- 
2.53.0



