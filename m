Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6939C356744;
	Sat, 12 Sep 2026 09:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206872; cv=none; b=pp58p3MQvIKnUbeZkAiTvN/xkqzzJ3NlZElPb18Wtq5GAPFNNDDk+8xEXWa+Wz90994lIP4J+9QtHeDjxRckfxjcn5Za+rtwL7tst0qe3dp/n7AtgL9JzOuHs2kR5Dnnk98qINE6QgFP7dkp74oli6Rf47D8J/opoei89ZCPwBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206872; c=relaxed/simple;
	bh=yH1hUbIMKH4R8UiDeLVEaObO78oGAH4b+WTJb/Ccw6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLoYwYWySx5B+Yuw1BpvdzLLEq0SmRjtWTXFJWevI7Bl7Hwxbve0PKtOyRHI3NVmTezjFoB2DxpkqVDJ9U/d3xpoxQ7Dq4TI5fk1CE61T+TfgtWeeUpFI4RviEvzjgppHRQlZr5rUiwGY0kw/CJDgsjRQlmTJaXV9fFpcVn9UqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBVkzbwt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBVkzbwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53EEE1F000FF;
	Sat, 12 Sep 2026 09:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206871;
	bh=ngG6D6++y1tSe6tMDHWiDA/GC5Wb3NFG6t30HR4t9QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GBVkzbwtyxx45WgbaBpoypiCuvqOUqiU7x7caSYMC6MIUI6UDuDCy768a8NPDr414
	 zzGU7onPEmASnzYEU8clSyocCuBi6aozjQkIIzsfcHY9KMEMgmEOS2IJu47ItZwwbQ
	 WcRpYxqWvl0suEAKlHCYPc57aYE8LqkslasUQ2cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sunil V L <sunilvl@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0296/1518] ACPI: RISC-V: Check acpi_get_handle() status in riscv_acpi_add_prt_dep()
Date: Sat, 12 Sep 2026 08:41:05 +0200
Message-ID: <20260912065630.176898431@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 52bb2738fa61b..46af9085dbce7 100644
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
 			dep_devices.handles = kcalloc(1, sizeof(*dep_devices.handles), GFP_KERNEL);
 			if (!dep_devices.handles) {
-- 
2.53.0



