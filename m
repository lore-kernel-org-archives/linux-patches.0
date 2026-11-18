Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029430;
	b=lKCmXeygyZF1gCejQROmrqJLNWb9cGSRN88LeTuega6txjaeXqSgBb0Q6ZomYILVigsg
	 MAAMB0iG3iNYRPPiDklg6937d5ZWcNjNNai6+7ziXAEOgph0uwGsSomZHPaWCoHYIh4yW
	 rHRNPB/Rkc0zRg19QZSF1Byobatfft+Ammq8t+Hp/wJvkSNxou7RxPhgpFTjIYvfYZpdB
	 ijCdoqY+l9sT2DTI+AM6XoIN6mZXx6McYm93B45sIWfEEuBFq9xAGNDsSKU9NIJFZk0yA
	 5M3iJpRybE76tMWbhdfSmi98FaHiXvLi2BBsAUpcKmhyhije+HzArGNY7E7rZaZUW1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YhXc0aCvRg/ScLco7jYtGrpSAfboj27XL6N4H9VpkEU=;
	b=h7xxv1sc+OTUV6dxMy0nXzSW1MHeTCJBCXoJwrnOvMbi6OUm6rHzkzjnV7ib6oC0qP4d
	 ZpfLr9rT47yM5MkKEQsuvLrDCSCej3jWnNYFVcbTHFWc21cFYjzKYDZ0Z0bkmYB9giA04
	 vQDAblSIRNWuAa4KHnc9y5Fha2fNTzLdot75PeK1G/vYm2LSrH9r3a6ZmVTo3UNqeiwHJ
	 sNoj/iiqvOAvcMdQGxR2tGHqNFDMAgGQCja/g0awvJo5V0m2EUm35T0FUg7qMah2tFOoN
	 t9IvJCHPP/YBXfjjLE26vavSslIwYw1fzwW3gGcX6BGDwCf2e56qr+eqWYvoLyhFYxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PcVuwB8A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D847606A31C;
	Wed, 18 Nov 2026 19:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PcVuwB8A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D8E1F000C4;
	Wed, 18 Nov 2026 19:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029430;
	bh=YhXc0aCvRg/ScLco7jYtGrpSAfboj27XL6N4H9VpkEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PcVuwB8ALngTXUjU1BC1NjD3otqv987Fi092LnCNGd/dTHbndwAxfA+t+Jdhcz87G
	 ljlK40ZnP5e1d5yJu5zoNybYAcNw69VaumESAtxbgen/Cc733N4/KTHYjDosDJDRkV
	 OSeMbK9VYcjSI/kxfuR4AzpHOA/dnPBLmuzBu+ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0347/1756] regulator: ab8500: Treat cut 1.0 VAUX3 as fixed
Date: Wed, 18 Nov 2026 15:41:14 +0100
Message-ID: <20261118150022.194873795@linuxfoundation.org>
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



