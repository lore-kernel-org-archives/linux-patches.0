Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D18B3DC4DA;
	Wed, 20 May 2026 18:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300731; cv=none; b=UqaLCPGGdkU+LZMEU2JjosFwXf0HJvayYavgQVwSRahrelcrO1BmkSjCE+9Xybu5P1yK4+TOELfUbjkci7BFfab/sh7tz5gfMARKBHLmkg5Bt/bNQWGufMRGYUd3SvDNoiytcIxLPjfL7/zECU7OducPheRGW44IW0jx1F4l7+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300731; c=relaxed/simple;
	bh=bk6Wy2vB95M+O3bYJrXa6JBdmLHdD8tpilu6LQA6kp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyQjgQkUpB2R0r18a2HiIw4S5mKmEmrMJeMyI26+EVDTo889IB4JLbX05kZ1x+ZeGmQAFJ4BatxVBcDzoZWK0kCmR2AvWIbD+iqBZt1v+t8evUViQFK0w9h8Mid4vqkOluT8Z7Tfi8HeKi/vLqmWO0A3aHdSu1F1Ms71v3JLxYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zY9i7p6M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zY9i7p6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24861F000E9;
	Wed, 20 May 2026 18:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300730;
	bh=z0zBHmbGQkxltDJKo2nYNpvj38bdco2pef5SZfs0YNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zY9i7p6MowKzVwLiRgM3U6qs5KgRfleWbAoTFTZBJzi6wzuHf21BJlDDaxqjjHQq0
	 110kMn1TXx9fr2crEzozNRZk2MraVwKfnJE2y96zw6f7wMtPfOLJiOJ3UUu7RuyeHe
	 D8ay1zf0zXDCdGpxCqCsCThABfqy5lhrZZDvtd7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 285/666] arm64: dts: qcom: sm8650: Fix GIC_ITS range length
Date: Wed, 20 May 2026 18:18:16 +0200
Message-ID: <20260520162117.392506129@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 6c8e2ca1263d0da5976418ed285eaec430e8d87f ]

Currently, the GITS_SGIR register is cut off. Fix it up.

Fixes: d2350377997f ("arm64: dts: qcom: add initial SM8650 dtsi")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260317-topic-its_range_fixup-v1-5-49be8076adb1@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index 6763c750f6801..d38d44438477f 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -5142,7 +5142,7 @@ intc: interrupt-controller@17100000 {
 
 			gic_its: msi-controller@17140000 {
 				compatible = "arm,gic-v3-its";
-				reg = <0 0x17140000 0 0x20000>;
+				reg = <0 0x17140000 0 0x40000>;
 
 				msi-controller;
 				#msi-cells = <1>;
-- 
2.53.0



