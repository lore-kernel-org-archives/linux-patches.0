Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE03148FFF;
	Thu, 11 Apr 2024 10:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831536; cv=none; b=OVO8Vw+tdfOg07roy0hacu7jvRu7OYgkm4XxknP+P5D55se9gfO7Q362U3S2dVZgfGQ9AKMWeVJQ8MqHq/nSOOvh/4HxJ+ClCs3KVCn4yTG9aNMnIGNFfoDzoeDcCNTs9JvzepgSmwz/wr3wIqfHafPp9mGK9i8nVjWCTGl27V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831536; c=relaxed/simple;
	bh=fAMIAS0QMqQex7fLwaZFhf29RVxuckmbCOCv82vHrDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LL7MmcjeY9U+L1r9GiJ01k0FWdAOE1dtKMVRz76HeYdDP5rq6rR2EQzBkmFl/Imq7xYvwEnVZKoffiPBXq6httWjzluz/gJ/Bw9ZtrGsgjLuDZJMKXkBMAh4zhYb46OgCVbBldAOhbdf4ZXyPhp+GrN99PFfcruHyMlPofkHE/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPuST56S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPuST56S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A26C433C7;
	Thu, 11 Apr 2024 10:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831535;
	bh=fAMIAS0QMqQex7fLwaZFhf29RVxuckmbCOCv82vHrDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XPuST56ST9ExVbq/9nuS8fKKr63L9it7F1QuZqNxStwGDN1Nl3yv26S1cADJNy2pj
	 NqAzPmQ02nmA+L7BbcRScb+Z2FdyztbpdskjwZUUsBTtJJWUyEuOo1Sta6GW+TEJX9
	 NdZP/B964CrY18PVRvcHKxtEVhrubDonS9lpaemE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/294] clk: qcom: gcc-ipq6018: fix terminating of frequency table arrays
Date: Thu, 11 Apr 2024 11:53:24 +0200
Message-ID: <20240411095436.875569574@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit cdbc6e2d8108bc47895e5a901cfcaf799b00ca8d ]

The frequency table arrays are supposed to be terminated with an
empty element. Add such entry to the end of the arrays where it
is missing in order to avoid possible out-of-bound access when
the table is traversed by functions like qcom_find_freq() or
qcom_find_freq_floor().

Only compile tested.

Fixes: d9db07f088af ("clk: qcom: Add ipq6018 Global Clock Controller support")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240229-freq-table-terminator-v1-2-074334f0905c@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq6018.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/qcom/gcc-ipq6018.c b/drivers/clk/qcom/gcc-ipq6018.c
index 4c5c7a8f41d08..b9844e41cf99d 100644
--- a/drivers/clk/qcom/gcc-ipq6018.c
+++ b/drivers/clk/qcom/gcc-ipq6018.c
@@ -1557,6 +1557,7 @@ static struct clk_regmap_div nss_ubi0_div_clk_src = {
 
 static const struct freq_tbl ftbl_pcie_aux_clk_src[] = {
 	F(24000000, P_XO, 1, 0, 0),
+	{ }
 };
 
 static const struct clk_parent_data gcc_xo_gpll0_core_pi_sleep_clk[] = {
@@ -1737,6 +1738,7 @@ static const struct freq_tbl ftbl_sdcc_ice_core_clk_src[] = {
 	F(160000000, P_GPLL0, 5, 0, 0),
 	F(216000000, P_GPLL6, 5, 0, 0),
 	F(308570000, P_GPLL6, 3.5, 0, 0),
+	{ }
 };
 
 static const struct clk_parent_data gcc_xo_gpll0_gpll6_gpll0_div2[] = {
-- 
2.43.0



