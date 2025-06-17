Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20291FBEA8;
	Tue, 17 Jun 2025 16:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177701; cv=none; b=rGAApeGx4e7EGwLWYlKPOetKKlpkkHWOyCvQvJrKDLRvx1NqnAE4wgRI9ggzZTOaUR4q8tt/5k1JkpmHpN41noVUHV6vDnucT9OBnsnajsmONFn5YwFWFF5fIHTRzeFtgv5gQMRjhTQhufHYHg3UIqQ7Y+9nN9b8TbVGyc0hE4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177701; c=relaxed/simple;
	bh=EsQKEqiBOW+hhuZFzCevMeQaiNdibymBJyngZ3hgNuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6Erek82vn2aF7H0W6oP+PgPKE8vRao+v7Qh4oqnm2PtnnmRBGwWLNuOPY4HZ8Jvafwb7ZLbFjNz2QMG4lGV1AW4NPICcgpmmUEJiM2x4Qzlo4s8zrnDOMvNkTEnxdK+Oc2prEZK6wyX21NXRdQSMHTHKZQdyC/Y9B5lzKm9GBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0CFwjvUe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0CFwjvUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A44C4CEE3;
	Tue, 17 Jun 2025 16:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177701;
	bh=EsQKEqiBOW+hhuZFzCevMeQaiNdibymBJyngZ3hgNuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0CFwjvUephXQ5FzpPUJgkUwBOO8bets5XV+iUCtIHhd14Z4w9mmv/1SJmyuqe3EnK
	 X5KKEYQtKzaizjn2zfkjBev/LRP6oAcjxo3dQ7FUt96k7ffUf/xIHdM3x7pnX6/YOv
	 JHV4w2PaKedX0bW5sKMVaKXXGJ6wYy4nbhTtJQ1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 348/780] arm64: dts: qcom: x1e80100-romulus: Keep L12B and L15B always on
Date: Tue, 17 Jun 2025 17:20:56 +0200
Message-ID: <20250617152505.628789030@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 0783c8b3c06b9cf16b5108d558e2faffb8c533b7 ]

These regulators power some electronic components onboard. They're
most likely kept online by other pieces of firmware, but you can never
be sure enough.

Fixes: 09d77be56093 ("arm64: dts: qcom: Add support for X1-based Surface Laptop 7 devices")
Reported-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20250304-topic-sl7_vregs_aon-v1-1-b2dc706e4157@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi b/arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi
index 5867953c73564..6a883fafe3c77 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi
@@ -510,6 +510,7 @@
 			regulator-min-microvolt = <1200000>;
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l13b: ldo13 {
@@ -531,6 +532,7 @@
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l16b: ldo16 {
-- 
2.39.5



