Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829491;
	b=ND1IUSPzufZtCqkuHK7nT5AYV5g6XvI5VK6EoGU/sZEONZtT19XNcrHsPooHJtiMMZPs
	 bcoaCHWrb/zF2Fqd45CgtUbWi2BwwF0kPwEZ1es/rxH/o+z4CksRq8RawShVH89BSLFvl
	 hV0NpBhJXv9FXW5mXMl+HhxnsdgC3ZsYHHceX/eBbzZ0eysaWMDPtiineTR3jenbM5J4Z
	 s9JpGwUHFE6eh27TYdHZMWcnOFzncRC53UkKiMK12lVKM64qrNEk7Kb57tQ7Wgm8S4hYf
	 hPBM4MSKXSH3kaFhpadraY0Pp952H3MRF3YUz5Wq6jIeoYTIx2KmD8riiVGcQNCp2pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TUPXf0tZKs0ITb5pl1iI8vp3gho98qxc53p7Cxp+cdQ=;
	b=r06m8H8P9GtCS1H6Pfvby1cXG/aqeg5uwoPCz/UGXOfAJRRpD86o7yOi2oM9be1EzQ+N
	 GKRPRkqX26Q5gJVT3DrjPr8kWw/oJ6K33odaBYs5uQ2F0ecwY4cSyilN/ecLRMbykkwwQ
	 3e2VjMTyuhHipeMhYf2Ne2Uu4Edq5iiESEO3pS5XDfEk1Oq0r2SBT48cidMEw6zBFHm2/
	 elZtjoEOUA7oUxE0t6R+x7u7qAmqJVzexesJyQWDdzrfzW/VXCVZksDhz7t0uxI8Dm+DS
	 4rwi9gjW7sK5bWE4uemGYCi2CAaAi+feRRY5wD/W4g7HksmOvDH8mNx0boJ1zR0+EQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E05T+Fo6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E978D606AB25;
	Wed,  4 Nov 2026 21:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E05T+Fo6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E4C1F000C1;
	Wed,  4 Nov 2026 21:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829490;
	bh=TUPXf0tZKs0ITb5pl1iI8vp3gho98qxc53p7Cxp+cdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E05T+Fo6AXQLkWymsOZ3HWlr3ZGXgpy2jG88m8XSAZUjKWnOpcYyuVr4brbOfoiaw
	 HHq+aWsM/Mca1UApg/vS+2k8r49NypOpmTay/6QM4p9GihN0+PIOZbjJT22hn86cKe
	 fRbBPD8dFRohF7Et1+C82L0EbnC1uvMlGVeEAL2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0158/1005] wifi: iwlwifi: validate UEFI reduced-power SKU TLV length
Date: Wed,  4 Nov 2026 15:58:11 -0500
Message-ID: <20261104211048.180850019@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit f051995c539582b05276abda4c5874fd4cafd2a5 ]

iwl_uefi_reduce_power_parse() reads an iwl_sku_id from an
IWL_UCODE_TLV_PNVM_SKU payload after only checking that the generic TLV
payload is present.

A short type-specific payload can therefore make the three data[] reads
extend beyond the TLV. Reject SKU TLVs shorter than the structure before
accessing it.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260715135916.24417-2-pengpeng@iscas.ac.cn
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
index 4ae4d215e633e..395973c3f2bf8 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
@@ -248,6 +248,12 @@ int iwl_uefi_reduce_power_parse(struct iwl_trans *trans,
 			IWL_DEBUG_FW(trans,
 				     "Got IWL_UCODE_TLV_PNVM_SKU len %d\n",
 				     tlv_len);
+			if (tlv_len < sizeof(*tlv_sku_id)) {
+				IWL_ERR(trans, "invalid PNVM SKU TLV len: %u\n",
+					tlv_len);
+				return -EINVAL;
+			}
+
 			IWL_DEBUG_FW(trans, "sku_id 0x%0x 0x%0x 0x%0x\n",
 				     le32_to_cpu(tlv_sku_id->data[0]),
 				     le32_to_cpu(tlv_sku_id->data[1]),
-- 
2.53.0



