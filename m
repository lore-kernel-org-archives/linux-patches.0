Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2499F47B425;
	Sat, 12 Sep 2026 16:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232275; cv=none; b=lUnetBlnvkm2HKuFZTlO2KBrcdyerBtUP/x3O5XGANeMzSCFrWKDDF/FskPzNx0fpkHwayDWtdsRWnN6QHG+FDO0XsvBbEMLdjVdCWvz7Zd6gv1Vxzh/dNU+YIvm97VfuKpm2JTRNTUvVJTmVkruYul5NOeUVQm17DD9aleRCSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232275; c=relaxed/simple;
	bh=PB9w7WvqsWVIBz+FZEi5ubs0lpg956lLa6GB85HNJbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MU+KdqM8gT5DKecIjEUOcY1Rqf8g4SvG3YXGz8+oolhuByGSzHkUxIxXvVfSIW53IAHSJbgKZPlCyPvwbzJ6El91XKMxA+OcbFUBp4j8Hvh4YWUspuRwGqbQ0/VIupuejQNi+3KQzOwbHYA5UZ605XuVUxIGEMj8VXb1jgpd0vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zDQh+fsd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zDQh+fsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDB41F000FF;
	Sat, 12 Sep 2026 16:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232274;
	bh=bnxEtRGeM2qoAqTFmZNm4F+ZqNymI+JGLkm80mULYj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zDQh+fsduAaC+UhRtmZjp4ycRFTLQCQ9EraXCsX0edLP6lmFkhA0+roFzZng4xFC1
	 naZNLvBjWNNIHcjjN7KLxeBRYTXfJKzDTA/avD4hVvoCtXVcHCivIp6bDrNnLIWSSI
	 LiGGzKsRiKwpoaAwjXrbMtLBDzNjQSDQU/4Iq+Ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1169/1191] arm64: dts: qcom: sm8550: Separate out X3 idle state
Date: Sat, 12 Sep 2026 09:04:57 +0200
Message-ID: <20260912065614.395330478@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 28b735232d5e16a34f98dbac1e7b5401c1c16d89 ]

The X3 core has different entry/exit/residency time requirements than
the big cluster. Denote them to stop confusing the scheduler.

Fixes: ffc50b2d3828 ("arm64: dts: qcom: Add base SM8550 dtsi")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231218-topic-8550_fixes-v1-11-ce1272d77540@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 2e7421d80a23b..20790336eada5 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -274,6 +274,16 @@ BIG_CPU_SLEEP_0: cpu-sleep-1-0 {
 				min-residency-us = <8136>;
 				local-timer-stop;
 			};
+
+			PRIME_CPU_SLEEP_0: cpu-sleep-2-0 {
+				compatible = "arm,idle-state";
+				idle-state-name = "goldplus-rail-power-collapse";
+				arm,psci-suspend-param = <0x40000004>;
+				entry-latency-us = <500>;
+				exit-latency-us = <1350>;
+				min-residency-us = <7480>;
+				local-timer-stop;
+			};
 		};
 
 		domain-idle-states {
@@ -373,7 +383,7 @@ CPU_PD6: power-domain-cpu6 {
 		CPU_PD7: power-domain-cpu7 {
 			#power-domain-cells = <0>;
 			power-domains = <&CLUSTER_PD>;
-			domain-idle-states = <&BIG_CPU_SLEEP_0>;
+			domain-idle-states = <&PRIME_CPU_SLEEP_0>;
 		};
 
 		CLUSTER_PD: power-domain-cluster {
-- 
2.53.0



