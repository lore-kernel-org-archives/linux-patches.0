Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C314A14A09C;
	Tue, 23 Jan 2024 00:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969201; cv=none; b=BQfD63UAWcg2E3BOdPaYQG0EuuF4g5DzqM1UWOemuI6DHp8f1SqHhR7mosxwLzKwed9b8/d11OHJDcAJL2wRlzhSfvTqxxxqMqe8emneL8ObKi6RiiMaTrdfEUI2ge46wAVqXb+ed5ySLK5av1iVU/6j3V5Y62MirLb7AI1urqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969201; c=relaxed/simple;
	bh=Ljj6bdXYK4qSklYzfTA7bLBg4PYHb5j1Wd/UOc4h7u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptzDA6/hfYWl/tmozPw5ZQzqg6kf/6b5qyOHBjoY81wkXLbwoQvDtaJF36LE/ehJsUeHW8MU2ZjZZTSC28qvR9jSC4EoBG/z4r5B8j/z/DXEW2Xq1AKVwflFvTJVBJ8gtLAuSVVLKzz69MLgOB9wH1k3F8mCWlStV9Pa2O2ctWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8JJgyiS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8JJgyiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DEF7C433F1;
	Tue, 23 Jan 2024 00:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969201;
	bh=Ljj6bdXYK4qSklYzfTA7bLBg4PYHb5j1Wd/UOc4h7u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8JJgyiSm7xkwkjQjkIBehj/wgqfkdnayqupiXfp1elU/RtdUEGXj8vAaNYbBSx3h
	 lsFX9c5UlgXkp3pfumq2R2hrUeynoDNbpaabRjhWs6xluIzkXTU3xyX7xeQ0uRFcEt
	 LXa4KWDOHgWYstWq60982f+GYJ1AHhjk7lQhMAU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca@z3ntu.xyz>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 095/641] ARM: dts: qcom: msm8226: provide dsi phy clocks to mmcc
Date: Mon, 22 Jan 2024 15:49:59 -0800
Message-ID: <20240122235821.010816820@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca@z3ntu.xyz>

[ Upstream commit 836d083524888069cd358776a4e6c4ceec04962e ]

Some mmcc clocks have dsi0pll & dsi0pllbyte as clock parents so we
should provide them in the dt, which I missed in the commit adding the
mdss nodes.

Fixes: d5fb01ad5eb4 ("ARM: dts: qcom: msm8226: Add mdss nodes")
Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230712-msm8226-dsi-clock-fixup-v1-1-71010b0b89ca@z3ntu.xyz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom/qcom-msm8226.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/qcom/qcom-msm8226.dtsi b/arch/arm/boot/dts/qcom/qcom-msm8226.dtsi
index 97a377b5a0ec..5cd03ea7b084 100644
--- a/arch/arm/boot/dts/qcom/qcom-msm8226.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-msm8226.dtsi
@@ -442,8 +442,8 @@ mmcc: clock-controller@fd8c0000 {
 				 <&gcc GPLL0_VOTE>,
 				 <&gcc GPLL1_VOTE>,
 				 <&rpmcc RPM_SMD_GFX3D_CLK_SRC>,
-				 <0>,
-				 <0>;
+				 <&mdss_dsi0_phy 1>,
+				 <&mdss_dsi0_phy 0>;
 			clock-names = "xo",
 				      "mmss_gpll0_vote",
 				      "gpll0_vote",
-- 
2.43.0



