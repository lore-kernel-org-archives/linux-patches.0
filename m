Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3076D43C7DF;
	Mon, 17 Aug 2026 13:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974671; cv=none; b=CHKj1UbP4MgULOz+XbiY7yGGgJ5q5dYSXBmVKR57t/hyqphVreFFernYt9milCBvhYyb6mHmG52FDMvu9IlksTu4S8pkG7eCBd96chNp3gQKZMLv3DT3ugLLwdBXld0AAGjAN0K4e7E/JneZH1IU3sZ/e+JYRySOBvF9p6euPtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974671; c=relaxed/simple;
	bh=VcxGjwoZXhyZ+hvRXIjm+rif/S+QGPfIDNUr/xWo6sU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LB9/CGuXIU2GebxturCR8UA3oqRF+iUsULwZ8TGBAQAe2yAE7Fj3ytJtsApBoV53OME+2t9HFiCXzcgJemDBTVI0QivOFIdRh+HzX9aM/0DEeedJdxAQl/Qf/NK0KRzT20Cgwty0BIFzfHSsUEn7qGtxGO8regeUHSQn+He3vlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHhX9OWU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHhX9OWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144AF1F00A3A;
	Mon, 17 Aug 2026 13:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974663;
	bh=3A6o7kn2IL11LmoH0S1b4XNTA50QcPFSqy2GvWDZ5oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FHhX9OWUkveii8/hn7U9SAjirEdd2Qnmin/gNSJ5eSBFTcOaxniUN+RXHlRxh4DKK
	 rkP0HWH9zjreSKpqPQcQKcM/Gio6NJleaaGlMM2M+/3fbIG7Vfx2XiPaw+3c3s/ggs
	 FVOY/z+ZUfd4I9wq6GRM0WFpX+CNc+FVd2zMIfIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 012/250] arm64: dts: qcom: sdm850-lenovo-yoga-c630: lower PSCI cluster idle
Date: Mon, 17 Aug 2026 15:29:33 +0200
Message-ID: <20260817132536.952816330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 07db10de262f4150e24fd631a7a6c428f7bf80c9 ]

With the default PSCI suspend value for cluster idle state Lenovo Yoga
C630 isn't stable enough. For example it might reset if display device
isn't probed early enough. Drop the bit 0x4000 from the PSCI suspend
value to make C630 work in stable way. The bit was found by
expertimenting with the cluster idle PSCI value. Most likely it results
in the less deep sleep and more energy beign spent in the suspend state,
but it's better than the non-stable system behaviour.

Fixes: a1ade6cac5a2 ("arm64: dts: qcom: sdm845: Switch PSCI cpu idle states from PC to OSI")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260429-c630-fix-idle-v2-1-ac867dad6f21@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
index 90efbb7e3799b..bead957cf83b4 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -347,6 +347,10 @@ &cdsp_pas {
 	status = "okay";
 };
 
+&cluster_sleep_0 {
+	arm,psci-suspend-param = <0x41008244>;
+};
+
 &gcc {
 	protected-clocks = <GCC_QSPI_CORE_CLK>,
 			   <GCC_QSPI_CORE_CLK_SRC>,
-- 
2.53.0



