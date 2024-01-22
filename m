Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A6D153BE4;
	Tue, 23 Jan 2024 00:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969371; cv=none; b=PcU0vM4X5pN1lUX0LGMfqBmTNuYvunIy2qYpcYUMv5Bkggi9G3mC7ZLw2iex3Q9pTk0Zdk4IOVl6CKlsve7rZ7tNTf99NAGz82NoDhVghQJescKFo1x6NW7jCkGX27sZuH17tGs3Exeyk8+zLxDza+slrgXFpy69fqV8BQcqMbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969371; c=relaxed/simple;
	bh=FLgRcnCWE0hnkMD3IBU50b/5y1gazPXmQB4nyBuDjY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfHEcv8sRy9z25tgiVjxhuIHT2FufNCGrzXrGkAvbtfHvW6hgzCM64K5dTgEKpuiaVjdHtkC6zse5Ac0CRwaJ3GkEu3twwUXjLOtjF04unM1b2Mp0EjFUxW6OcJembiATFETCzTZBPBwqOF0ClRXU+0MuSUaSbavGDnlQKkFNiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqIVC+MR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqIVC+MR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9C1C43394;
	Tue, 23 Jan 2024 00:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969370;
	bh=FLgRcnCWE0hnkMD3IBU50b/5y1gazPXmQB4nyBuDjY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqIVC+MRYX3Caygw21zxFtuQKYfk4xjSv3c6cSl+EkbTZ5Rk/vCKDMR4vQi9WzlFL
	 jAfKMJrIwHp3OC508quPlMiVZA2z6LKuwkZduAH1LsfunEnfp3+yAlqTiOfTZ5gjFG
	 CeSuxR2mk5DAqs2P1umaeD2jv4nSzVN6iBbhngEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 202/641] arm64: dts: qcom: sm8550: Separate out X3 idle state
Date: Mon, 22 Jan 2024 15:51:46 -0800
Message-ID: <20240122235824.281431841@linuxfoundation.org>
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
index 6c2b4da8e90a..a3aba04e4c4a 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -300,6 +300,16 @@ BIG_CPU_SLEEP_0: cpu-sleep-1-0 {
 				min-residency-us = <4791>;
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
@@ -400,7 +410,7 @@ CPU_PD6: power-domain-cpu6 {
 		CPU_PD7: power-domain-cpu7 {
 			#power-domain-cells = <0>;
 			power-domains = <&CLUSTER_PD>;
-			domain-idle-states = <&BIG_CPU_SLEEP_0>;
+			domain-idle-states = <&PRIME_CPU_SLEEP_0>;
 		};
 
 		CLUSTER_PD: power-domain-cluster {
-- 
2.43.0



