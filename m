Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04A71EB5FD;
	Sat, 12 Sep 2026 07:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197567; cv=none; b=jNUxXXrGNogcWNz7T2799kZJsPYUuO9SyHpuGrv5xjjwEzs5oXmZ2WRYJhhxrNcPtnkk4RC8xmFCObsPXgSs6HRT6tpSJRBPmYqeA7F/eMhLiDlMmUUORYctcfXn6LbPuQBCpV8RHh0rq3DgRNw2OFcqOnQg8V4uKfv/uVv2TIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197567; c=relaxed/simple;
	bh=sBLFLK0S+VYCgRAJKQYCxM9JsDgFZpnnD0F/C95CsOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgumyHQysZTl00DviE/TNT+lyQnLPl4BctRB4yTTx1xBuYqhtQSGk53zm/QKIHJ++t3TXfSr1GRoUZWCHUXTHOVZ+KpDkwUuizN+cbolPkgO7mf4RzqflDUkFgcYRsZ9ZOKpqR3bE+BcX7RH5FXzOjbwxGJAsHpA3kt01kYIyOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JM8LeKA9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JM8LeKA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA7B1F000FF;
	Sat, 12 Sep 2026 07:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197565;
	bh=Hs69npI2e1sMmGKbEKpY7Hzz7fCPFhn3AwSxIT7uZ4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JM8LeKA901HxGd9wDTJ06gdGqK9Mifs+tQn1EU1L4UmJ9Rmm0qtBOsbwJ32jZHHz6
	 4FSMjNAyRdtwRx2F/lpVl0ZyFjOYAssJV48UV7K03pXQonDE7fy1vumm7BccjAbqjU
	 /FLwsRkrloPukGD3lc6NH8MhchPI2pQk3e6n1uxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Subject: [PATCH 7.2 0201/1815] arm64: dts: qcom: sm8750: wire UFS to ice instance
Date: Sat, 12 Sep 2026 08:32:31 +0200
Message-ID: <20260912065653.721212733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

[ Upstream commit ac456227d22952b656ad291ebd2d3d3e498e3d95 ]

The Inline Crypto Engine (ICE) exists as a standalone DT node, but the
UFS node lacks the required qcom,ice phandle reference.

Add the qcom,ice property to explicitly associate the UFS controller
with its ICE instance.

Fixes: d288abc3a70e ("arm64: dts: qcom: sm8750: Add UFS nodes for SM8750 SoC")
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Tested-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com> # on sm8750-mtp
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260429-sm8750_ice_dt_fix-v1-1-2540dc337082@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8750.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8750.dtsi b/arch/arm64/boot/dts/qcom/sm8750.dtsi
index fafed417c66fc..6bcda7c38dbf9 100644
--- a/arch/arm64/boot/dts/qcom/sm8750.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8750.dtsi
@@ -5445,6 +5445,7 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 			phy-names = "ufsphy";
 
 			#reset-cells = <1>;
+			qcom,ice = <&ice>;
 
 			status = "disabled";
 
-- 
2.53.0



