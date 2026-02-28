Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5508036C9E0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302334; cv=none; b=gLnbyiV46UqdaWGyc8dOkDaRSt4Ae72BsLPnheQj+4mLMFsBnMDfbOS53E6F3adFhHo9VFsONoBh0AIxaJgxpkZxQwJKF5eEF/RXQzI4OVI463oS1rsq7YTqFFUPyoTAdlBRotzzcRHrk4ShYhjZhAV6h3NclG/yUInEW9icuNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302334; c=relaxed/simple;
	bh=Mcol7r4yA/fuTckED35VQzcV3Bob9sufL/KQVvvzS+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+iZ49/dXRB0AguwKfF/SltgygoUbttCiN4ZZBNMt/ZJS/QSPuiWYDMldb/ThVfRo9xCYaAjs7wBc27FMCnteXbkEURhQ3hpFh0T8o+5AGQqDxczTu5KDkNoSi7wuX1mySYTr9LHdfRwzwuBscfrSKhDIYa9u3bOoMMj0kk2dcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HEbim051; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HEbim051"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE42C19424;
	Sat, 28 Feb 2026 18:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302334;
	bh=Mcol7r4yA/fuTckED35VQzcV3Bob9sufL/KQVvvzS+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HEbim0519rMPUWlmyOul97pvqyIeJqK5l0UrZpCmvmn1S+KtfcVO8ydAp+/eTxmXC
	 2dLX/Tzvpsd/nbTt+nclbKeG8At5LUgpL1x95uIov8iysKUDhx9qpAsIoVztDO3YOd
	 vZZVFahCzhsZaRIC8XplcJj7HJGDQY4zd15cOz9GqieVVwZHuL5xsfg+bQ3jj2EOgR
	 HjODJdZ9oh5zNzJXlR31ugPAARHKrX3oHKzqRb5Ju6J5b57v6nEYz/XJNIVMvjMeJJ
	 T7LjdaLhORuGiOFVBI27YTNOmoYsGNFz/IxDLv+MjW4xaFWaV2Cr4ZYA2lZZKOQA5h
	 wmMcaFWAc2DxQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/232] arm64: dts: qcom: sdm630: fix gpu_speed_bin size
Date: Sat, 28 Feb 2026 13:08:28 -0500
Message-ID: <20260228181127.1592657-55-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 75ddebebb8fc1..5580a8722045e 100644
--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -564,8 +564,8 @@ qusb2_hstx_trim: hstx-trim@240 {
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

