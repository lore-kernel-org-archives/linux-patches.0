Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFD8375AC8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301727; cv=none; b=Co80qF2NLRfzLowin7rlSEJNchrnuSM3Zjct53igT5MflPzCovQR0oqgWyryL9QLmjAqmbBvKR3S/e0bo99aJTUV264ZETkcGMrm9nUtq68dC4Vs8iysb4O6tpw3SdbrIJgQkg6f9u3Iey4oILtqHaoaoFkjfiezNPXOBABwfU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301727; c=relaxed/simple;
	bh=gZhTibiEvBvD50I3od6vqwFHtnbaDQs1j/2Y0uXvyLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6g/ojNqxuih/eAVnBnLEjs0tz5mAIzsWPVfWVcXJC7CW2suZUXalaXGbKmgkCIqxURBhkxkiXX4jD8nY/TSorhF686SmJDtmpRa60DmfyUQc2fbu46OQ5y1tP6haJEeik+ItAGW7dsXj7l87I+4nX3Dl26g0hDFPymzHsY0Aro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VYlK5KDU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VYlK5KDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B38C19425;
	Sat, 28 Feb 2026 18:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301726;
	bh=gZhTibiEvBvD50I3od6vqwFHtnbaDQs1j/2Y0uXvyLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYlK5KDUA/HGUuDIQN/7hQ7kL2COLfnvwRse4e4fklVPvHU93wEA4YnGQq1uGytmJ
	 y08eQYG2bLD3pYZvuPDcvj9Dvy3UzU5XdbfYU7xqnwvVjKSbmSiR7C8xmCP5sfjyLT
	 GkZmDzpINBbFgVsbs3iwRVUHZsSwCQ15ahWpQWQOneIz2znEpjjS7GHY+xqdY89PvR
	 6Ig+O2MXOpFedP7pDGuccT5r4H9OUQSt+gBpYLqm5FM7d/f7V9i6o/YscBv0c5jdXT
	 5sen7W+dexSsGJj6ToeObdV7Riu+ghB7zOnQ34tV5eIVX9wdbJMqiqfHR8J/WOXuzM
	 3rATOLdbFxBYQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jonathan Marek <jonathan@marek.ca>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 125/385] arm64: dts: qcom: x1e: bus is 40-bits (fix 64GB models)
Date: Sat, 28 Feb 2026 12:55:47 -0500
Message-ID: <20260228180011.1568201-125-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit b38dd256e11a4c8bd5a893e11fc42d493939c907 ]

Unlike the phone SoCs this was copied from, x1e has a 40-bit physical bus.
The upper address space is used to support more than 32GB of memory.

This fixes issues when DMA buffers are allocated outside the 36-bit range.

Fixes: af16b00578a7 ("arm64: dts: qcom: Add base X1E80100 dtsi and the QCP dts")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251127212943.24480-1-jonathan@marek.ca
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index a19b217b6f8ee..6f47f4d5ff2a6 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -736,8 +736,8 @@ soc: soc@0 {
 
 		#address-cells = <2>;
 		#size-cells = <2>;
-		dma-ranges = <0 0 0 0 0x10 0>;
-		ranges = <0 0 0 0 0x10 0>;
+		dma-ranges = <0 0 0 0 0x100 0>;
+		ranges = <0 0 0 0 0x100 0>;
 
 		gcc: clock-controller@100000 {
 			compatible = "qcom,x1e80100-gcc";
-- 
2.51.0

