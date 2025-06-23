Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F2230E84D;
	Mon, 23 Jun 2025 13:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685703; cv=none; b=gVZkjdJ9dBJpMvx6SZ3zff5u+i8BRws2ZtKN+9Gxy9Ntu/BkLplHEJDOrjp0SRW3leFiRR8ew+SJrEoUdshaza3C+zRC4Yz/HGA/6bN4wjJ9byzL+fnWcP1E/2mLfOi7xKz9hV6BtvpFSf0cYByj3QfWFrOzRYFjEg0gT9cdLUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685703; c=relaxed/simple;
	bh=K9WQDYTGVPi04TEAFu2sYmuhPRDF9xdWHQnKjGpP7DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qIWQ7mRSHoTe0QF1ZwjVT6W3PcjJTlK0nu7qL9jYgIC5OsLArup540rE7JTBFT7MdVn3Bq8yawTpCReD3cPOA9GX0Y0NzKXS136hTfrLRxFFC4NhuqOe5APcSJeiPBLAC0v0oKwpI/BJ9d3SlwOjA6mCIWFofSa8GnbzpjX03/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPB5viDZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPB5viDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D7DC4CEEA;
	Mon, 23 Jun 2025 13:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685703;
	bh=K9WQDYTGVPi04TEAFu2sYmuhPRDF9xdWHQnKjGpP7DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rPB5viDZ05KykD5w0qFkuE8vBEFQ1WrDFaBVVyt3yE1a/NMPG+I3TGMNtgBlHb2af
	 bnSYGQiuX/3pluzktWdatbOZmScQjHKzSgLGOsHl7kilWHYLz/hrEZiljZJQmxDOZr
	 DOp7xFuiFEpfYqIeWdTICFrNGAD8Ym+ljKFuQuyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Taniya Das <quic_tdas@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/411] clk: qcom: gcc-sm6350: Add *_wait_val values for GDSCs
Date: Mon, 23 Jun 2025 15:03:17 +0200
Message-ID: <20250623130634.588012596@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit afdfd829a99e467869e3ca1955fb6c6e337c340a ]

Compared to the msm-4.19 driver the mainline GDSC driver always sets the
bits for en_rest, en_few & clk_dis, and if those values are not set
per-GDSC in the respective driver then the default value from the GDSC
driver is used. The downstream driver only conditionally sets
clk_dis_wait_val if qcom,clk-dis-wait-val is given in devicetree.

Correct this situation by explicitly setting those values. For all GDSCs
the reset value of those bits are used.

Fixes: 131abae905df ("clk: qcom: Add SM6350 GCC driver")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Taniya Das <quic_tdas@quicinc.com>
Link: https://lore.kernel.org/r/20250425-sm6350-gdsc-val-v1-3-1f252d9c5e4e@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm6350.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/clk/qcom/gcc-sm6350.c b/drivers/clk/qcom/gcc-sm6350.c
index 0860c6178b4d3..e31a25084b0a3 100644
--- a/drivers/clk/qcom/gcc-sm6350.c
+++ b/drivers/clk/qcom/gcc-sm6350.c
@@ -2319,6 +2319,9 @@ static struct clk_branch gcc_video_xo_clk = {
 
 static struct gdsc usb30_prim_gdsc = {
 	.gdscr = 0x1a004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "usb30_prim_gdsc",
 	},
@@ -2327,6 +2330,9 @@ static struct gdsc usb30_prim_gdsc = {
 
 static struct gdsc ufs_phy_gdsc = {
 	.gdscr = 0x3a004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "ufs_phy_gdsc",
 	},
-- 
2.39.5



