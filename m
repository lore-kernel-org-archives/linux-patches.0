Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5539346AC1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302081; cv=none; b=O+Zc5rg2pnqAMPMIqa2ja3QkAWyniqovRwt6JDPc6z4IyxyQOjQIc5EDQWyihgiJhs8OvGsRVNlKI5W5K34ds+wkwOPL2xksbeplr8C8VbIj2nrczmvh/1zbRdGAzGmFonssGC7gLiRby5nM7SUO5ef1UtOAqo4AU7aoKqH6PcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302081; c=relaxed/simple;
	bh=9FSlJfuBzqE/VtqRJubcyxozG1CtseSgG/dWmV9PoL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdfS9v+9y2gg3ZxXcJCVCxnO3pzQt7lOC/1pj1G7MmTffeGvmE3RHkz2nw3191yRhEj2WocKsf2JyvjxOLknlX3tjU0+zpltwRVFFkTzifhsLfq2zeLO+BqwsUnecP5YrVClLK6PQE6mr5vDqe2MI5IpIlu1yd0ZjBotYS0vU4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yi1daLls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yi1daLls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC45C19423;
	Sat, 28 Feb 2026 18:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302081;
	bh=9FSlJfuBzqE/VtqRJubcyxozG1CtseSgG/dWmV9PoL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yi1daLls+z8MIZZFBIN/YdB8cqqPqfUTQgVY/H7zJLPJi+MG4TRjeYI3iUGdpoCpC
	 x14rIs+hlbp1aLUIz3G4x/cRRwOjtpfLUo+DYoSpwQQrbXWQJSnQG3sHFoZGlqETIG
	 6oTK9VVV2fDma+sN3qh94HRfom8dGlfYTqQO7adnU/Ziq7Kq2QUnt705yNBqr6V/2u
	 myQYFJyh6LNqDuSDs32gWUins8lLuaaeHGHIe3dWovQm6p5blRlBStZNvZJOzqcOW6
	 kGfCUefM/LNE70ozdpFe1r5SWiclJ+Jce2pUcB4YuSq0VfWUQ+oqylgIyZgykkS3Pi
	 umqnsTege7uWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/283] arm64: dts: qcom: sdm630: fix gpu_speed_bin size
Date: Sat, 28 Feb 2026 13:03:25 -0500
Message-ID: <20260228180709.1583486-63-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit e814796dfcae8905682ac3ac2dd57f512a9f6726 ]

Historically sdm630.dtsi has used 1 byte length for the gpu_speed_bin
cell, although it spans two bytes (offset 5, size 7 bits). It was being
accepted by the kernel because before the commit 7a06ef751077 ("nvmem:
core: fix bit offsets of more than one byte") the kernel didn't have
length check. After this commit nvmem core rejects QFPROM on sdm630 /
sdm660, making GPU and USB unusable on those platforms.

Set the size of the gpu_speed_bin cell to 2 bytes, fixing the parsing
error. While we are at it, update the length to 8 bits as pointed out by
Alexey Minnekhanov.

Fixes: b190fb010664 ("arm64: dts: qcom: sdm630: Add sdm630 dts file")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Alexey Minnekhanov <alexeymin@postmarketos.org>
Link: https://lore.kernel.org/r/20251211-sdm630-fix-gpu-v2-1-92f0e736dba0@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm630.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm630.dtsi b/arch/arm64/boot/dts/qcom/sdm630.dtsi
index 0f3f57fb860ec..74b36cb8bffa8 100644
--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -589,8 +589,8 @@ qusb2_hstx_trim: hstx-trim@240 {
 			};
 
 			gpu_speed_bin: gpu-speed-bin@41a0 {
-				reg = <0x41a2 0x1>;
-				bits = <5 7>;
+				reg = <0x41a2 0x2>;
+				bits = <5 8>;
 			};
 		};
 
-- 
2.51.0

