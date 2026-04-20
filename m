Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31D049218D;
	Mon, 20 Apr 2026 13:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691935; cv=none; b=LGc8dJJWAYbTZte5Cmm4cL5OClhQx5edGMkeKfcoBoVHZmvYcZX4U9S0HRyVKrnTzFsOmHr1f7BjEdZH6sHDeRnHA+Oaup8v4xCYoS7b2oza4eLrv4Mdn/L4eloRlw9e/gGl7wWHC8VVw153+jwnORcHDc6xm74iS6Iyxn/sbms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691935; c=relaxed/simple;
	bh=zH+XapoQ+nsRLPDH7ug+1YBImNv/ttzA7g3bA3wdVXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cix9YX+WgpfgynHNFH6G+tUE0rooVtiX42JGfnPELqs9lxU1gSCe1Hwz5c5YXUD4aRoYBJ+Ubq4X6BOcfqiWBKlagYmcd0afEjVdIsrA1852cRTHfvbOAJm4uCFQocH/VicD5CBlmNG/HHjtqwhF3gvZ63LnzSlJNf3/8+TCSC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M40yHFyQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M40yHFyQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6AFC2BCB4;
	Mon, 20 Apr 2026 13:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691934;
	bh=zH+XapoQ+nsRLPDH7ug+1YBImNv/ttzA7g3bA3wdVXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M40yHFyQI87rxlDZKUpoU8845PCaKcK2q/DH1XQHMbUeF6s924G5mzAsvuJfA5JlK
	 lllmCmWVHdMwn1T/P8oPqZQo73gcMdOQNpBCjlGAsTCBIU6WJRYwGzYfxtj1Aby71K
	 8OslIPH4fA0qBHv5h3jhtbC/0z0vveJgBleb/5hqwUSTYRrhRQSccfXFKTJJFMuZK4
	 TkhF7D2mv750ZSxVROcRtE+8RHRMNiURasKWXQjtCkHftUgUlmiKWhMNG3n6jDgBkk
	 7+hdSjBoiEfAlafEoIfM4aTALq60BdTnHBhcqG7DwPtO6EUdfwyKmFX1ksN1lucxrD
	 m2aXUY/tgpgTA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	konradybcio@kernel.org,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	quic_msavaliy@quicinc.com,
	quic_vdadhani@quicinc.com,
	linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] arm64: dts: qcom: monaco: Fix UART10 pinconf
Date: Mon, 20 Apr 2026 09:21:12 -0400
Message-ID: <20260420132314.1023554-278-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Loic Poulain <loic.poulain@oss.qualcomm.com>

[ Upstream commit 5b2a16ab0dbd090dc545c05ee79a077cc7a9c1e0 ]

UART10 RTS and TX pins were incorrectly mapped to gpio84 and gpio85.
Correct them to gpio85 (RTS) and gpio86 (TX) to match the hardware
I/O mapping.

Fixes: 467284a3097f ("arm64: dts: qcom: qcs8300: Add QUPv3 configuration")
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260202155611.1568-1-loic.poulain@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 arch/arm64/boot/dts/qcom/qcs8300.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs8300.dtsi b/arch/arm64/boot/dts/qcom/qcs8300.dtsi
index 8d78ccac411e4..b8d4a75baee22 100644
--- a/arch/arm64/boot/dts/qcom/qcs8300.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs8300.dtsi
@@ -5430,12 +5430,12 @@ qup_uart10_cts: qup-uart10-cts-state {
 			};
 
 			qup_uart10_rts: qup-uart10-rts-state {
-				pins = "gpio84";
+				pins = "gpio85";
 				function = "qup1_se2";
 			};
 
 			qup_uart10_tx: qup-uart10-tx-state {
-				pins = "gpio85";
+				pins = "gpio86";
 				function = "qup1_se2";
 			};
 
-- 
2.53.0

