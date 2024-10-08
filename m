Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8881DFE3E;
	Tue,  8 Oct 2024 13:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394117; cv=none; b=LrUTUZkj/dlsoOBxdC1mM2Sk9CRXWf2JP1EBXy61J2OQLF88Ukq9c3Z3zmi5C90KlE8l+R8C237NKWQ67Brs4lT/wKj++iOIKbu4kNk7vd0a34wi3TYrTAn5IN9FnmsPse5E6QmTYLA6IBxC7va/Y8PHk9Ffa1EAarSv9I0yk+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394117; c=relaxed/simple;
	bh=Wn6vkc2NPhrc+1mPwwKnE/yrTGTjQAPfqR5bTxLZk2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnu4tg0JZCFvwrTQVYS17xYZPRIEuQ3YXKvLXNlsFxQNfIM1mO0j8bUBZVsrqjXIo7S1u4LqeZExS3ZWaMJvCtFXlzPB+QGws3ei6GXe6lpzXtc+3fzjfBjzwBHgN2AV3LRzl52Bi4o64+tNQriO2mXmEC2mX6Pf3AYqJb0Z1J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n17V+/ST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n17V+/ST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46243C4CED1;
	Tue,  8 Oct 2024 13:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394117;
	bh=Wn6vkc2NPhrc+1mPwwKnE/yrTGTjQAPfqR5bTxLZk2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n17V+/STywKu5d3I5oWcVyJrYDfpWRSyT39Iv656gWjwADreOl6yt56uF8xPa3mmU
	 YlXhPeQWimy6S4vHqw2bba38F3cL4Sq34776QBflaEB6nLWOZnFVK7/cOzZFEd/Pkc
	 /TEwjgNsP22xnZrT50v7cCGw0K34aABugydTI4CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 352/386] dt-bindings: clock: qcom: Add GPLL9 support on gcc-sc8180x
Date: Tue,  8 Oct 2024 14:09:57 +0200
Message-ID: <20241008115643.233809361@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>

[ Upstream commit 648b4bde0aca2980ebc0b90cdfbb80d222370c3d ]

Add the missing GPLL9 which is required for the gcc sdcc2 clock.

Fixes: 0fadcdfdcf57 ("dt-bindings: clock: Add SC8180x GCC binding")
Cc: stable@vger.kernel.org
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Link: https://lore.kernel.org/r/20240812-gcc-sc8180x-fixes-v2-2-8b3eaa5fb856@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/qcom,gcc-sc8180x.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/clock/qcom,gcc-sc8180x.h b/include/dt-bindings/clock/qcom,gcc-sc8180x.h
index 90c6e021a0356..2569f874fe13c 100644
--- a/include/dt-bindings/clock/qcom,gcc-sc8180x.h
+++ b/include/dt-bindings/clock/qcom,gcc-sc8180x.h
@@ -248,6 +248,7 @@
 #define GCC_USB3_SEC_CLKREF_CLK					238
 #define GCC_UFS_MEM_CLKREF_EN					239
 #define GCC_UFS_CARD_CLKREF_EN					240
+#define GPLL9							241
 
 #define GCC_EMAC_BCR						0
 #define GCC_GPU_BCR						1
-- 
2.43.0



