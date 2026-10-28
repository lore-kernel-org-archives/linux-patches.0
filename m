Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209512;
	b=n09EhIiAzHF3jvT7E5ybxmSEla4Rxu4Eq41+dr/VtUF7wtPsX1T9u2gksa3W4tL0qNxv
	 6meC6XVTGylbW1W4fXgF+kz7XaEd2CQJlZmt+UCmM8mbwN3+69Zpq+oR4J5OzSnhlTqLE
	 3ALVc8vIfixxpjMLsKLyKOQVYOsf3KAGiq24GcEtoEe1arMsQliYMfP8n2MzraXpJRxcg
	 /tuy9w6x7Wq+ElIbCwr5H7FY8iEJA3N1TLAumAwVCrpVaqwejalxmUDn7shv6tjDdA68J
	 RL3dwxbAaTyBH/WPfPvitnC9u4tVe1MFrhCDqyS1B9NTwA2C1aomggi9aZbO40eG1Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=82diPvffMxISCQAdfZTXGVIu+DM+DzwPX4oRei7ecs8=;
	b=JAgZ8PwkQFxF6KwnzsUpIGqZ50pH2l0KMIxL0Z+9GhF7eMnaKi05Ml9gQjdbnNMVHPGl
	 yLfg6hBy+/4c+ZSJrkqCRt/y2trPbCHFxnylxMpeTfPLMPz4NbuuG8zfTHpFpayTWGqq2
	 dg+N/nlJDgF5z3WSlf6rOVUHtgoVrT8a2FZjEQvS/BSXTOAsuUcsDy9kS065LP0qKva3F
	 nqrSnZzRZZ3fGPscogSmOzRQ/zmEeg+TQNjnJfoBHoWKGXEYQZZSKqJpPxorBHjECebVJ
	 3Wj8RCT+w9gs1sBgrbF179qOAVY6S7WToERM2arVLA1dfKwosizOL2W4aHh2vToVrbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bTr/MRm2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB94606A31A;
	Wed, 28 Oct 2026 17:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bTr/MRm2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DFA1F01825;
	Wed, 28 Oct 2026 17:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209511;
	bh=82diPvffMxISCQAdfZTXGVIu+DM+DzwPX4oRei7ecs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bTr/MRm2cJfaPRONGUzHlDBMOHeXolz6JZLAY9jntXX/WgNuSXAqG1TaBRpQVHG1A
	 IiPZAPWQwS5GH84LiHLXXG8YLalVLxJyro1QmrlZX/OMtyUlRxoQUKxw9e0KxumRQ8
	 kXtlduM9ctL/66kgScbH6wkWwCZxGrb1jJaZJaJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>,
	Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 496/516] drm/i915/dmc: Harden DMC firmware payload parsing
Date: Wed, 28 Oct 2026 18:00:48 +0100
Message-ID: <20261028170015.230491473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted parse_dmc_fw_header() changes to the existing parse_csr_fw_dmc() implementation ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_csr.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_csr.c b/drivers/gpu/drm/i915/display/intel_csr.c
index d5db16764619c..086ba8720558e 100644
--- a/drivers/gpu/drm/i915/display/intel_csr.c
+++ b/drivers/gpu/drm/i915/display/intel_csr.c
@@ -439,7 +439,7 @@ static u32 parse_csr_fw_dmc(struct intel_csr *csr,
 	}
 
 	/* Cache the dmc header info. */
-	if (mmio_count > mmio_count_max) {
+	if (!mmio_count || mmio_count > mmio_count_max) {
 		DRM_ERROR("DMC firmware has wrong mmio count %u\n", mmio_count);
 		return 0;
 	}
@@ -454,12 +454,21 @@ static u32 parse_csr_fw_dmc(struct intel_csr *csr,
 		csr->mmioaddr[i] = _MMIO(mmioaddr[i]);
 		csr->mmiodata[i] = mmiodata[i];
 	}
-	csr->mmio_count = mmio_count;
 
 	rem_size -= header_len_bytes;
 
 	/* fw_size is in dwords, so multiplied by 4 to convert into bytes. */
-	payload_size = dmc_header->fw_size * 4;
+	if (check_mul_overflow(dmc_header->fw_size, 4u, &payload_size)) {
+		DRM_ERROR("DMC fw_size too large (%u dwords)\n",
+			  dmc_header->fw_size);
+		return 0;
+	}
+
+	if (!payload_size) {
+		DRM_ERROR("DMC firmware has empty payload\n");
+		return 0;
+	}
+
 	if (rem_size < payload_size)
 		goto error_truncated;
 
@@ -467,7 +476,6 @@ static u32 parse_csr_fw_dmc(struct intel_csr *csr,
 		DRM_ERROR("DMC FW too big (%u bytes)\n", payload_size);
 		return 0;
 	}
-	csr->dmc_fw_size = dmc_header->fw_size;
 
 	csr->dmc_payload = kmalloc(payload_size, GFP_KERNEL);
 	if (!csr->dmc_payload) {
@@ -475,6 +483,9 @@ static u32 parse_csr_fw_dmc(struct intel_csr *csr,
 		return 0;
 	}
 
+	csr->mmio_count = mmio_count;
+	csr->dmc_fw_size = dmc_header->fw_size;
+
 	payload = (u8 *)(dmc_header) + header_len_bytes;
 	memcpy(csr->dmc_payload, payload, payload_size);
 
-- 
2.53.0



