Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F6F2F0C62;
	Wed, 20 May 2026 16:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295601; cv=none; b=FmS5Htpkop21weNNqWmQqRk6NO3D6faaipg6XE/SCEkty3vkKMmEHCpVYnBJDiYSdETfe0pKuapEwepCFjgas9vPDJxAV1n+uucykcf2hTwL8a6gNAmmnMawtQgVrhM42IiLGDj1X7yWP1yHX1p7vk6ISCA/DlwULLtjkVivxJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295601; c=relaxed/simple;
	bh=WNSKa11xhyB8fXXs8mvkjOzXVLuyUMmq173Mbng+PjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOuBDHvoIKjE+X3kARlvjXZ77Pl9A/5B6NwH0mgn3YYXikyvd2cmTw3oVtQH4lau2pbjIzrYKMRAuSOqY3DjThPa5fH+HPf9FltivbADKdBpXSS6s8LMrdE2p/Fizm5EGqY/xnpbVdCWuyNut6vffm7uECWFblxQiBPWyGT0ri4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JvZt7+ew; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JvZt7+ew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D524A1F000E9;
	Wed, 20 May 2026 16:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295600;
	bh=3OS6yHwfK/VzpH1HDUxOlx7abhVkvDR6ilx6yVXe1pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JvZt7+ewYy8Om3z16ngyGPN0YtRWsVOZwKO8BZQfvAgK5saKr4GwEk7o2ctjrKUNW
	 KzMVHVFqKd31f3QuON5wLE+LwMlpB7hVQK0Rx2kXYDl4o3kvS2zutkLD/GmlRQQjOe
	 jgjjCOMenQe82wYfjGx7Q2n8NZxtEe4u8mNTym/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0482/1146] arm64: dts: qcom: talos: Add missing clock-names to GCC
Date: Wed, 20 May 2026 18:12:12 +0200
Message-ID: <20260520162159.099565876@linuxfoundation.org>
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

[ Upstream commit c653607929bb4e0d8b80573bdb523adab5b975c2 ]

The binding for this clock controller requires that clock-names are
present. They're not really used by the kernel driver, but they're
marked as required, so someone might have assumed it's done on purpose
(where in reality we try to stay away from that since index-based
references are faster, take up less space and are already widely used)
and referenced it in drivers for another OS.

Hence, do the least painful thing and add the missing entries.

Fixes: 8e266654a2fe ("arm64: dts: qcom: add QCS615 platform")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260126-topic-talos_dt_warn-v1-1-c452afc647ad@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/talos.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/talos.dtsi b/arch/arm64/boot/dts/qcom/talos.dtsi
index 75716b4a58d6d..6dab0d5dcbb8a 100644
--- a/arch/arm64/boot/dts/qcom/talos.dtsi
+++ b/arch/arm64/boot/dts/qcom/talos.dtsi
@@ -666,6 +666,9 @@ gcc: clock-controller@100000 {
 			clocks = <&rpmhcc RPMH_CXO_CLK>,
 				 <&rpmhcc RPMH_CXO_CLK_A>,
 				 <&sleep_clk>;
+			clock-names = "bi_tcxo",
+				      "bi_tcxo_ao",
+				      "sleep_clk";
 
 			#clock-cells = <1>;
 			#reset-cells = <1>;
-- 
2.53.0



