Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA55157E6B;
	Wed, 30 Jul 2025 09:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868970; cv=none; b=Rut0Dq2timFv6xqvNqcSDmKURSSej4b4nQzAX8z00kzA/FLzj39NcOE9V4ObGfgtZav33Ip04AEN59A2u8Q+biFVh2QVr76fPCRncuiWsAj1BsI+3/oR0NbcOk2CX0l1XqD9cWH6J+65F1PxVZgkaw2EPLbtJZkuZ+JTbamSf6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868970; c=relaxed/simple;
	bh=+pbiXn5Oxvmc7xtF48QjMLbfl8NtXn7XhitjRU+Rwr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=du+SzMjGJlgwS+VWWVnAXpJ6q1T+e08/A/lmSeVHapEiWsGlCDqBU7kKc01uYt00KXnWd+oCm9jlu6G6kMi5EtojfFtk0Demlh9ps6ic2bb9a0fRj0koiTtsDUoZBx+SzBxu+XIAJATHZEDa8B/sF1qGKwq4urvIHYYIRQkwsVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xu8dhL/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xu8dhL/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42725C4CEF5;
	Wed, 30 Jul 2025 09:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868969;
	bh=+pbiXn5Oxvmc7xtF48QjMLbfl8NtXn7XhitjRU+Rwr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xu8dhL/UVwC6e4nbdptPn6k59qxvcIZerbd3R9sfIRSPb3nKaQdss288HAnSSZZgO
	 mweEZOnLid+X6rf9+1YsZKaZ3ULMpdUXpTsBJUXYotdb+UmHquVjW4tzbHZxRgPoGe
	 PcRdBlSlPhB5f8/X6d5oSm5c6iaBzzYkj1xgrjZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/117] arm64: dts: qcom: x1-crd: Fix vreg_l2j_1p2 voltage
Date: Wed, 30 Jul 2025 11:36:11 +0200
Message-ID: <20250730093237.775593898@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

[ Upstream commit 5ce920e6a8db40e4b094c0d863cbd19fdcfbbb7a ]

In the ACPI DSDT table, PPP_RESOURCE_ID_LDO2_J is configured with 1256000
uV instead of the 1200000 uV we have currently in the device tree. Use the
same for consistency and correctness.

Cc: stable@vger.kernel.org
Fixes: bd50b1f5b6f3 ("arm64: dts: qcom: x1e80100: Add Compute Reference Device")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250423-x1e-vreg-l2j-voltage-v1-1-24b6a2043025@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
[ Change x1e80100-crd.dts instead ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
@@ -659,8 +659,8 @@
 
 		vreg_l2j_1p2: ldo2 {
 			regulator-name = "vreg_l2j_1p2";
-			regulator-min-microvolt = <1200000>;
-			regulator-max-microvolt = <1200000>;
+			regulator-min-microvolt = <1256000>;
+			regulator-max-microvolt = <1256000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 		};
 


