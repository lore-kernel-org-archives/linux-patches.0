Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D356379EE2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301704; cv=none; b=aXRW6f0jewNkWtBCrYch/GBUx22MI3IQgLeIVO18TInHeS3louYJHG4/cIFnyHNAjThrpSNjZbUtwQCUSf7SN4wjw5/Smqtbjt9qSAbCAV2rBbtug2OWyHzEUn8nnBzBuaLMwGKalZkA/7LWiqPBxIJs3JOKahumaXruLiMaK+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301704; c=relaxed/simple;
	bh=3Cx8aYVMq78wlkVAxbfbgH7VjKniHJ9E/vl4htfnuGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdnEXpyIB89oOgdIXrGimdpCLF/gyQCiNRhKrzB+WSnlsBbmhSMCGm2GBlfU5EmXDzFuqPiOuAOYKmkyD+Fto2zM3m8r1LLmOUupra8otrteKO6YAfSrc91m7KmstmQoEdWtJuq/PKhpklYPuG6kEpKVkh3J3517xLfOhx3i/PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OquNmMwZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OquNmMwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B11C116D0;
	Sat, 28 Feb 2026 18:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301704;
	bh=3Cx8aYVMq78wlkVAxbfbgH7VjKniHJ9E/vl4htfnuGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OquNmMwZq7HXcXhBT2npddcCea8RzzllynU2+r5BzB1HSHEnWNiBxVMyUauAOFIB/
	 ERdn7h/r2aH8mik+pWMu/QAo3NFwYaVFc7XxAWpQkPKFjOutv4Qarh5SDktwlBV7DV
	 h0SlDy41m/l7f3fKYafeksuEWWDIGURyqkLwPh+xSTWDTzVALN+9pJ/jzQOrckJLM/
	 lV1WkNOqX+CoWIz2CV7wEskmDZP/NJyRq5hF1CBpjrVqjb8+FIAuP5NFAjGNTDWf+7
	 TugHNhbxJly+Zl0agJ8HZhEX7SaSrNGs+mfNpLJH79N2e5xBDjQHobUBbc158WQsWj
	 8e+EF5/uMGRlg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/385] arm64: dts: qcom: sdm630: fix gpu_speed_bin size
Date: Sat, 28 Feb 2026 12:55:20 -0500
Message-ID: <20260228180011.1568201-98-sashal@kernel.org>
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
index c8da5cb8d04e9..37692d438d230 100644
--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -591,8 +591,8 @@ qusb2_hstx_trim: hstx-trim@240 {
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

