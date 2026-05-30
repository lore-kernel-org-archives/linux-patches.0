Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FDB3016E1;
	Sat, 30 May 2026 17:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161297; cv=none; b=k56fqrahGL2Pbs/JvCnbGhx9h01jk+Kg9eoKPwfpwWi156b9nu6ve3LPIlRejRN2P5lIjso8YkSyMvoVlTEGhWsbrMKREEwo3yOVmBkF80NEIc4swU/wAmSfEMwALOK2YPee+A9YX1XwNZV8cWKzleiOmUFwcY3Cyr7iX8s4g44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161297; c=relaxed/simple;
	bh=jsinAz6pms+yaND0v9mvb8MwHOnX1IBl2gOg6CJ5MQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQ7FDodgq0hH0Ex0v8queIWc654/J1wIkcOgV2pnNbO0cmReMHOcFG7RPZPlE0SiH3s5ZOzUozubiTrYa9Yf2SpHRDWt1EhD8fjiN+Qxf+dJ5P4SZh/zTcPViDdmG+beGSjs083F7vpId9qRSBoCjqaMEbmFCRE3E2q9QaMz9As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t95YBfsT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t95YBfsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933511F00893;
	Sat, 30 May 2026 17:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161296;
	bh=At6hv6k9e/wS2o/S2bj9pL6j2pk19tTFkk416dbPwSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t95YBfsTmA+vsddox6nP/fF6W/sUQiL3743WXywwzVdL+++VWVALhuSHvpQ3yXBlP
	 nyi0w3ezQuZAhvS0vvlC7mQ5UuPibRRsUg439V6ZWJoxm1GwMzGL6fAvwtPfHFC0ih
	 IucLUU4kUvXS5OKfvWCyBc/+nP415b82w1c+8QSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 583/969] arm64: dts: qcom: sdm845-xiaomi-beryllium: Mark l1a regulator as powered during boot
Date: Sat, 30 May 2026 18:01:47 +0200
Message-ID: <20260530160316.509008302@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 3b0dd81eea6b7a239fce456ce4545af76f1a9715 ]

The regulator must be on, since it provides the display subsystem and
therefore the bootloader had turned it on before Linux booted.

Fixes: 77809cf74a8c ("arm64: dts: qcom: Add support for Xiaomi Poco F1 (Beryllium)")
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260320-beryllium-booton-v2-1-931d1be21eae@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
index 6d6b3dd699475..9c0f7b410eee2 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
@@ -133,6 +133,7 @@ vreg_l1a_0p875: ldo1 {
 			regulator-min-microvolt = <880000>;
 			regulator-max-microvolt = <880000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-boot-on;
 		};
 
 		vreg_l5a_0p8: ldo5 {
-- 
2.53.0



