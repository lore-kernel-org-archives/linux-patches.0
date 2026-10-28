Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207818;
	b=oIJpTn/TMX4iL3FBA/7qNTN/wFBPumDDNnk8xxWEEBMl4vZNxVs5VrsWI0HSQcU/m9Ro
	 yTKyH4a/nkAxg2hgzkoMcIozOCNXmkYk6JIy5w9vnG9eiDROHfeXZrWhOpXpw1Lqp5P/O
	 olCN7LwrV3sUGT04fn+McFqSYc9J8NI833OJH8mVIVMqH1hmveKm3Jw0O6cIJq+/INkY2
	 Igizmjn4h89EhiKpX30axk1k9K1Tf9LPrsgDohQN+U6H9VBBWd2W1mKRIkRIzUoLoMIg/
	 g8xmCzrZufqgaP9RJESBq3bx0smiUux+ThGOQGH6TEwB4+2TRDcyCMRNvI6NcZ+T1Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eZhmea06dscMMUglcXS3CQeV6ZxGsykq5nDyPxj/d9M=;
	b=oxHdYb+Si5lRyVuiLRsikNmf+YwH6bGpMUf3jwbuMihFLdFRKZ1AfNeRa5j6+I2JHs1O
	 ybSOjWXtJ7DeBnbgPUHiqlWoI60OaQLBlqEp7SgkLkLakFLsSrxja1EbgiRv1uWqj7Qfh
	 9TuYOXwcGEXh7fyICa23AjSl+ZCvn6yu508m/B84X3okcKKCXdAk89Rl9wq4bZUsQSD5c
	 b6ofmuQWvnfMYBjWYMT49MCzFW8MQOByAYhzTIAmiRs7nbzsxn643vIwu8ndwCO8j7LbF
	 NekTnQXK7TjnsM2cvMnL3jRZ4o1DJ+Y1Ou/Aracszrzu3UIyCoUxVgqYtzZUAWcijaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="A4gXQf/r";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D88606A31C;
	Wed, 28 Oct 2026 17:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A4gXQf/r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52EF1F031E1;
	Wed, 28 Oct 2026 17:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207818;
	bh=eZhmea06dscMMUglcXS3CQeV6ZxGsykq5nDyPxj/d9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A4gXQf/rLTcJsqzHHq9oYQEoWhQPYnKhQcsDn8tfYU6ejJ28YPAji3Z0nq0CJHujo
	 nPJf7YC+z+cRtfjK9iIzhDQGPp24mrrVP3h4QAhsY6FkTjw8MsftYkeAChnikauat4
	 vb/TwKzpfdAHaqaMbciOjLaFajJ0A9eKrtq5E4SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>,
	Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 150/247] drm/i915/dmc: Harden DMC firmware payload parsing
Date: Wed, 28 Oct 2026 17:59:13 +0100
Message-ID: <20261028165950.964237030@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Changed logging arguments from `display->drm` to `&i915->drm`. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dmc.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dmc.c b/drivers/gpu/drm/i915/display/intel_dmc.c
index 7c756d5ba2a22..641dabf275e73 100644
--- a/drivers/gpu/drm/i915/display/intel_dmc.c
+++ b/drivers/gpu/drm/i915/display/intel_dmc.c
@@ -796,7 +796,7 @@ static u32 parse_dmc_fw_header(struct intel_dmc *dmc,
 	}
 
 	/* Cache the dmc header info. */
-	if (mmio_count > mmio_count_max) {
+	if (!mmio_count || mmio_count > mmio_count_max) {
 		drm_err(&i915->drm, "DMC firmware has wrong mmio count %u\n", mmio_count);
 		return 0;
 	}
@@ -819,13 +819,21 @@ static u32 parse_dmc_fw_header(struct intel_dmc *dmc,
 			    disable_dmc_evt(i915, dmc_id, dmc_info->mmioaddr[i],
 					    dmc_info->mmiodata[i]) ? " (disabling)" : "");
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
 
@@ -833,12 +841,15 @@ static u32 parse_dmc_fw_header(struct intel_dmc *dmc,
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



