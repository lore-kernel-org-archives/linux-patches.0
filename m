Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D43F2C327B;
	Mon,  2 Jun 2025 13:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872624; cv=none; b=szcc59FEU91T5+/ldw36n2mNf4zotn6HN1gZvv6R10z+R2ecK7IRRRVHr3JXtGCwJqR700NA1ggUA8s5ckXjcB3skdwPzUYax3q3sxBCgqrNwHW6RjuQxf6Cy3Jv6MFv4pDAUrTgNrJHzMAZ/vczr3NyJeEnGHw+kvVWetdgvls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872624; c=relaxed/simple;
	bh=j19D/hp1MEFZSZcZv4qxkKHybwVAf9RjlGlfyq1HvIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jcK5HAhg6l5w6G/sQncvLDrS+m9RF6pPKZO3Y/UQY713JK+9oh4O1dPOk1mjRGQaoHtk2lmR9JuVxYc/vAJnvEQePUKt84m5NRoei38Z3QUbtgeDdE/qW6WnVWTCWGake3DI6b+zw1jeQMpk2hsXF5S3HaQlhRugE3pHo6nz0aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0z9Wi635; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0z9Wi635"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE41C4CEEB;
	Mon,  2 Jun 2025 13:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872624;
	bh=j19D/hp1MEFZSZcZv4qxkKHybwVAf9RjlGlfyq1HvIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0z9Wi635kF34YS4uZmxFqcVXQkNTh4ReLYbV3b1/kqQ38O/wkF4cZ0BFEtfWlwmV1
	 ak6Qa1ETO0aknWzCMehaO7VHCaSO6BYJI6Rd5gljXKc+/Jx0DnhxA5xz8xWcQjscZh
	 fbopkMdZvWl9A/iGe5K6koaNRYcp/s1xJHcIQNt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.14 20/73] arm64: dts: qcom: x1e80100-qcp: Fix vreg_l2j_1p2 voltage
Date: Mon,  2 Jun 2025 15:47:06 +0200
Message-ID: <20250602134242.494307096@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit efdbeae860bf0278b050c6c9ad5921afba4596d0 upstream.

In the ACPI DSDT table, PPP_RESOURCE_ID_LDO2_J is configured with 1256000
uV instead of the 1200000 uV we have currently in the device tree. Use the
same for consistency and correctness.

Cc: stable@vger.kernel.org
Fixes: af16b00578a7 ("arm64: dts: qcom: Add base X1E80100 dtsi and the QCP dts")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250423-x1e-vreg-l2j-voltage-v1-6-24b6a2043025@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
@@ -675,8 +675,8 @@
 
 		vreg_l2j_1p2: ldo2 {
 			regulator-name = "vreg_l2j_1p2";
-			regulator-min-microvolt = <1200000>;
-			regulator-max-microvolt = <1200000>;
+			regulator-min-microvolt = <1256000>;
+			regulator-max-microvolt = <1256000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 		};
 


