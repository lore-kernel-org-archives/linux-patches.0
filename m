Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDF5524BE;
	Mon,  1 Apr 2024 15:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986835; cv=none; b=M551ISUC9yAw+Rp0D6VPyeVvj1cv3aVRawU6HacNQuugPuWmaKoTeTAp3DG18YUsTHcpS13scEtl5f6whkxvPqYYDY3yf3NjG+6w4PDvJtJIUB57HaBq652pf/TNOEpoX8klV7bk4y39UoKIjiOwXp1dZAC0JqmyEG7GgbMpCkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986835; c=relaxed/simple;
	bh=tisdk5xaiIjftrlX7RJTMZhpx3rzacTwX/fk/ThajkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiWDLGf5l3yb69UhPGHwncXSCu/+Hqz2jZBw1+JOjFfb0EJT6x7l9a8y3SsmvjsuMEGbBK0nFy6maylTBDCJ5lkYLsgr1D3Ar6+Ay0DjhadrAE81GG69C2YgXFRyH8r5+gl3R+6JsRciXqeYXibXveFMbylvVI/aUg08Vyxk5mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDOPs18X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDOPs18X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B574C433F1;
	Mon,  1 Apr 2024 15:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986835;
	bh=tisdk5xaiIjftrlX7RJTMZhpx3rzacTwX/fk/ThajkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDOPs18X4vYqqLbrUIRxDCw3lIGkfgbUBmSsu4143rj54Ip1vjET1KAzGNQqb/dYU
	 kyVrjjdEjEoeaJOVrpXu1RWjXGvAp02ARwEt1iyE6Hi6U1FG+QJVNmRUr/wR0AWr5l
	 HsjbFtpBilNBsMswgnhrATjGD300ByY0NRInusjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 070/399] clk: qcom: gcc-ipq5018: fix terminating of frequency table arrays
Date: Mon,  1 Apr 2024 17:40:36 +0200
Message-ID: <20240401152551.275757280@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 90ad946fff70f312b8d23226afc38c13ddd88c4b ]

The frequency table arrays are supposed to be terminated with an
empty element. Add such entry to the end of the arrays where it
is missing in order to avoid possible out-of-bound access when
the table is traversed by functions like qcom_find_freq() or
qcom_find_freq_floor().

Fixes: e3fdbef1bab8 ("clk: qcom: Add Global Clock controller (GCC) driver for IPQ5018")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240229-freq-table-terminator-v1-1-074334f0905c@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5018.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/qcom/gcc-ipq5018.c b/drivers/clk/qcom/gcc-ipq5018.c
index e2bd54826a4ce..c1732d70e3a23 100644
--- a/drivers/clk/qcom/gcc-ipq5018.c
+++ b/drivers/clk/qcom/gcc-ipq5018.c
@@ -857,6 +857,7 @@ static struct clk_rcg2 lpass_sway_clk_src = {
 
 static const struct freq_tbl ftbl_pcie0_aux_clk_src[] = {
 	F(2000000, P_XO, 12, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 pcie0_aux_clk_src = {
@@ -1099,6 +1100,7 @@ static const struct freq_tbl ftbl_qpic_io_macro_clk_src[] = {
 	F(100000000, P_GPLL0, 8, 0, 0),
 	F(200000000, P_GPLL0, 4, 0, 0),
 	F(320000000, P_GPLL0, 2.5, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 qpic_io_macro_clk_src = {
@@ -1194,6 +1196,7 @@ static struct clk_rcg2 ubi0_axi_clk_src = {
 static const struct freq_tbl ftbl_ubi0_core_clk_src[] = {
 	F(850000000, P_UBI32_PLL, 1, 0, 0),
 	F(1000000000, P_UBI32_PLL, 1, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 ubi0_core_clk_src = {
-- 
2.43.0



