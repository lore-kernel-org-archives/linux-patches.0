Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774235;
	b=ds5IcZ0r9Dw8UBrBSYY/t+lvNullI5btmskCVrBqetoWDoei+vVbhXkJTGoELq7UMwaw
	 /Yp7cK0K/ifPdGkc+gUeurfJTqCMaGsmySgI5X7ZiYA4/ejJKj2O18A+SHPNyzL881Yds
	 WPq481mJ/x0i2FD8IR2QptCdpyi/MdQB2SWnNZStEAvsbfecUZ2OjPgAdf73/FngS4L6d
	 3ueOD5POHhozIYOT/0OimtRxNbqWqmjAUbVOghe0KYGXEHcMYVzLMmXaxIKZeF7R80Xty
	 gkwDhKRbEWTGUR9uCHK8XYO70tTJsU0V5VkYHi/j8EsHwCFXpSXR7UNzJ/t/ssj6zKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9tn2rXB/H9ox0J+/C64OdYdxD89mYnoy4np60qM+QlI=;
	b=f+qMoA88ekZt2FTXQOt41GNFXJImFTiyRCMH1c+EeKN23TU/z6Yq4NDzLKj2n6In0H4G
	 kXan4O2/7Aja/hi/3xf+8pJsrA6VlvjILSdnezqd07dlZXc21TBi1QBaqhWrK4ENxXyYV
	 +HAF9MhOoIJcSai78J0P96QFR0DMOAAquejY7hnF2X/+aNhh5oDhr7qWgyft+CR7QWZHC
	 D+3QR9Ib7Y0vwFsP3vb0G9uVK9yBQsk8McAV+J0rG800o0lLHKc1GvbTt///aM7ysRiVS
	 93kMZuJ50QXd7PTH+U4gZTDTix57oElCpltbUUc8j1DL0FhVvHFT1A+PHXImfkf+eiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SABNuzSm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196A9606A31B;
	Fri, 23 Oct 2026 16:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SABNuzSm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616221F01828;
	Fri, 23 Oct 2026 16:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774234;
	bh=9tn2rXB/H9ox0J+/C64OdYdxD89mYnoy4np60qM+QlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SABNuzSmaJSKfjWXqRzTCkW5xdNcLQSX4wMzKDpFRaML0EW3rJE89+w88dE5Rnmbi
	 9ciMP6zdrb3vGvToVe/mMgKRnxIuIbwDsn6ChsBlHLWZav5zgTLexk+Ijds8dScBTc
	 GXpYRoVMG0unV4xqXT/S3yttxkfzWPyCujXtTWow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>,
	Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 165/193] drm/i915/dmc: Harden DMC firmware payload parsing
Date: Fri, 23 Oct 2026 18:37:22 +0200
Message-ID: <20261023163718.116287421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1132,7 +1132,7 @@ static u32 parse_dmc_fw_header(struct in
 	}
 
 	/* Cache the dmc header info. */
-	if (mmio_count > mmio_count_max) {
+	if (!mmio_count || mmio_count > mmio_count_max) {
 		drm_err(display->drm, "DMC firmware has wrong mmio count %u\n", mmio_count);
 		return 0;
 	}
@@ -1178,13 +1178,21 @@ static u32 parse_dmc_fw_header(struct in
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
 
@@ -1192,7 +1200,6 @@ static u32 parse_dmc_fw_header(struct in
 		drm_err(display->drm, "DMC FW too big (%u bytes)\n", payload_size);
 		return 0;
 	}
-	dmc_info->dmc_fw_size = dmc_header->fw_size;
 
 	if (!dmc_load_addr_sanity_check(dmc, start_mmioaddr, payload_size,
 					dmc_header->header_ver, dmc_id)) {
@@ -1204,6 +1211,10 @@ static u32 parse_dmc_fw_header(struct in
 	if (!dmc_info->payload)
 		return 0;
 
+	dmc_info->mmio_count = mmio_count;
+	dmc_info->start_mmioaddr = start_mmioaddr;
+	dmc_info->dmc_fw_size = dmc_header->fw_size;
+
 	payload = (u8 *)(dmc_header) + header_len_bytes;
 	memcpy(dmc_info->payload, payload, payload_size);
 


