Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E325B16D4D2;
	Tue,  7 May 2024 21:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715116095; cv=none; b=PEQoqrntooguhlbBjV5/NteossM+JvEF+9LAcqbGX+BoWLIxryO3SbPylS7reBDxx18oiPcwC66Cn3Sb5LPXIfqBHwwcYL7aGthf6IEOmBzCezxRFZvu6SFemAA72TTCp0cbbMXiX1XxNJKC0/u0mpRyp0W8zniFKn3hr9IL3E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715116095; c=relaxed/simple;
	bh=iPZdriiWL4U7F2SiTbYBohdlD/p7KD7TouuP9bduaaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxSMGZ2/A1hPupSyq5Vlj/+EutnBRiQuAANWglwzO/0OPLJISRgwEOPReYwKpOpRrwAcGNy8g3PZRAYaPvSVEZ9UnY3Nqt0BYMcKLuQbz5OtSof3se9SmkLB5BqmoVUbj+LlOwVx5WQp6kCDLflQELJ1Rvw0+goxdVR305ZyxoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H0zPwVkR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H0zPwVkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DC3C4DDE0;
	Tue,  7 May 2024 21:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715116094;
	bh=iPZdriiWL4U7F2SiTbYBohdlD/p7KD7TouuP9bduaaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H0zPwVkRcwOUStWv6FfXYqFfawt2Yx3DSPaqrsLFnbFGw0Aw6Yqmnzbu52jCKNqOj
	 2QXiSKTQyxevA/UORjqO7aXjvpl6Q+ZLIjV1t2Ejv1a7dFjdmRr7NY0tN5FPpQMS0A
	 5/R4pbFrjXwRakFKEOK0DIHcIuznxM9hSMmzn7riZ69r9BJVBoVI8b+B8jkPvX5ny+
	 rmc5HUrXlzzyVVQgavWKz3ZbG2dkMnxYTpUtV+NSe0QT/LSmo3Q8w8ND6hacO42kwF
	 BrAPVFHZ2IYdUNz0sGRV0xm2yhWqyi8orCZFtfL2OAJa+RDUExpk4gcULSxdmxq7VS
	 0WEikK/EjJe5Q==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Abel Vesa <abel.vesa@linaro.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 07/12] dt-bindings: spmi: Deprecate qcom,bus-id
Date: Tue,  7 May 2024 14:07:44 -0700
Message-ID: <20240507210809.3479953-8-sboyd@kernel.org>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240507210809.3479953-1-sboyd@kernel.org>
References: <20240507210809.3479953-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Abel Vesa <abel.vesa@linaro.org>

As it is optional and no platform is actually using the secondary bus,
deprecate the qcom,bus-id property. For newer platforms that implement
SPMI PMIC ARB v7 in HW, the X1E80100 approach should be used.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20240417-spmi-multi-master-support-v10-2-5bc6d322e266@linaro.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.yaml b/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.yaml
index f983b4af6db9..51daf1b847a9 100644
--- a/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.yaml
+++ b/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.yaml
@@ -92,6 +92,7 @@ properties:
     description: >
       SPMI bus instance. only applicable to PMIC arbiter version 7 and beyond.
       Supported values, 0 = primary bus, 1 = secondary bus
+    deprecated: true
 
 required:
   - compatible
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

