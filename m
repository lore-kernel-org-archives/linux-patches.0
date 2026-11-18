Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024434;
	b=HFEdwoALubUiPOV9wkrIEHYdO8AEJZ4942bE1EKiinnDnd2wLS13aIaErpK+Ko/DBSaY
	 v0L7I1iesNsc9oCeIJB/tZaPP6T2aaqJO/9RsAtDZs3mh73ThslaMak3uOshCvZorTmKq
	 RqFyypeluYw9xo/YfSrBAQ7xxm1bFXxLnNW3H2DeR09rWJgRjCetBGhVmMPhkseieN4tT
	 /mwLQwgDSyqZWr6yDMBtp8wwbStJ5NnAeJ+bofX+HvaVzbPsqeuhjbK40NtmsnfS6Y7xd
	 l0Y5DCvApt29JJZoFd93e9IHLBraDzn+0aBsEdiZdQ1lsfkgYTNDa1TRkKbzyh/Puyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cA08IbrD13xMYav2OceudeSjJozvsh1eDzsCRkY7dDk=;
	b=e57em0tJFIfXFvQQ4hf/PaYLEEurVDIbK8XqmrxxazvEBccZVKXIVlyMJTNQHbvPz9Or
	 p6vDDoQ+HhJQ0z1jBZ/abSV18bNOiwSgFr0rBIVQYuxkOTi18XFIhYJQi/aER6rumsL41
	 Xbh9q6pMxKnveenQXsVfVxjw4A803NpKnz8iJ8ZmZmym4mQ74Y62TidriEDwoiBKfv1AQ
	 GqFCvtLv8NlPg9/jv/XhOi1UIRXnw7kWWgELM0Q5Yt9XMsph0mmTC7dPjRwMVW5DY+S9b
	 BcPwXUqqjADntn31Hmw08FSPmHjAuX7bOIf1clcRiVMgHNNZSfsXDZ75d4fm/N7+y0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ig2Fa/zg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E82606A32A;
	Wed, 18 Nov 2026 17:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ig2Fa/zg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698041F000C4;
	Wed, 18 Nov 2026 17:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024433;
	bh=cA08IbrD13xMYav2OceudeSjJozvsh1eDzsCRkY7dDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ig2Fa/zgMX8G7SUbGQudXvLPppGLEW1+bcY2s9xb2f3PV8d+XEhTAoNPI5ItBcq+S
	 KCz0Hrh3yvnq3aEMN7PNxCWvdFnY0Nkj5/GpSfMH8FVaY2/e9MHDrFBAQeowPZInPh
	 Yh0khpsf9177V9lpN5sZ/LTyYLzoAH/VWhVqlTb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0723/2151] arm64: dts: qcom: x1-crd: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:40:58 +0100
Message-ID: <20261118150148.373462045@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 099cd579fa73c142fde2f7e3ea473f334792a249 ]

GPIO 65 from TLMM is connected to the embedded controller's active-high
reset line. Asserting it causes the fans to run at full speed during
reset and leaves the keyboard non-functional afterwards.

Reserve it to prevent Linux from requesting or reconfiguring it.

Fixes: bd50b1f5b6f3 ("arm64: dts: qcom: x1e80100: Add Compute Reference Device")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-1-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1-crd.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1-crd.dtsi b/arch/arm64/boot/dts/qcom/x1-crd.dtsi
index 5e324f35547a4..59f8c1ed98c77 100644
--- a/arch/arm64/boot/dts/qcom/x1-crd.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1-crd.dtsi
@@ -1476,6 +1476,7 @@ right_tweeter: speaker@0,1 {
 &tlmm {
 	gpio-reserved-ranges = <34 2>, /* Unused */
 			       <44 4>, /* SPI (TPM) */
+			       <65 1>, /* EC reset */
 			       <238 1>; /* UFS Reset */
 
 	edp_reg_en: edp-reg-en-state {
-- 
2.53.0



