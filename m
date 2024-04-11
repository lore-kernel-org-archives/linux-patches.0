Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D96E1448F6;
	Thu, 11 Apr 2024 10:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830543; cv=none; b=RUXusxQkK37t5BBjq19oDpIVHFAnQFm2Y8wHLVvfWhemjJW4oBLgKH3anbXNoAkaPZMk1EHckhi0hMoyt6ri4mzkrN6vcOaStCnHNbOvgCLK3ATIkuKzebjnKh0Gslf5zZhoES+V61QXKlU7BCFui1ZlnUMOsmRYlB/BwnhCpRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830543; c=relaxed/simple;
	bh=ySymJP3MWgt9Gsg+gcJUKtCdsW5ssM7xZ/gQ+krDhrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbjZdW2kDpYIrfc/IiZeqOdv2canvWpIUvruTISfJ3vSMW4XyU8VEfTVaRri0AFonIvedotA2URAj4+K4+g4MzkZrDi29g4NAk0g4MD2rRlaOdiHHmQjz5bB5c+xijLmwRKHFMbS3qaZ13BKBlmRxK+FH1KBao2RSedshV9F5hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sPE6njns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sPE6njns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F359C433C7;
	Thu, 11 Apr 2024 10:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830543;
	bh=ySymJP3MWgt9Gsg+gcJUKtCdsW5ssM7xZ/gQ+krDhrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sPE6njns/H7NaifyMKblwGFtqL47LpqcE7NHsvi2XGGYnQ8K/OGGuTQTPcrC7N6zZ
	 VGctK8JsVjjZKeyHsS7xWdOkgdYg2E7Nn0bHSJnY7QC6dGsU9KpG15gLLRXRRscdrs
	 dYkH8xP6trD/qdIv9IfNQRs2wdGZkwk6qHVg91LQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/215] clk: qcom: mmcc-msm8974: fix terminating of frequency table arrays
Date: Thu, 11 Apr 2024 11:54:05 +0200
Message-ID: <20240411095425.982603136@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index bcb0a397ef918..8ce1826aea140 100644
--- a/drivers/clk/qcom/mmcc-msm8974.c
+++ b/drivers/clk/qcom/mmcc-msm8974.c
@@ -283,6 +283,7 @@ static struct freq_tbl ftbl_mmss_axi_clk[] = {
 	F(291750000, P_MMPLL1, 4, 0, 0),
 	F(400000000, P_MMPLL0, 2, 0, 0),
 	F(466800000, P_MMPLL1, 2.5, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 mmss_axi_clk_src = {
@@ -307,6 +308,7 @@ static struct freq_tbl ftbl_ocmemnoc_clk[] = {
 	F(150000000, P_GPLL0, 4, 0, 0),
 	F(291750000, P_MMPLL1, 4, 0, 0),
 	F(400000000, P_MMPLL0, 2, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 ocmemnoc_clk_src = {
-- 
2.43.0



