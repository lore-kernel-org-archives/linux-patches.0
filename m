Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB33B1FCCFD;
	Wed,  5 Feb 2025 14:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766844; cv=none; b=iKl4DbmdlrY7VjiLvlaMbfIgZTpz5Xk2XGhHzedUGd+Jp7+PCZKxwdBClyr/E/jKpfl8bhGt73Ecz3treAkkDd34o2FOu+CATvgYsF/2FGreyg6TBE0Jl4qUDkhHlHoeEFHYifN7w1dmHHMM3PBpL3WId5bro2HuQGD8XsmbJL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766844; c=relaxed/simple;
	bh=2GDZeLW5bEvOom70yq8yRTzZunpXjA3tlyjMjJ4LxrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xzv5tnuivCkx+VJTW+QeBHdcsXfvPGa7+woh1eL0inIzCiKyCZ0CulB/2sTaPQOmKZ/MyZqy3/nMpnSLdDR+7hKqmG/tm5anWSSeL76MQZ4Muc0Fkx2OYrRzswqjBhr/G+7E+rso5h96WreXGiIc7WmpMvf9pHXKLhDHsjqVMio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ezqmnDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ezqmnDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395D0C4CED1;
	Wed,  5 Feb 2025 14:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766844;
	bh=2GDZeLW5bEvOom70yq8yRTzZunpXjA3tlyjMjJ4LxrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ezqmnDb+j5u2CtXvIShq05TjxyZ1qNyvkw8JJs8ZfjZRdqKekgnFof9XxIsRo6PK
	 vyEOhhPi1VqCETCbeyXryuF0kNRL209Dz7BcKVN+mMkOtdjsLisw3cyAEv8bCuxmEZ
	 uCA9ovPhBQCpAChuCAL8C/ZZTGZQCsOcO23YgML0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 348/590] arm64: dts: qcom: qrb4210-rb2: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:41:43 +0100
Message-ID: <20250205134508.586406669@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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
index 1888d99d398b1..f99fb9159e0b6 100644
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



