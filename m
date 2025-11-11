Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF04124E4C6;
	Tue, 11 Nov 2025 01:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822932; cv=none; b=YwMOX0IkPyXJXkUsXlpufroHGKDg2djCqmTAi3z/rsLZCSkqTERSg1Y5GCv25nnNIIsOihhb7CpS8JmYVU25qJbeS92ouwTg29r9haOnC+RbETYDcc1HcORhs/0caNzCHsZfLVb+7OCJSHUw7++DHp+FQsyB5SRavFzS3zBzVtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822932; c=relaxed/simple;
	bh=efq1Ok5b0v0oiZZuo3rkJADVv2ZAKydYkgVH9WNAdHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g43pSs26tu1dge3wVpFzhUv7Gd9Z7h9lTUJevkyG+J+5bNM3BWrDMsIfDXb8Ld8W20I/PQJiZEOpveuoowypJYgesJDROm2fxGc1wfoPE/UcFlNW3fv5iopo1+TNpSeEOCG38XCkxWui2Tme7dRBhglN6V2C3qFtvrvSHOQO54Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHbe96zf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHbe96zf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB4EC116B1;
	Tue, 11 Nov 2025 01:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822931;
	bh=efq1Ok5b0v0oiZZuo3rkJADVv2ZAKydYkgVH9WNAdHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHbe96zfPeaewkahbWKI6s5OcUCc1/MZTe6V1FKSDvYlJzrFOxxUn93lrWJrABiNF
	 0HgFtOvrphcz2/fhHhTJmIf+Xthw6Flk97IVSifDh53E7IsxqdxzMb71Y9/vsS+RLs
	 XPwCBDOXgOoLFPkwhLRsU7jEnQ1If+a81vusnNmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quanyang Wang <quanyang.wang@windriver.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 167/849] arm64: zynqmp: Disable coresight by default
Date: Tue, 11 Nov 2025 09:35:37 +0900
Message-ID: <20251111004540.471754484@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quanyang Wang <quanyang.wang@windriver.com>

[ Upstream commit 0e3f9140ad04dca9a6a93dd6a6decdc53fd665ca ]

When secure-boot mode of bootloader is enabled, the registers of
coresight are not permitted to access that's why disable it by default.

Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Signed-off-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/7e308b8efe977c4912079b4d1b1ab3d24908559e.1756799774.git.michal.simek@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
index e11d282462bd3..23d867c03263d 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -550,6 +550,7 @@
 			reg = <0x0 0xfec10000 0x0 0x1000>;
 			clock-names = "apb_pclk";
 			cpu = <&cpu0>;
+			status = "disabled";
 		};
 
 		cpu1_debug: debug@fed10000 {
@@ -557,6 +558,7 @@
 			reg = <0x0 0xfed10000 0x0 0x1000>;
 			clock-names = "apb_pclk";
 			cpu = <&cpu1>;
+			status = "disabled";
 		};
 
 		cpu2_debug: debug@fee10000 {
@@ -564,6 +566,7 @@
 			reg = <0x0 0xfee10000 0x0 0x1000>;
 			clock-names = "apb_pclk";
 			cpu = <&cpu2>;
+			status = "disabled";
 		};
 
 		cpu3_debug: debug@fef10000 {
@@ -571,6 +574,7 @@
 			reg = <0x0 0xfef10000 0x0 0x1000>;
 			clock-names = "apb_pclk";
 			cpu = <&cpu3>;
+			status = "disabled";
 		};
 
 		/* GDMA */
-- 
2.51.0



