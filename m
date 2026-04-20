Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4002D77E5;
	Mon, 20 Apr 2026 15:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700132; cv=none; b=ujWWwn4OuitzVLnqOrPZFwh98xUt/B4VOqowYYGq8azD6R02FRZI+YzpWRBb+52/D4sR6OUiKRG0kF/lWKr3oh/W2BR+7VGLoZDukmilXXE0eBlxEN2K2Yw1P0OMGxqR8RS7AIh9vaKekkRdh+JCEe8qAl3oXVUP9+qWjsyZFLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700132; c=relaxed/simple;
	bh=7rxUVTAstHeZTfX5oJ+Na2iwZPNJ/NxfWY+cvbMkcG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clIRM0ujTQxAwzBYJNEshLFv0bvOlFCGUfkdvKWGMCgvUJ+VQ+9vC31ERE+kcuQY7OaQELD0fJwLnPtvgEsYgrb6JJLUS7v/N2QbwV2W86FKvIwhZulSElu5Ea7DXRaOed+PfKtpPqgpL58bjaLnYmuUxuaPQ7T1BvhhfS0wke0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RdT+1mgI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RdT+1mgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEC5C19425;
	Mon, 20 Apr 2026 15:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700132;
	bh=7rxUVTAstHeZTfX5oJ+Na2iwZPNJ/NxfWY+cvbMkcG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RdT+1mgIubrQfUgqLJCcOu6DHUwBcVjZRnmTVKL8m/nVVStaGL3QfYGw8ggIwzMfm
	 1vNHI7Y2kHhj/5mQzy2OrdiJZEOp2T9DylSj4LvknTe65FCAOCyo8y+4rUmZtnchTZ
	 ZqH239zswgo9/tfiWXci3Np6auYfr9+LArqTID6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 054/220] arm64: dts: qcom: monaco: Fix UART10 pinconf
Date: Mon, 20 Apr 2026 17:39:55 +0200
Message-ID: <20260420153935.985381247@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 arch/arm64/boot/dts/qcom/monaco.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/monaco.dtsi b/arch/arm64/boot/dts/qcom/monaco.dtsi
index 816fa2af8a9a6..f74045be62420 100644
--- a/arch/arm64/boot/dts/qcom/monaco.dtsi
+++ b/arch/arm64/boot/dts/qcom/monaco.dtsi
@@ -5437,12 +5437,12 @@ qup_uart10_cts: qup-uart10-cts-state {
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



