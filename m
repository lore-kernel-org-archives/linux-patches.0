Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5671DDC11;
	Wed, 19 Feb 2025 09:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956371; cv=none; b=I8Z1jIDlsK8xVd2DlHDwXkL9YbHfoCAb9Of2t/jqPzrPp5D1LQQXAhay08gFctU55kF6Y+yYPC+tkOvlE9WUPCxMrpQPEzMOWZo8fHWZc2QlbTe/+PELj1rFRH4fc0+miG5V1iT4r34pZ83QYTbmZn40LrYNvbyonypvnPTxJsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956371; c=relaxed/simple;
	bh=Hb+lzXNh0GtWBOQAR/hr1hQUX+LVM2VpdI/f7BaOLhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeXCWd2OJSL1IQJwTF/lNnDqhrJxSY8YUJjC9ozWwMXINIS0g3/hzUFPeLsM/HXRhHsZenjA6TD7XgnpVEIQ3aRKo8LPFA70/d9n2FNCO29zL3UGXan7vxTBbB+K1fmjnEiCD338GFmkxMrdQu/deU9BX+RvVaeATI2ys+Qver0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nG0yvcN8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nG0yvcN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E27FC4CED1;
	Wed, 19 Feb 2025 09:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956371;
	bh=Hb+lzXNh0GtWBOQAR/hr1hQUX+LVM2VpdI/f7BaOLhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nG0yvcN8wMscbrhQZ22n6jWis5AS2K6VrgcOyGpjWT+DKAYjn6Q08uDwnRpXlM2x8
	 d/+Bg4RssZoJVljiSeZDZNezOJSzZq5mb0bwaYGF44cyCbapQ/t0dl1e5H2Rm2kWVZ
	 0GDN06ALNsrjvG/UQ5apPQ6dRc2aJWMXjqpxRo64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 157/578] arm64: dts: qcom: msm8916: correct sleep clock frequency
Date: Wed, 19 Feb 2025 09:22:41 +0100
Message-ID: <20250219082659.150087857@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit f088b921890cef28862913e5627bb2e2b5f82125 ]

The MSM8916 platform uses PM8916 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: f4fb6aeafaaa ("arm64: dts: qcom: msm8916: Add fixed rate on-board oscillators")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-1-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index 987cebbda0571..571ed1abdad4f 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -109,7 +109,7 @@
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-			clock-frequency = <32768>;
+			clock-frequency = <32764>;
 		};
 	};
 
-- 
2.39.5



