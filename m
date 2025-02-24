Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4BF18A95E;
	Mon, 24 Feb 2025 14:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407923; cv=none; b=BydokzAbb7I6EdokILVuvBhI1D2XnGCEbcWVL6KIgDZ4AJ2QJkIxTJgZuRM0JAzYNAbL7WJlSxqFJ9Kwi1o6eu7uU4j3cCK7KMumpCaN+DIhC5KWNpyoMfB/cRas96yEndFh3zeMvgbUhts98I/sXykOWOQG9uqwST19eaVOAL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407923; c=relaxed/simple;
	bh=6cimDX7seyBQ4u4Zhamw2x9IllH3UcIx55CBpoJFUpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMf5OG811HMN6C6DjONq0Ff/ioHAHk/tLtQngZNnsNWKdp67rNfAaW75qHBJ37fcT9bimffMQFZj8hoBHP/dDvTQ9uZIYnqq7dWF+ktPZ+ZWfmyHLVAN9KfsVI53638mNUSiHlms4096HH1SdYRBlC61zhKnKqq3Cklx+ef/o3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ww4QJW8e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ww4QJW8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A148C4CED6;
	Mon, 24 Feb 2025 14:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407923;
	bh=6cimDX7seyBQ4u4Zhamw2x9IllH3UcIx55CBpoJFUpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ww4QJW8erwsznOvIGORAWMBdFqZoas0qn+vlXFSDbIldG/1Fm2FTcF254H0JDcPhk
	 RSk+kdtz1+vdNy73B5eiCJq1fg8T7u657ruNqn3B3yMjmhQBHIY6LbVdu0F2GLhnCK
	 NKYTaiQ6hx0U+W3UtbJEAq7Sz6hiPDVyKnmTrEys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/140] arm64: dts: qcom: sm8450: add missing qcom,non-secure-domain property
Date: Mon, 24 Feb 2025 15:34:07 +0100
Message-ID: <20250224142604.901321244@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 033fbfa0eb60e519f50e97ef93baec270cd28a88 ]

By default the DSP domains are non secure, add the missing
qcom,non-secure-domain property to mark them as non-secure.

Fixes: 91d70eb70867 ("arm64: dts: qcom: sm8450: add fastrpc nodes")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240227-topic-sm8x50-upstream-fastrpc-non-secure-domain-v1-1-15c4c864310f@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 13c96bee5d5e ("arm64: dts: qcom: sm8450: Fix ADSP memory base and length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 2a49a29713752..fb0162e65a38c 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -2135,6 +2135,7 @@
 					compatible = "qcom,fastrpc";
 					qcom,glink-channels = "fastrpcglink-apps-dsp";
 					label = "sdsp";
+					qcom,non-secure-domain;
 					#address-cells = <1>;
 					#size-cells = <0>;
 
@@ -2449,6 +2450,7 @@
 					compatible = "qcom,fastrpc";
 					qcom,glink-channels = "fastrpcglink-apps-dsp";
 					label = "adsp";
+					qcom,non-secure-domain;
 					#address-cells = <1>;
 					#size-cells = <0>;
 
@@ -2515,6 +2517,7 @@
 					compatible = "qcom,fastrpc";
 					qcom,glink-channels = "fastrpcglink-apps-dsp";
 					label = "cdsp";
+					qcom,non-secure-domain;
 					#address-cells = <1>;
 					#size-cells = <0>;
 
-- 
2.39.5



