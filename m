Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3956C4D5A1;
	Sat, 12 Sep 2026 07:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198778; cv=none; b=pAXc+6o1MHtB5vFbfmjYYw9vMQqGvZa+DBGOuKnwzkjKd+abYbH9abKnn9aGDFbTS0H19GnP7Lbtt0/POTnrZ0UqgqRLClGL3jR/I79a0357Q9606rdj78U23ov8xklaqdZVlpaiFLxPnWDoM8i7/LP6O+uaoi2ziE0bJsqEKks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198778; c=relaxed/simple;
	bh=ZS9HzFpGgVFtHHd/bJyDqUl5lyrq/8dY/TwziYYpqgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkKz0JVbKVZmOj4XgNTuNx68E6LkbBwVWHGzNrbBCugI7sn0VIW8rWTF+EvY2Ak/NEOIETaVpSfEclki4ezX7HOJ+qqYtmMMVNaxHKTFWzrWus3AuqZfFNmRNel/1UBu06RH2J6mEIeXVdHSLSUkn4X+kYuGIBFttbozD6RNqSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQ4lS9+d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQ4lS9+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A431F00893;
	Sat, 12 Sep 2026 07:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198776;
	bh=EM+mvE8A2ult0HYzKfx0nF4G8yC2ER8qWBza7EfM18Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EQ4lS9+dioUgzlQplX36ps/jMrd0gNyewlmFYuNNQrIo9gulYKyj11ymsGrnYJKgc
	 f64+/EU946dQbxMVah3cS1WYm6/+piSMyDorGrT49el5WROVr3DX4SVhQKuFJlTuIE
	 9uHFVPPq1oldudAjl1MOS5aEusOtzbh6kgU4kIG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0448/1815] arm64: dts: qcom: eliza: Enable first QUPv3 wrapper by default
Date: Sat, 12 Sep 2026 08:36:38 +0200
Message-ID: <20260912065659.410747005@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit e78c2cf207c1ebf4558b709308199ee21de478ac ]

Since each serial engine will be enabled as needed in each board dts,
there is no point of disabling the first QUPv3 wrapper in SoC dtsi.

So enable it by default. This is also now in line with the other SoCs, and
also with the second QUPv3 wrapper.

Fixes: 844807e1f89d ("arm64: dts: qcom: eliza: Add QUPv3, GPI DMA, SDHCI and LLCC nodes")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260709-dts-qcom-eliza-enable-qupv3-1st-v1-1-e9a6904d0dea@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/eliza.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/eliza.dtsi b/arch/arm64/boot/dts/qcom/eliza.dtsi
index 72b786fec195f..2e9f5aa092cc2 100644
--- a/arch/arm64/boot/dts/qcom/eliza.dtsi
+++ b/arch/arm64/boot/dts/qcom/eliza.dtsi
@@ -1232,8 +1232,6 @@ qupv3_1: geniqup@ac0000 {
 			#size-cells = <2>;
 			ranges;
 
-			status = "disabled";
-
 			i2c0: i2c@a80000 {
 				compatible = "qcom,geni-i2c";
 				reg = <0x0 0x00a80000 0x0 0x4000>;
-- 
2.53.0



