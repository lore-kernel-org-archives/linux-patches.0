Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAF315147C;
	Tue, 23 Jan 2024 00:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969366; cv=none; b=jIJEhG7wB96LkKOWIDaYtr+V/J//6iOJlaU7gIadk672+9NOYi0onrSN+C0+R1O6ix4B0I282fG5EDgBI4H49Nas64VzEVu0FZRJZIj+AThqNuRNEJMUIAlWtIXqlIv0JtIimdkcj0xMlQ3ACHyPsYf8d9wCeKOqIphewnjk2CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969366; c=relaxed/simple;
	bh=PO5qFGhqyCz1rJ17V+ACCmmTAVn5eELM33Etv83tTH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxvJb05nE+SpYk0tt9UVy6ClT1COyg9+xU7pZRIvBY9L+LWGQ5g3ts2AyTz9biOer2xLjcmKCtv5oA3VCUqHi4lkO0cKGg2Ae/w1MRFhBwmokgA+Cpa1FZ/jqm/kNQSEvpg21b65rxsCbZs3QSRFM4qqPMz/amiUWnxuz1bKGbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dz4nrmAY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dz4nrmAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA3CC433F1;
	Tue, 23 Jan 2024 00:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969366;
	bh=PO5qFGhqyCz1rJ17V+ACCmmTAVn5eELM33Etv83tTH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dz4nrmAY5d+nQXhM2c2j+zfM7jMs7GLvmPwcUFUsrx6hTebwFk1oN4leDhqeizX5t
	 EfijBup4TwtMURjaj/+01/lMPjw+dE1O3geLQk9d+txO6tynVLJyWYieo7BJPmEawy
	 dnReLEFx8hWs/fQibGhjccj/KbIZuA6+5iSGjaL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Unnathi Chalicheemala <quic_uchalich@quicinc.com>,
	Satya Durga Srinivasu Prabhala <quic_satyap@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 198/641] soc: qcom: llcc: Fix LLCC_TRP_ATTR2_CFGn offset
Date: Mon, 22 Jan 2024 15:51:42 -0800
Message-ID: <20240122235824.158014494@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 110cb8d861cc1a040cdab495b22ac436c49d1454 ]

According to documentation, it has increments of 4, not 8.

Fixes: c72ca343f911 ("soc: qcom: llcc: Add v4.1 HW version support")
Reported-by: Unnathi Chalicheemala <quic_uchalich@quicinc.com>
Reviewed-by: Satya Durga Srinivasu Prabhala <quic_satyap@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20231012160509.184891-1-abel.vesa@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/llcc-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
index 2e32a0e521d5..57d47dcf11b9 100644
--- a/drivers/soc/qcom/llcc-qcom.c
+++ b/drivers/soc/qcom/llcc-qcom.c
@@ -47,7 +47,7 @@
 #define LLCC_TRP_STATUSn(n)           (4 + n * SZ_4K)
 #define LLCC_TRP_ATTR0_CFGn(n)        (0x21000 + SZ_8 * n)
 #define LLCC_TRP_ATTR1_CFGn(n)        (0x21004 + SZ_8 * n)
-#define LLCC_TRP_ATTR2_CFGn(n)        (0x21100 + SZ_8 * n)
+#define LLCC_TRP_ATTR2_CFGn(n)        (0x21100 + SZ_4 * n)
 
 #define LLCC_TRP_SCID_DIS_CAP_ALLOC   0x21f00
 #define LLCC_TRP_PCB_ACT              0x21f04
-- 
2.43.0



