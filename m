Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060507;
	b=wkvzviq3lybYr2BIN/AE3B43oeDD/D1/SeBhXy5JFaD+ozCaHQ7toVcraiZlcRSM9blW
	 /YHhytN/t1613KA6/k9Lxt4qeZhIBhKqcOTzeXuv5IXWO2ywcv5jhatkvv1eM4H+uZasD
	 Bcll0WFHB/VZyT2u9EbT6BgnQ0xtZWsz09ouDcIggp7sc1lBfdrUlqsZrITs5HJM/rKbA
	 zfSrfC+7LqurGW6t+o5ctI/rLBIyp8WHvC1ROkALSKcV/2h+zxw5F5SzLk/2B80J9l5Kw
	 kitDwYLYcgOuBueQP31H1dO9Q6elDZpdginRno3wx7b9CTR9o54WkHk079OZeeV96RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3b6//8DIuEKiwqAG4XCijOguCsoeEhHaEQp21lxlemk=;
	b=wUHisNSigRRszdKxugQm4cNeKsvDkGDvpC7EfcPnE6JQvAHhBvfO6qWXoD7kPypjjdCc
	 cOy2yQdsX05Ubrs3thMmAkE5LZZiqr+tbrTX9ZXXN9o9H4mgARj39QFt6kUCNg1v60LvO
	 E+d2yeOxSfhypaZN1vmuQzuM28GnDL7dEOFRPdm2yTAN+Uod9MXiqimnIESYQf6enU9ws
	 e1Wfp8f6cagJ8ROsD0zh1rbm1dPWUZwqpU+QZ2qft3eXeWiMVoNwfq53VNH5Xr+2nelu1
	 9532pvwMVxESab+O3GkIOORNQnzl3JY3uPk4eIbqeaPNkgYI8d64e9f3Cquiu2xza9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ga9dz5l4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3E8606A325;
	Thu, 19 Nov 2026 03:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ga9dz5l4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BE91F000C4;
	Thu, 19 Nov 2026 03:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060506;
	bh=3b6//8DIuEKiwqAG4XCijOguCsoeEhHaEQp21lxlemk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ga9dz5l4mmyiuzSbrvLvnbtTsqY8ljWPkXswbQKsldvaXZV8g4ZvEdEfIH3HChQVq
	 9hMcjxli4x9RlphCU5EnxtZdq9P1kVWx6bbO+E5eCi+lBxNDxf2keFRQj2QkGzl46i
	 FYNyZOKm54ntts86zOVbqLSd2RiuOXHsksbEb+w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1223/1848] regulator: ab8500: Treat cut 1.0 VAUX3 as fixed
Date: Wed, 18 Nov 2026 15:54:21 +0100
Message-ID: <20261118150011.135285444@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit b9fc8a8d31b914b09329240f532ff0e9c00cd727 ]

The early-cut workaround currently gives AB8500 cut 1.0 the 16
programmable VAUX3 settings introduced with cut 1.1. On cut 1.0 the
selector is not programmable and VAUX3 is fixed at 1.2 V.

Register VAUX3 as a fixed-voltage regulator on cut 1.0 and retain the
16-value workaround only for cut 1.1.

Reference: AB8500 User Manual, UM0836 Rev 3, p. 240

Fixes: 2b75151a1041 ("regulators: Added ab8500 v2 support")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260901-ux500-dts-snowball-regulator-v2-4-fe88b01829bf@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/ab8500.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 147456e526fed..ba39ff87339cd 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -1669,9 +1669,14 @@ static int ab8500_regulator_register(struct platform_device *pdev,
 	config.driver_data = info;
 	config.of_node = np;
 
-	/* fix for hardware before ab8500v2.0 */
-	if (is_ab8500_1p1_or_earlier(ab8500)) {
-		if (info->desc.id == AB8500_LDO_AUX3) {
+	/* Handle the different VAUX3 implementations in early AB8500 cuts. */
+	if (info->desc.id == AB8500_LDO_AUX3) {
+		if (is_ab8500_1p0_or_earlier(ab8500)) {
+			info->desc.ops = &ab8500_regulator_mode_ops;
+			info->desc.n_voltages = 1;
+			info->desc.volt_table = fixed_1200000_voltage;
+			info->voltage_mask = 0;
+		} else if (is_ab8500_1p1_or_earlier(ab8500)) {
 			info->desc.n_voltages =
 				ARRAY_SIZE(ldo_vauxn_voltages);
 			info->desc.volt_table = ldo_vauxn_voltages;
-- 
2.53.0



