Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00080364042;
	Tue, 16 Dec 2025 12:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886953; cv=none; b=uc1DUiehzPYOy7ku7dgr80/uifwP6dDECRhHwc6mroq0jadtnNw0VZRn7/31pOAKTg+Iqs81aXBna2akekqdnUO+jWchZuj8mJzs74Ak7NHqgVQUbQZ3nWOLHSY60nNbVikPjyjncn9B98sTguw7xVVvf1AR637nM8AtTvJF1RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886953; c=relaxed/simple;
	bh=dZaK2oCFHQ1SC1FNdFJa+VEWQ8RWqhqGG62XzXcr2UI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouJ6ir9h1iFWW+RUyArpnpi8b2MV8R0LINB+Q6TNOexih/tw0vVqHmVlBR2oAJeBO8CaTH71GZX0Zy+CN37ZgZreNqI6kKrqOYPR8dVFxqs2/OulkgBgsfJCWmpUiA1fqFqZmQTgLsIkANkHDzfN1I4Qe3twQ7QFO4lKX4RhS1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IPKzcqWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IPKzcqWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A494DC4CEF1;
	Tue, 16 Dec 2025 12:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886952;
	bh=dZaK2oCFHQ1SC1FNdFJa+VEWQ8RWqhqGG62XzXcr2UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IPKzcqWw2M8DzlgOxF+f5vlKAq5c5dZ2/uuV0slxI510Ci2SUZcHrdpSRMdSuaSbg
	 DzFReAlosRaSeGEDEkBMSie9V7eVOtlCeynDnzvXQbrUxjcC5incQFE+5EpCA+la16
	 6/4/eTIpvUpS3C779Rhnv/onjUjFzRQnzWlfjSsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 082/614] clk: qcom: gcc-sm8750: Add a new frequency for sdcc2 clock
Date: Tue, 16 Dec 2025 12:07:29 +0100
Message-ID: <20251216111404.288166005@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <taniya.das@oss.qualcomm.com>

[ Upstream commit 393f7834cd2b1eaf4a9eff2701e706e73e660dd7 ]

The SD card support requires a 37.5MHz clock; add it to the frequency
list for the storage SW driver to be able to request for the frequency.

Fixes: 3267c774f3ff ("clk: qcom: Add support for GCC on SM8750")
Signed-off-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250924-sm8750_gcc_sdcc2_frequency-v1-1-541fd321125f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm8750.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-sm8750.c b/drivers/clk/qcom/gcc-sm8750.c
index 8092dd6b37b56..def86b71a3da5 100644
--- a/drivers/clk/qcom/gcc-sm8750.c
+++ b/drivers/clk/qcom/gcc-sm8750.c
@@ -1012,6 +1012,7 @@ static struct clk_rcg2 gcc_qupv3_wrap2_s7_clk_src = {
 static const struct freq_tbl ftbl_gcc_sdcc2_apps_clk_src[] = {
 	F(400000, P_BI_TCXO, 12, 1, 4),
 	F(25000000, P_GCC_GPLL0_OUT_EVEN, 12, 0, 0),
+	F(37500000, P_GCC_GPLL0_OUT_EVEN, 8, 0, 0),
 	F(50000000, P_GCC_GPLL0_OUT_EVEN, 6, 0, 0),
 	F(100000000, P_GCC_GPLL0_OUT_EVEN, 3, 0, 0),
 	F(202000000, P_GCC_GPLL9_OUT_MAIN, 4, 0, 0),
-- 
2.51.0



