Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BA14D5A1;
	Sat, 12 Sep 2026 07:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198783; cv=none; b=eETO5EjklTMye7YhPR+UJMjojBRHxB+r5e3Q/oi6OTccokkma95mX9PoTEhYYN2kaa7bNU15PNJM1YvVRMN7cyarjZHaRU0nVs/uBCySsItWHfl6CKLj2UwKIUDTHWZD+7lbYF5WDaJ5LeITYk+j/YV4cVUg9L0ykF9pi7NkDWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198783; c=relaxed/simple;
	bh=XCRmAiStiXkH+4Z2x8zoDMQYEK3aSFfwQ2vWx96w1R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TiiXmdphKQjo9RVnLv4qy+fQIsjckNRGMBoE+VTH880wUF/LueR5lhEebTGk9BveX5eeEkJvHlBn1uwC4bYpfGjnuiNVDOwa8lzPCLqGiM+aRS6NdSH04J56stm7tx7hhRZ6NUHai2+PEr6mcZQsO/c1xMbmsunj7Y2M6Ximamc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sVGmQjp3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sVGmQjp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9200E1F000FF;
	Sat, 12 Sep 2026 07:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198781;
	bh=UH4mOxxpaHqZ41bhV3UWMh8gFJq1JH9vIPunVjgv9Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sVGmQjp36IJWKsNSx8qworSawauIWHeF5F/OzvkzlamiOJ69GQmXokW3rpA3CkAUX
	 qtiqjYx+H93OrMOv05NVyGJW83+zLT5x2zVGyIfCW8EqbLe+Py1vNM/8K7XEK4rdTx
	 xnjuoILnBErtMgwTxhoTfg6ibSqFKbtVYf9rjsmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>,
	Pankaj Patil <pankaj.patil@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0449/1815] arm64: dts: qcom: glymur-crd: merge duplicate &pmh0101_gpios node extensions
Date: Sat, 12 Sep 2026 08:36:39 +0200
Message-ID: <20260912065659.434221920@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>

[ Upstream commit 63b9c63716d452a71d4c5346e0dba4212b94c6a1 ]

The &pmh0101_gpios node is extended twice in glymur-crd.dtsi. The first
extension defines the nvme_reg_en pinctrl state for the NVMe regulator
enable GPIO (gpio14), and the second adds key_vol_up_default for the
volume-up key (gpio6).

Merge both pinctrl states into a single &pmh0101_gpios block to avoid
the duplicate node extension.

No functional change intended.

Fixes: a5ad8a8e473c ("arm64: dts: qcom: Commonize Glymur CRD DTSI")
Signed-off-by: Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>
Reviewed-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260602-merge-duplicate-pmh0101-gpios-node-v2-1-251107b3d9fe@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/glymur-crd.dtsi | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/glymur-crd.dtsi b/arch/arm64/boot/dts/qcom/glymur-crd.dtsi
index 7d3c6bbd31d28..f09a957d094da 100644
--- a/arch/arm64/boot/dts/qcom/glymur-crd.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur-crd.dtsi
@@ -781,14 +781,6 @@ &pcie6_port0 {
 	wake-gpios = <&tlmm 151 GPIO_ACTIVE_LOW>;
 };
 
-&pmh0101_gpios {
-	nvme_reg_en: nvme-reg-en-state {
-		pins = "gpio14";
-		function = "normal";
-		bias-disable;
-	};
-};
-
 &pmh0110_f_e1_gpios {
 	nvme_sec_reg_en: nvme-reg-en-state {
 		pins = "gpio14";
@@ -804,6 +796,12 @@ key_vol_up_default: key-vol-up-default-state {
 		output-disable;
 		bias-pull-up;
 	};
+
+	nvme_reg_en: nvme-reg-en-state {
+		pins = "gpio14";
+		function = "normal";
+		bias-disable;
+	};
 };
 
 &pmh0110_f_e0_gpios {
-- 
2.53.0



