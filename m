Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E1B241666;
	Thu, 13 Feb 2025 14:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458079; cv=none; b=LiIgaJFLHAVJPAcBlomXGhlX/AH//h51sWe44qo2y8QiLIR5mCrPY69oOk5wIF6slufA7BVB2+fI26V99Xndh3N+qxNM4tA5ozzsGjR/VdgDwslVczWp/AIpCjIAPWCgyhNs8gOzYdMq9OtNxQBAlgMw4ckQf/dMI/sguNI3GvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458079; c=relaxed/simple;
	bh=Ce4ASTbllAdK0DDe2CgN7n2VMnOn5/yoBzGKC7RWaI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHYtJw9rf/cFO0s19BSHKqMdWyF5ArKPtjvZLSubEi8EruLB2N/7GxYvcWyDKrHw+zWg6EzdnYP2kWZc7GsTVdLKawaZXCMVCT4JD9zfxIVNB8nDbdf6IsTbxgBH3/4YYMFvm7l8xiBjHrjgqdm7tkOOL8w+xM9Jr8qwYuhGHQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f/zs7rKw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f/zs7rKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4018BC4CED1;
	Thu, 13 Feb 2025 14:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458079;
	bh=Ce4ASTbllAdK0DDe2CgN7n2VMnOn5/yoBzGKC7RWaI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f/zs7rKwTl4pMz/I+GIYhNHcAc148npzsJvKfI9zmLlrZsja91o2iCvdcngy15jWS
	 acI52xLXdrsyCGvD9hpxgyFOQxWwOClXVQLrjeakozpxXZRifhF840jcUvpmNYj7AX
	 UrKDMP5szWGRmLjeYOvJmY3NC8y49piLDXR8y1Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 294/422] arm64: dts: qcom: sm8650: correct MDSS interconnects
Date: Thu, 13 Feb 2025 15:27:23 +0100
Message-ID: <20250213142447.888491286@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit 9fa33cbca3d2842f1f47ed4e5f6574e611dae32b upstream.

SM8650 lists two interconnects for the display subsystem, mdp0-mem
(between MDP and LLCC) and mdp1-mem (between LLCC and EBI, memory).
The second interconnect is a misuse. mdpN-mem paths should be used for
several outboud MDP interconnects rather than the path between LLCC and
memory. This kind of misuse can result in bandwidth underflows, possibly
degrading picture quality as the required memory bandwidth is divided
between all mdpN-mem paths (and LLCC-EBI should not be a part of such
division).

Drop the second path and use direct MDP-EBI path for mdp0-mem until we
support separate MDP-LLCC and LLCC-EBI paths.

Fixes: 10e024671295 ("arm64: dts: qcom: sm8650: add interconnect dependent device nodes")
Cc: stable@kernel.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241026-fix-sm8x50-mdp-icc-v2-2-fd8ddf755acc@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -3603,11 +3603,8 @@
 			resets = <&dispcc DISP_CC_MDSS_CORE_BCR>;
 
 			interconnects = <&mmss_noc MASTER_MDP QCOM_ICC_TAG_ALWAYS
-					 &gem_noc SLAVE_LLCC QCOM_ICC_TAG_ALWAYS>,
-					<&mc_virt MASTER_LLCC QCOM_ICC_TAG_ALWAYS
 					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>;
-			interconnect-names = "mdp0-mem",
-					     "mdp1-mem";
+			interconnect-names = "mdp0-mem";
 
 			power-domains = <&dispcc MDSS_GDSC>;
 


