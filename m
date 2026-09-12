Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C37346A08;
	Sat, 12 Sep 2026 07:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198057; cv=none; b=YSXpJ13J3CqtAUNres9Izax6wDQDYgZTIib8TC1/JiIDY7RSzcdkfRiTJDdyrELw41qQzR7IG9XuZV2Rx590qEbp9Sx0CJO7MRyEZ2wvE18gBWMUzqUIn886mmhqah6JZI+dgXZ9ZFa+k5FpuJNs6OX7Ah/pTGHygFD62394FAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198057; c=relaxed/simple;
	bh=tx+48CNa2Hds4ZI78+I7IbodLNFM0dVfPsCO/VAqKt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMs0DkOj37Yr9aKakgbX2O64QymZ09deaKLDo37Tu1YPVng2uMIWljatzGTvAR81aH4+7PFL8w6Jsl8K9DZVAXUQT6zCE55cDHE6YURg/YSsdfV7rLYFU+a1CPXcqmf45W5901tsYSiiK4SiNqrPUWw2t84gH1rq0zjZob4PyuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MJoUZNNl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJoUZNNl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944A31F000FF;
	Sat, 12 Sep 2026 07:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198056;
	bh=lQ/7/12RtwYb8T8C/uOG/PgrBDU/nKgbWSZ+S0ktfuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MJoUZNNlyFMxrrr04X/L7tXBXxxd1j+npD9ZIWANFJBMcgBL+JNGQd/asbhl5bVrn
	 EG8eQ9+eU/dlu6SIEyCXRh7JOKyJOM4XMJ5GOD3jI7KlTk6+l3Yi8FzxBgJxNg+CgP
	 LtTYm7MhOcGbst9Gi36LbFLtf2YMNGRuOneLvt1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sunil V L <sunilvl@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0301/1815] ACPI: RISC-V: Check acpi_get_handle() status in riscv_acpi_add_prt_dep()
Date: Sat, 12 Sep 2026 08:34:11 +0200
Message-ID: <20260912065656.015459043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Pieralisi <lpieralisi@kernel.org>

[ Upstream commit 20435bda13f1219891ed0ce41207e320a916ff9c ]

In riscv_acpi_add_prt_dep(), the acpi_get_handle() call can fail which
would leave link_handle uninitialized.

Fix it by checking the acpi_get_handle() return status and skip the entry
if it fails.

Fixes: 1b173cc4bfcd ("ACPI: RISC-V: Implement function to add implicit dependencies")
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Tested-by: Sunil V L <sunilvl@oss.qualcomm.com>
Reviewed-by: Sunil V L <sunilvl@oss.qualcomm.com>
Link: https://patch.msgid.link/20260709-gic-v5-acpi-iwb-probe-deferral-v4-3-48dae790f871@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/riscv/irq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/riscv/irq.c b/drivers/acpi/riscv/irq.c
index cd83c3035cf6b..75170151c6141 100644
--- a/drivers/acpi/riscv/irq.c
+++ b/drivers/acpi/riscv/irq.c
@@ -339,7 +339,9 @@ static u32 riscv_acpi_add_prt_dep(acpi_handle handle)
 	entry = buffer.pointer;
 	while (entry && (entry->length > 0)) {
 		if (entry->source[0]) {
-			acpi_get_handle(handle, entry->source, &link_handle);
+			status = acpi_get_handle(handle, entry->source, &link_handle);
+			if (ACPI_FAILURE(status))
+				continue;
 			dep_devices.count = 1;
 			dep_devices.handles = kzalloc_objs(*dep_devices.handles,
 							   1);
-- 
2.53.0



