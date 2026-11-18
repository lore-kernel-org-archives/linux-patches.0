Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019909;
	b=fSaU1PORWBnTeMyRYotqDm5GmWJ0NG7P7/NZ7T/C0U7FNFD26iayJDycDbMoPMMinB9Y
	 z+pkpWj9IDbyxWh5+tFUi9yTaH4E5RC3rLPK7XplsZSzVoO/PvbNL4XgYJPf/rDVs/z32
	 gRuHixwBl+soKxOVURDisQOxnJB+Pc+6a7vKGpPEHq5tBe2GU55RCsN6Tizcf8B2uqOGw
	 erxGANpq8MgTOufyQaEKnwIbwZ1jzuBY/y4J2psgN4VZiCep4nVVTnBLjb7dOCEJhlZ4O
	 hwUNwZVEtGg8yvide1Hk58sLJIDJPlyRr6ptUZshMggv04oLS7JPWlCv18Nkc4OuU3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IdkXVRqMqVcH2YCp56GEICkiUaq8wU8t/le/3QO8hjY=;
	b=xOrVzS0lJTShs1I/kKZWDPSfFZrxTZW0GAxWhcW7opYBxULVbpnRoQ8oa73KVdBAjRFS
	 UPdPD7s/i4miLSVlxAPFgqOmKzcZyiU2RDuINV5MHSJC8RFUegrJyiRfX7bhdaYGFvcaW
	 a1DorPyOaHvyVOLYB0XW3ylKwsXeREsU4JpxLG8roun3rLBNqBVjkCQ78KGO9rRTX4wDt
	 QSUnXLQz8Bcdh8z0YuR67hetqZWJQPiM7hAgr+d9SGihqnYHjHP6WD6SQgNvgtEv1Fmuv
	 NZRyUOW1B5AqAhg86YxEnhIhgot4cFx+3NP5YLSVZbIav3UC9xeCtMzqB/Q0SIP1CYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TByqeLYM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712CF606A332;
	Wed, 18 Nov 2026 16:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TByqeLYM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FB51F000C5;
	Wed, 18 Nov 2026 16:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019909;
	bh=IdkXVRqMqVcH2YCp56GEICkiUaq8wU8t/le/3QO8hjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TByqeLYMwkGA1u387VJytUCDMKWWIf01WEA+vgucRFE4Rud5NarOPnJypDXvtOXWU
	 prZgJWMdLijDcev/FJVW6on4WqgLdqUBi1k5KsSmsmCt/uEF7xEf/zqOc2r7N2PXK6
	 4r91YeG5uT9nkSzwyk9FR+9xFLJjdcJwkYGtKD0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1746/2651] clk: qcom: gcc-ipq5424: Fix TME reset register offsets
Date: Wed, 18 Nov 2026 15:49:46 +0100
Message-ID: <20261118150350.394430245@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 3732dccb8d75b2cddc8857f3944cb7482ef4b46a ]

The GCC_TME_BCR and GCC_TME_SEC_BUS_BCR offsets exceed the regmap maximum
of 0x3f024. Regmap therefore rejects accesses to both registers, leaving
the resets ineffective while the reset operations report success.

The offsets appear to contain typographical errors. Use 0x10000 for
GCC_TME_BCR, matching the offset used on IPQ9574 and the surrounding
register layout. Use 0x1a030 for GCC_TME_SEC_BUS_BCR, placing it in the
same register block as GCC_SEC_CTRL_BCR at 0x1a000.

Fixes: 21b5d5a4a311 ("clk: qcom: add Global Clock controller (GCC) driver for IPQ5424 SoC")
Assisted-by: LLM
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916-clk-qcom-gcc-ipq5424-fix-tme-bcrs-offsets-v1-1-0fa10674908a@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5424.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-ipq5424.c b/drivers/clk/qcom/gcc-ipq5424.c
index 3ddd4b3aedea9..32243e110b279 100644
--- a/drivers/clk/qcom/gcc-ipq5424.c
+++ b/drivers/clk/qcom/gcc-ipq5424.c
@@ -2949,7 +2949,7 @@ static const struct qcom_reset_map gcc_ipq5424_resets[] = {
 	[GCC_QUPV3_SPI0_BCR] = { 0x04000, 0 },
 	[GCC_QUPV3_SPI1_BCR] = { 0x05000, 0 },
 	[GCC_IMEM_BCR] = { 0x0e000, 0 },
-	[GCC_TME_BCR] = { 0x100000, 0 },
+	[GCC_TME_BCR] = { 0x10000, 0 },
 	[GCC_DDRSS_BCR] = { 0x11000, 0 },
 	[GCC_PRNG_BCR] = { 0x13020, 0 },
 	[GCC_BOOT_ROM_BCR] = { 0x13028, 0 },
@@ -2960,7 +2960,7 @@ static const struct qcom_reset_map gcc_ipq5424_resets[] = {
 	[GCC_UNIPHY2_BCR] = { 0x17064, 0 },
 	[GCC_WCSS_BCR] = { 0x18004, 0 },
 	[GCC_SEC_CTRL_BCR] = { 0x1a000, 0 },
-	[GCC_TME_SEC_BUS_BCR] = { 0xa1030, 0 },
+	[GCC_TME_SEC_BUS_BCR] = { 0x1a030, 0 },
 	[GCC_ADSS_BCR] = { 0x1c000, 0 },
 	[GCC_LPASS_BCR] = { 0x27000, 0 },
 	[GCC_PCIE0_BCR] = { 0x28000, 0 },
-- 
2.53.0



