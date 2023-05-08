Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3DB168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8699AC433D2;
	Mon,  8 May 2023 11:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543999;
	bh=/udD4aTSZTEpOkzkEGL8WCi98hBZUSpxZmWWW8RqDec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CKR0OxKNH4GWTF3tvDt9+Wd6tN/EN5gA9C6cCV+quJS97NUBzVfn6QlH7F0i2aRD4
	 tZyl+wqDjuHHMBvO9/a6BO4OwvBPQ9vxIOnAYYSmmncPsSAeqs0aWYi6bhGrckPrAV
	 SS3ueOkwqdn9lD/pzgDX44i9b1caHW90vEsMnueo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vorel <pvorel@suse.cz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 269/694] arm64: dts: qcom: msm8994-angler: removed clash with smem_region
Date: Mon,  8 May 2023 11:41:44 +0200
Message-Id: <20230508094440.993217488@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Petr Vorel <pvorel@suse.cz>

[ Upstream commit c85c8a992794dfcd7cea7a41871710c27c5592a6 ]

This fixes memory overlap error:
[    0.000000] reserved@6300000 (0x0000000006300000--0x0000000007000000) overlaps with smem_region@6a00000 (0x0000000006a00000--0x0000000006c00000)

smem_region is the same as in downstream (qcom,smem) [1], therefore
split reserved memory into two sections on either side of smem_region.

Not adding labels as it's not expected to be used.

[1] https://android.googlesource.com/kernel/msm/+/refs/heads/android-msm-angler-3.10-marshmallow-mr1/arch/arm/boot/dts/qcom/msm8994.dtsi#948

Fixes: 380cd3a34b7f ("arm64: dts: msm8994-angler: fix the memory map")

Signed-off-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230131200414.24373-3-pvorel@suse.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi          | 5 -----
 arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts | 4 ++--
 arch/arm64/boot/dts/qcom/msm8994.dtsi                      | 5 +++++
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
index cd77dcb558722..b8f2a01bcb96c 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
@@ -60,11 +60,6 @@
 			reg = <0x0 0x05000000 0x0 0x1a00000>;
 			no-map;
 		};
-
-		reserved@6c00000 {
-			reg = <0x0 0x06c00000 0x0 0x400000>;
-			no-map;
-		};
 	};
 };
 
diff --git a/arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts
index 59b9ed78cf0cb..29e79ae0849d8 100644
--- a/arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts
@@ -41,8 +41,8 @@
 			no-map;
 		};
 
-		removed_region: reserved@6300000 {
-			reg = <0 0x06300000 0 0xD00000>;
+		reserved@6300000 {
+			reg = <0 0x06300000 0 0x700000>;
 			no-map;
 		};
 	};
diff --git a/arch/arm64/boot/dts/qcom/msm8994.dtsi b/arch/arm64/boot/dts/qcom/msm8994.dtsi
index 9ff9d35496d21..24c3fced8df71 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -228,6 +228,11 @@
 			reg = <0 0xc9400000 0 0x3f00000>;
 			no-map;
 		};
+
+		reserved@6c00000 {
+			reg = <0 0x06c00000 0 0x400000>;
+			no-map;
+		};
 	};
 
 	smd {
-- 
2.39.2



