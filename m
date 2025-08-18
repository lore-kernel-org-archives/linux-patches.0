Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A4D2877DC;
	Mon, 18 Aug 2025 13:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524348; cv=none; b=hGdBPsGmthUZxtZUpYglV6XbT09Dz3WQpSKJkiFqZrkKiZ6VIRbIAHSwKaLDLTE2XVn/ejx8C8Iq2pLk98RRHuhdAt8TCH1RrOFn5hsEN1rcCsqSJcbuJFUncDU2K71xN4k946GmTySRyZniy0VPYns/c4yLpDvoZ/Oc25JBwLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524348; c=relaxed/simple;
	bh=GFfm4C9Tcis1vSKsLWgr0LfzjXN4422eMLS51VOfSpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzfJjljE9qV7z+DqkoOUhepk0ztOxtpMAipjILvWmhLmcejy9ZMYZIFNQMmDBN0MJW63EYRfvV6LqWm/O6A1sPJz7LdAZI4E7/OTsc2vvYcVse4WKBmsbToBPBAEXVQqe4uKaR+2sfP/SakEZFYqfB5ITMiJT1Q2eK7HorgCswk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6BYPzaF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6BYPzaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48906C4CEEB;
	Mon, 18 Aug 2025 13:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524347;
	bh=GFfm4C9Tcis1vSKsLWgr0LfzjXN4422eMLS51VOfSpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6BYPzaFIDudNsVfDQO1IbCV/r8Avqu1pBCE7gtbkS4+UAw+eO1ddZHrEEuKhJA59
	 XsHz5aFk5Sk7ZgTqhaQzmqILHZER8XmNfgysZsN8DS3q20530yrDd6gI1aaIKWdvgT
	 trxo9ctXfYU5aK8JIie1mTQNSdukeve7K0M/Ud5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Robert Marko <robimarko@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.15 445/515] clk: qcom: gcc-ipq8074: fix broken freq table for nss_port6_tx_clk_src
Date: Mon, 18 Aug 2025 14:47:11 +0200
Message-ID: <20250818124515.554670307@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/clk/qcom/gcc-ipq8074.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/clk/qcom/gcc-ipq8074.c
+++ b/drivers/clk/qcom/gcc-ipq8074.c
@@ -1895,10 +1895,10 @@ static const struct freq_conf ftbl_nss_p
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
 


