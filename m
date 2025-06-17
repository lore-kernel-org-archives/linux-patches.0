Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0492EA155;
	Tue, 17 Jun 2025 16:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177774; cv=none; b=asf02cBIs/YEe1hT3Dk+4FBx+xGgtiVvVrQK3y3zbpS3/G1LPb+W8oiezeClT+XmqvpfwxiWl8SAYMsmBZTCcO8nKBwjGhR/COt8IxCwwEjAohNkzQmdlAfR1pWUnjPKCgMUmlw+9Y7W+KKNw4CKW7lEH8nJ8tG2iydsQK3+XUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177774; c=relaxed/simple;
	bh=uJ0Twk80UpdM71ilQCRUNaBLIpeBP/qd4lDSyRzUrNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/eyD47ccIRKAUul5FpIUbBsyjGiYBqQ77Hoq0uAYJXjp7gH/g/UKHs3tvjzSgvDrlwI5adamm3A2N/9H7SLiv9iSyfnzJlPGvyeEb3bqyNeAnivwkHkl22sLLw8Z2F1XC4yhR43sTXq0JyVwwH39gColnSKH1+9U3mKJ5QGdRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hAWW56Oj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hAWW56Oj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C80C4CEE3;
	Tue, 17 Jun 2025 16:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177773;
	bh=uJ0Twk80UpdM71ilQCRUNaBLIpeBP/qd4lDSyRzUrNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hAWW56OjMb+g0YZeAVocJeX59nTo/lQQM68LhA3CcgjyBXldfPHIWB3WKdGzz2Trb
	 ob1pnOAhSzhgV+5T8WKC//gqVO3NUs/HuzoJZVZP41VXXUiVK7PTtKnaV5Uut4nXgA
	 AwXRlYH2Q4GrN0/VbYJmmIFtvQsEwhXlAe7gPpJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 361/780] arm64: dts: qcom: sm8650: Fix domain-idle-state for CPU2
Date: Tue, 17 Jun 2025 17:21:09 +0200
Message-ID: <20250617152506.159122646@linuxfoundation.org>
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
index 36919efc888c2..bf6590e09a4c4 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -460,7 +460,7 @@
 		cpu_pd2: power-domain-cpu2 {
 			#power-domain-cells = <0>;
 			power-domains = <&cluster_pd>;
-			domain-idle-states = <&silver_cpu_sleep_0>;
+			domain-idle-states = <&gold_cpu_sleep_0>;
 		};
 
 		cpu_pd3: power-domain-cpu3 {
-- 
2.39.5



