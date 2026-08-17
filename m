Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7F343BDB8;
	Mon, 17 Aug 2026 13:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973877; cv=none; b=lcnQU0cU4PhE1CU0UR79q3Ita/sotRx8nyM43sAUFiZ+FhnpZxYS0Da+/khhuWNRLW3dVZJY3SrAxjdi9Dk7nCrDnN2SoOneKkyahLBW3NDQfgOtNrveND9HEF09xTfuASkSj9FUlGep26tvYNGY7Up9upoWA8liWeYXKePrEso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973877; c=relaxed/simple;
	bh=BwFKWp6XSPpQSxUPoawMHMwHbGyfhXwZZZ8jfrdZe5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k21PMdkmbrbvOPRJDN/r7ujx7MQP4oxx/79a75tIrd/cTs+9mrNeAe/L7hVtGSUks0uIL9EC3ZG9gWtvjdZBY0cRCSP3UYYtB4/sEk61erxQOFss3n8pVhgXUSXxo0ruXras3CvbZd59531tVjgZx2i9Y8YBOWSvR+kJ5MSMQqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HYpQ+5yY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HYpQ+5yY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F60D1F000E9;
	Mon, 17 Aug 2026 13:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973871;
	bh=LelVAeNcInxBN0hrs6Y7nwnVzwppxydWLkOt4o9uKOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HYpQ+5yYB7nq8cHkhWjkHFNdni9i/buWL2HBoHZd9y73jOtUgeZXWWH4PF/CosURO
	 J/JFX3bIZpvVOOnQWhGO+QTzKwo4eIzFUR2Zl7vn2WNrl+uSLBQfulJmWwrzhzYKde
	 6/9THFjtt0n8Y1XtEAPll5bzUntVg1nl+x7wD8vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Koskovich <akoskovich@pm.me>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 011/271] arm64: dts: qcom: sm8650: Fix IPA IMEM slice
Date: Mon, 17 Aug 2026 15:28:56 +0200
Message-ID: <20260817132537.225627187@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Koskovich <akoskovich@pm.me>

[ Upstream commit 41d237b1546af5d5cf877175930cd23163422c83 ]

Downstream the IPA IMEM slice for SM8650 is described as:
qcom,additional-mapping = <0x14683000 0x14683000 0x2000>;

Update upstream ipa_modem_tables to reflect downstream.

Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
Fixes: 581fc5d5ade6 ("arm64: dts: qcom: sm8650: Explicitly describe the IPA IMEM slice")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260415-fix-8650-ipa-modem-tables-v1-1-95f8f425e416@pm.me
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index e2d98cf6adca8..ecfa3478cbdde 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -7091,8 +7091,8 @@ sram@14680000 {
 
 			ranges = <0 0 0x14680000 0x2c000>;
 
-			ipa_modem_tables: modem-tables@8000 {
-				reg = <0x8000 0x2000>;
+			ipa_modem_tables: modem-tables@3000 {
+				reg = <0x3000 0x2000>;
 			};
 		};
 
-- 
2.53.0



