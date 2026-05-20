Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2893C6A5C;
	Wed, 20 May 2026 16:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295770; cv=none; b=YPqyHBkpgDDJyQqj+wvPJenAodLXsTMQLlJjWoE+NgIA+sQd/YnXpBmZO7s7I2ylrCmrjBprpiUScHEkWR6REa3GsuRRqQhRRfAqsN8Nhlkq9OiPiVYrxFPlMojwtxcMEYRECsZqqyUyOVmBXf5eNF5q9gzoD0i2UyQW4XO8BnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295770; c=relaxed/simple;
	bh=RiaQ3CZzT7zC29jPD1GDzrzUna4enImAyWRTaCI1AZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2SXwgGBuI6ZHiNVv3QfC0fSIey9qqU162DCdUhoCHS9BHFhRwdBekXp0+7feyB/sYZVTd7w6RHEjtOTUoAXtLXT9kBDGap7HapeiJOuZNYcizuaOEjWjcRVB4VoCysDH7UcVOMMI4TJc7bOzS3nfxythNlAQnAPg+4XEj84PIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pn2oqyvT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pn2oqyvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35791F000E9;
	Wed, 20 May 2026 16:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295769;
	bh=eF5vNyXXvwjvHqWVlJtpaFaaOIQFqBghtLwRb4T3CCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pn2oqyvTo+Sp+EBUZ7WUGdz1gudJEoOGWzhl1Gxroou+hF2mdqvSjddpUKNtUpxVU
	 IBu3eeR3QHKbXGSjzXM/zT3a3vYlu1sHP8rzUf5DsW06mFRivVZPRcq65+fja/Hoc3
	 wOaiJNS8BY3K2wCO8VLWyjDAeAZ/6rR7AL/I0URw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0518/1146] arm64: dts: qcom: milos: Fix GIC_ITS range length
Date: Wed, 20 May 2026 18:12:48 +0200
Message-ID: <20260520162159.908867266@linuxfoundation.org>
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

[ Upstream commit 1831b64854bd8adfccfef4f949534f9e8163293a ]

Currently, the GITS_SGIR register is cut off. Fix it up.

Fixes: d9d59d105f98 ("arm64: dts: qcom: Add initial Milos dtsi")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260317-topic-its_range_fixup-v1-2-49be8076adb1@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/milos.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/milos.dtsi b/arch/arm64/boot/dts/qcom/milos.dtsi
index e1a51d43943ff..084be5316e0d5 100644
--- a/arch/arm64/boot/dts/qcom/milos.dtsi
+++ b/arch/arm64/boot/dts/qcom/milos.dtsi
@@ -1911,7 +1911,7 @@ ppi_cluster1: interrupt-partition-1 {
 
 			gic_its: msi-controller@17140000 {
 				compatible = "arm,gic-v3-its";
-				reg = <0x0 0x17140000 0x0 0x20000>;
+				reg = <0x0 0x17140000 0x0 0x40000>;
 
 				msi-controller;
 				#msi-cells = <1>;
-- 
2.53.0



