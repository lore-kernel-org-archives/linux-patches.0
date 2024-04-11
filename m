Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1A3143C72;
	Thu, 11 Apr 2024 09:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829578; cv=none; b=az742IkBIi6wEKS9jGHPSV9sh2mVsX/kbeg6TgaxNFkqTt45Dv/U9yfG+Cr+uTlHztw38jx50YV9zuPUe3GtfrZ9u1NkVcn3ZR+GY71olzL8NfY4yscCfOAGZzDjzLiSC1IOj8qoNr1GlY1eL4/YkdczpN4wYqu7IiXgHs8K+yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829578; c=relaxed/simple;
	bh=VaveYaJ4NYeGlmB5W4ZXAP05K4b1DFcuqPme1X4DHKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYj7/C+DIAICezG4tYMJL8ZVCbk+wZX4Eb0U0lOx/yaK6qLptu0CGgFqggIv+RuUnz7CyIntQvGQLe7Zc8s1QonuJQ6xKR9XzMKEHx2HJi2XmXP1L0I0H+yfdrV2OveYt/VJE8BWSHrLdAPnjhhNVsQoT5A4u6vhAyLj8FxqnB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=heIvpsXb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="heIvpsXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9226C433C7;
	Thu, 11 Apr 2024 09:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829578;
	bh=VaveYaJ4NYeGlmB5W4ZXAP05K4b1DFcuqPme1X4DHKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=heIvpsXb97//LBbqbgTG++E7czDzj55mukCIHY2GcEo/Nc1YH7NfcpGEWdf7QEAYy
	 WtVEJyGAUmWERpmJGbqxDQZl66OxYKH5n2TmXcwu+ngThLnv6QaM68aIoC0mrOKdsH
	 BX/q6p9hY8huvAixnML3on20Hq/smFTzAf2cY0Z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 033/175] clk: qcom: mmcc-msm8974: fix terminating of frequency table arrays
Date: Thu, 11 Apr 2024 11:54:16 +0200
Message-ID: <20240411095420.555150255@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 91818516c3e0c..124d21f19e2c7 100644
--- a/drivers/clk/qcom/mmcc-msm8974.c
+++ b/drivers/clk/qcom/mmcc-msm8974.c
@@ -291,6 +291,7 @@ static struct freq_tbl ftbl_mmss_axi_clk[] = {
 	F(291750000, P_MMPLL1, 4, 0, 0),
 	F(400000000, P_MMPLL0, 2, 0, 0),
 	F(466800000, P_MMPLL1, 2.5, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 mmss_axi_clk_src = {
@@ -315,6 +316,7 @@ static struct freq_tbl ftbl_ocmemnoc_clk[] = {
 	F(150000000, P_GPLL0, 4, 0, 0),
 	F(291750000, P_MMPLL1, 4, 0, 0),
 	F(400000000, P_MMPLL0, 2, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 ocmemnoc_clk_src = {
-- 
2.43.0



