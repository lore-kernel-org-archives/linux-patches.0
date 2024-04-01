Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C7F47A5D;
	Mon,  1 Apr 2024 17:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990847; cv=none; b=nhOQ6dZNXjaiUad3qJSMAv9BBHZmVgvE5a5C2O5cFcXqYpwucwow/f/UX9ySayFJqm0N0ugVzH+wMwoxuyRea70NIvb6DMBvjFpviVrLPPoohC+NHm/tyKMWFK0IhbfJpqvPnCLs+G6uW4kB8eSbzgBJjpsRn63NtruyXHRh9KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990847; c=relaxed/simple;
	bh=DfCDK3OcPa++Iyfo8h/+P4VVcXQBoVW7NFLPYshtyZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7umTJao6Ar0+FWejPkMFb3BZopfmilR8Uy3ztfSpY2Mf/OitpQ3cttsVo/ahoYeRwDediMbRPU1ksG0emkxVEMrHuGsv53mRePwVEd8ojzfPYAoM33NPGDvVF3hE8WE9X0D/xHbfd9Qdy+wtawUlXuiGeWhqVDnKZ0QumqFceQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ggaKBKqb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ggaKBKqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C8EC433F1;
	Mon,  1 Apr 2024 17:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990847;
	bh=DfCDK3OcPa++Iyfo8h/+P4VVcXQBoVW7NFLPYshtyZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ggaKBKqbAuWg+U5Us55vHl4dJ1QrYOf2vK5NsYweV4Tbm+S8YQM1KAUw4uRRhhs9R
	 kjqB0tgjJqGIRqy4Dkfa5uxuFI1XPH7JsMlAJOY5bJBLV9t+HuI6rlOR4V19whlEVH
	 fJRvbjZ2Js09XRf1RRXDTklYJQHVdt++Y+11ez20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/272] clk: qcom: mmcc-apq8084: fix terminating of frequency table arrays
Date: Mon,  1 Apr 2024 17:44:05 +0200
Message-ID: <20240401152532.269209719@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit a903cfd38d8dee7e754fb89fd1bebed99e28003d ]

The frequency table arrays are supposed to be terminated with an
empty element. Add such entry to the end of the arrays where it
is missing in order to avoid possible out-of-bound access when
the table is traversed by functions like qcom_find_freq() or
qcom_find_freq_floor().

Only compile tested.

Fixes: 2b46cd23a5a2 ("clk: qcom: Add APQ8084 Multimedia Clock Controller (MMCC) support")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240229-freq-table-terminator-v1-6-074334f0905c@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/mmcc-apq8084.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/qcom/mmcc-apq8084.c b/drivers/clk/qcom/mmcc-apq8084.c
index e9f9713591558..5f373c10ec6ee 100644
--- a/drivers/clk/qcom/mmcc-apq8084.c
+++ b/drivers/clk/qcom/mmcc-apq8084.c
@@ -334,6 +334,7 @@ static struct freq_tbl ftbl_mmss_axi_clk[] = {
 	F(333430000, P_MMPLL1, 3.5, 0, 0),
 	F(400000000, P_MMPLL0, 2, 0, 0),
 	F(466800000, P_MMPLL1, 2.5, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 mmss_axi_clk_src = {
@@ -358,6 +359,7 @@ static struct freq_tbl ftbl_ocmemnoc_clk[] = {
 	F(150000000, P_GPLL0, 4, 0, 0),
 	F(228570000, P_MMPLL0, 3.5, 0, 0),
 	F(320000000, P_MMPLL0, 2.5, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 ocmemnoc_clk_src = {
-- 
2.43.0



