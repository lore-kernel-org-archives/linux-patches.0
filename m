Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049641;
	b=ZYyiT4nyAYsUXaVMW089NudaCIiIJnebf5gS7i5mFDkApdyzh8kuCDqhKVbb6IN/k4Ul
	 Dj64teYeYep/BR5bVuC8ZS3YMRhU5PAil/axLIwPYA8xOlCP+7JhYamOCih/Xp5VRwhKW
	 L3E2iZLUbjI3qfsDlgqJ0tDZ0tydpA9JiPq5i4itE9joHByZIS7J1trTV4yGtJQmxXwvY
	 Uu/T1lxyRbs5D008QmSjBeDse2nVIcmxudp25Xy4nz2iRv1rgbFAEbQidesTegfM/xMJM
	 AgU3umw76TpOp58Vf6n1qL30f4a/xuwpKUlppal2fOIajMvuUZEjOSG39a1h5hdYorg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=liQf+9TlZ3lmBRvWJFDlDbjanpz5GUEndNBdtHqh5Xo=;
	b=mHe0HQKlHcEhTaEG9HcHvI1eJm/LbwIGcAHb4Kmz8davxGIgC+QVlSBq+e/z7EbrKNud
	 Y0fKqexcKTcAx4vrtEBu+CMW5WTMzZ+TySXYkKPixMa6rqLLu+NVsnPaP6h0+foMUxK1J
	 T+rj53lE4rAQSY87+6zyoPI1AH9mf9jz8vwstwuh906AxvCD/91SqcXcRqUdbhWK2pg/R
	 Mo/5wTQPI5vPrtBRkYqSjPpcQdbVlJzy/iUVrLkWUfitwrzvCIY3+b9AtS/WnQ7zgsnUQ
	 ecJYZ8mJHocZst7+9jG6+fHJF2JuosFSKyhLH/iG6sV+RHiujwd6UoDnR6SPD9UMwIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FmmEUuSG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F955606A31C;
	Thu, 19 Nov 2026 00:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FmmEUuSG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB7A1F000C4;
	Thu, 19 Nov 2026 00:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049641;
	bh=liQf+9TlZ3lmBRvWJFDlDbjanpz5GUEndNBdtHqh5Xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FmmEUuSGSlf/XjzQ5DKqq8OdH0aVeATfWIHjO3kYju/Q0SJtpPobPF5VlHq1OGZxw
	 /BFsEXyJ61Xze0WiDH13d4fx8eflu+XdTksBkV9O7XgfMWwxIFzZNdvUIdw5r+Fui2
	 y6GnB9oyYxt5RvAI178UgCtgpjpF1osg46oN3bvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2424/2857] clk: qcom: mmcc-sdm660: Fix MDSS AHB clock HWCG register offset
Date: Wed, 18 Nov 2026 15:57:38 +0100
Message-ID: <20261118150328.831872851@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit c5f338329a2d0d60f7874aa7a1addaa0e4e75a3b ]

The MDSS AHB clock HWCG bit resides in the same register as the branch
enable and halt status bits, at offset 0x2308. The current HWCG register
offset of 0x8a004 exceeds the regmap maximum of 0x40000, so regmap rejects
the read in clk_branch_in_hwcg_mode(). Since the read error is ignored,
the helper uses an uninitialized value to decide whether to skip the
halt status check.

Correct the HWCG register offset so the helper reads the actual hardware
clock gating state.

Fixes: 5db3ae8b33de ("clk: qcom: Add SDM660 Multimedia Clock Controller (MMCC) driver")
Assisted-by: LLM
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916-clk-qcom-mmcc-sdm660-fix-mdss-ahb-hwcg-offset-v1-1-30dcf09d907c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/mmcc-sdm660.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/mmcc-sdm660.c b/drivers/clk/qcom/mmcc-sdm660.c
index 4d187d6aba734..fc2fc74d1c01d 100644
--- a/drivers/clk/qcom/mmcc-sdm660.c
+++ b/drivers/clk/qcom/mmcc-sdm660.c
@@ -2022,7 +2022,7 @@ static struct clk_branch csiphy_ahb2crif_clk = {
 static struct clk_branch mdss_ahb_clk = {
 	.halt_reg = 0x2308,
 	.halt_check = BRANCH_HALT,
-	.hwcg_reg = 0x8a004,
+	.hwcg_reg = 0x2308,
 	.hwcg_bit = 1,
 	.clkr = {
 		.enable_reg = 0x2308,
-- 
2.53.0



