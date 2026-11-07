Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064683;
	b=yNLLhoTriK0WrAcQIAN/s/aGiGssne4oRGQjRbDrZd9be+pr3HoqLLytjSMu2UtMBXaf
	 0nZeKwlioYzig+rI5miED3q/98XfIC06oM6L9aoSXEdtEu2EV9m6+RByMJqgScP9sbcmP
	 8kZbbHHGDcJeCUXRcQbBD8kQ22/m6V9TdhEllTWwJIMllaryB7Jlfbznq+Z4iT9pHDgCm
	 RWasZnjehrzHSJT+0h+p13nS0Q0DM36Evl8/vJnTEJcW9TTXjPVnUik99YbW0/kre41di
	 kR20+sRdJWrDuP/LfH1FqdGcJTlntOd+yRSxufEXIhSPaNrVPyUDrtKAM9spnIHzyfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=wy90t5TmgSGfrpWdXsG3J+TWSfGPoTMsdUpVl/Wuehc=;
	b=WFCBiToWZYOI4e6P2gSqp1qD+sHjKrvbFTfSrgAyY5WgAhInPL6z1913gYmj20H7QSXJ
	 PQWFy1XP0ZWp3S8akN1dTMlOH4IezCCCJh4G5bn3ySWIEebpjBlP1QbXAIwx+8WxOhYB0
	 SpNLb+epCorEDFzxYZ401TkxgBzQLxC9RiDoCX6EHCxibzxUBFRwnFVtrv0fbzjxbskLg
	 Our/LX83FNOV+xb0OskbRRba9OAS+rX6tZ770rczARR5ubXyerRq2VEWn82j74zmMcgDs
	 xnRNCXpGWL9RRVn3fuDvvJuMVU7ofiwkI9mu1QBE5qtV8o1gYMqVKkqWhUlEOyL64XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="WvcuTJa/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63417606B8A5;
	Sat,  7 Nov 2026 15:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WvcuTJa/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F0A1F008A1;
	Sat,  7 Nov 2026 15:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064683;
	bh=wy90t5TmgSGfrpWdXsG3J+TWSfGPoTMsdUpVl/Wuehc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WvcuTJa/hBCHx1d1wORDsHbTp0p/FgVoCchmvPG6q6m6dOtF6QWRUuclGl2kN+t+j
	 v+0jzrWnUmN8p3y9wFHzeNOmEx7bVts7BnAXLAPBmGIk3W/2JxPYR+KZTWsWyPdb8w
	 3GeDL4oBqXOH7sIKqEZwRaPGpvatcQv01c9l//4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0678/1257] platform/x86/amd: hfi: Fix out-of-bounds reads when parsing ranking data
Date: Sat,  7 Nov 2026 08:49:34 -0500
Message-ID: <20261107134957.988387876@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit b7b273844b94af9cc64907dccd9e7997c2b60f1a ]

amd_hfi_fill_metadata() parses CPU core ranking data out of the
firmware-provided PCC shared memory but trusts two values it should not:

 - n_bitmaps is used to bound the outer loop that reads the APIC ID
   bitmaps from table_data[], but it is never validated against the size
   of the shared memory region (pcct_ext->length).  A firmware-supplied
   count larger than the region reads past the end of table_data.

 - When resolving the base of the ranking data for a processor, the
   pointer is shifted by an extra "i * nr_class" term, where i is the
   current bitmap index.  The per-processor offset is already applied
   through apic_index, which uses the running count of active processors
   (apic_start).  The extra shift compounds for every logical processor
   beyond the first bitmap (APIC ID >= 32), reading out of bounds.

Both result in out-of-bounds reads that can corrupt the ranking metrics,
oops, or otherwise destabilise the system.

Reject an n_bitmaps value that would not fit within the shared memory
region, and drop the bogus "i * nr_class" term so the ranking data is
addressed only through its correct per-processor offset.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: d4e95ea7a78e ("platform/x86: hfi: Parse CPU core ranking data from shared memory")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260921170411.1149960-3-mario.limonciello@amd.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/hfi/hfi.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/amd/hfi/hfi.c b/drivers/platform/x86/amd/hfi/hfi.c
index e1c776b71f3e6..6d1d3b6c28a97 100644
--- a/drivers/platform/x86/amd/hfi/hfi.c
+++ b/drivers/platform/x86/amd/hfi/hfi.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/mailbox_client.h>
 #include <linux/mutex.h>
+#include <linux/overflow.h>
 #include <linux/percpu-defs.h>
 #include <linux/platform_device.h>
 #include <linux/smp.h>
@@ -168,6 +169,21 @@ static int amd_hfi_fill_metadata(struct amd_hfi_data *amd_hfi_data)
 		return -EINVAL;
 	}
 
+	/*
+	 * The bitmaps enumerating the APIC IDs occupy the first n_bitmaps
+	 * words of table_data.  Reject a firmware-provided count that would
+	 * push those reads past the end of the shared memory region.
+	 */
+	if (struct_size(amd_hfi_data->shmem, table_data, amd_hfi_data->shmem->n_bitmaps) >
+	    pcct_ext->length) {
+		dev_err(amd_hfi_data->dev, "invalid number of bitmaps: %u\n",
+			amd_hfi_data->shmem->n_bitmaps);
+		return -EINVAL;
+	}
+
+	/* The ranking data for each processor follows the bitmaps */
+	u32 *table = amd_hfi_data->shmem->table_data + amd_hfi_data->shmem->n_bitmaps;
+
 	for (unsigned int i = 0; i < amd_hfi_data->shmem->n_bitmaps; i++) {
 		u32 bitmap = amd_hfi_data->shmem->table_data[i];
 
@@ -192,10 +208,6 @@ static int amd_hfi_fill_metadata(struct amd_hfi_data *amd_hfi_data)
 			info = per_cpu_ptr(&amd_hfi_cpuinfo, cpu_index);
 			apic_index = apic_start * info->nr_class * 2;
 			for (unsigned int k = 0; k < info->nr_class; k++) {
-				u32 *table = amd_hfi_data->shmem->table_data +
-					     amd_hfi_data->shmem->n_bitmaps +
-					     i * info->nr_class;
-
 				info->amd_hfi_classes[k].eff = table[apic_index + 2 * k];
 				info->amd_hfi_classes[k].perf = table[apic_index + 2 * k + 1];
 			}
-- 
2.53.0



