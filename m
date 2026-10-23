Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792775034;
	b=If5NZTPwr5H7Q+J0y18Z/lteVoYvXRn0raHPVJ0pc5E1OnEPbRptb1n/53gK+xG7L9p9
	 9bESuurqFtY8QOMS/Wd4Jr5MV890DcoFRMs1KtkWjTSZdh48NsxwZcEQ3aqE2GMwhkd01
	 xAMWmMDpUceJL0rfZrx8t27LM/OIJUrtlmZF6S21jt2JELoG43sHQZDvuMAjjfKKptWv4
	 zfK/UvzA7c8JGfLn0p4Pp1mX9OrFDOM4U9gPGMYOKYSjYmheUqVkmFROrPyQFQPRhhm4L
	 ga5mmVFCiv0Vi52aXfa47SsoMXYYHzKx1njHUeY2WUTCrQQ0WTkzPnJKkUtPzkKPuoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775034;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uFJDWPrp4uHvO1X/yWPzaih0hrRe5Dg3iftcLclsWzk=;
	b=BsFLolxqa8CQWdmPp8nOPYIZ7bdG0PT/9IQT6W4Lk6/x7rrROeZeU+M0kD0zAUS8SiVI
	 clMJhqpM1BWPwHI/wGWpc+7qAWcVG0YqxiHCRcPvZXDCX1Zk/fGvuoT50cRAyyazi93yo
	 N/F0UFK3uc+ntkupbbmyYZtgr9TfTQPLGHQ3S3JeMF9gnbJzG2JuxgrAKs0uGbvKGfbmV
	 h48y5mr6Bs1iwcKiZJhXbH8qxveyvoPC/YOuXnyRGgzfxsIoQbAom/lko/KqYFnuJ8DyC
	 Tt8U3LZ8tSglBdJPTRESXDzuYz3TplC+BOF2xLWw1jirQgWhyHuPlZz9x3Z1sZvM37g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EhetOnQc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63180606A31A;
	Fri, 23 Oct 2026 17:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EhetOnQc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20491F01825;
	Fri, 23 Oct 2026 17:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792775034;
	bh=uFJDWPrp4uHvO1X/yWPzaih0hrRe5Dg3iftcLclsWzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EhetOnQcDodFxguArsO7q33VCGlwNqAGpmosOpr5Qocl/IUr6HEtLwbclg3x0sMcL
	 4hhlow1/7gJpBZIkPEv1bFIQqZ7LMcFX9v3TrPFbBnIAW4cQm/nZ0tBwNusB5drwVY
	 czzOi2N51ZmxDg6BTKC4z7E+uAvfVIw6mwG/jAis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>,
	Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 212/242] drm/i915/dmc: Harden DMC firmware payload parsing
Date: Fri, 23 Oct 2026 18:40:54 +0200
Message-ID: <20261023163718.812805887@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dmc.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dmc.c
+++ b/drivers/gpu/drm/i915/display/intel_dmc.c
@@ -1165,7 +1165,7 @@ static u32 parse_dmc_fw_header(struct in
 	}
 
 	/* Cache the dmc header info. */
-	if (mmio_count > mmio_count_max) {
+	if (!mmio_count || mmio_count > mmio_count_max) {
 		drm_err(display->drm, "DMC firmware has wrong mmio count %u\n", mmio_count);
 		return 0;
 	}
@@ -1211,13 +1211,21 @@ static u32 parse_dmc_fw_header(struct in
 			    disable_dmc_evt(display, dmc_id, dmc_info->mmioaddr[i],
 					    dmc_info->mmiodata[i]) ? " (disabling)" : "");
 	}
-	dmc_info->mmio_count = mmio_count;
-	dmc_info->start_mmioaddr = start_mmioaddr;
 
 	rem_size -= header_len_bytes;
 
 	/* fw_size is in dwords, so multiplied by 4 to convert into bytes. */
-	payload_size = dmc_header->fw_size * 4;
+	if (check_mul_overflow(dmc_header->fw_size, 4u, &payload_size)) {
+		drm_err(display->drm, "DMC fw_size too large (%u dwords)\n",
+			dmc_header->fw_size);
+		return 0;
+	}
+
+	if (!payload_size) {
+		drm_err(display->drm, "DMC firmware has empty payload\n");
+		return 0;
+	}
+
 	if (rem_size < payload_size)
 		goto error_truncated;
 
@@ -1225,7 +1233,6 @@ static u32 parse_dmc_fw_header(struct in
 		drm_err(display->drm, "DMC FW too big (%u bytes)\n", payload_size);
 		return 0;
 	}
-	dmc_info->dmc_fw_size = dmc_header->fw_size;
 
 	if (!dmc_load_addr_sanity_check(dmc, start_mmioaddr, payload_size,
 					dmc_header->header_ver, dmc_id)) {
@@ -1237,6 +1244,10 @@ static u32 parse_dmc_fw_header(struct in
 	if (!dmc_info->payload)
 		return 0;
 
+	dmc_info->mmio_count = mmio_count;
+	dmc_info->start_mmioaddr = start_mmioaddr;
+	dmc_info->dmc_fw_size = dmc_header->fw_size;
+
 	payload = (u8 *)(dmc_header) + header_len_bytes;
 	memcpy(dmc_info->payload, payload, payload_size);
 


