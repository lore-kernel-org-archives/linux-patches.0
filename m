Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80329221703;
	Mon,  2 Jun 2025 13:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872147; cv=none; b=IooUMVmUgOgCEvOofbicsuxP3ei1f43+vD/iqtXRLUnUQaDLxZ5t7/wbjgp94XCjZIknFsQd7Tjx97KYQijEnTYaBaubt3oAy31FcDEZXR6Mzgm7qc2sWO/6UUaadd078OXk2RzO9gkU7257hPdVhEXWnsp0VwC3BGDe33ukJIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872147; c=relaxed/simple;
	bh=zHao4m32PlPKSIW3K/UCQwajjz4s5ZABu9Y280edmkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKnwByRRiAfUDRyjDw80ZFaPOmcFcod7I9p8kEQin3uwylNuDTVNIPZf+ASS3UrdKoWRU46AJFX8mSaTfFivW27OCS63CNne4+m3PneC4BTG/b268Jl68m5XSzarhkLMIVMxlrWkYd1BrPQlJI9EP4SU+SKY/+4R/ekTOVODab8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vnznfev1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vnznfev1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305CBC4CEEB;
	Mon,  2 Jun 2025 13:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872146;
	bh=zHao4m32PlPKSIW3K/UCQwajjz4s5ZABu9Y280edmkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vnznfev1roFTvktAfLFe8L4MYuZ4GsFKc/P9YOPkFYie1xvooxCtMJjfjk6CgEYNx
	 NZE0v2d2Bb2oMzKGCfSo8vdvQyzRjwoto+GQc0bI2pBKHu6ycl16IxQY4OU8HG4u2d
	 NvUNZWEfqxhO7cHBBZO8H5+M+msKqBp/LTsW76rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Md Sadre Alam <quic_mdalam@quicinc.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.15 04/49] arm64: dts: qcom: ipq9574: Add missing properties for cryptobam
Date: Mon,  2 Jun 2025 15:46:56 +0200
Message-ID: <20250602134238.114395162@linuxfoundation.org>
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

commit b4cd966edb2deb5c75fe356191422e127445b830 upstream.

num-channels and qcom,num-ees are required for BAM nodes without clock,
because the driver cannot ensure the hardware is powered on when trying to
obtain the information from the hardware registers. Specifying the node
without these properties is unsafe and has caused early boot crashes for
other SoCs before [1, 2].

Add the missing information from the hardware registers to ensure the
driver can probe successfully without causing crashes.

[1]: https://lore.kernel.org/r/CY01EKQVWE36.B9X5TDXAREPF@fairphone.com/
[2]: https://lore.kernel.org/r/20230626145959.646747-1-krzysztof.kozlowski@linaro.org/

Cc: stable@vger.kernel.org
Tested-by: Md Sadre Alam <quic_mdalam@quicinc.com>
Fixes: ffadc79ed99f ("arm64: dts: qcom: ipq9574: Enable crypto nodes")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Link: https://lore.kernel.org/r/20250212-bam-dma-fixes-v1-6-f560889e65d8@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/ipq9574.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/ipq9574.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq9574.dtsi
@@ -378,6 +378,8 @@
 			interrupts = <GIC_SPI 207 IRQ_TYPE_LEVEL_HIGH>;
 			#dma-cells = <1>;
 			qcom,ee = <1>;
+			qcom,num-ees = <4>;
+			num-channels = <16>;
 			qcom,controlled-remotely;
 		};
 


