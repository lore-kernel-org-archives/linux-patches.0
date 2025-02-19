Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91D21DDC11;
	Wed, 19 Feb 2025 09:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956368; cv=none; b=BhMX4TH5/ukENuWBBIRqZyqX3AbSftD6u34ZSpwf2Cc3Z9O2YCD1mbh+jRTtGQCK93qaVkSsee2iDGw4NJWTvuiJh2GPxf+ck6UHU06ldiH0PcyUDySnp+8AsGf5ZanbZ4vZrUuJUyQHG71rAhu+bVHInglGjREtE2nSPtCvVH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956368; c=relaxed/simple;
	bh=swjSBq/gUJ5nFJSNinh1lQEH2QLeiYXqsk4DR0HdJY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccpzZwbTp4vDpPbA5GV3FBXq+YfvwbTIPcSjLfS07LemUjyV+kmjDV4DxhwlLeEP0ZzgvK6W8i2ukqIi64yu/nVf5+h12wXJZtHgt/TmAMCkpV54NmrtIU0vYK2wziy/ntkKiWB10qt189Xw7VCY7cQl6E1sXXjQgodIZkyMnZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eP36gcn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eP36gcn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51DC6C4CEE7;
	Wed, 19 Feb 2025 09:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956368;
	bh=swjSBq/gUJ5nFJSNinh1lQEH2QLeiYXqsk4DR0HdJY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eP36gcn3S6hnFOnz9hmDAZ6Yn6OawguJESbgvacS+bCQwRgN5NN8yxKJ5fmy2ZR7r
	 wWFts+8Duzat+pB0SRyty5v7dMxRy+T8cVv0jYj4mYx4VNyU8/W6RNF/EGEqqWZ6mw
	 Ri9ZHmLzN3QhMHSsYIut0OzwpJWXqrvbREnHe2DE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 156/578] arm64: dts: qcom: sm7225-fairphone-fp4: Drop extra qcom,msm-id value
Date: Wed, 19 Feb 2025 09:22:40 +0100
Message-ID: <20250219082659.112382813@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 7fb88e0d4dc1a40a29d49b603faa1484334c60f3 ]

The ID 434 is for SM6350 while 459 is for SM7225. Fairphone 4 is only
SM7225, so drop the unused 434 entry.

Fixes: 4cbea668767d ("arm64: dts: qcom: sm7225: Add device tree for Fairphone 4")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241220-fp4-msm-id-v1-1-2b75af02032a@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
index 30c94fd4fe61f..be47e34da9906 100644
--- a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
+++ b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
@@ -20,7 +20,7 @@
 	chassis-type = "handset";
 
 	/* required for bootloader to select correct board */
-	qcom,msm-id = <434 0x10000>, <459 0x10000>;
+	qcom,msm-id = <459 0x10000>;
 	qcom,board-id = <8 32>;
 
 	aliases {
-- 
2.39.5



