Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57091337110;
	Fri, 17 Oct 2025 15:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715233; cv=none; b=titFBLAWpbiEkR6ju1gf8CSoUbreGRtJcGvbwhSgOM9mMqrOwzdDJho8w+QR5AmLm86Q7olf8mssE6wfzHpxw9vMnQrHieawh4V7/mM6sw6MuVURddrOT/6Megf29O9Sqxt6YI2YQ7oppdSm5dC4hSSh1EuJZIzyQUqrN62RI4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715233; c=relaxed/simple;
	bh=v6PECsREVZo8FLzo/oVjq3F5wT4BudU9ZP54SYay4BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9a6uGBdLslA4nOTkxgsJ/vOHOQ4lRVNudjhpKofK4fUoanKd4cpmx1ydpVh1ZFkUXPutsF/qYkWnXW1+9mBhd+6VVb8udu3Y9Ai9lwWRGPZVufY7eDnDAo470STS+V8vR/xvkIv+85wj4IRRzcP4ktXtVSw3CsA09tcBIpw7zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aq2j5iL3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aq2j5iL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E94C4CEFE;
	Fri, 17 Oct 2025 15:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715233;
	bh=v6PECsREVZo8FLzo/oVjq3F5wT4BudU9ZP54SYay4BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aq2j5iL3k+tpzB8VEm27proKMPwCSWgpJZeDVSEm8X4281Tj5H/vJvbE5zriJgq2V
	 rVTHcbTRz4yU89jqcnGgwOXLEsG7mdJcJf1pjkHpLPzAu+UACeBbNk3YOX6JrcKJQa
	 lJUihX5H3Q/Moi7tCZR5uv3i/0hgYYSemaVB1sFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.17 144/371] arm64: dts: qcom: sdm845: Fix slimbam num-channels/ees
Date: Fri, 17 Oct 2025 16:51:59 +0200
Message-ID: <20251017145207.145008683@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit 316294bb6695a43a9181973ecd4e6fb3e576a9f7 upstream.

Reading the hardware registers of the &slimbam on RB3 reveals that the BAM
supports only 23 pipes (channels) and supports 4 EEs instead of 2. This
hasn't caused problems so far since nothing is using the extra channels,
but attempting to use them would lead to crashes.

The bam_dma driver might warn in the future if the num-channels in the DT
are wrong, so correct the properties in the DT to avoid future regressions.

Cc: stable@vger.kernel.org
Fixes: 27ca1de07dc3 ("arm64: dts: qcom: sdm845: add slimbus nodes")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250821-sdm845-slimbam-channels-v1-1-498f7d46b9ee@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -5404,11 +5404,11 @@
 			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
 			qcom,controlled-remotely;
 			reg = <0 0x17184000 0 0x2a000>;
-			num-channels = <31>;
+			num-channels = <23>;
 			interrupts = <GIC_SPI 164 IRQ_TYPE_LEVEL_HIGH>;
 			#dma-cells = <1>;
 			qcom,ee = <1>;
-			qcom,num-ees = <2>;
+			qcom,num-ees = <4>;
 			iommus = <&apps_smmu 0x1806 0x0>;
 		};
 


