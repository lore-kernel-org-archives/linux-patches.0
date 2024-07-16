Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388551DA4D;
	Tue, 16 Jul 2024 15:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144940; cv=none; b=WJWL76yEmQI9H8mR9YGE6NS6OR94fOZgkfX3F2ai4eNEYorMf+sjzk+Qy5Ny9uSkIictNQYJfCk4oV6SzKVJztVyaLeo7nzm8JtNE78uuHQcGACAZ9RA0O5ofO7J3FNc9qpXYmzUyGnJe3g2bQBRGCbqo21rDcurxujjjnxs464=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144940; c=relaxed/simple;
	bh=DYKM5vQLlSJhaQ7mX32GPq1fjehk/2popHhEgM/Ki34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGISKSwueAaNbYgWZ030n9IAWNzfOkkC2e8JOrWaPwOyGKvB7XsWToWM0Ua1z40xcrxbhM/vVB6tWmAEYIQ7ZxIAGiuhi5VC/m/nqs2EPQU6jPerMCUdFEZFefI5ltZzFOI99neCmnm0lisPOu1MnWvpAG8QUFYd49WaWm2rMgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qpj1BFYA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qpj1BFYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1614C116B1;
	Tue, 16 Jul 2024 15:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144940;
	bh=DYKM5vQLlSJhaQ7mX32GPq1fjehk/2popHhEgM/Ki34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qpj1BFYAxAzXAYn/hmQszP6FC+hpIXt1DyJvVhBdg1v7kHvjIcB/PXjPUcnSbRlFk
	 uk+kQmCizkSUetPym5r/fDgXot/vcVJqy0PEyFd/rkU3aJc4ndl3ybFLEDoWyOK3Cd
	 weJJ2yFnrWtMTQuJt3716DlDJY9zW06Ob5etpChE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 046/143] arm64: dts: qcom: x1e80100-*: Allocate some CMA buffers
Date: Tue, 16 Jul 2024 17:30:42 +0200
Message-ID: <20240716152757.759305232@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 50b0516030fd549c9fd4498c9ac1f3a665521b2e ]

In a fashion identical to commit 5f84c7c35d49 ("arm64: dts: qcom:
sc8280xp: Define CMA region for CRD and X13s"), there exists a need for
more than the default 32 MiB of CMA, namely for the ath12k_pci device.

Reserve a 128MiB chunk to make boot-time failures like:
 cma: cma_alloc: reserved: alloc failed, req-size: 128 pages, ret: -12
go away.

Fixes: af16b00578a7 ("arm64: dts: qcom: Add base X1E80100 dtsi and the QCP dts")
Fixes: bd50b1f5b6f3 ("arm64: dts: qcom: x1e80100: Add Compute Reference Device")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240522-topic-x1e_cma-v1-1-b69e3b467452@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts | 9 +++++++++
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts | 9 +++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-crd.dts b/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
index 6a0a54532e5fe..5cc627c11b13a 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
@@ -48,6 +48,15 @@
 		stdout-path = "serial0:115200n8";
 	};
 
+	reserved-memory {
+		linux,cma {
+			compatible = "shared-dma-pool";
+			size = <0x0 0x8000000>;
+			reusable;
+			linux,cma-default;
+		};
+	};
+
 	sound {
 		compatible = "qcom,x1e80100-sndcard";
 		model = "X1E80100-CRD";
diff --git a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
index e76d29053d79b..49e19a64455b8 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
@@ -22,6 +22,15 @@
 		stdout-path = "serial0:115200n8";
 	};
 
+	reserved-memory {
+		linux,cma {
+			compatible = "shared-dma-pool";
+			size = <0x0 0x8000000>;
+			reusable;
+			linux,cma-default;
+		};
+	};
+
 	vph_pwr: vph-pwr-regulator {
 		compatible = "regulator-fixed";
 
-- 
2.43.0



