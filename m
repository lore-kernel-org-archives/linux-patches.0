Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64A147A62;
	Mon,  1 Apr 2024 16:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988160; cv=none; b=ZuDawdnv9U4pOGRTaho7k8WgShkwlUf85wMbJRSD0J5pQYpQHSrbIeHurf3vlRUrFStMXibOm1JBBl1CT7wt08S+eI0z8KZ0rUf19QOs1Sx+lyVSogZdTMY9dn5QjbZfMNNNhKpTEay4vuX2k1pBaa/7Ggvs5MrfAp8fMutqlV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988160; c=relaxed/simple;
	bh=V78gTyw54xgK6BPhS0pxGCU/TuwUvR+ymNBTYF4Lvvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dblpgOIt+D061XdmjvHQAMYFPhXqtIQ5z6ixBuNFhXCFrTjoVF8IzrG/LHzLnFyfLQ3qR9t2jH73hpTaFxp67HMattKQrt6nOfNQOloq1P/0Rn19tKL6bhU7BfhZ9PkmtbzPqETiuk5bnjgjH/2CQdwmXjGjTHS1xoX1FtAFbQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FFbsA0ge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFbsA0ge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5E8C43390;
	Mon,  1 Apr 2024 16:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988159;
	bh=V78gTyw54xgK6BPhS0pxGCU/TuwUvR+ymNBTYF4Lvvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFbsA0ge5a68wdZ3JQU+hjsi7H+i/DO5eWHPX6+CT5cG5URcWgMdXgoa57rClHJGm
	 +jWBbDPAyg8nRl5MeQjaa4uiHe008zkbGaiWOhDNskC3A1LQHQsfqYOkQ5NUI2YQm6
	 TXba6oe4tzWCjueB87NLJcXO7ZiBsRDLLApjxrJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 074/432] clk: qcom: mmcc-msm8974: fix terminating of frequency table arrays
Date: Mon,  1 Apr 2024 17:41:01 +0200
Message-ID: <20240401152555.330823680@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit e2c02a85bf53ae86d79b5fccf0a75ac0b78e0c96 ]

The frequency table arrays are supposed to be terminated with an
empty element. Add such entry to the end of the arrays where it
is missing in order to avoid possible out-of-bound access when
the table is traversed by functions like qcom_find_freq() or
qcom_find_freq_floor().

Only compile tested.

Fixes: d8b212014e69 ("clk: qcom: Add support for MSM8974's multimedia clock controller (MMCC)")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240229-freq-table-terminator-v1-7-074334f0905c@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/mmcc-msm8974.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/qcom/mmcc-msm8974.c b/drivers/clk/qcom/mmcc-msm8974.c
index a31f6cf0c4e0c..36f460b78be2c 100644
--- a/drivers/clk/qcom/mmcc-msm8974.c
+++ b/drivers/clk/qcom/mmcc-msm8974.c
@@ -290,6 +290,7 @@ static struct freq_tbl ftbl_mmss_axi_clk[] = {
 	F(291750000, P_MMPLL1, 4, 0, 0),
 	F(400000000, P_MMPLL0, 2, 0, 0),
 	F(466800000, P_MMPLL1, 2.5, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 mmss_axi_clk_src = {
@@ -314,6 +315,7 @@ static struct freq_tbl ftbl_ocmemnoc_clk[] = {
 	F(150000000, P_GPLL0, 4, 0, 0),
 	F(291750000, P_MMPLL1, 4, 0, 0),
 	F(400000000, P_MMPLL0, 2, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 ocmemnoc_clk_src = {
-- 
2.43.0



