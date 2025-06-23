Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51406221734;
	Mon, 23 Jun 2025 21:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713702; cv=none; b=EzmNoslUabw3YNlHmXiAbxhao17E4So773hJypVQcrSH4H61UgvIh2U8KbO+wb0a1ICyuLAVdpwpBLiXpFBH6Ts8YB71kdWr7uDYvtmRJVJxMqir4HEGYCfehkZlERoor/yiLPUVxPtQ8NYNp/VQVTIyy8kusaYEx2MKTfW3jYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713702; c=relaxed/simple;
	bh=m2+d8bYtr91j+uxOWuHSTXzM5uJepDBj+WkTVxPSeXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFbsbKHB+mn6RCTgAcp/4Z20Nhmuo5HN/3e86ggzB9vJL6CiNfsHk+eXvG2FrVuVtg5fpnY5sFVhpVdjfd/67EKkrOudROzO1uLy8R4N8pSLmWW5nr4VMoaNgmpoidkavUYbMDCt13Q0Gu/IqcUi1V3Yn3Ab0rT1/65mE+iw5oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBOrjKk5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBOrjKk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD5CC4CEED;
	Mon, 23 Jun 2025 21:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713702;
	bh=m2+d8bYtr91j+uxOWuHSTXzM5uJepDBj+WkTVxPSeXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBOrjKk58T9ks5aIb1pCl86CuKjOkiE/voE6RdzKlXquiDtWZuI2ef/sgItlmA641
	 1hjcITP4G/I5BRuiHra3KcNADz68BN0V6TgHZauEh/OUp8HaLwf5LFWlwd4knk8dOU
	 rai6mrUSWsMwBkMze5205qr3W/ZRvKW57/qXX6Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xilin Wu <wuxilin123@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/508] arm64: dts: qcom: sm8250: Fix CPU7 opp table
Date: Mon, 23 Jun 2025 15:02:31 +0200
Message-ID: <20250623130647.889565325@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index eb500cb67c86c..72ab4ca129459 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -569,7 +569,7 @@
 		};
 
 		cpu7_opp9: opp-1747200000 {
-			opp-hz = /bits/ 64 <1708800000>;
+			opp-hz = /bits/ 64 <1747200000>;
 			opp-peak-kBps = <5412000 42393600>;
 		};
 
-- 
2.39.5



