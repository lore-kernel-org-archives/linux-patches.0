Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9460022156B;
	Mon,  2 Jun 2025 13:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872111; cv=none; b=A/pz3als+CaUIDv8CSZ/l0d04Wu/glqfydlbV1QMAYCuephZDQz0eCAGbl7B2mOzRI7dGeLhBUyk3Num8ZMyk+3JSuEg/6FYf1dSeLW0jtNF3IPSK5RM4r2XsVnvyuLcR8WDkGulNM97PmNDTMgncLHonIl2wxOTd5FVGSZi0aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872111; c=relaxed/simple;
	bh=E7bWldQHf4sGX8xPYKC5m1JJcS0MvS034D9FYhtJAgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwaW2zUqKwSy+bl7AAXkIH4+RYNaEHYBOFzpyp2qoNOXUfu0YEgbDDDUC07x5gvaGzeRzEGZuuLooC7KXbdR7r+LHDF7klDDftjfErU+L1aC1hBMGXmnabmM3VcAHCH0HAZ++9JLeEmqoGH4TysadkVAWpT9BPg5yKgxojuJYOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UeOJ+JYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UeOJ+JYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2048C4CEEB;
	Mon,  2 Jun 2025 13:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872111;
	bh=E7bWldQHf4sGX8xPYKC5m1JJcS0MvS034D9FYhtJAgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UeOJ+JYFv6KjTY8ZBOoD4Az+7g6W6lbbk1CwiKTrcqboM1HnkW38uJ8zLJup4g4BQ
	 UXLKcJzZypwBQoW9Mvldv2emVegYqSoW4woloAcOriarQaADDnO1tMvvlx8sahjb2c
	 SUSB94UT04hzbp1puJ8PwICopEumrqx7lmQ7hk54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajendra Nayak <quic_rjendra@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.15 21/49] arm64: dts: qcom: x1e80100-qcp: mark l12b and l15b always-on
Date: Mon,  2 Jun 2025 15:47:13 +0200
Message-ID: <20250602134238.776348770@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
References: <20250602134237.940995114@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit ff6ba96378367133b66587bd3ee9f068a39ff3a9 upstream.

The l12b and l15b supplies are used by components that are not (fully)
described (and some never will be) and must never be disabled.

Mark the regulators as always-on to prevent them from being disabled,
for example, when consumers probe defer or suspend.

Fixes: af16b00578a7 ("arm64: dts: qcom: Add base X1E80100 dtsi and the QCP dts")
Cc: stable@vger.kernel.org	# 6.8
Cc: Rajendra Nayak <quic_rjendra@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20250314145440.11371-8-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
@@ -437,6 +437,7 @@
 			regulator-min-microvolt = <1200000>;
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l13b_3p0: ldo13 {
@@ -458,6 +459,7 @@
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l16b_2p9: ldo16 {


