Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015303;
	b=FhS5nSU6n6sUBe/zD+BpMbeDNbBgdGW5MD964KEzQd+7Q4G/meobdMByzoxn7eANvb6n
	 bS3LmVwnv7JHAEnHVx1jtJmhU0L/D3we599rDMLa9BkSpyOSElFJn5mNZn1ljWitPrHyl
	 lFhUlYUK7+8j/x7v2e1QoTl1vrm1ylQF3nrW+dRioJNzXZGw54iDBNSdqREFU+peTxyg+
	 V/oA2rYrt07rq3hEycuEDG0emUAOU99aGTLAKWiZTYViJYrAnkR8sYPvj/dev2N9mSx8P
	 /7Ucy88oDKc7HmaKmKeLJNuBgipzdN5giXU5clj0CSBtdOTA+X0G1S+TkUClHiljpuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G5qMNz1OYzhCBiT9orKkBl3+GhXcns8uHZK9OBLjLeo=;
	b=OOKDPXnPFN9Kiu5SynEEp4iB16bv6/qkueSy5QZPwt9ynppEV7rnVZ4xpykljy9OoR4Q
	 j1YUOKh1V3d6VMPV0ItF6er+NMVyTFToa4bmp8Ymc1UWedPcQo6g04gT0BoAKEhHuq55C
	 zrkElfnakZXteYJaM2E+BXYklWJ1/p7255IYrLdji0JAAnNuHXqi5+l0znNtLHC/GN/O+
	 twNaKPyYUBrOeLHW2nkboSxqmBLpeFkcg2KaUpqi/sf+v1pmntMH4pwGAsNuxbSynO6Tq
	 G7xYymLvILHkiiOW/P1ghzM1nPaCFGt0DjXUt/k8DbWGndkNR1U+PqOlmW6uxdlMazA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uZ3NEkz5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505FB606A31C;
	Wed, 18 Nov 2026 15:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uZ3NEkz5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F631F000C5;
	Wed, 18 Nov 2026 15:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015303;
	bh=G5qMNz1OYzhCBiT9orKkBl3+GhXcns8uHZK9OBLjLeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uZ3NEkz5karsJtCKnaoklnQW6ktgJ+/ep6jzQkqmORC1diVM9n3vaWruTKIyFNVsc
	 jbJdGM5EWOh7Lfudxdc7vq5LoEufRXkbOQG7XhlD5SDMVbcnrcbm9Qo9BSa9BI44iB
	 377jBKmSMU79FBQdsobMueeuIfqKm1RBvQCN6UUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0126/2651] soc: qcom: smem: Fix byte order in v3 14-frequency parser
Date: Wed, 18 Nov 2026 15:22:46 +0100
Message-ID: <20261118150252.395789210@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 9f3136c0c5bcb26d5c864f8a5658c1a6f449d351 ]

smem_dram_parse_v3_14freqs_data() uses the little-endian
freq_khz field directly when scaling the frequency from kHz to Hz. This
produces byte-swapped values on big-endian systems.

Convert freq_khz to CPU byte order before using it, as the other DDR
data parsers do.

Fixes: 1d234eeafc56 ("soc: qcom: smem: Expose DDR data from SMEM")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260827020447.2642830-1-lilinmao@kylinos.cn
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/smem_dramc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/qcom/smem_dramc.c b/drivers/soc/qcom/smem_dramc.c
index 9612230a03bef..cba5376ec80d3 100644
--- a/drivers/soc/qcom/smem_dramc.c
+++ b/drivers/soc/qcom/smem_dramc.c
@@ -231,8 +231,11 @@ static void smem_dram_parse_v3_14freqs_data(struct smem_dram *dram, void *data)
 	for (int i = 0; i < MAX_DDR_FREQ_NUM_V3 + 1; i++) {
 		struct ddr_freq_table *freq_entry = &details->ddr_freq_tbl.ddr_freq[i];
 
-		if (freq_entry->freq_khz && freq_entry->enabled)
-			dram->frequencies[dram->num_frequencies++] = 1000UL * freq_entry->freq_khz;
+		if (freq_entry->freq_khz && freq_entry->enabled) {
+			u32 freq_khz = le32_to_cpu(freq_entry->freq_khz);
+
+			dram->frequencies[dram->num_frequencies++] = 1000UL * freq_khz;
+		}
 	}
 }
 
-- 
2.53.0



