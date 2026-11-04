Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829488;
	b=no6/rKKyBuPj1QO+kwgRxIVGi9z4UjsW7PsOE2lxVCnejgw4TFpBKXRPHquQgpNQQinw
	 dYIUv1FmjkpMqy3KHqEEcKgi7oqYWSAgx/24Q5pk63IXFRn5L7t+9eyEFTm2UTWEV+Cyj
	 3xCH8sCe5U08MvhA+vR23XQ7GlrvTm5WBFCske3fqrA1ZRCojuDgJJPDKDLHuseL/I6Rs
	 Z6MkEuHnROaMRrcnZAaKWaciwqc3+y6Ou5jjC3//PzCZ2uYKWklkhWfTN7EAU/9CyGiCT
	 nBsVE+gMfvZ3dop5h/mdPQqyVm4vXlMpoKn5uDXCqEzBADbegL9Xt1N3UrHdBH+0A9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T9D7wm7Y69E9pFXBhM9oAM7VLc0YoO01GW5dTtDgHI0=;
	b=XGcc1wLSrcyZ9YviJg5S+gdr+FfC4p6semrNIHMQXOTf74uJQJ3wYzBWG2mSawquDbuk
	 NF7B1xQpTEU3Q2vv0vF7vp4yFR0trbORufTHX7sT9K/TbviA/QKjVN4RtNPrborGpxZUL
	 W9aUlUfFMi5BGy7l3fyrVHgWAkPUHm/zHHVuBLh9UFDwPYQSn2zBk6yILGSopaHJUBWlM
	 4UEoGopgcZ3t21A4l27Qgq1DJaAxuTNSC4lhEnGb1Qy23viQ2sdhqbGJugA0PbJoe49eN
	 85CuIyx3D/8KnAGc0PlIsvPvVK6V2puy8luJrtafjF5om2kSrN4t1urNAPxAHb/S85A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gqnwALyY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCB66082BE9;
	Wed,  4 Nov 2026 21:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gqnwALyY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D30A1F000C1;
	Wed,  4 Nov 2026 21:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829487;
	bh=T9D7wm7Y69E9pFXBhM9oAM7VLc0YoO01GW5dTtDgHI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gqnwALyYAg035++WFm63dg8DI+kJqUrm8hS1bNmtKDxw16KzJeayHbNarNytXC4e4
	 CcaebXDzD3SEhV+RoJDK+OPt55apVFPw1FBfLBtYxgcAlws1n6FcIZr3lBNOGrybzx
	 IHNEJaypnoZOoZDvTFPpHUfkhmxpzdAh3dWxtcwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0156/1005] wifi: iwlwifi: validate PNVM SKU TLV length
Date: Wed,  4 Nov 2026 15:58:09 -0500
Message-ID: <20261104211048.126060238@linuxfoundation.org>
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

[ Upstream commit 7410e4548a17bd868dfc60b48f2e78eacde3ad78 ]

iwl_pnvm_parse() reads an iwl_sku_id from an
IWL_UCODE_TLV_PNVM_SKU payload after only checking that the generic TLV
payload is present.

A short type-specific payload can therefore make the three data[] reads
extend beyond the TLV. Reject SKU TLVs shorter than the structure before
accessing it.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260715135916.24417-1-pengpeng@iscas.ac.cn
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
index 5de3a9c0b3ef0..f623f1b679367 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
@@ -205,6 +205,12 @@ static int iwl_pnvm_parse(struct iwl_trans *trans, const u8 *data,
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



