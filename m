Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063308;
	b=5XEuZU4cKt4DYaheZuAKw3Xz1+FFR0pHCG2AXGNZBZeCTDcHhhmIlc0xN0v4RtgQZKaL
	 aLUVE09xYlnnjTHxphWv0B0wqm2PdVlFV46lgqaCY/glW3nrDMfJzlrtU/Lx3xlk3bDFm
	 fySksr9pOL6t8rnRDunA6PrCrH+bJySlgFn14tcOTTGVBVJKOUUs0hM0f2M2kJI12wVgt
	 23jo7/iPz8irJvf34UxY3hypXlFUAk2nWoma9MjfsaWYE53x98cDtVd65DjWXTuIhaFrI
	 F6R4FnW26mHcJd590eTL/xSpN1gdML9cCjhHRRq8OorFOgcngo9Vk9v74YBRupBYbCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dQRH+Y3cT957Yqr8GIEiRXjL6qQJ9KVmW/0kIq2piSc=;
	b=ctiZYYikGGmdUzyQRn8/lkJNjfuZ9JL7NM6ZRgM3N/7jgMnEGAFLoeUSxxPzpOWealQ/
	 ek2Y7C68i3fnsuSG+FE1ENhHIPpBZic3xwMnMTVdf67nlr1OCi960NNFDtxlC6jcEtWhK
	 7+bFIR0VWLf8/1n+tdbIgElOBov4kDhuWmHS1/i6ttOxHdleHU4wDQp9eLhhLRQ0ZTCnD
	 zFhu3s09itDTT5kzqByTXr/4J0AU4P+Va0TQCDl4m5XdypE8gv7mzj5fQ6jVH/+Y9ore3
	 Z+b7LFOyOAa7MoYswNL0UVPuKDolvLLcYUvsqVhAZVp+SxfYk7Iwaq87AEryiqvNY1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nwjOxY3I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FFE606EEBD;
	Sat,  7 Nov 2026 14:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nwjOxY3I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2532F1F008A1;
	Sat,  7 Nov 2026 14:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063308;
	bh=dQRH+Y3cT957Yqr8GIEiRXjL6qQJ9KVmW/0kIq2piSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nwjOxY3IeGiqvjsM/inmdXWcdnd8GaKkP9RrCi+zfdRWhdu3ELCuB2Jp7OKksF1+9
	 EOTXiClM457dZG5txLEXs4iDJ8xWrXx5F0wVw1zM22L4WwZ66IBKpo6B9OijMqEFxS
	 wPlPtxQ101tgSX+awkd2e7S4q1fWUPm7RGm4aMzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 497/869] platform/x86/amd: hfi: Fix out-of-bounds reads when parsing ranking data
Date: Sat,  7 Nov 2026 08:52:59 -0500
Message-ID: <20261107134910.415877825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ac6ef0b5b95b2..1d12a3b8f32f1 100644
--- a/drivers/platform/x86/amd/hfi/hfi.c
+++ b/drivers/platform/x86/amd/hfi/hfi.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/mailbox_client.h>
 #include <linux/mutex.h>
+#include <linux/overflow.h>
 #include <linux/percpu-defs.h>
 #include <linux/platform_device.h>
 #include <linux/smp.h>
@@ -169,6 +170,21 @@ static int amd_hfi_fill_metadata(struct amd_hfi_data *amd_hfi_data)
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
 
@@ -193,10 +209,6 @@ static int amd_hfi_fill_metadata(struct amd_hfi_data *amd_hfi_data)
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



