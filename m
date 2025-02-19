Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E181DE3CE;
	Wed, 19 Feb 2025 09:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956380; cv=none; b=bJFFxKQi7RB95SnmtxxmQbk4dNbl1RD2/7FhtQWgNy3NkxA+o3OpAXdoJeQHUYKMMAbnwA13ybxfYfdjihwjvgi1ME2iN9RO1D+6wC/XCX5wdsaYC6gI6lORJWcwdMv1R2GT9JmzBEaiuSVHHm09yS4WlTSyETU6KpsuaDz4n94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956380; c=relaxed/simple;
	bh=kwTCWnETlPn8NyOUCBBH0Gy7yWRPBIpMeW5lbw0DwPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxoWkMarDJL87nRaX1FiUzb8wZB2NljmeObWSduthtPAB4k6Yn0OLoT/0OmX2L6T7vZKBfLtfRs+Yf7Wla8tjYtA11m2H7/C8ntA0r40FsAn0OoMuGbl3KfvXtKZeo3Q1AlhuilJV2hX0ALC391cVtGf8zUXLO3MnOCWP046mik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vvrxd0b+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vvrxd0b+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB62CC4CED1;
	Wed, 19 Feb 2025 09:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956380;
	bh=kwTCWnETlPn8NyOUCBBH0Gy7yWRPBIpMeW5lbw0DwPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vvrxd0b+ZhClZzE5HOdRk6LIkAosci+3WhEouayPw7EYRYEgKRmqdjadTxT9pvY+3
	 pLIdCJy1QDHzb/+VRHq3BFefgTjhRC0Gdo+NZvokJ4lihjTfm886SXhMwPKWG2m+dX
	 kWP/sx4eplSzgV2q2UcJzu2BYNC2arqES5jEfqjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/578] arm64: dts: qcom: sm6125: correct sleep clock frequency
Date: Wed, 19 Feb 2025 09:22:44 +0100
Message-ID: <20250219082659.265195427@linuxfoundation.org>
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

[ Upstream commit b3c547e1507862f0e4d46432b665c5c6e61e14d6 ]

The SM6125 platform uses PM6125 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: cff4bbaf2a2d ("arm64: dts: qcom: Add support for SM6125")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-11-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6125.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6125.dtsi b/arch/arm64/boot/dts/qcom/sm6125.dtsi
index 271247b371759..a3876a322baa0 100644
--- a/arch/arm64/boot/dts/qcom/sm6125.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6125.dtsi
@@ -27,7 +27,7 @@
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			clock-output-names = "sleep_clk";
 		};
 	};
-- 
2.39.5



