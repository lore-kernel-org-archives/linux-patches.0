Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E41221DB6;
	Mon,  2 Jun 2025 13:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872084; cv=none; b=YtzrxHoM8cS9TvM05OJQdYYF0F6t0vT6bJVzH1/ura7DptcJID4AapPUc3PJzqlGj6NF9IVI6GKgjrghIvFpaSTpDgBLNnRiPenHH3UHYjs4dmyq52BC+3I14bxfoGax7UH0ACkh5tA9C2uYj2KdcZ08InCiQ6Ej6GrRQY8X3BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872084; c=relaxed/simple;
	bh=xa4GAiDc1U04iSNUMVcNm7Jw1mnxb1VtQSLaY2YiHOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cf/MgtjFRDRILJFvzPuD9PGFB3AyRR8JsyxgPhf0UsE0sKOIWDRFl6IO7Z12dffNVdeEmjuUmP3yDPpzuJUwJcJRGKMUja4gr4Ifg8zQr33fDha2l5E2UVMaMvRsoD57J+EQdc7kJz8LVEOo65iM3+qWNNxQS1exbMxCDk744Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3Zx/GbI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3Zx/GbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC6BC4CEEE;
	Mon,  2 Jun 2025 13:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872083;
	bh=xa4GAiDc1U04iSNUMVcNm7Jw1mnxb1VtQSLaY2YiHOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3Zx/GbIXCyK8icx6YG0d7K7iLHjamQH+ZX0icEtyABXzwvwfdLcFfjCHO4uX7HI2
	 QFecqx04a9a7GPrFBK3+LDp/odug0X3AASRLbNVYn5B8d0VYTcFdl8epmCWIuXeik+
	 9nLD56+juVFtsicHkU+PhoeTAsXJvI9YAAokIOb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.15 13/49] arm64: dts: qcom: x1e001de-devkit: mark l12b and l15b always-on
Date: Mon,  2 Jun 2025 15:47:05 +0200
Message-ID: <20250602134238.458799137@linuxfoundation.org>
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

commit 7d328cc134f7db1e062f616a30cffe96fbc43abb upstream.

The l12b and l15b supplies are used by components that are not (fully)
described (and some never will be) and must never be disabled.

Mark the regulators as always-on to prevent them from being disabled,
for example, when consumers probe defer or suspend.

Fixes: 7b8a31e82b87 ("arm64: dts: qcom: Add X1E001DE Snapdragon Devkit for Windows")
Cc: stable@vger.kernel.org	# 6.14
Cc: Sibi Sankar <quic_sibis@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20250314145440.11371-4-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e001de-devkit.dts |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts
+++ b/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts
@@ -507,6 +507,7 @@
 			regulator-min-microvolt = <1200000>;
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l13b_3p0: ldo13 {
@@ -528,6 +529,7 @@
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l16b_2p9: ldo16 {


