Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775BE155308;
	Mon, 24 Feb 2025 14:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407934; cv=none; b=EQg4lIhoFd42x1OYQYidqKuzTsomCSMxeixWpVNhkasJH/YjxopPpZtSF2g931a4lYmgtxWNmN8FqfTRwQoVQ+jPAu2R/XJOdaSrlnO05azIW1YUHAkslC6AmMhHHHlI1p7HJ/2cQd5Lui8e0VbwIs2gPH5D2YttIiYoHTognjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407934; c=relaxed/simple;
	bh=ffDCbwlsTOFT7l3hqNi59PpraptKdVmuq8SHTTJtzFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOjmdcV9ZAwrushkEQ3ErkLnJNV6Kp3Pz6az9WbQJT6h5V+kmiSSk+gyoGik5RF9vQoHIjDrVg9YipD8YYhcE6ixDyEUW10GHHdSdyh/T+CLxs/4bdZJablAGqTuO4rSl/sJENYiuEQDNbv8e+S2ijGXSQGwQEku3vlrsDkD9C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RFRVnKOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFRVnKOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E57C4CEE6;
	Mon, 24 Feb 2025 14:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407933;
	bh=ffDCbwlsTOFT7l3hqNi59PpraptKdVmuq8SHTTJtzFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RFRVnKOOzM9wAnMgIMLc7WO0jOuD5wwpSBSpXY1AbuJ3Yqbcz30GOOrf32+tC27FT
	 O+6rCj+nvc2qOnKgd4uLJzm/+xR9bAHcMbeV6I50Ya0KL45MA0ezt0RVH/vUgyuvQs
	 pRaLP24N4lIxurbKjTXLEedPawsqcpIb5ln3or/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/140] arm64: dts: qcom: sm8550: add missing qcom,non-secure-domain property
Date: Mon, 24 Feb 2025 15:34:10 +0100
Message-ID: <20250224142605.020018955@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 49c50ad9e6cbaa6a3da59cdd85d4ffb354ef65f4 ]

By default the DSP domains are non secure, add the missing
qcom,non-secure-domain property to mark them as non-secure.

Fixes: d0c061e366ed ("arm64: dts: qcom: sm8550: add adsp, cdsp & mdss nodes")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240227-topic-sm8x50-upstream-fastrpc-non-secure-domain-v1-2-15c4c864310f@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: a6a8f54bc2af ("arm64: dts: qcom: sm8550: Fix ADSP memory base and length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 51407c482b51f..500dfbd79fb69 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -3998,6 +3998,7 @@
 					compatible = "qcom,fastrpc";
 					qcom,glink-channels = "fastrpcglink-apps-dsp";
 					label = "adsp";
+					qcom,non-secure-domain;
 					#address-cells = <1>;
 					#size-cells = <0>;
 
@@ -4136,6 +4137,7 @@
 					compatible = "qcom,fastrpc";
 					qcom,glink-channels = "fastrpcglink-apps-dsp";
 					label = "cdsp";
+					qcom,non-secure-domain;
 					#address-cells = <1>;
 					#size-cells = <0>;
 
-- 
2.39.5



