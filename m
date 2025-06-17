Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4E31FBEA8;
	Tue, 17 Jun 2025 16:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177730; cv=none; b=m2L/YhPNaFWyVWLJvZasV8vM4p3B40qXksPss4k9HXliNUjESY5A1eMNio8Fb7qySW4w3N2N1mJMeocuC4eEWI3sWO1dE5g3HKUDLan1zskdreca2KmkIgmkbsPKzAgvVk/ZRR1ECAazy4oE/R4eL1ccOrPZtNhywF18pIE27ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177730; c=relaxed/simple;
	bh=P8I1eLoCjC200O2C3vTY9lfWN43iZIVarnmwd16DhTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0Tt25qFTGRFpRVFPqNM+r73dbU8VxVomHHOYZxTbYkqbQBZ+mFwCt/nk15T0UHMXW9AgIcOkSHr+f/vja5IO9vKCdZz7ApY7Wmxio+SXv0ncrAa+TAVngqV+IAYsPtLV4633qERwVd8tNoE08RkmzK4onthqbxeVSSDGj2x9gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2R8g7g6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2R8g7g6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055C3C4CEE3;
	Tue, 17 Jun 2025 16:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177730;
	bh=P8I1eLoCjC200O2C3vTY9lfWN43iZIVarnmwd16DhTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2R8g7g6ArnWYT79B9ylouYFhutqw8JvKtTK1rfG1t02fMZ9i00iyi9fC1dRPCsH4
	 ThajVwgjLuOFmXPfwhM8weVJABjiKIEgxA0SNAhOMFh1gCeU9T7YHYEJ4nI7CQkmKt
	 Urs5dlRJVSJDON4SlCU433dLLnFH5llIcF1/XRpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dzmitry Sankouski <dsankouski@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 352/780] arm64: dts: qcom: sdm845-starqltechn: remove excess reserved gpios
Date: Tue, 17 Jun 2025 17:21:00 +0200
Message-ID: <20250617152505.793861285@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dzmitry Sankouski <dsankouski@gmail.com>

[ Upstream commit fb5fce873b952f8b1c5f7edcabcc8611ef45ea7a ]

Starqltechn has 2 reserved gpio ranges <27 4>, <85 4>.
<27 4> is spi for eSE(embedded Secure Element).
<85 4> is spi for fingerprint.

Remove excess reserved gpio regions.

Fixes: d711b22eee55 ("arm64: dts: qcom: starqltechn: add initial device tree for starqltechn")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Dzmitry Sankouski <dsankouski@gmail.com>
Link: https://lore.kernel.org/r/20250225-starqltechn_integration_upstream-v9-5-a5d80375cb66@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
index 8a0d63bd594b3..5948b401165ce 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
@@ -418,7 +418,8 @@
 };
 
 &tlmm {
-	gpio-reserved-ranges = <0 4>, <27 4>, <81 4>, <85 4>;
+	gpio-reserved-ranges = <27 4>, /* SPI (eSE - embedded Secure Element) */
+			       <85 4>; /* SPI (fingerprint reader) */
 
 	sdc2_clk_state: sdc2-clk-state {
 		pins = "sdc2_clk";
-- 
2.39.5



