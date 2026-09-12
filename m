Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9D137A827;
	Sat, 12 Sep 2026 12:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215357; cv=none; b=nNOm0ZEfRNeMFs8/f2w4CRPgJnXbzS2AoIfkxBH9wrs0arXwXcdB2cN887+rh57qc5vL9on8dVIKggf+s0EnBhBPQKPpnqKBVJATDbJRYzb1pELiYU81BQVuK5hdiOmU/ntXyNIWpQbQaZi8Svg0RVuyIIc9ZN3jEev7SvLj2tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215357; c=relaxed/simple;
	bh=huc+EsOsq0zmvbwnpScJj200PPZ92kzOpa6QaIQTMbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CI5IdoGtpaEy8/k6b0G3chGHa8KOY1qeKqqRVHL1OwnpTfdqb0ChX1gmvwx4VY0W7Drk5VqPxIZsdc4+Ix27HbeC6ZQNgnnbHzS3zlMX2cs7Y0x56Ov/AGeiRtANAqYEPSMMbDynnZiFmai8CZUVT6m/zFjb48GttUHJNHkBCB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rxchmxgf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rxchmxgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E68D1F000FF;
	Sat, 12 Sep 2026 12:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215355;
	bh=Xr/RUR75F/QejcO/VqAGzA+WiSLdr0Qkff9aK4dfai8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rxchmxgfPZ6DG5Nrt0M/lVDybWEBRQpkXAqXTZS8bF7pOyf5i/nN2p+OX7GNR/smD
	 A8/w+UrVX1Zf8pROL8ffzNFQalBjQdiokCvpqzvWHP/6SQcMhIVaUC/ppAZ/IfK/jq
	 BwGTPMyOvguMdVCAo9n+Mn8La9zB+xv0ITvLFrQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sunil V L <sunilvl@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0472/1376] ACPI: RISC-V: Check acpi_get_handle() status in riscv_acpi_add_prt_dep()
Date: Sat, 12 Sep 2026 08:48:18 +0200
Message-ID: <20260912065618.052602800@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e24266ce8a14f..e97417ab94ce9 100644
--- a/drivers/acpi/riscv/irq.c
+++ b/drivers/acpi/riscv/irq.c
@@ -270,7 +270,9 @@ static u32 riscv_acpi_add_prt_dep(acpi_handle handle)
 	entry = buffer.pointer;
 	while (entry && (entry->length > 0)) {
 		if (entry->source[0]) {
-			acpi_get_handle(handle, entry->source, &link_handle);
+			status = acpi_get_handle(handle, entry->source, &link_handle);
+			if (ACPI_FAILURE(status))
+				continue;
 			dep_devices.count = 1;
 			dep_devices.handles = kcalloc(1, sizeof(*dep_devices.handles), GFP_KERNEL);
 			if (!dep_devices.handles) {
-- 
2.53.0



