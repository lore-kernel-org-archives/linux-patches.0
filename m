Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAE42DFF04;
	Tue,  8 Jul 2025 16:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992958; cv=none; b=eRoFyl7ZaCsQHj5Re/zFhfe4XW6zXcB9R8dfvYBj642gRaJ0P+pWkHcBIwhxphQaEVbPKNR/gyJH4Pf+hmKZtdy+y7ocb4qem5RbYIyykQ7DWtteHGbqyPFXEqIaK31nb+OE6gxOpekAevHR9ESwssxkk8J5UYuARQzf0BJL4jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992958; c=relaxed/simple;
	bh=cDb4JFr4wmx8MO0h6kV03BIMZ1LpH60IP54LaFRsxgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jb8v3+lJT6iICHmGZWgAaEH06IMVpHVjH3lfHaknbdzbx8JZ4UgtSXbkBXOiKAySLn0Kp5huj2CBFbCKVAu7iXApLhSkKXXfmusGqVTDxZAz/bu3uv8lHt5jjewej3REodhq6+eu7n9uE34HkLoxGWwQ5VuP/QVFTEWq86VnrVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N5TfALXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5TfALXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EAB5C4CEF0;
	Tue,  8 Jul 2025 16:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992955;
	bh=cDb4JFr4wmx8MO0h6kV03BIMZ1LpH60IP54LaFRsxgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5TfALXktL26TNK2R+0VK3Hoevbzdg6y7+Ct6NJYdjZyOqKpfctrWobkMw5TEqj3g
	 BVlvPOPX9UIYdBAMiwNMf3/fIGmtPGirXAF3jBzS99PSavdCbTxR9aNqtFIom2O2X+
	 wivT2mZ7YBG2gdUF0ubN72z4R7VfGjdCpR2YzbZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 139/232] arm64: dts: qcom: sm8650: Fix domain-idle-state for CPU2
Date: Tue,  8 Jul 2025 18:22:15 +0200
Message-ID: <20250708162245.079292562@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 9bb5ca464100e7c8f2d740148088f60e04fed8ed ]

On SM8650 the CPUs 0-1 are "silver" (Cortex-A520), CPU 2-6 are "gold"
(Cortex-A720) and CPU 7 is "gold-plus" (Cortex-X4).

So reference the correct "gold" idle-state for CPU core 2.

Fixes: d2350377997f ("arm64: dts: qcom: add initial SM8650 dtsi")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250314-sm8650-cpu2-sleep-v1-1-31d5c7c87a5d@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index 3a7daeb2c12e3..72e3dcd495c3b 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -426,7 +426,7 @@ cpu_pd1: power-domain-cpu1 {
 		cpu_pd2: power-domain-cpu2 {
 			#power-domain-cells = <0>;
 			power-domains = <&cluster_pd>;
-			domain-idle-states = <&silver_cpu_sleep_0>;
+			domain-idle-states = <&gold_cpu_sleep_0>;
 		};
 
 		cpu_pd3: power-domain-cpu3 {
-- 
2.39.5



