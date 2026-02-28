Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDB235AC25
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302684; cv=none; b=qDsHoJJAKDQUlUgByl9wtatGJBFrv3/1hmB6QqVfeh2anT5aiOF1enLqHzQADC5AWByZ4d5wsrPRtNbYHFI7AsfWKxma958Z6M9i0TanfmtWd/KOJiQcrNhhUM+CEixLJ6YrriMtLYwMuLHrjC7s67I4oLduAZBiIclWbuUiZ3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302684; c=relaxed/simple;
	bh=L2Gqpp0UJWb1UkKnR2+aEcXAYWwnGRL/JV8Shsj5i9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6uLyHh8YsfZy0ngsNK7waHSQMBS3peADUL9AmG1AQqhIa0DP6OED5aPgiPOoTyYcu7Ogk+9ck4dmjKP21BLKnIqrEBuoLmoc1hCiUofrkp+b/ULzPPdLpxJuMqA4AgIuGFCMipMu/gfzjmWmXtT3+zBzfjHm1wYXCPUaXiHj0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fKcG2KAI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fKcG2KAI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16248C19423;
	Sat, 28 Feb 2026 18:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302684;
	bh=L2Gqpp0UJWb1UkKnR2+aEcXAYWwnGRL/JV8Shsj5i9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fKcG2KAIj+O0rzmUNUbpJkqVzX9HrbLW99EE0vuGvOnRGPKVy1tWUKkWOn+bdnvx9
	 e/xQn21Ji5cOvuWYWU/CEVrBhPnzv2uSX6XRjU3WU1H519Xn27Bqtk7x8quSNt8bS7
	 hyiAc7CZI+xS3o4bYs+QrHM/EF2rKoMFcYmp13t/mCH0uivlFkvuApFDLUqM/ypcm3
	 FbZugljhfurnNTGuMUqYD8DdLXEY7qyf1OeIZrMdajJkubIU5mpWr8d5igOICyJJhU
	 gwBkfUc91D5UBePCRhxofsVkuQbApHQn5uIMrBWh3d4zKne1do+kuxaAEfO4vmIqPp
	 5sByxGPUhEIkQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/147] arm64: dts: qcom: sdm630: fix gpu_speed_bin size
Date: Sat, 28 Feb 2026 13:15:44 -0500
Message-ID: <20260228181736.1605592-36-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index c39e67fa64650..cc43d014c5038 100644
--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -467,8 +467,8 @@ qusb2_hstx_trim: hstx-trim@240 {
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

