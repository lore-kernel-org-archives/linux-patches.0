Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015845;
	b=AV/QFt/KiFawEiEzgLu5vbrO5h7xlOB3fYfCsETqqrLgPU/Bb1VNbSzpgCBZrqVX02YA
	 93NPV7UOOoEhTgTgi+CxjFftIZzmX9gVnQc2i7x6oMXFpaqjQaGkFf9YiISGtWJbnKoF5
	 ehEePuOHCLR/MwVuxW/H41wF0YM7J+aYBq40HV6aCBMI4ejMR8ShMLSfOHveAjAMCKzYR
	 4USTAaR+NL6fORD6Rbd9hh0ehxWRjCnr+z9KpSm8K0RAN8caxEFUuTO+pFQyVodwVikHH
	 GDaQvJoBVOjuIW+VRheU0g2GzGE0webXYen4g9Ilkfr8pRhcRwx53BWeidpA6RrbTiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015845;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6AcoZhOV4gBlquMWzDiWBhiQgMyv9N0T1ExEPJLbUwE=;
	b=TrKT7KLh7+ttlqfDm+SiT7bEUSQMr6qx8G+zj+i4PM/aF4nzh7ztf1yNkHKi1vRkhOgI
	 1XaG9OJBP0BWqJIWYjcLzjiM+bnGXpI61KU44NTaLbVsyw5qgN8BZH6ldty3hqn1IPbEJ
	 SrQrW3Og+PsurmBAgLFSMJTVUpaKMJ9dSu9JywaXpkTMxwtLidutFDKk8PCVFs0m/L4Wp
	 VZamQIz8dogXJW/O0OD65P8VmOnvhzIhy+FfAqsBY2nqEQ0aR0yM/DUbS0dqgb4gBR2nL
	 E2fseBwLJKXGwoParIsGwXqrhZmZcPmvwFKMvVC2/QAUnAts9Iy3oaoAlzZIZ2HgfhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HloXd6Uy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494C9606A337;
	Wed, 18 Nov 2026 15:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HloXd6Uy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB231F000C4;
	Wed, 18 Nov 2026 15:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015845;
	bh=6AcoZhOV4gBlquMWzDiWBhiQgMyv9N0T1ExEPJLbUwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HloXd6UyX1F7SnJ+S39cWKdlnRJyf/bfvbBZZ4el5OzYulL7TJt95R6fEU+B2gtuV
	 adEnlKV9hNg5mQ0Tpr9XDFzd6f0nrSl15KXnYKfaoJqIRbx+bZrZW8et69lYGRI6xN
	 yLzkpP8nbljcIO5xG/8iu5QqVj+U4HbUnVzF/LgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0318/2651] wifi: ath12k: fix truncated TX buffer DMA address in MSDU ext descriptor
Date: Wed, 18 Nov 2026 15:25:58 +0100
Message-ID: <20261118150259.327064389@linuxfoundation.org>
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

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit 979ecb88ed3528e08dd7f87b90b029374226ca84 ]

ath12k_wifi7_hal_tx_cmd_ext_desc_setup() programs the low 32 bits of the
TX buffer physical address into HAL_TX_MSDU_EXT_INFO0_BUF_PTR_LO but
hardcodes the high bits field HAL_TX_MSDU_EXT_INFO1_BUF_PTR_HI to 0x0.

dma_addr_t is 64-bit on platforms with CONFIG_ARCH_DMA_ADDR_T_64BIT, so
whenever a TX buffer is mapped above the 4 GB boundary the upper bits of
paddr are dropped and the firmware is handed a truncated address,
leading to potential TX failures.

Write the upper bits of paddr into BUF_PTR_HI to fix this issue.

Issue found during code review, compile tested only.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260818-ath12k-truncated-tx-dma-addr-v1-1-ead978969371@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index 02f509935fff6..3f6df96de160e 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -63,7 +63,7 @@ ath12k_wifi7_hal_tx_cmd_ext_desc_setup(struct ath12k_base *ab,
 {
 	tcl_ext_cmd->info0 = le32_encode_bits(ti->paddr,
 					      HAL_TX_MSDU_EXT_INFO0_BUF_PTR_LO);
-	tcl_ext_cmd->info1 = le32_encode_bits(0x0,
+	tcl_ext_cmd->info1 = le32_encode_bits((u64)ti->paddr >> HAL_ADDR_MSB_REG_SHIFT,
 					      HAL_TX_MSDU_EXT_INFO1_BUF_PTR_HI) |
 			       le32_encode_bits(ti->data_len,
 						HAL_TX_MSDU_EXT_INFO1_BUF_LEN);
-- 
2.53.0



