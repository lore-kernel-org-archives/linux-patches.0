Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8338B3E49FD;
	Tue, 21 Jul 2026 22:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671847; cv=none; b=gJz5jZwT2nZXAyF6j1u6/Co0ld+k/qHsqmXpv866+9prfSWkg5D28OwCWaf/bxQKMAo1XWjvf5aXVYu5FlmyF5TzSopSo33wxA2KIJV9fZx59iV/ywXUzXNxtn1EHLI/DbbFzdZunX87lzWtd2sTifR995hFu20d87AxomHBUwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671847; c=relaxed/simple;
	bh=6RGOKvdHsx9fEvCfjPvEJmhEdXsozOcHe1K/dGOiG/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7iuJ4tPwrsn+HuOPgcaFcx4TX/eDW8KMSfe6zbNMy7K+Z74nxq1GKAP+xYgOW/WTT9dw5iCuhcZS+QlLaxQ/MA/97tvt2CA7S2XKDKHSe3hFhtjmIsgiaaTV6aMzClP06Qjofw/zQ0FHyaWp3GGSLljHD+0pF0/YNsSHiE1lfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccfHaRqs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccfHaRqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E290A1F000E9;
	Tue, 21 Jul 2026 22:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671846;
	bh=3gGPq+v018fPRqsjMLcn66JJBlNcOKk4h2XEOqBrg2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ccfHaRqsZ1Pa1RMRLLYE9mBi5zEJl2glo2JAOMdCwpFoIrhQlfTqXpXpQP9zJtC7I
	 xcSmtp2wbJ3X5+x99B8NJiN2ddO6K8Qt/NnKFexsYBkmzuoAG9CS8BYEkfh6PqFcE3
	 4wBU3sPnM9j3mXB2tRfRT3EEVajK08ny85MXx1Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Varney <pbvarney@protonmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 399/843] clk: qcom: a53: Corrected frequency multiplier for 1152MHz
Date: Tue, 21 Jul 2026 17:20:34 +0200
Message-ID: <20260721152415.014824144@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phillip Varney <pbvarney@protonmail.com>

[ Upstream commit bb56147ea9fce98ebde1d367335ba006cba61fbd ]

The 1152MHz frequency entry for the a53 currently selects a multiplier of 62, giving 1190MHz. This changes the mulitiplier to 60 giving the intended 1152MHz.

Signed-off-by: Phillip Varney <pbvarney@protonmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Fixes: 0c6ab1b8f894 ("clk: qcom: Add A53 PLL support")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260605005502.313928-1-pbvarney@protonmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/a53-pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/a53-pll.c b/drivers/clk/qcom/a53-pll.c
index 9e6decb9c26fa7..454a8458e00b33 100644
--- a/drivers/clk/qcom/a53-pll.c
+++ b/drivers/clk/qcom/a53-pll.c
@@ -20,7 +20,7 @@
 static const struct pll_freq_tbl a53pll_freq[] = {
 	{  998400000, 52, 0x0, 0x1, 0 },
 	{ 1094400000, 57, 0x0, 0x1, 0 },
-	{ 1152000000, 62, 0x0, 0x1, 0 },
+	{ 1152000000, 60, 0x0, 0x1, 0 },
 	{ 1209600000, 63, 0x0, 0x1, 0 },
 	{ 1248000000, 65, 0x0, 0x1, 0 },
 	{ 1363200000, 71, 0x0, 0x1, 0 },
-- 
2.53.0



