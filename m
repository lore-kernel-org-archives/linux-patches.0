Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015560;
	b=4LnRAsgQik0WuPlV/QcF24t3oiNrkUBeWeitEDV8M9S+N80yHK+JZSHSV3Y11j2Hwn4h
	 pMZb/7912U3HV4BQFMQOaS8yIzV9JFRDm1XIDRZmnPKYhNYcnw5RPd/45ZwtAXbTXESxC
	 7QBM/eVWnLaPR0Ja9NtQMwemSRJxXED/BhCUebPYpryfUsJGcG8XTYaJ9qqyovdTWzw8E
	 6rbMa+FoE5ReWkk3sCn65zRLMDlWF8h9NqP6YNAgVKHzOWg2hjf/TLlsqWA4bRmJ+G6BA
	 jgDO8eZi4m+f3ViCZq7KQMlbr3FuEq1eFC5V6upGKfv48gWQG6m54MAyhSlcIH4Lywg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5nQ65VLmK4nuJvdCgG+rILZTWK9le7JgadEyMRVu9eo=;
	b=Hvrk5KSgNSjMCTFA0+G+uR+c51nOlfmidVtVJVqOfl3VQ7o3/X2AT5AXWZpr4rH+Hzsu
	 C88Jn+zeJ2yZOX2hFWNdFOTs+1Tkbo1cbvogLlWkZC0X4TVQbASNVr6U1s1khLOum2bXa
	 B7/oVVfQqnWE+mHONGtNNJATWbfLzu4aTWaCGcYfOej86Ejpyb1c90d+he9VtdjXSK6vR
	 AE1hwYt8ilxLjj9BS59rMnmGu1HiLB/cl3jMqzEEgSAm8Qas+fsmwU3uVitAHk2pjtUXc
	 85jlO2MV6wMfk3yHu+qng64O0pv5nahRSCBaaxwLiOJT0yT+sKahGG4ha0dEvFR/SUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fSfO+C0w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB18606A330;
	Wed, 18 Nov 2026 15:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fSfO+C0w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6250F1F000C7;
	Wed, 18 Nov 2026 15:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015559;
	bh=5nQ65VLmK4nuJvdCgG+rILZTWK9le7JgadEyMRVu9eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fSfO+C0w7a5se0ooziEvnFGQIYBmyDwtT7ofcgXRqDB0oQ+Se7apmdZWeFxmtSfAe
	 xc6YlG8GSNFQFZumEtQMqtnr1PoOhlFouA2GDHO+UbJplN2y6DvMu1cA8BPtkpIAvD
	 CWcTOaxKrwGE9I/NG2bPO2hiNYATMQ99YfbDJd+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0218/2651] memory: brcmstb_dpfe: validate firmware section sizes
Date: Wed, 18 Nov 2026 15:24:18 +0100
Message-ID: <20261118150255.717406373@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit e61c1a1103e2617e8f86288368911a8591e35c1e ]

The firmware header is read before the image has been shown to contain a
complete header. In addition, the final size check adds two
firmware-provided u32 section lengths before comparing the result with
fw->size, so the addition can wrap.

Reject images shorter than the fixed header and checksum before reading
the header. Then derive the available payload length with subtraction and
require the two declared sections to fill it exactly.

Fixes: 2f330caff577 ("memory: brcmstb: Add driver for DPFE")
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260815134559.47888-1-pengpeng@iscas.ac.cn
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/brcmstb_dpfe.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/memory/brcmstb_dpfe.c b/drivers/memory/brcmstb_dpfe.c
index 7b02c36c7fca7..04ae3cfb449e4 100644
--- a/drivers/memory/brcmstb_dpfe.c
+++ b/drivers/memory/brcmstb_dpfe.c
@@ -533,9 +533,15 @@ static int __verify_firmware(struct init_data *init,
 			     const struct firmware *fw)
 {
 	const struct dpfe_firmware_header *header = (void *)fw->data;
-	unsigned int dmem_size, imem_size, total_size;
+	unsigned int dmem_size, imem_size;
 	bool is_big_endian = false;
 	const u32 *chksum_ptr;
+	size_t payload_size;
+
+	if (fw->size < sizeof(*header) + sizeof(*chksum_ptr))
+		return ERR_INVALID_SIZE;
+
+	payload_size = fw->size - sizeof(*header) - sizeof(*chksum_ptr);
 
 	if (header->magic == DPFE_BE_MAGIC)
 		is_big_endian = true;
@@ -554,13 +560,8 @@ static int __verify_firmware(struct init_data *init,
 	if ((dmem_size % sizeof(u32)) != 0 || (imem_size % sizeof(u32)) != 0)
 		return ERR_INVALID_SIZE;
 
-	/*
-	 * The header + the data section + the instruction section + the
-	 * checksum must be equal to the total firmware size.
-	 */
-	total_size = dmem_size + imem_size + sizeof(*header) +
-		sizeof(*chksum_ptr);
-	if (total_size != fw->size)
+	/* The data and instruction sections must fill the payload exactly. */
+	if (dmem_size > payload_size || imem_size != payload_size - dmem_size)
 		return ERR_INVALID_SIZE;
 
 	/* The checksum comes at the very end. */
-- 
2.53.0



