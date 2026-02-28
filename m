Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185E837524F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302535; cv=none; b=PtDc7B7QwiWXd0Q8BpF81bOCMXK0GZGjKROBwhH6N55jrOzWDzXXO3HDzQv4zt7JGolNAj23QW9Z99QWblOOj5YX7TYi3XBIOeio/aHhLmMfsVjqF2ZqMthd9gIv622E4ILsYspaw2x8Xe/7KxvvK6PV9PqtAGNN8SADHVJ0dBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302535; c=relaxed/simple;
	bh=Qmnur3PQuJzjLnY43L7jszxkLfDZk5Lbz92Tculs7co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1Sql6ssvA1za+QwEHPoWewxuPBoh6RNZlxONFAmCSQ2cK+Lm0WKbTRPiLsgdEeSrcrsNaCh7hpcXK4fMcIP/zImcnV7bTWkV0TZ0RguaY3kNTickvpaNzg4DIB14Ky64qnKaCrx5D9tolOqV4pgQbaqj/eO7BhijUbQxowZiik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W5xpYHgj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W5xpYHgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53012C19423;
	Sat, 28 Feb 2026 18:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302535;
	bh=Qmnur3PQuJzjLnY43L7jszxkLfDZk5Lbz92Tculs7co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W5xpYHgjs1n0XNukD45RJ2gNddoqYmYcuBatLvfNJVZncEECjlrDpSifUy0o72bOt
	 2GA4Js9FNnIpxfcW7XxwVX4S9p12J5Hww23ZFHNG2yu02KDznv3JwkTfiBwISFHXAd
	 imjJJOh18kxBTBbnA4QbMEiC62yEymEMgYdEJjgI/Y4B2FmZS9oy6EnWYnmIYsOtkV
	 mLrv6ckj4L6PwHfbpXjKkdhBV6y9TRJ3kLdyzXIWMR7Xsr06hCKxW0PVjmODvBmX5t
	 dLucDgR5rQ4R2kXGkEc5qq0hbtl/jqPPJw/SM0igDFTbdyf//OGzKzwS68uh9Wun8F
	 u56ht5ltDOE+Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/164] arm64: dts: qcom: sdm630: fix gpu_speed_bin size
Date: Sat, 28 Feb 2026 13:12:54 -0500
Message-ID: <20260228181505.1600663-35-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index e6527652a1245..5a1069cb696e9 100644
--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -559,8 +559,8 @@ qusb2_hstx_trim: hstx-trim@240 {
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

