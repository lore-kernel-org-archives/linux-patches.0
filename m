Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF10E8F54;
	Tue, 17 Jun 2025 16:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177993; cv=none; b=qE2yKpvrkKRR6Qj4801NoI8GvUOHOZ5UYlWSv7YfA7WZJar9+ykOJJurZGPT+xZQyGy54Dej7TnZGlWtOyeggnYCsoZ9W/ZF9T2d65xQi4gs8uykoSBP5JnxgBiA7K/5fv7iOJK/D34it647mFTUH3Y+QcGvzfTh3bwyhPmvwzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177993; c=relaxed/simple;
	bh=YQdVr+tzRVXkDJG1xkRSGGmOAnwovA88YV/xcd6pUHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avBqqGVZrN6G1CEIsKFERnmhpyMkPvZ+JGyTH2eS6GxIOF9utiPx/YgWuvVmHpou4TM39cH5SVCmkEiewFD5ws9+AI7pBxneZqf9Vg14UOCph2TadY1poZc32HQvblnZtXlF2Y3Osf5FamvScEgAN2oxftfBYQMemMqmxNlOFms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HsA8ab2T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HsA8ab2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB1DC4CEE3;
	Tue, 17 Jun 2025 16:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177993;
	bh=YQdVr+tzRVXkDJG1xkRSGGmOAnwovA88YV/xcd6pUHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HsA8ab2TPXNCbKfyIiIE2BbxbQ9dnL6fjU5Vbkg0yo075/rQZqYfVBRf707oQCjxE
	 xx94ge5UjIPlnbJfLVvAAA1widCcy2itwcXESgEHYCCUxGRAlwHWvqI+lnx8uLYwEr
	 C4iM/hrSSdFCWdi67Hc5MIP3vOIdWFuBr/zZkHSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 380/780] arm64: dts: qcom: sdm660-lavender: Add missing USB phy supply
Date: Tue, 17 Jun 2025 17:21:28 +0200
Message-ID: <20250617152506.935200571@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Minnekhanov <alexeymin@postmarketos.org>

[ Upstream commit dbf62a117a1b7f605a98dd1fd1fd6c85ec324ea0 ]

Fixes the following dtbs check error:

 phy@c012000: 'vdda-pll-supply' is a required property

Fixes: e5d3e752b050e ("arm64: dts: qcom: sdm660-xiaomi-lavender: Add USB")
Signed-off-by: Alexey Minnekhanov <alexeymin@postmarketos.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250504115120.1432282-3-alexeymin@postmarketos.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts b/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts
index 0b4d71c14a772..a9926ad6c6f9f 100644
--- a/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts
+++ b/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts
@@ -107,6 +107,7 @@
 	status = "okay";
 
 	vdd-supply = <&vreg_l1b_0p925>;
+	vdda-pll-supply = <&vreg_l10a_1p8>;
 	vdda-phy-dpdm-supply = <&vreg_l7b_3p125>;
 };
 
-- 
2.39.5



