Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA54336B059;
	Wed, 20 May 2026 16:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295817; cv=none; b=DTHKDeHAMGN3YjwsSMDFLVmpdmmIuu/tlS157B7UdsBuqyLKazSKxUx9HItoRO8vifWalzwY2I8gZF3EK5nDRQGGGZx+QHRGZWjfph61MDZyC+39K8d/eXcpkYpJwHw8qKfIvfgVuf7G/QISzz+MrFHuTSiHN55dzEnBbWJ6ufM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295817; c=relaxed/simple;
	bh=aKV2xjRDnRg6NSFbKbq7s+cZC793Jk5G3YcGeeoiRdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxxE+R4rIohaNTtOdWZZvEWZkRUNRrMPL1AX+EdRIgBfm8lS0TdDBUzIosuIkhGXfjGgYYRFAfYQ79nxFrCO7EbmnmzTEx0FWEDTirdQNnHhJqD3IhGY+NeQRhypOocMvg5mSe8SG4UROfG+kg4rKo3ajQ9yt90LY3Nql6Zfh6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zo6urN/X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zo6urN/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF88C1F00893;
	Wed, 20 May 2026 16:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295816;
	bh=GxoW0cAtgsmessSaqFsbSOz0IsDYhB2AxzCTZesgaOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zo6urN/XIvh2KrRJwEcOWiDsiT6wUkgNos6IqFrJw6udptn5x4vWIazik/s8gQWhJ
	 X19/QatCxNTbsd019/EOE1FYJztLU23qMcVCsogQmPmx0qHg9Dp2StY6s+xJeywWwI
	 MCUT5swT30xwVU1tjxq1HUmG+mbAM9XLT7ojykMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0522/1146] arm64: dts: qcom: sm8750: Fix GIC_ITS range length
Date: Wed, 20 May 2026 18:12:52 +0200
Message-ID: <20260520162159.995914108@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit c2f1f8874fda674af1efaa9a90efbdea8b6834ff ]

Currently, the GITS_SGIR register is cut off. Fix it up.

Fixes: 068c3d3c83be ("arm64: dts: qcom: Add base SM8750 dtsi")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260317-topic-its_range_fixup-v1-6-49be8076adb1@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8750.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8750.dtsi b/arch/arm64/boot/dts/qcom/sm8750.dtsi
index f34f112d3aa34..4efdead3583f9 100644
--- a/arch/arm64/boot/dts/qcom/sm8750.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8750.dtsi
@@ -4658,7 +4658,7 @@ intc: interrupt-controller@16000000 {
 
 			gic_its: msi-controller@16040000 {
 				compatible = "arm,gic-v3-its";
-				reg = <0x0 0x16040000 0x0 0x20000>;
+				reg = <0x0 0x16040000 0x0 0x40000>;
 
 				msi-controller;
 				#msi-cells = <1>;
-- 
2.53.0



