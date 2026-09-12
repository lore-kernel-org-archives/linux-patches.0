Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E396221FD4;
	Sat, 12 Sep 2026 15:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226440; cv=none; b=eqWW10BdEOoVypCfE/VmEUrp12f8pSwmXxvrQJVHBf/oPCizsyyHKqL9CENC9pJQRYTm618Espvjv129gF5l2DnbPXPFpCauql6WkPPoyfog3nPzZrw/WAlpr/+vZCrYJhNSQ/11te/dSKk3O28nJ5S+6+BtY5uFxNBrXMlzDaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226440; c=relaxed/simple;
	bh=qVle2LyuMfVqMM0wYfXEMZypgTjQTo06LPQ+hzlAMWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mF0v3kr5UBICehjUeQYHwLNIS2GkRW0bmcIQKpkRbFwD8WtCQX/U5cYuXTyF0T37MlnoHPRGfSB/UWFspL8sH03OBJsQw2XZ7ptHHAkpjhIWRadopyTMy2DkfcsUqnuXdWGjRz3oHavtj4VxiTpuMfYPlquCMtndbsBo47w4K6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WU8qlwTd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WU8qlwTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F99E1F000FF;
	Sat, 12 Sep 2026 15:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226439;
	bh=G9y/rgNFjvCRiZkN0uGvH11VvrFzhYkpKaSoCaCkt8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WU8qlwTdxnXqssymskvr36c38kFfttIhI8OsjNOLvU7BMXzTBHVgPgKjFaJbMxHDI
	 6d/r7wkBxDB44ON5ydqO3bS41+uVf3mzkDVjC58N8zOTAODOdFKqqYm3a7bKZjcTLg
	 tp1L6ucxbtjT/jqft9fRvvsZRLb1R6AJT69ju/JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1401/1424] ACPI: processor: idle: Remove redundant cstate check in acpi_processor_power_init
Date: Sat, 12 Sep 2026 09:03:53 +0200
Message-ID: <20260912065638.635789938@linuxfoundation.org>
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

[ Upstream commit db19103ea847ed139da59a2fb71773081c12cd40 ]

The function acpi_processor_cstate_first_run_checks() is responsible
for updating max_cstate and performing initial hardware validation.

Currently, this function is invoked within acpi_processor_power_init().
However, the initialization flow already ensures this is called during
acpi_processor_register_idle_driver().  Therefore, the call in
acpi_processor_power_init() is redundant and effectively performs no work,
so remove it.

Signed-off-by: Huisong Li <lihuisong@huawei.com>
Link: https://patch.msgid.link/20260311065038.4151558-2-lihuisong@huawei.com
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 66c62e6773c5 ("ACPI: processor: Add cpuidle driver check in acpi_processor_register_idle_driver()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_idle.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 1309254f51871..afc746b3d7ae6 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1431,8 +1431,6 @@ int acpi_processor_power_init(struct acpi_processor *pr)
 	if (disabled_by_idle_boot_param())
 		return 0;
 
-	acpi_processor_cstate_first_run_checks();
-
 	if (!acpi_processor_get_power_info(pr))
 		pr->flags.power_setup_done = 1;
 
-- 
2.53.0



