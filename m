Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585249;
	b=pbr1mBN29qLSmeKO8lO57MtPTvzZnAF4ssj2CuJXXVIzFDL/46LEXH0DCLAMHWbbxKQR
	 wWmqv2CL2a9TUheC7szS0MijivcnvoOXHIzEAlbfClYSsN0ywt2aSBpXmqkIrOlUiK4Uh
	 4cWNOpTH6n06uLQWQ8NoM7v+oqqFfjlqIENUAQmKKGF5cuwfYZ67Eiog2GupuO9E3/BSY
	 JsEX4DSYi8Vfb5OPXQsHzRuJZfDhjJuXma32zGPWaPeTA2Wo3RC7iCgvL1lMivlh+08RT
	 InkTXKxbInX7m3Ujtv3cS3m66X9B/GaS4nmkGRB72fIGc9o7oD8PHVeizZyzz4FRPgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K2k2vCDUPppG7hqBsoBdN6vCAGy+I6h3Io/9bLuT1Kk=;
	b=BU7C1pvmTOg0TKn3qIxjDp5Yo7Epn6ewd/z4D5qoffDuXitEFtaSwbX4TLOI8DVbRWT0
	 U1o4ZpfJcyEZpLYWRsbbXPwTpQhDp7tMRIFVFYFhYku/WWQU45xyFYmf2bavhtaklkl8+
	 R24CS7wE2nAoqaEWGJaIhbfMcYeAnjpgL+Q1Mp9tUGK/Rox/SYNF441cCsqwRRoscgF6Y
	 Xru9jA1Vk9ZaSuV/CeRAATsr6cU4+0b7BxCVGzZXunK2iaZv8oHeXLCbsddqxbz6QuC7h
	 qKh3Z61Ze0onMt8c7YRBN9aILDanoAibfIBj/xRJhUmvs1Lota3aMu9DDtSnCClBe5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TBcAyamh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66576606A880;
	Fri, 13 Nov 2026 15:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TBcAyamh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE451F000C4;
	Fri, 13 Nov 2026 15:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585249;
	bh=K2k2vCDUPppG7hqBsoBdN6vCAGy+I6h3Io/9bLuT1Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TBcAyamhSIR6PXGU0Mafdtdrc7jtDelgKDlnyzeZYE2Kkykax4TJ7B0iFMtCiMCd5
	 dXJk48xRbOrHoOEyGgPt8VHWPDngoE3KTTCjvDK5oEr/E2zbEorZ98CYz+Jo7DB1eo
	 0osD13qEidPoZr0kI2ASwXtwiO4Zu27ohFkp3AMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashok Raj <ashok.raj@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Ahmed Abdelfattah <me@ahmedabdelfattah.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 003/686] cxl/features: Ensure that count is set before access to ent[] __counted_by()
Date: Fri, 13 Nov 2026 10:42:16 -0500
Message-ID: <20261113153821.047069702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Ashok Raj <ashok.raj@oss.qualcomm.com>

commit c1031c2474f73261d8d5e4deef2b5dc20fb964f5 upstream.

get_supported_features() assigns entries->num_features only after the
memcpy() loop that fills entries->ent[] has already run. Since ent[]
is __counted_by(num_features), the compiler's bounds instrumentation
sees a 0-length array during that loop and FORTIFY_SOURCE trips on
the memcpy. Set @num_features right after allocation, before any
write into ent[], so the bound is correct for the whole lifetime of
the array.

This was found via a fortify panic:

 memcpy: detected buffer overflow: 384 byte write of buffer size 0
 WARNING: lib/string_helpers.c:1035 at __fortify_report+0x54/0xa0
 kernel BUG at lib/string_helpers.c:1043!
 Call trace:
  __fortify_panic+0x10/0x18
  get_supported_features.isra.0+0x4a0/0x4d0 [cxl_core]
  devm_cxl_setup_features+0x84/0x120 [cxl_core]
  cxl_pci_probe+0x254/0x5e0 [cxl_pci]

Same class of bug, same fix shape as commit 6c9d2e87df40
("cxl/fwctl: Fix __fortify_panic"), which fixed the analogous issue
in cxlctl_get_supported_features() but missed this one.

[ dj: Fixed up title typo per Jonathan. ]

Fixes: f0e6a2329bf9 ("cxl: Add Get Supported Features command for kernel usage")
Signed-off-by: Ashok Raj <ashok.raj@oss.qualcomm.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Link: https://patch.msgid.link/20260911215304.1816467-1-ashok.raj@oss.qualcomm.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Ahmed Abdelfattah <me@ahmedabdelfattah.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/features.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/features.c b/drivers/cxl/core/features.c
index bb73f205f16cf..0ea5a31275d38 100644
--- a/drivers/cxl/core/features.c
+++ b/drivers/cxl/core/features.c
@@ -97,6 +97,7 @@ get_supported_features(struct cxl_features_state *cxlfs)
 		kvmalloc(struct_size(entries, ent, count), GFP_KERNEL);
 	if (!entries)
 		return NULL;
+	entries->num_features = count;
 
 	struct cxl_mbox_get_sup_feats_out *mbox_out __free(kvfree) =
 		kvmalloc(cxl_mbox->payload_size, GFP_KERNEL);
@@ -174,7 +175,6 @@ get_supported_features(struct cxl_features_state *cxlfs)
 		start += num_entries;
 	} while (remain_feats);
 
-	entries->num_features = count;
 	entries->num_user_features = user_feats;
 
 	return no_free_ptr(entries);
-- 
2.53.0



