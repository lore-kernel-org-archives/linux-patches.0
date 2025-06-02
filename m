Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD7214901B;
	Mon,  2 Jun 2025 13:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872096; cv=none; b=rzyLR8AQYInbwMSjMLNKBH9h40tqbg+sAYo7ALtKulyYupaCQ35CqYRZOytqvzryaggyHczTYNgFY6Cr1fqbCOUnyLgDpiATWe205qgJnXCXpXwIdeCe6rSvuqHuuBq/L6bPBNclfMUBsUd92tJ0FPXEsnNeip7bD4obPRU39Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872096; c=relaxed/simple;
	bh=X0PdvBWxebmiTKchGzbEjOy8nMDeiMDqCFJykZSLaTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=asWZCzH9yr7AhQCuQqn01D4leluuxjpvagVEzcqa/4qF2J/RLE4zJve2byS73DiFTKwGaLUahZpnNoHUlMgDYwo7Mmngv/uwEL2ZUj34U7Ol6x9k42gkI5KwdSXcnUkE5rDcVssz9hThQ1beGhgYgIhRIGxnEVDA1vTeh/AZ9fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vwerD4/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vwerD4/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C384C4CEEB;
	Mon,  2 Jun 2025 13:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872096;
	bh=X0PdvBWxebmiTKchGzbEjOy8nMDeiMDqCFJykZSLaTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vwerD4/QxW2hQXH7HRX2jATGPdv4ZplezWUzOPiUTFfJLdhmkoGBS7yXNAMEBv0lx
	 fA89COxsMvLPSPF3A716emumtdWr6j8JpRvI2bsgoe/WWrCgLgcsw9Kby304ZSjcLt
	 vh8A2VQt20sTecnxN6Guius35ivyvw64cqDVRYmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.15 17/49] arm64: dts: qcom: x1e80100-hp-omnibook-x14: Fix vreg_l2j_1p2 voltage
Date: Mon,  2 Jun 2025 15:47:09 +0200
Message-ID: <20250602134238.623429723@linuxfoundation.org>
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

commit 4a09dad9d437a13e9cd4383ff7791a816a6e1652 upstream.

In the ACPI DSDT table, PPP_RESOURCE_ID_LDO2_J is configured with 1256000
uV instead of the 1200000 uV we have currently in the device tree. Use the
same for consistency and correctness.

Cc: stable@vger.kernel.org
Fixes: 6f18b8d4142c ("arm64: dts: qcom: x1e80100-hp-x14: dt for HP Omnibook X Laptop 14")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250423-x1e-vreg-l2j-voltage-v1-4-24b6a2043025@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-hp-omnibook-x14.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100-hp-omnibook-x14.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-hp-omnibook-x14.dts
@@ -871,8 +871,8 @@
 
 		vreg_l2j_1p2: ldo2 {
 			regulator-name = "vreg_l2j_1p2";
-			regulator-min-microvolt = <1200000>;
-			regulator-max-microvolt = <1200000>;
+			regulator-min-microvolt = <1256000>;
+			regulator-max-microvolt = <1256000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 		};
 


