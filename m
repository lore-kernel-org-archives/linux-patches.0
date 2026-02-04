Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FFE2C08AC;
	Wed,  4 Feb 2026 15:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217802; cv=none; b=H41pus+u9ORjA6HhBF9Wc745JUQEzikyzJcX6EAWrLSce2uAbTjJohZ3bCsQxdZCxo8VocMdsqScwLSRokCd4+g3T9oipItc2S5BV6rAVlUgOXnnyBlJ+ba9dDqPRJp78gKjsvce99UCRTHqJYKcrMpIozRj9yDsj5+OmPVIYpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217802; c=relaxed/simple;
	bh=rfXbgtSjIUuNhZwtwg/fUK7Lsqv9VfYBGraKTAZJa2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llIFxg6U6PAsSc79sjiOfZqHCShOPjJm7JYP3iwxpKXlHDnhLJ/pab3hfrrBjhuYbYdGLqv9y4WfjEsubtsKiJeyeNXsFcYepLX2ekqzafQ5m/J7AfBC3/njbS+kbKN30n9FJq6TDxrpJrO0RYbaN2ksnnXU8UXqtcFH0WtXNrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CaUBaPIQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CaUBaPIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5C5C4CEF7;
	Wed,  4 Feb 2026 15:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217802;
	bh=rfXbgtSjIUuNhZwtwg/fUK7Lsqv9VfYBGraKTAZJa2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CaUBaPIQ0SJghEl72j6t08/Zu11cQ9sDx5VRNp5iMZ0q6ZLT2E07r2DYeuzoeWmnu
	 Rd/hUBxjY22X13a1ZcRshBhNQ+rUzBpqPkGI0911U3cw9SseyNfbA1dsinOT3/ZJOz
	 B74f6OS3fieVbAeWnxMDxgxwuSEVEf+XS0zfakSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/280] arm64: dts: qcom: sc8280xp: Add missing VDD_MXC links
Date: Wed,  4 Feb 2026 15:37:43 +0100
Message-ID: <20260204143912.860806476@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 868b979c5328b867c95a6d5a93ba13ad0d3cd2f1 ]

To make sure that power rail is voted for, wire it up to its consumers.

Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20251202-topic-8280_mxc-v2-3-46cdf47a829e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index 6b0d4bc6c5419..e502360de601d 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -1819,8 +1819,12 @@ remoteproc_nsp0: remoteproc@1b300000 {
 			clocks = <&rpmhcc RPMH_CXO_CLK>;
 			clock-names = "xo";
 
-			power-domains = <&rpmhpd SC8280XP_NSP>;
-			power-domain-names = "nsp";
+			power-domains = <&rpmhpd SC8280XP_NSP>,
+					<&rpmhpd SC8280XP_CX>,
+					<&rpmhpd SC8280XP_MXC>;
+			power-domain-names = "nsp",
+					     "cx",
+					     "mxc";
 
 			memory-region = <&pil_nsp0_mem>;
 
@@ -1950,8 +1954,12 @@ remoteproc_nsp1: remoteproc@21300000 {
 			clocks = <&rpmhcc RPMH_CXO_CLK>;
 			clock-names = "xo";
 
-			power-domains = <&rpmhpd SC8280XP_NSP>;
-			power-domain-names = "nsp";
+			power-domains = <&rpmhpd SC8280XP_NSP>,
+					<&rpmhpd SC8280XP_CX>,
+					<&rpmhpd SC8280XP_MXC>;
+			power-domain-names = "nsp",
+					     "cx",
+					     "mxc";
 
 			memory-region = <&pil_nsp1_mem>;
 
-- 
2.51.0



