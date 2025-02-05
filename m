Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC061519BF;
	Wed,  5 Feb 2025 14:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767362; cv=none; b=u8LaYnVfp+DrCYPzdIcxOueujr4xGCc7AjZ/uLRhXwz39nvNvYSPqqNQeX451LvuABRQX6U+8o2uJ6oTO41zsN4yN1l7c0cM467sNMlwFFwrW+0sB0yyJrHlRh2/+bA1FscwQvZe9qNaBpKBir3yUafJwbRPJ0B2d59kbCZX/Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767362; c=relaxed/simple;
	bh=07W2mj19XQ/DiBaAc3Kn08hn+ctglGM9q+IDXuB+Eds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdX0/f5FbfIQE1FFUZx9LiWU46hlJKpkxbOWydIW7+xlcjddJqYpVxc0Y4nrFS5owASHX378RK5GUdH95IvWKOqqUId6fb1sp+ASxe30EGc9muBKxzLtG2Md6nHIsrXNVPtGbXXfcodWedWUfhJBkZJ6ED9xl6qrn2/3AB3sk8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+COEuKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+COEuKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC30DC4CED1;
	Wed,  5 Feb 2025 14:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767362;
	bh=07W2mj19XQ/DiBaAc3Kn08hn+ctglGM9q+IDXuB+Eds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+COEuKYYzyfFOsvhxuy5UpiVCPXtgkYlIw9fHVjpXMK2eNTlaVVc/K1XrF5i29OM
	 CaCMiFF+IDwtaPF2CtbOjKPQJrRIDiKQmgdEIfhzM3bMiMZL1csDh0S77OlIVAZ0kW
	 1lG7Y81A7gV2AW+LDFPNw20Po4wtny/O+ggWcTA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maulik Shah <quic_mkshah@quicinc.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 370/623] arm64: dts: qcom: sa8775p: Add CPUs to psci power domain
Date: Wed,  5 Feb 2025 14:41:52 +0100
Message-ID: <20250205134510.375963801@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maulik Shah <quic_mkshah@quicinc.com>

[ Upstream commit 736f50489e08ba7329a9e828c35a2358968dacf0 ]

Commit 4f79d0deae37 ("arm64: dts: qcom: sa8775p: add CPU idle states")
already added cpu and cluster idle-states but have not added CPU devices
to psci power domain without which idle states do not get detected.

Add CPUs to psci power domain.

Fixes: 4f79d0deae37 ("arm64: dts: qcom: sa8775p: add CPU idle states")
Signed-off-by: Maulik Shah <quic_mkshah@quicinc.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/r/20241112-sa8775p_cpuidle-v1-1-66ff3ba72464@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sa8775p.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p.dtsi b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
index d9482124f0d3b..97c85a3db3019 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
@@ -44,6 +44,8 @@
 			compatible = "qcom,kryo";
 			reg = <0x0 0x0>;
 			enable-method = "psci";
+			power-domains = <&cpu_pd0>;
+			power-domain-names = "psci";
 			qcom,freq-domain = <&cpufreq_hw 0>;
 			next-level-cache = <&l2_0>;
 			capacity-dmips-mhz = <1024>;
@@ -66,6 +68,8 @@
 			compatible = "qcom,kryo";
 			reg = <0x0 0x100>;
 			enable-method = "psci";
+			power-domains = <&cpu_pd1>;
+			power-domain-names = "psci";
 			qcom,freq-domain = <&cpufreq_hw 0>;
 			next-level-cache = <&l2_1>;
 			capacity-dmips-mhz = <1024>;
@@ -83,6 +87,8 @@
 			compatible = "qcom,kryo";
 			reg = <0x0 0x200>;
 			enable-method = "psci";
+			power-domains = <&cpu_pd2>;
+			power-domain-names = "psci";
 			qcom,freq-domain = <&cpufreq_hw 0>;
 			next-level-cache = <&l2_2>;
 			capacity-dmips-mhz = <1024>;
@@ -100,6 +106,8 @@
 			compatible = "qcom,kryo";
 			reg = <0x0 0x300>;
 			enable-method = "psci";
+			power-domains = <&cpu_pd3>;
+			power-domain-names = "psci";
 			qcom,freq-domain = <&cpufreq_hw 0>;
 			next-level-cache = <&l2_3>;
 			capacity-dmips-mhz = <1024>;
@@ -117,6 +125,8 @@
 			compatible = "qcom,kryo";
 			reg = <0x0 0x10000>;
 			enable-method = "psci";
+			power-domains = <&cpu_pd4>;
+			power-domain-names = "psci";
 			qcom,freq-domain = <&cpufreq_hw 1>;
 			next-level-cache = <&l2_4>;
 			capacity-dmips-mhz = <1024>;
@@ -140,6 +150,8 @@
 			compatible = "qcom,kryo";
 			reg = <0x0 0x10100>;
 			enable-method = "psci";
+			power-domains = <&cpu_pd5>;
+			power-domain-names = "psci";
 			qcom,freq-domain = <&cpufreq_hw 1>;
 			next-level-cache = <&l2_5>;
 			capacity-dmips-mhz = <1024>;
@@ -157,6 +169,8 @@
 			compatible = "qcom,kryo";
 			reg = <0x0 0x10200>;
 			enable-method = "psci";
+			power-domains = <&cpu_pd6>;
+			power-domain-names = "psci";
 			qcom,freq-domain = <&cpufreq_hw 1>;
 			next-level-cache = <&l2_6>;
 			capacity-dmips-mhz = <1024>;
@@ -174,6 +188,8 @@
 			compatible = "qcom,kryo";
 			reg = <0x0 0x10300>;
 			enable-method = "psci";
+			power-domains = <&cpu_pd7>;
+			power-domain-names = "psci";
 			qcom,freq-domain = <&cpufreq_hw 1>;
 			next-level-cache = <&l2_7>;
 			capacity-dmips-mhz = <1024>;
-- 
2.39.5



