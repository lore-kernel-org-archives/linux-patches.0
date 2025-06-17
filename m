Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2C92F2365;
	Tue, 17 Jun 2025 16:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176411; cv=none; b=dMjawz0+mYtkw2E7U/LUznPz3FJ9P7gqXSa8oBewnI1emsXstmfDjvrnLKoIyqQqUHQIIMVN7doJasNMViqChR/Tvo2oIL8zuytlCAaAEWOyqhrLdRRrYYiuEH3RoclzT8dbvDajrkuoHpug7H+0775PKfFr7mPxvjYC/0BPwFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176411; c=relaxed/simple;
	bh=MADa4wPpy2LakqcVZYPQiBfK2m8KCqkfdPgE2ckrGqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UeyNyF8GMGj6rpdUz2BVCqtWvzq6V6thbmfcmAat8yNUrDpyZxno58K/nVrTq7eb34PEGMozm66nofzwpfLxueR9rolBxbZR3Yu6d7JHZz6qwKIPPDut/05evJeelJHRCR7AjljmD9MlBkK9uzknc41UBLhiasPCJG5X5mQ+vs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apgqCdGY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apgqCdGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477AAC4CEE3;
	Tue, 17 Jun 2025 16:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176411;
	bh=MADa4wPpy2LakqcVZYPQiBfK2m8KCqkfdPgE2ckrGqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=apgqCdGYhAF4Xsz361gsVFuC9R0QS6rVjZ2anoZUVXKW0XWNAqDh+5p/zhQSJVh9U
	 2S048EOHNKgHeESGfPH48tvu13mMFdqiLrnAAI9do4U9C1R2nLx/jgtOOjmM3trXHv
	 ma+koZbx6Y2E8m+/tUh74nDDMpHifFgtIQfgm07M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xilin Wu <wuxilin123@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 227/512] arm64: dts: qcom: sm8250: Fix CPU7 opp table
Date: Tue, 17 Jun 2025 17:23:13 +0200
Message-ID: <20250617152428.821018683@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Xilin Wu <wuxilin123@gmail.com>

[ Upstream commit 28f997b89967afdc0855d8aa7538b251fb44f654 ]

There is a typo in cpu7_opp9. Fix it to get rid of the following
errors.

[    0.198043] cpu cpu7: Voltage update failed freq=1747200
[    0.198052] cpu cpu7: failed to update OPP for freq=1747200

Fixes: 8e0e8016cb79 ("arm64: dts: qcom: sm8250: Add CPU opp tables")
Signed-off-by: Xilin Wu <wuxilin123@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250308-fix-sm8250-cpufreq-v1-1-8a0226721399@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index faa36d17b9f2c..e17937f76806c 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -606,7 +606,7 @@
 		};
 
 		cpu7_opp9: opp-1747200000 {
-			opp-hz = /bits/ 64 <1708800000>;
+			opp-hz = /bits/ 64 <1747200000>;
 			opp-peak-kBps = <5412000 42393600>;
 		};
 
-- 
2.39.5



