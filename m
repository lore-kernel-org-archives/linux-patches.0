Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A65375ACB;
	Wed, 20 May 2026 16:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295856; cv=none; b=AevD/V3ALw08ggQoB9/xifGNn01PJpDOvva9lUA4GyihyOLunYqt/HzBmIdhZKWRM9thvj9zminNSpAa2yTB6nkcuj1GYZGvOcj/PYP8YRwyUwRW/6Ke3nw6JAy16aL31Ox0uXbF0NMc/9u3VOWrXBePzX604DOeB4QCzrU3R88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295856; c=relaxed/simple;
	bh=NC8Ug3mBG82X9jvQMqmxdsT4MvAZgKa3tYvOdWetfFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DX07LQGZ2WQooXECbWNa+5MphY5Xpni1RCXZ2d8Nkx1ryNK6x4A+ef+6cCbzqeGlLdneUsRtKEO+9JlRqX9VW2iTateDqFEeXa5Gzucd02oa06TWwNFJDGXDYI6t7+mNzQ3QxZWxnr+IemR3OlHHHFNGD2+uiVFRVs9cLoFqtwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9YUD143; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9YUD143"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B641F000E9;
	Wed, 20 May 2026 16:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295855;
	bh=RS+eJP2dchyS2Y//aei01ioPAtjq+4VG3/sUlSJpWpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X9YUD143nFwl7bONEd6QH3qP81khJYUF3+dgwguZbbyIf0cBl5zJuwZc3Y6TTzIoD
	 8Mvow0yYauRlYLZ44zU1HpvVgkK67PZo0RTTEDzf3QooQIp05m7NSTJr34zay4e8Su
	 0J6f8pRkmE1H/BPLqRU69hls/zWmI7k5t9zsKLhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0561/1146] arm64: dts: qcom: milos: Add missing CX power domain to GCC
Date: Wed, 20 May 2026 18:13:31 +0200
Message-ID: <20260520162200.877799226@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit e46b48b853122626806d989d5db4ce97eaaac2ca ]

Unless CX is declared as the power-domain of GCC, votes (power and
performance) on the GDSCs it provides will not propagate to the CX,
which might result in under-voltage conditions.

Add the missing power-domains property to associate GCC with RPMHPD_CX.

Fixes: d9d59d105f98 ("arm64: dts: qcom: Add initial Milos dtsi")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260327-dt-fix-milos-eliza-gcc-power-domains-v1-2-f14a22c73fe9@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/milos.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/milos.dtsi b/arch/arm64/boot/dts/qcom/milos.dtsi
index 084be5316e0d5..098f9ceaa4f38 100644
--- a/arch/arm64/boot/dts/qcom/milos.dtsi
+++ b/arch/arm64/boot/dts/qcom/milos.dtsi
@@ -802,6 +802,8 @@ gcc: clock-controller@100000 {
 				 <0>, /* ufs_phy_tx_symbol_0_clk */
 				 <0>; /* usb3_phy_wrapper_gcc_usb30_pipe_clk */
 
+			power-domains = <&rpmhpd RPMHPD_CX>;
+
 			#clock-cells = <1>;
 			#reset-cells = <1>;
 			#power-domain-cells = <1>;
-- 
2.53.0



