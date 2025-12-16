Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B193659E6;
	Tue, 16 Dec 2025 12:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887018; cv=none; b=nrD5ObOz8JLlvtYCEnwHA1VdEYhUVTwZHfAc2NxmiGJFdFnm6ONvYXv3/q+r1k7s5dyYxXHq0FKcgCRajvW0sAerueMBS/b3A3fbhWT3aMXjTzOkAf8Ebnf5ZxnktltEqDJs+38UmWshF41LX6xeGco22rECFTINSpHNGv1N2Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887018; c=relaxed/simple;
	bh=gT7Y3/zXuacWk8vs8IuYk+/3JuzWKtZy4MBOsgMb80E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmjMfABloN9RjyRVIqyNGoELlJv45MoGYAPErrmr9C6gjYVwtbMNxEicHi55Qaukjkn1cOHK2QL/+ZvGGcLYAkFrYxM42+b73x0uD54lQuNHGKbXsbaHKZ/SYHUromVkdkKQAYXLt/j22Fhgi9VGjsIdZaoM4lJqgomnYlRimlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQHzPIbS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQHzPIbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC4BC4CEF1;
	Tue, 16 Dec 2025 12:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887018;
	bh=gT7Y3/zXuacWk8vs8IuYk+/3JuzWKtZy4MBOsgMb80E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQHzPIbSoUl3vs278OtVHy9mx7DpS2FxPS/7/3pSHLgXwG+H6J9ge0quTnq2Pp2AS
	 UnyDL0jOQBr2Z7F3U+Sc93m7cKpbajimifQJ1lcJ6e+wUfvq09XVeY0EjbkxoelqnO
	 OjFqr2Wn0rcAGcgprypdFL2HTkA29HmIqLtoICFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 059/614] arm64: dts: qcom: ipq5424: correct the TF-A reserved memory to 512K
Date: Tue, 16 Dec 2025 12:07:06 +0100
Message-ID: <20251216111403.449763758@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>

[ Upstream commit 28803705b552a0a711fa849490f14dca2bc5296e ]

Correct the reserved memory size for TF-A to 512K, as it was mistakenly
marked as 500K. Update the reserved memory node accordingly.

Fixes: 8517204c982b ("arm64: dts: qcom: ipq5424: Add reserved memory for TF-A")
Signed-off-by: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251014-tfa-reserved-mem-v1-1-48c82033c8a7@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq5424.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq5424.dtsi b/arch/arm64/boot/dts/qcom/ipq5424.dtsi
index ef2b52f3597d9..227d5ce297515 100644
--- a/arch/arm64/boot/dts/qcom/ipq5424.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq5424.dtsi
@@ -213,7 +213,7 @@ smem@8a800000 {
 		};
 
 		tfa@8a832000 {
-			reg = <0x0 0x8a832000 0x0 0x7d000>;
+			reg = <0x0 0x8a832000 0x0 0x80000>;
 			no-map;
 			status = "disabled";
 		};
-- 
2.51.0



