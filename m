Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11121607B7;
	Wed,  5 Feb 2025 14:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767272; cv=none; b=nIsrSN7L4HItMxwEr/rtZZlMB7Sd1VoYHxp/Gprr+9MERrVpIjWemv0fBdyfn1JpYLw65H3CunmI8suX1DJAbvy6j6aWt55HP0Px8n3meTtHNOXnqWwtwiKGba8YUu6xZrDfmZXf3P9AHzt4G4yXx0k//V0GCl1TWljOlIVTEBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767272; c=relaxed/simple;
	bh=ZYTLchg8HytQBhPvmfyOMdtzMsbUgojUF746G755r0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIGScfUBaTOZiccUKuPdhgOjEArOgjPhWosjk+4/CO85bPZGBnXU2mAfp+8ledPn84c0bjH1Mi+aZUlUxQ39d1szFX6RWJXGtCK5CG3e7sL18phbQmOOzs4DDeKFtMCb5ked7oNK0rG6s0ScTOp1ZsOx1RbXNHVDgPPRz3mNBCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uFUFmTsn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uFUFmTsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BBDC4CED1;
	Wed,  5 Feb 2025 14:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767272;
	bh=ZYTLchg8HytQBhPvmfyOMdtzMsbUgojUF746G755r0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uFUFmTsnO/HlNx8gfIXr9HQPWI8rRF3eFoIr9NcsixPKayu3jECoE0cHHo+Nhtfag
	 QDTFVfMChVzqVO7SDZzte2UTf5kSNKDXeJXdnMtYJvr90oXp0W+g10P1HZfcMHZMgp
	 f3e7xj4OmFL6u1E83tz500QRY2uBZBDKQ+eWIwy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 381/623] arm64: dts: qcom: qrb4210-rb2: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:03 +0100
Message-ID: <20250205134510.800913557@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 298192f365a343d84e9d2755e47bebebf0cfb82e ]

Qualcomm RB2 board uses PM6125 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 8d58a8c0d930 ("arm64: dts: qcom: Add base qrb4210-rb2 board dts")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-6-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qrb4210-rb2.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts b/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts
index a9540e92d3e6f..d8d4cff7d5abe 100644
--- a/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts
+++ b/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts
@@ -545,7 +545,7 @@
 };
 
 &sleep_clk {
-	clock-frequency = <32000>;
+	clock-frequency = <32764>;
 };
 
 &tlmm {
-- 
2.39.5



