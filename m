Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030336;
	b=buourwGsEMuYAwQyJ/aI9teVaBiLp2vJlrXRb7WCcK3j8d7KJ7AuxiO6lEwxJN1pNtWi
	 /XUnIcGylsc8kVXwSJ4nglke91//MifzozA0OYPirUnGE27Cv/ISvhvkeQeNVUBPBESRY
	 lL9vzBNh37Rr/2RPEDVzIuhByLnLo70qlZw2JWGZwFeDaw3yzAzqA1mwWVVohVQOGBcjw
	 y+ZhUcCeJiy6VzCL78VLCEB+5DVKYu9G03fsMQQwx5e6ZDYuZWXOhxBDulKO0G1KoZXNV
	 2lmZP9Mp/moeWRVoYIO2uzEsKDSbownO4LvR00rse33Tpm62GGW6+x4OgGDstR1CrPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t0jB57yO1GXT9P2MtVp3LjTLOmyoCTcumh47iWIRvvE=;
	b=Bn/eU/W772IZxGOQLchbtCeV06X6HEawybB2MdQfFc+e1cBQ61pliThLLRFfm4evJSsZ
	 nBwOerEt7C0B0FpW6Xg/na72RnxycxhKMHCKzOe/7jHpsYWjnZo31Cky8AJZG42fgaQFI
	 hYxtUdF9XMzXXfnwSe6qj9jCfRSp5Nm1CJ+hurHdQPLT+kuZQWtyA/t95rrJxqmU3veT8
	 vt9+zMQlKH+ebr3fKgwCdDiH/BmaErcFrTDDcx4SiykJ0duyvg4oOb6yulnK+55dOBDUU
	 EozJ0iYUG8fIrV3wB57nf1HDGrDTQgCVpCjPkB1Rv4ON68anKcQ4zbcx/XIcjlO9NSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1NRZ72cP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE00606A933;
	Wed, 18 Nov 2026 19:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1NRZ72cP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16091F000C4;
	Wed, 18 Nov 2026 19:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030336;
	bh=t0jB57yO1GXT9P2MtVp3LjTLOmyoCTcumh47iWIRvvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1NRZ72cP5nVbi3l3YYI2PvBm2Dusmpz9C219VPdQmJ3FO6UNxwVI+BM8TI1qAGQIb
	 0Xu3z4zVEN8YNS9bx4CBfcbeWOd7HruNxija59lSSXYkMKIiafgSG/HFpW4PI4laWf
	 ySZypypX+npSqFr7aHY4f3PrFaYGkvf5hqzP1aco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0668/1756] soc: ti: k3-ringacc: Fix DMA ring initialization kernel-doc
Date: Wed, 18 Nov 2026 15:46:35 +0100
Message-ID: <20261118150035.789910179@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 6c4e6e8f5cf95f7e0d4f04928a9ae70e20c73d4b ]

The heading for k3_ringacc_init_data repeats struct, so kernel-doc
cannot match it to the declaration. Its three fields are also missing
descriptions.

Use the structure name and describe the firmware handle, device ID,
and total number of available rings used during DMA ring initialization.

Fixes: d782298c6f6b ("soc: ti: k3-ringacc: add AM64 DMA rings support.")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Udit Kumar <u-kumar1@ti.com>
Link: https://patch.msgid.link/20260923061658.20140-2-kmehltretter@gmail.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/soc/ti/k3-ringacc.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/soc/ti/k3-ringacc.h b/include/linux/soc/ti/k3-ringacc.h
index 2de6031b94241..7b7fc237c08f5 100644
--- a/include/linux/soc/ti/k3-ringacc.h
+++ b/include/linux/soc/ti/k3-ringacc.h
@@ -254,7 +254,10 @@ u32 k3_ringacc_get_tisci_dev_id(struct k3_ring *ring);
 struct ti_sci_handle;
 
 /**
- * struct struct k3_ringacc_init_data - Initialization data for DMA rings
+ * struct k3_ringacc_init_data - Initialization data for DMA rings
+ * @tisci: TI SCI firmware handle
+ * @tisci_dev_id: TI SCI device ID of the DMA controller
+ * @num_rings: Total number of available rings
  */
 struct k3_ringacc_init_data {
 	const struct ti_sci_handle *tisci;
-- 
2.53.0



