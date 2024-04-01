Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5191C0DE7;
	Mon,  1 Apr 2024 16:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989503; cv=none; b=KqjG2nyCVrHCul0hSu97JFj+Xaro6pxq4rRxIP2h327yp4oiFLCmmedO0NxexIAwknzFKf00eGfaiN5L4sD6prc7gvaEVz/JOUFHctuZUgc81nez4Sj05dR//H6QJEAaXO1xEGPxIYwB629GT/B5xkv+YQc02HawEmDZx7oyQ3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989503; c=relaxed/simple;
	bh=Yu4nyhZUdgQZ/fMTiQjkEUC4EbboZuuKMtu9nW/RWSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dhtzrsc2jY3s2eHUSpWgvIiA8dQRDXwambsNUpBFz5BOMPQXHYK+WTBfoFiJ1Bw1d/tyzqfnnJZeusWrqbRazpA09iKA6p+AwUO+qQIRmXS7PBOpTltMPQzwK9PQacJZvPFrDFBMdrjCPu43QR+YuZge2MCx77KEzxNDAZaQVDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YzW3GnS/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YzW3GnS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114C6C43394;
	Mon,  1 Apr 2024 16:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989503;
	bh=Yu4nyhZUdgQZ/fMTiQjkEUC4EbboZuuKMtu9nW/RWSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YzW3GnS/x9fslCZp4GIZ0ws/k+fXe2vQt4diLqgn8Sz0R3BwNrO0DV5SP2WbOxoeQ
	 918cDpN/9BF1UmkAAXY3xO4lArhde5l5qkMAWp/j+DqKhfCNU8rBN6EIURbkFb0QM3
	 m0sPPkmREguElUsdu/SrwMA2mJ9vDxNkJMUm/wgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/396] clk: qcom: gcc-ipq9574: fix terminating of frequency table arrays
Date: Mon,  1 Apr 2024 17:41:58 +0200
Message-ID: <20240401152549.979157725@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit bd2b6395671d823caa38d8e4d752de2448ae61e1 ]

The frequency table arrays are supposed to be terminated with an
empty element. Add such entry to the end of the arrays where it
is missing in order to avoid possible out-of-bound access when
the table is traversed by functions like qcom_find_freq() or
qcom_find_freq_floor().

Only compile tested.

Fixes: d75b82cff488 ("clk: qcom: Add Global Clock Controller driver for IPQ9574")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240229-freq-table-terminator-v1-4-074334f0905c@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq9574.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-ipq9574.c b/drivers/clk/qcom/gcc-ipq9574.c
index e8190108e1aef..0a3f846695b80 100644
--- a/drivers/clk/qcom/gcc-ipq9574.c
+++ b/drivers/clk/qcom/gcc-ipq9574.c
@@ -2082,6 +2082,7 @@ static struct clk_branch gcc_sdcc1_apps_clk = {
 static const struct freq_tbl ftbl_sdcc_ice_core_clk_src[] = {
 	F(150000000, P_GPLL4, 8, 0, 0),
 	F(300000000, P_GPLL4, 4, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 sdcc1_ice_core_clk_src = {
-- 
2.43.0



