Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217240;
	b=u29OMwvAEaJ5lbyI69b6EeE5MP9FR/OoVnMzWNPNkfpF8drwZGEr9YaxjEtNDFTBpaZt
	 Y1mcU0qib5Q5wIK7N0YQYTLVBtAMa7Q7LZrkJs9U/6MKOw/UEBaxr1lTTtcG2HDhvYnHe
	 L9KvmQBXodkHoiWTtRco1kPNCV5AD1nKrD5Seflr6g2LzVZY3rGdmezjyX1q7kvCuH7/Y
	 S+l35vgNG0V/D6Zx9yScPcwrdr7plbuMoIS+ES7PkGKgdZ/a7eUmmgg+5SgMdLvwbU2n+
	 3HenUPYiaJCn6iR5yRp6o7AcOLxcdJ1PwhKI9YpH6+dM2vkJiHtQ4cUkAiwGalwRDNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3+6HtKYGW0opZNQ7vf/k5iYOArQ964P5Q8tPX6jpQfw=;
	b=xH3dlzuywPLh80/0F48EzqMntD9PpnzqXs6Jv0hUQbZKGd3FRbht2PdxBDKq9PVqIgaz
	 dGFoC/cO5OUKlvZWV1wZ1QH3g99UbMPs7lcU6NYNDW1BPEROEipnaeWw/mLQUt9AREo8s
	 xVgic+qTPPyLdu9N2OiWEznrYiChPsH30P6vUf8SUvJEVD1D9rX1j+T78BS5cGvqSa1gY
	 370i2MwtfwGgol9ul8QGrVWtyLx4gQJFFsygG6ssO1h+iWNABz9EU7bvljC02EIuvDlJ/
	 FfkvTDvBOOEdR2kCrRxvazInP9HpTfei1m+vAI91c9UvwCieDZOvIg+3wfhix/FJELA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OmJHYsoY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172BB606A322;
	Wed, 28 Oct 2026 19:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OmJHYsoY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38EB11F031E1;
	Wed, 28 Oct 2026 19:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217239;
	bh=3+6HtKYGW0opZNQ7vf/k5iYOArQ964P5Q8tPX6jpQfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OmJHYsoYncCWndfVZZboBcs6dHcIvGvfthhP6Z1udk9PAQgyfmV1lGmO7ZVBGCI3k
	 +gAEDt7uOquqBT2r79BVr4zkpiBceq6SG07JUC5Zm1VpV4sJzfnTup3JFUv1nsfpKo
	 CPxRKN2kTkt7gHmo1r5hiL9K0/isUHYLuy2mXe8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>,
	Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1790/1887] drm/i915/dmc: Harden DMC firmware payload parsing
Date: Wed, 28 Oct 2026 18:04:46 +0100
Message-ID: <20261028170540.184938712@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>

[ Upstream commit 8bb1858db453cd4250e3b633f5d2d09206024ca6 ]

Validate the conversion of the DMC firmware size from dwords to bytes
using check_mul_overflow() before calculating the firmware payload size.

Reject zero-length payloads and zero MMIO counts in the DMC firmware
header so malformed firmware is caught early. Also set dmc_fw_size only
after the payload allocation succeeds.

Fixes: eb805623d8b1 ("drm/i915/skl: Add support to load SKL CSR firmware.")
Cc: stable@vger.kernel.org
Assisted-by: Claude-Code:Sonnet-5
Signed-off-by: Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>
Reviewed-by: Mitul Golani<mitulkumar.ajitkumar.golani@intel.com>
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patch.msgid.link/20260922133535.3180973-5-dibin.moolakadan.subrahmanian@intel.com
(cherry picked from commit efde6601a1f1daedfe3dcc2816c934ddb44e3eef)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
[ sashal: Adapted drm_err() calls to use &i915->drm instead of display->drm. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dmc.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dmc.c b/drivers/gpu/drm/i915/display/intel_dmc.c
index e52ecc0738a60..722fdffb09f93 100644
--- a/drivers/gpu/drm/i915/display/intel_dmc.c
+++ b/drivers/gpu/drm/i915/display/intel_dmc.c
@@ -645,7 +645,7 @@ static u32 parse_dmc_fw_header(struct intel_dmc *dmc,
 	}
 
 	/* Cache the dmc header info. */
-	if (mmio_count > mmio_count_max) {
+	if (!mmio_count || mmio_count > mmio_count_max) {
 		drm_err(&i915->drm, "DMC firmware has wrong mmio count %u\n", mmio_count);
 		return 0;
 	}
@@ -660,13 +660,21 @@ static u32 parse_dmc_fw_header(struct intel_dmc *dmc,
 		dmc_info->mmioaddr[i] = _MMIO(mmioaddr[i]);
 		dmc_info->mmiodata[i] = mmiodata[i];
 	}
-	dmc_info->mmio_count = mmio_count;
-	dmc_info->start_mmioaddr = start_mmioaddr;
 
 	rem_size -= header_len_bytes;
 
 	/* fw_size is in dwords, so multiplied by 4 to convert into bytes. */
-	payload_size = dmc_header->fw_size * 4;
+	if (check_mul_overflow(dmc_header->fw_size, 4u, &payload_size)) {
+		drm_err(&i915->drm, "DMC fw_size too large (%u dwords)\n",
+			dmc_header->fw_size);
+		return 0;
+	}
+
+	if (!payload_size) {
+		drm_err(&i915->drm, "DMC firmware has empty payload\n");
+		return 0;
+	}
+
 	if (rem_size < payload_size)
 		goto error_truncated;
 
@@ -674,12 +682,15 @@ static u32 parse_dmc_fw_header(struct intel_dmc *dmc,
 		drm_err(&i915->drm, "DMC FW too big (%u bytes)\n", payload_size);
 		return 0;
 	}
-	dmc_info->dmc_fw_size = dmc_header->fw_size;
 
 	dmc_info->payload = kmalloc(payload_size, GFP_KERNEL);
 	if (!dmc_info->payload)
 		return 0;
 
+	dmc_info->mmio_count = mmio_count;
+	dmc_info->start_mmioaddr = start_mmioaddr;
+	dmc_info->dmc_fw_size = dmc_header->fw_size;
+
 	payload = (u8 *)(dmc_header) + header_len_bytes;
 	memcpy(dmc_info->payload, payload, payload_size);
 
-- 
2.53.0



