Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06ACD22068E;
	Mon,  2 Jun 2025 13:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872103; cv=none; b=E0f0vLnRNYmTYF+ns0LfZOrmkEdAuin9RAmNC8kjadpDXGcFvx3tDU8UtGwBM/kaKw2OR6E0xYNDm/oekRYDh0obgstcARUwg1FfTbTNTzBYgaPIcF5knH0L76Gq+l1RpAH2orkgKIKUogLDMm1lw8SBAV24uPjtW7fNRYUaKMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872103; c=relaxed/simple;
	bh=l+JOu/h6aMm/w5NdIfdmMSqgxy7GyjfGyqfn6yq9j3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItSu+5dDoGjh1uKP54bwVBOxOvFrDC9OcDS85RhkEZIgv7pXm+xggAlLm20Rn7w9toaG9/eP0HzoJGK3bRMDN1VHy0Q4Ubb1TTo3AuWV7EOXgfxNoj0b5CWYxh5JQNetgmT87Twr6kIiib6CdGkyHOVyMVTgSnx1AEz6ufjTWdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oKCCs+hA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oKCCs+hA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDF5C4CEEB;
	Mon,  2 Jun 2025 13:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872102;
	bh=l+JOu/h6aMm/w5NdIfdmMSqgxy7GyjfGyqfn6yq9j3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oKCCs+hAfyIZXJPiUtR5k73k6EKOsQS++nUPfh2OWci3o/XsqdHUA4ivx8puUZaZ7
	 lhFpysUrORmn23B8at3xI1QwN4+wzlgCHUbAbwXtpqP4xm7qiOiUiClj7wBYgvwAP1
	 JBvMLLR0NQo/N1fN7fl7s9ZqK7fm6z5vDc5qKtgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.15 19/49] arm64: dts: qcom: x1e80100-lenovo-yoga-slim7x: Fix vreg_l2j_1p2 voltage
Date: Mon,  2 Jun 2025 15:47:11 +0200
Message-ID: <20250602134238.700969223@linuxfoundation.org>
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

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit 4f27ede34ca3369cdcde80c5a4ca84cdb28edbbb upstream.

In the ACPI DSDT table, PPP_RESOURCE_ID_LDO2_J is configured with 1256000
uV instead of the 1200000 uV we have currently in the device tree. Use the
same for consistency and correctness.

Cc: stable@vger.kernel.org
Fixes: 45247fe17db2 ("arm64: dts: qcom: x1e80100: add Lenovo Thinkpad Yoga slim 7x devicetree")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250423-x1e-vreg-l2j-voltage-v1-5-24b6a2043025@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
@@ -508,8 +508,8 @@
 
 		vreg_l2j_1p2: ldo2 {
 			regulator-name = "vreg_l2j_1p2";
-			regulator-min-microvolt = <1200000>;
-			regulator-max-microvolt = <1200000>;
+			regulator-min-microvolt = <1256000>;
+			regulator-max-microvolt = <1256000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 		};
 


