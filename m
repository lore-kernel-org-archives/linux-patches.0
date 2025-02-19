Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F821DE887;
	Wed, 19 Feb 2025 09:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956429; cv=none; b=jRqu/tCnPVZCBu6w82tNAh65oTgsF5kcVlDdHxL4XQKKx2OYTOKxLpswe8yeQk/tUTr1RfV30GcrO5dK7q2HkRSOgBB8I3Ka75vGu+pqSV6vIxr6FSMdFtRc026v5258d782X5sPui6sOMjIcflGtiuuZoHv81pgMH5RvXijrtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956429; c=relaxed/simple;
	bh=LUiqnjsHwLAY5So9jl1QI23OFpc6mEWLZxqaVNAtqds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bo8DG9wn5YhcjCcQosWSrOekE/onANnYINrVBaVF6cgwDX4qe4hHyLSAOdVAybsiwHrrp5UT91+qo7+xRD9kzTWRRlOPVsaAxH/Z06Q8IesRDembpovJMgYcDTBfgJh4q8aQqOGuIWGyLyFoBFlDVO4itJ2P9aFjfgGSRwvI06k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/SDGaQW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/SDGaQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD75C4CED1;
	Wed, 19 Feb 2025 09:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956429;
	bh=LUiqnjsHwLAY5So9jl1QI23OFpc6mEWLZxqaVNAtqds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/SDGaQWC3IJSvmsKNOV2d+Z1BCLSwkOREljHj9/RCoaothPO7VvunE2/Fjoy74XL
	 tztpr1YAckCaeAASRBTCxjTjfN5K5QQdX1GJQdc6JeFssaERHxSUFBzSwuaKrf/aXP
	 +vqrOqiF/9FlTPRNf0nCA1T08pS+kcp8c4oCqLZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 175/578] arm64: dts: qcom: sc7180-trogdor-pompom: rename 5v-choke thermal zone
Date: Wed, 19 Feb 2025 09:22:59 +0100
Message-ID: <20250219082659.850777015@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 9180b38d706c29ed212181a77999c35ae9ff6879 ]

Rename the 5v-choke thermal zone to satisfy the bindings.

This fixes:
sc7180-trogdor-pompom-r2-lte.dts: thermal-zones: '5v-choke-thermal' does not match any of the regexes: '^[a-zA-Z][a-zA-Z0-9\\-]{1,10}-thermal$', 'pinctrl-[0-9]+'
	from schema $id: http://devicetree.org/schemas/thermal/thermal-zones.yaml#

Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241230-topic-misc-dt-fixes-v4-4-1e6880e9dda3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi
index d363a8b6906aa..31f91f4e97360 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi
@@ -12,11 +12,11 @@
 
 / {
 	thermal-zones {
-		5v-choke-thermal {
+		choke-5v-thermal {
 			thermal-sensors = <&pm6150_adc_tm 1>;
 
 			trips {
-				5v-choke-crit {
+				choke-5v-crit {
 					temperature = <125000>;
 					hysteresis = <1000>;
 					type = "critical";
-- 
2.39.5



