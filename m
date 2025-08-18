Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0243B31B100;
	Mon, 18 Aug 2025 13:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522639; cv=none; b=up17dbcGrOnkZ7jLd+U+sFr1oSr1BNyYnHJ9jUE6LQBGfJWa4Brkzak2j32xjqcffdRvVlNYSox51pGm5Ms100L2TUdPVr44TqDzperNnzxol6dE3DaR+Kyt5RreAFqcPp9a0BtFcefQgPqy8A5TQdelazbOkv947uRYG4pLaLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522639; c=relaxed/simple;
	bh=PJXf3tOxhPHhzy6gqZ6QM/RGUu8DsTVfg4c+Qh+MXZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7sRVhGiLNRrX30COYK/D9hYT+RVOiF5yBVUQZJR8MGXD7EZUXcS2wl1tTYq61Op03Ap9t+u/FgdBl6RUAaBwqLm7zDhGexIdbJ8fNaFmGPCoT2e8CaWyRRi3mLOKQb8iY1hjCYU7ZCmT2EXDC8u8HEwbgoDu3fZCePVhdY7tY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hyLKGEye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hyLKGEye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F157C4CEEB;
	Mon, 18 Aug 2025 13:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522638;
	bh=PJXf3tOxhPHhzy6gqZ6QM/RGUu8DsTVfg4c+Qh+MXZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hyLKGEyedZUUoWauBX2nWC4E1EWoYIw23MwLSrcRoYKJGIIHB/MZIhhGEY15BFg67
	 DkpjY41thUbGwv2BJGizq3UmHaNUS0QOFn7TNhdtH4rOjPhVfV6ZVE7bAltdNl3xkU
	 ti8T7xbrbHCTDcexotBe/zBJuKJ90lqvLN24bTAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Robert Marko <robimarko@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 376/444] clk: qcom: gcc-ipq8074: fix broken freq table for nss_port6_tx_clk_src
Date: Mon, 18 Aug 2025 14:46:42 +0200
Message-ID: <20250818124502.988607929@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Christian Marangi <ansuelsmth@gmail.com>

commit 077ec7bcec9a8987d2a133afb7e13011878c7576 upstream.

With the conversion done by commit e88f03230dc0 ("clk: qcom: gcc-ipq8074:
rework nss_port5/6 clock to multiple conf") a Copy-Paste error was made
for the nss_port6_tx_clk_src frequency table.

This was caused by the wrong setting of the parent in
ftbl_nss_port6_tx_clk_src that was wrongly set to P_UNIPHY1_RX instead
of P_UNIPHY2_TX.

This cause the UNIPHY2 port to malfunction when it needs to be scaled to
higher clock. The malfunction was observed with the example scenario
with an Aquantia 10G PHY connected and a speed higher than 1G (example
2.5G)

Fix the broken frequency table to restore original functionality.

Cc: stable@vger.kernel.org
Fixes: e88f03230dc0 ("clk: qcom: gcc-ipq8074: rework nss_port5/6 clock to multiple conf")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Tested-by: Robert Marko <robimarko@gmail.com>
Link: https://lore.kernel.org/r/20250522202600.4028-1-ansuelsmth@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-ipq8074.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/qcom/gcc-ipq8074.c b/drivers/clk/qcom/gcc-ipq8074.c
index 7258ba5c0900..1329ea28d703 100644
--- a/drivers/clk/qcom/gcc-ipq8074.c
+++ b/drivers/clk/qcom/gcc-ipq8074.c
@@ -1895,10 +1895,10 @@ static const struct freq_conf ftbl_nss_port6_tx_clk_src_125[] = {
 static const struct freq_multi_tbl ftbl_nss_port6_tx_clk_src[] = {
 	FMS(19200000, P_XO, 1, 0, 0),
 	FM(25000000, ftbl_nss_port6_tx_clk_src_25),
-	FMS(78125000, P_UNIPHY1_RX, 4, 0, 0),
+	FMS(78125000, P_UNIPHY2_TX, 4, 0, 0),
 	FM(125000000, ftbl_nss_port6_tx_clk_src_125),
-	FMS(156250000, P_UNIPHY1_RX, 2, 0, 0),
-	FMS(312500000, P_UNIPHY1_RX, 1, 0, 0),
+	FMS(156250000, P_UNIPHY2_TX, 2, 0, 0),
+	FMS(312500000, P_UNIPHY2_TX, 1, 0, 0),
 	{ }
 };
 
-- 
2.50.1



