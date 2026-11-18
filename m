Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039615;
	b=BoWhCenOMsiOpVi4o53Gi+2kSMNuhh8kzcilgo0XUNknmZOyXlvxz9QQBYJR/04pAFFB
	 eBNmRDOxZumOcXyG9fH07LolRS9xkQjT213M6HYRsLnq+LzCSF/hB+3dTcyiJe4HNE69J
	 fKOatn6MCeC4YAblPEMcNWqRFANYJDCU4DzzCr3GYj1OdLbvN05ENyPqbmDjfyzL5Hu3+
	 1VMAPwptDUtzzNFRKiiKN/hMUCsKlNR+llz77h9u00eVI6+KLI4tepZOpa2vuveQALuGo
	 MBoX6vARSMbIArCZKcWT5nnnz2oVCQ/0+uLpZet9NGVkI1BdTKDDNN60g3kXGpfpmow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=131I8/GGaCYqLmAbiXAs+jrlid1YWtaET6hcMqcYGYg=;
	b=KXdjcBH9UG7Ij/aYEZtfBBl4tKQEJa/h3JMMWFlkGodojU4E7zOhG4scuogy2EVpD6pI
	 j0ciFpRniHv9itygTPKcHBd92dXZVMnQ6IWmhNE9yiNen6R1sI5ycsrKBt7LSmhcl0nFL
	 j+5JcvuQHy0dzlJQO/CnbkK4DVS6ptg/WRDMB71tlKLeAyzi0OjVLfMBFyFzoXC7XTpmu
	 OYTx/8zbhTU/xb3YpYe/eTaCruBZ5WVquqI5KeHszTztft21LfC1mTIF69So2ihWLOpAl
	 kjqHZ6nTlS7Es1bscsjJud5HUeYzsYxGoYERigR1zJ4SFzVevLZmo5dbcnbsRnVpuxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NyAacXWT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E29606A31C;
	Wed, 18 Nov 2026 22:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NyAacXWT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3CA01F000C4;
	Wed, 18 Nov 2026 22:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039615;
	bh=131I8/GGaCYqLmAbiXAs+jrlid1YWtaET6hcMqcYGYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NyAacXWTdLuoEhhS9faJntBIJHPnYIcm8ZKibTWrl9M14HtDX787Wh2e6/rJ/L8ae
	 waEKlbZNSitRsO0NLc8qx77xUs0/1Nsm9OS7NrUq4LUaGgvbvgn8HV/nY4D2MKKsrp
	 20bmUgMHx4UiSp+BbiJu68FEbZqyC5x2cQl/eMzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2164/3318] regulator: ab8500: Treat cut 1.0 VAUX3 as fixed
Date: Wed, 18 Nov 2026 15:46:26 +0100
Message-ID: <20261118150426.926837211@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5e24e6cdc7732..42cb8dfdc7c90 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -1783,9 +1783,14 @@ static int ab8500_regulator_register(struct platform_device *pdev,
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



