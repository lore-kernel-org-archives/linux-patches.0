Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE023546F6;
	Sat, 30 May 2026 17:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161324; cv=none; b=jgNwXad3ASkw75EUqJB6Jilfwk++NjKxmI0yoAFcfgug7QxGNVmGR9hRXSqryUdvcrDm6Cr8XcAmvr2Ok48y02TSSvEfw730H+ZQ6gNf0Lvvv5zaCptqoBCRh1T3i1rQMy27RjPt5W7LoGS5FwWnUcwy6WHBW+45FC4YWg8caRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161324; c=relaxed/simple;
	bh=lA0Yajm6m/w8oKXp573D+KWPOFM/yOI3Z917V2N3akw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACbGiJ6733hjyaAqb0Uge9NDDERK2nQy7nckxz99vgcITPahfHw2rJSRGzIuQB9/wymWL/4jlSZkloFHloyescQKgyNZVwVQMkVHQI/Vopijg6KU1WwlH+6ILfD6fC8TSGYyPRVCImIz2z6zTtshok/DaweX8CquRtmbbtfmxac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPO4JT+l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPO4JT+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20D21F00893;
	Sat, 30 May 2026 17:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161323;
	bh=BNLUU10v5dYK5zRZTe5118YsCfUwmMnrD3tytYVmJaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tPO4JT+l4yxsl94e0hq56c/h0zxhWTA/+eYbBHjL8Wm31KYhiHmnm+qXgHYuwntR+
	 sBU63PZTyCCRrFdj/a3UPqEsOQxDt8TxDFW/MMeZ+utODxkcqarcNy1Zedvf4bq3rD
	 uTdYCfNQT8Wn2tXar4CJD5QXBs/1s1Pq0NvI1Rco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Koskovich <akoskovich@pm.me>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 590/969] arm64: dts: qcom: sm8250: Add missing CPU7 3.09GHz OPP
Date: Sat, 30 May 2026 18:01:54 +0200
Message-ID: <20260530160316.708778963@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Koskovich <AKoskovich@pm.me>

[ Upstream commit b683730e27ba4f91986c4c92f5cb7297f1e01a6d ]

This resolves the following error seen on the ASUS ROG Phone 3:

cpu cpu7: Voltage update failed freq=3091200
cpu cpu7: failed to update OPP for freq=3091200

Fixes: 8e0e8016cb79 ("arm64: dts: qcom: sm8250: Add CPU opp tables")
Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260307-sm8250-cpu7-opp-v1-1-435f5f6628a1@pm.me
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 72ab4ca129459..ba912e03441ef 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -627,6 +627,11 @@ cpu7_opp20: opp-2841600000 {
 			opp-hz = /bits/ 64 <2841600000>;
 			opp-peak-kBps = <8368000 51609600>;
 		};
+
+		cpu7_opp21: opp-3091200000 {
+			opp-hz = /bits/ 64 <3091200000>;
+			opp-peak-kBps = <8368000 51609600>;
+		};
 	};
 
 	firmware {
-- 
2.53.0



