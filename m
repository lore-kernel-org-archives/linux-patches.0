Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CD753E33;
	Tue, 23 Jan 2024 00:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969967; cv=none; b=FqHFBqAzv2lO12JvBcv9F6e0t4Ndu/rGbXahg/d+OjHAEvwEB7GrF5h40TSqDHsvhqZG9oOhF7O1oEDAGr+8AhmmH4Ao6hX8BT4sF/uNdC5VOfUmyk2eSPHiEKJWLZf0pn0TLhzTQQcqZ2zQV52yVi+K68wlapZe1Mm70QHQJCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969967; c=relaxed/simple;
	bh=6+WLQlMr9NCwfPqhqecbEWdngydCbA9gg8fj+HTtu7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VuzekrcdVYy0MkMV6szk+dPTnAmsZVP3D8puclqnafh8Rv9mI+qLx9AMj+pf1s3JXdaT6ahGProJro9ktmye+JDUbvwpfKXVzp8kNNtMrp3i/2ThxsIbfJE/mdFcrnDrQtcnjVVzwvWxX3KmOPL41cbBf0q+zj5W96OkuJRzuGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXFmX2bc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXFmX2bc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16BBC43390;
	Tue, 23 Jan 2024 00:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969967;
	bh=6+WLQlMr9NCwfPqhqecbEWdngydCbA9gg8fj+HTtu7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXFmX2bcx4ittcDdWPR2tglgYOm2P1f1GwQaecJFhYQEvZzDpLeH85meIdrpuktEu
	 fmSLQEiwHiUc53b2nVdR7hIdVfkmoZbf4EMwQcwVxzwcIydgGeaFvTqsFtrYqjYTX7
	 i/+Ey+aWqWQxYuIgdpFj04UFuuAwP/VH41DXtMVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 542/641] arm64: dts: qcom: qrb5165-rb5: use u16 for DP altmode svid
Date: Mon, 22 Jan 2024 15:57:26 -0800
Message-ID: <20240122235835.087874644@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 70e6163d17dd501ef27680eeb80d78b2cf823c5e ]

Follow the bindings and use 16-bit value for AltMode SVID instead of
using the full u32.

Fixes: b3dea914127e ("arm64: dts: qcom: qrb5165-rb5: enable DP altmode")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20231204020303.2287338-4-dmitry.baryshkov@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qrb5165-rb5.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
index f9464caddacc..4501c00d124b 100644
--- a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
+++ b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
@@ -1425,7 +1425,7 @@
 
 		altmodes {
 			displayport {
-				svid = <0xff01>;
+				svid = /bits/ 16 <0xff01>;
 				vdo = <0x00001c46>;
 			};
 		};
-- 
2.43.0



